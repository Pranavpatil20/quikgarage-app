import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/parts_catalog.dart';
import '../../../../core/providers/garage_provider.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../repositories/garage_repository.dart';

/// Owner sets default prices for service types and common parts.
class RatesSettingsScreen extends ConsumerStatefulWidget {
  const RatesSettingsScreen({super.key});

  @override
  ConsumerState<RatesSettingsScreen> createState() => _RatesSettingsScreenState();
}

class _RatesSettingsScreenState extends ConsumerState<RatesSettingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final Map<String, TextEditingController> _serviceCtrls = {};
  final Map<String, TextEditingController> _partCtrls = {};
  bool _hydrated = false;
  bool _saving = false;
  String _partQuery = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    for (final key in AppConstants.serviceTypes) {
      _serviceCtrls[key] = TextEditingController();
    }
  }

  @override
  void dispose() {
    _tabs.dispose();
    for (final c in _serviceCtrls.values) {
      c.dispose();
    }
    for (final c in _partCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _hydrateFromGarage() {
    final garage = ref.read(myGarageProvider).valueOrNull;
    if (garage == null || _hydrated) return;
    for (final key in AppConstants.serviceTypes) {
      final v = garage.serviceRates[key]?.toString() ??
          (key == 'general_service' ? garage.defaultServiceCost : '');
      _serviceCtrls[key]!.text = v;
    }
    for (final part in PartsCatalog.all) {
      final ctrl = _partCtrls.putIfAbsent(part.name, TextEditingController.new);
      final saved = garage.partRates[part.name]?.toString();
      ctrl.text = saved ?? (part.defaultRate > 0 ? part.defaultRate.toStringAsFixed(0) : '');
    }
    _hydrated = true;
  }

  Future<void> _save() async {
    final garage = ref.read(myGarageProvider).valueOrNull;
    if (garage == null) return;
    setState(() => _saving = true);
    try {
      final serviceRates = <String, String>{};
      for (final e in _serviceCtrls.entries) {
        final v = e.value.text.trim();
        if (v.isNotEmpty) serviceRates[e.key] = v;
      }
      final partRates = <String, String>{};
      for (final e in _partCtrls.entries) {
        final v = e.value.text.trim();
        if (v.isNotEmpty) partRates[e.key] = v;
      }
      final general = serviceRates['general_service'] ?? garage.defaultServiceCost;
      await ref.read(garageRepositoryProvider).updateGarage(garage.id, {
        'service_rates': serviceRates,
        'part_rates': partRates,
        'default_service_cost': general,
      });
      ref.invalidate(myGarageProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Default rates saved')),
        );
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
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    ref.watch(myGarageProvider);
    _hydrateFromGarage();

    final parts = PartsCatalog.all.where((p) {
      if (_partQuery.trim().isEmpty) return true;
      return p.name.toLowerCase().contains(_partQuery.trim().toLowerCase());
    }).toList();

    final bottomPad = AppBottomNavBar.contentBottomPadding(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rates'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Service types'),
            Tab(text: 'Parts'),
          ],
        ),
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
      body: TabBarView(
        controller: _tabs,
        children: [
          ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad),
            children: [
              Text(
                'Default labour / service prices used when creating invoices.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              ...AppConstants.serviceTypes.map((key) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    child: TextField(
                      controller: _serviceCtrls[key],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: s.serviceType(key),
                        prefixText: '₹ ',
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search parts',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _partQuery = v),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad),
                  itemCount: parts.length,
                  itemBuilder: (context, index) {
                    final part = parts[index];
                    final ctrl = _partCtrls.putIfAbsent(
                      part.name,
                      TextEditingController.new,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: GlassCard(
                        child: TextField(
                          controller: ctrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: part.name,
                            helperText: '${part.category} · ${part.vehicleTypes.join("/")}',
                            prefixText: '₹ ',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
