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

  String get _vehicleType =>
      widget.invoice.bookingDetail?.vehicleDetail?.vehicleType.toLowerCase() ??
      'bike';

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
    final cleaned = _items
        .map((e) {
          final name = e.name.trim();
          if (name.isEmpty) return null;
          e.name = name;
          return e;
        })
        .whereType<ServiceLineItem>()
        .toList();
    if (cleaned.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one named line item')),
      );
      return;
    }
    setState(() {
      _items = cleaned;
      _saving = true;
    });
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

  Future<void> _showAddLineDialog() async {
    final added = await showDialog<ServiceLineItem>(
      context: context,
      builder: (ctx) => _AddInvoiceLineDialog(vehicleType: _vehicleType),
    );

    if (added != null && mounted) {
      setState(() => _items.add(added));
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
            'Update name, qty and rate for each line. Service and parts both appear here.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(_items.length, (i) {
            final item = _items[i];
            return Padding(
              key: ValueKey('invoice-line-$i-${item.category}-${item.name}'),
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.name,
                            decoration: const InputDecoration(
                              labelText: 'Item name',
                              isDense: true,
                            ),
                            onChanged: (v) => item.name = v,
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remove line',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => setState(() => _items.removeAt(i)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.category.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            initialValue: item.qty.toString(),
                            decoration: const InputDecoration(labelText: 'Qty'),
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              item.qty = double.tryParse(v) ?? 1;
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            initialValue: item.rate.toStringAsFixed(2),
                            decoration: const InputDecoration(labelText: 'Rate (Rs.)'),
                            keyboardType: TextInputType.number,
                            onChanged: (v) {
                              item.rate = double.tryParse(v) ?? 0;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('Rs.${item.amount.toStringAsFixed(2)}'),
                    ),
                  ],
                ),
              ),
            );
          }),
          TextButton.icon(
            onPressed: _showAddLineDialog,
            icon: const Icon(Icons.add),
            label: const Text('Add line'),
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _totalRow(theme, 'Service / Labour', serviceTotal),
                const SizedBox(height: 6),
                _totalRow(theme, 'Parts', partsTotal),
                const Divider(height: 20),
                _totalRow(theme, s.total, total, bold: true),
              ],
            ),
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

  Widget _totalRow(ThemeData theme, String label, double amount, {bool bold = false}) {
    final style = bold
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : theme.textTheme.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: style)),
        Text('Rs.${amount.toStringAsFixed(2)}', style: style),
      ],
    );
  }
}

class _AddInvoiceLineDialog extends StatefulWidget {
  const _AddInvoiceLineDialog({required this.vehicleType});

  final String vehicleType;

  @override
  State<_AddInvoiceLineDialog> createState() => _AddInvoiceLineDialogState();
}

class _AddInvoiceLineDialogState extends State<_AddInvoiceLineDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _rateController;
  late final TextEditingController _searchController;
  String _category = 'parts';
  String _query = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _rateController = TextEditingController(text: '0');
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rateController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _addManual() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    Navigator.pop(
      context,
      ServiceLineItem(
        name: name,
        category: _category,
        qty: 1,
        rate: double.tryParse(_rateController.text) ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalog = PartsCatalog.forVehicle(widget.vehicleType, query: _query);

    return AlertDialog(
      title: const Text('Add line item'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  labelText: 'Search parts catalog',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
              if (_query.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 160),
                  child: ListView(
                    shrinkWrap: true,
                    children: catalog.take(8).map((p) {
                      return ListTile(
                        dense: true,
                        title: Text(p.name),
                        subtitle: Text(p.category),
                        trailing: Text('Rs.${p.defaultRate.toStringAsFixed(0)}'),
                        onTap: () {
                          Navigator.pop(
                            context,
                            ServiceLineItem(
                              name: p.name,
                              category: p.category,
                              qty: 1,
                              rate: p.defaultRate,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Item name',
                  hintText: 'e.g. Engine Oil 10W40',
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: const [
                  DropdownMenuItem(value: 'lubricant', child: Text('Lubricant')),
                  DropdownMenuItem(value: 'parts', child: Text('Parts')),
                  DropdownMenuItem(value: 'labour', child: Text('Labour')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _category = v);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _rateController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Rate (Rs.)',
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _addManual,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
