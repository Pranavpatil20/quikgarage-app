import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/parts_catalog.dart';
import '../../../../core/providers/booking_provider.dart';
import '../../../../core/providers/garage_provider.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../models/booking_model.dart';
import '../../../../models/garage_model.dart';
import '../../../../repositories/booking_repository.dart';

/// Owner adds/edits parts & labour while booking is In Progress.
class UpdateServiceScreen extends ConsumerStatefulWidget {
  const UpdateServiceScreen({super.key, required this.booking});

  final BookingModel booking;

  @override
  ConsumerState<UpdateServiceScreen> createState() => _UpdateServiceScreenState();
}

class _UpdateServiceScreenState extends ConsumerState<UpdateServiceScreen> {
  late List<ServiceLineItem> _items;
  final _searchController = TextEditingController();
  bool _saving = false;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _items = widget.booking.serviceItems
        .map((e) => ServiceLineItem.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _vehicleType =>
      widget.booking.vehicleDetail?.vehicleType.toLowerCase() ?? 'bike';

  GarageModel? get _garage =>
      widget.booking.garageDetail ?? ref.read(myGarageProvider).valueOrNull;

  double _defaultRateFor(PartCatalogItem part) {
    final garage = _garage;
    final fromGarage = garage?.partRates[part.name];
    if (fromGarage != null) {
      final parsed = double.tryParse(fromGarage.toString());
      if (parsed != null) return parsed;
    }
    final fromService = garage?.serviceRates[part.name];
    if (fromService != null) {
      final parsed = double.tryParse(fromService.toString());
      if (parsed != null) return parsed;
    }
    return part.defaultRate;
  }

  void _addPart(PartCatalogItem part) {
    setState(() {
      _items.add(ServiceLineItem(
        name: part.name,
        category: part.category,
        qty: 1,
        rate: _defaultRateFor(part),
      ));
      _query = '';
      _searchController.clear();
    });
  }

  void _addCustom() {
    final nameController = TextEditingController();
    var category = 'parts';
    final rateController = TextEditingController(text: '0');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add custom item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: category,
              decoration: const InputDecoration(labelText: 'Category'),
              items: const [
                DropdownMenuItem(value: 'lubricant', child: Text('Lubricant')),
                DropdownMenuItem(value: 'parts', child: Text('Parts')),
                DropdownMenuItem(value: 'labour', child: Text('Labour')),
              ],
              onChanged: (v) {
                if (v != null) category = v;
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: rateController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Rate (₹)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isEmpty) return;
              setState(() {
                _items.add(ServiceLineItem(
                  name: name,
                  category: category,
                  qty: 1,
                  rate: double.tryParse(rateController.text) ?? 0,
                ));
              });
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(bookingRepositoryProvider).updateServiceItems(
            widget.booking.id,
            serviceItems: _items.map((e) => e.toJson()).toList(),
          );
      refreshBookings(ref);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Service items saved')),
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
    final catalog = PartsCatalog.forVehicle(_vehicleType, query: _query);
    final total = _items.fold<double>(0, (sum, e) => sum + e.amount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Service'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(s.save),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            widget.booking.vehicleDetail?.displayName ?? s.vehicleLabel,
            style: theme.textTheme.titleLarge,
          ),
          Text(
            '${s.serviceType(widget.booking.serviceType)} · ${_vehicleType.toUpperCase()}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search parts (${catalog.length} matches)',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'Add custom',
                onPressed: _addCustom,
              ),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
          if (_query.isNotEmpty || catalog.length <= 12) ...[
            const SizedBox(height: 8),
            ...catalog.take(12).map(
                  (p) => ListTile(
                    dense: true,
                    title: Text(p.name),
                    subtitle: Text('${p.category} · ₹${_defaultRateFor(p).toStringAsFixed(0)}'),
                    trailing: const Icon(Icons.add),
                    onTap: () => _addPart(p),
                  ),
                ),
          ] else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Type to search ${PartsCatalog.forVehicle(_vehicleType).length}+ parts, or tap + to add custom',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          const SizedBox(height: 12),
          Text('Selected items', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),
          if (_items.isEmpty)
            GlassCard(
              child: Text(
                'No parts added yet. Search and add items used for this service.',
                style: theme.textTheme.bodyMedium,
              ),
            )
          else
            ...List.generate(_items.length, (i) {
              final item = _items[i];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
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
                      Text(
                        item.category.toUpperCase(),
                        style: theme.textTheme.labelSmall,
                      ),
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
                              initialValue: item.rate.toStringAsFixed(0),
                              decoration: const InputDecoration(labelText: 'Rate ₹'),
                              keyboardType: TextInputType.number,
                              onChanged: (v) => setState(() {
                                item.rate = double.tryParse(v) ?? 0;
                              }),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Amount: ₹${item.amount.toStringAsFixed(2)}',
                          style: theme.textTheme.labelLarge,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          const SizedBox(height: 16),
          Text(
            'Estimated total: ₹${total.toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: const Text('Save to booking'),
          ),
        ],
      ),
    );
  }
}
