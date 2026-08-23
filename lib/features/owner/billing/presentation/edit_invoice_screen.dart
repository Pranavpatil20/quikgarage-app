import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/parts_catalog.dart';
import '../../../../core/providers/invoice_provider.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../models/invoice_model.dart';
import '../../../../repositories/invoice_repository.dart';

class EditInvoiceScreen extends ConsumerStatefulWidget {
  const EditInvoiceScreen({super.key, required this.invoice});

  final InvoiceModel invoice;

  @override
  ConsumerState<EditInvoiceScreen> createState() => _EditInvoiceScreenState();
}

class _EditInvoiceScreenState extends ConsumerState<EditInvoiceScreen> {
  late List<ServiceLineItem> _items;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.invoice.lineItems.isNotEmpty) {
      _items = widget.invoice.lineItems
          .map((e) => ServiceLineItem.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      _items = [
        ServiceLineItem(
          name: 'Service / Labour',
          category: 'labour',
          rate: double.tryParse(widget.invoice.serviceCost) ?? 0,
        ),
        if ((double.tryParse(widget.invoice.partsCost) ?? 0) > 0)
          ServiceLineItem(
            name: 'Parts',
            category: 'parts',
            rate: double.tryParse(widget.invoice.partsCost) ?? 0,
          ),
      ];
    }

    // Older invoices may only have parts lines — always show service too.
    final hasLabour = _items.any((e) => e.category.toLowerCase() == 'labour');
    if (!hasLabour) {
      final serviceAmt = double.tryParse(widget.invoice.serviceCost) ?? 0;
      final rawType = widget.invoice.bookingDetail?.serviceType.trim() ?? '';
      _items.insert(
        0,
        ServiceLineItem(
          name: rawType.isNotEmpty ? rawType : 'Service / Labour',
          category: 'labour',
          rate: serviceAmt,
        ),
      );
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final payload = _items.map((e) => e.toJson()).toList();
      await ref.read(invoiceRepositoryProvider).updateInvoice(
        widget.invoice.id,
        {'line_items': payload},
      );
      ref.invalidate(invoicesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invoice updated')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);
    final total = _items.fold<double>(0, (sum, e) => sum + e.amount);
    final serviceTotal = _items
        .where((e) => e.category.toLowerCase() == 'labour')
        .fold<double>(0, (sum, e) => sum + e.amount);
    final partsTotal = total - serviceTotal;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Invoice #${widget.invoice.id}'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: Text(s.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Update qty and rate for each line. Service and parts both appear here.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_items.length, (i) {
            final item = _items[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => setState(() => _items.removeAt(i)),
                        ),
                      ],
                    ),
                    Text(item.category.toUpperCase()),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.qty.toString(),
                            decoration: const InputDecoration(labelText: 'Qty'),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => setState(() {
                              item.qty = double.tryParse(v) ?? 1;
                            }),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: item.rate.toStringAsFixed(2),
                            decoration: const InputDecoration(labelText: 'Rate ₹'),
                            keyboardType: TextInputType.number,
                            onChanged: (v) => setState(() {
                              item.rate = double.tryParse(v) ?? 0;
                            }),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('₹${item.amount.toStringAsFixed(2)}'),
                    ),
                  ],
                ),
              ),
            );
          }),
          TextButton.icon(
            onPressed: () {
              setState(() {
                _items.add(ServiceLineItem(
                  name: 'Custom item',
                  category: 'parts',
                  rate: 0,
                ));
              });
            },
            icon: const Icon(Icons.add),
            label: const Text('Add line'),
          ),
          const SizedBox(height: 16),
          Text('Service / Labour: ₹${serviceTotal.toStringAsFixed(2)}'),
          Text('Parts: ₹${partsTotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Text(
            '${s.total}: ₹${total.toStringAsFixed(2)}',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(s.save),
          ),
        ],
      ),
    );
  }
}
