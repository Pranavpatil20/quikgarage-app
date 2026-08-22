import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/invoice_provider.dart';
import '../../../../core/utils/whatsapp_share.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_overlays.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/segmented_tabs.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../models/invoice_model.dart';
import '../../../../repositories/invoice_repository.dart';

class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final statusFilter = _tabIndex == 1
        ? 'pending'
        : _tabIndex == 2
            ? 'paid'
            : null;
    final invoicesAsync = ref.watch(invoicesProvider(statusFilter));
    final theme = Theme.of(context);
    final s = AppStrings.of(context);
    final tabs = [s.tabAll, s.tabPending, s.tabPaid];

    return Scaffold(
      appBar: AppBar(
        title: Text(s.billingInvoices),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SegmentedTabs(
              tabs: tabs,
              selectedIndex: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
          Expanded(
            child: invoicesAsync.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(
                message: e.toString(),
                onRetry: () => ref.invalidate(invoicesProvider),
              ),
              data: (invoices) {
                if (invoices.isEmpty) {
                  return Center(
                    child: Text(
                      _tabIndex == 2
                          ? s.noPaidInvoicesYet
                          : _tabIndex == 1
                              ? s.noPendingInvoices
                              : s.noInvoicesYet,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(invoicesProvider),
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      AppBottomNavBar.contentBottomPadding(context),
                    ),
                    itemCount: invoices.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      return _InvoiceCard(
                        invoice: invoice,
                        onTap: () => _openInvoiceActions(invoice),
                        onMarkPaid: () => _confirmMarkPaid(invoice),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openInvoiceActions(InvoiceModel invoice) async {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);
    final isPending = invoice.paymentStatus == 'pending' ||
        invoice.paymentStatus == 'partial';

    await showAppModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Invoice #${invoice.id}',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  '${s.total} ₹${invoice.totalAmount}',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(s.editAmount),
                  subtitle: Text(s.updateServicePartsCost),
                  onTap: () {
                    Navigator.pop(ctx);
                    _editInvoice(invoice);
                  },
                ),
                if (isPending) ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.check_circle, color: theme.colorScheme.primary),
                    title: Text(s.markAsPaid),
                    onTap: () {
                      Navigator.pop(ctx);
                      _updatePaymentStatus(invoice.id, 'paid');
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.payments_outlined),
                    title: Text(s.markAsPartial),
                    onTap: () {
                      Navigator.pop(ctx);
                      _updatePaymentStatus(invoice.id, 'partial');
                    },
                  ),
                ],
                if (invoice.paymentStatus == 'paid')
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.undo),
                    title: Text(s.moveBackToPending),
                    onTap: () {
                      Navigator.pop(ctx);
                      _updatePaymentStatus(invoice.id, 'pending');
                    },
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _editInvoice(InvoiceModel invoice) async {
    final s = AppStrings.of(context);
    final result = await showAppDialog<({String service, String parts})>(
      context: context,
      builder: (ctx) => _EditInvoiceDialog(invoice: invoice),
    );

    if (result == null || !mounted) return;

    try {
      await ref.read(invoiceRepositoryProvider).updateInvoice(invoice.id, {
        'service_cost': result.service.isEmpty ? '0.00' : result.service,
        'parts_cost': result.parts.isEmpty ? '0.00' : result.parts,
      });
      ref.invalidate(invoicesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.invoiceAmountUpdated)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  Future<void> _confirmMarkPaid(InvoiceModel invoice) async {
    final s = AppStrings.of(context);
    final ok = await showAppDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('${s.markAsPaid}?'),
        content: Text(
          '₹${invoice.totalAmount} — Invoice #${invoice.id}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(s.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(s.yesPaid),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _updatePaymentStatus(invoice.id, 'paid');
    }
  }

  Future<void> _updatePaymentStatus(int id, String status) async {
    final s = AppStrings.of(context);
    try {
      await ref.read(invoiceRepositoryProvider).updateInvoice(id, {
        'payment_status': status,
      });
      ref.invalidate(invoicesProvider);
      if (mounted) {
        final label = s.paymentStatus(status);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${s.statusUpdated}: $label')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }
}

class _InvoiceCard extends StatelessWidget {
  const _InvoiceCard({
    required this.invoice,
    required this.onTap,
    required this.onMarkPaid,
  });

  final InvoiceModel invoice;
  final VoidCallback onTap;
  final VoidCallback onMarkPaid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);
    final booking = invoice.bookingDetail;
    final isPending = invoice.paymentStatus == 'pending' ||
        invoice.paymentStatus == 'partial';

    return GlassCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Invoice #${invoice.id}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              StatusChip(status: invoice.paymentStatus),
            ],
          ),
          if (booking?.customerDetail != null) ...[
            const SizedBox(height: 8),
            Text(
              booking!.customerDetail!.name.isNotEmpty
                  ? booking.customerDetail!.name
                  : booking.customerDetail!.phone,
              style: theme.textTheme.bodyLarge,
            ),
          ],
          if (booking?.vehicleDetail != null) ...[
            const SizedBox(height: 4),
            Text(
              '${booking!.vehicleDetail!.displayName} · ${booking.vehicleDetail!.vehicleNumber}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          if (booking != null) ...[
            const SizedBox(height: 4),
            Text(
              '${s.serviceCost}: ${s.serviceType(booking.serviceType)}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const Divider(height: 24),
          _row(theme, s.serviceCost, '₹${invoice.serviceCost}'),
          _row(theme, s.partsCost, '₹${invoice.partsCost}'),
          const SizedBox(height: 8),
          _row(theme, s.total, '₹${invoice.totalAmount}', bold: true),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => WhatsAppShare.sendInvoicePdf(
                context: context,
                invoice: invoice,
              ),
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: Text(s.sendInvoicePdf),
            ),
          ),
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onTap,
                    child: Text(s.manage),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onMarkPaid,
                    child: Text(s.markPaid),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(ThemeData theme, String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: bold
                ? theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _EditInvoiceDialog extends StatefulWidget {
  const _EditInvoiceDialog({required this.invoice});

  final InvoiceModel invoice;

  @override
  State<_EditInvoiceDialog> createState() => _EditInvoiceDialogState();
}

class _EditInvoiceDialogState extends State<_EditInvoiceDialog> {
  late final TextEditingController _serviceController;
  late final TextEditingController _partsController;

  @override
  void initState() {
    super.initState();
    _serviceController = TextEditingController(text: widget.invoice.serviceCost);
    _partsController = TextEditingController(text: widget.invoice.partsCost);
  }

  @override
  void dispose() {
    _serviceController.dispose();
    _partsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);
    return AlertDialog(
      title: Text('${s.editAmount} #${widget.invoice.id}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _serviceController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              labelText: '${s.serviceCost} (₹)',
              prefixIcon: const Icon(Icons.build),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _partsController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
            ],
            decoration: InputDecoration(
              labelText: '${s.partsCost} (₹)',
              prefixIcon: const Icon(Icons.settings),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            s.updateServicePartsCost,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(s.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(
              context,
              (
                service: _serviceController.text.trim(),
                parts: _partsController.text.trim(),
              ),
            );
          },
          child: Text(s.save),
        ),
      ],
    );
  }
}
