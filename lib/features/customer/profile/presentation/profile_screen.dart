import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/vehicle_provider.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_overlays.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../repositories/user_repository.dart';
import '../../../../core/widgets/mic_text_field.dart';
import '../../../../repositories/vehicle_repository.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _hydrated = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    final s = AppStrings.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.enterName)));
      return;
    }
    setState(() => _saving = true);
    try {
      final user = await ref.read(userRepositoryProvider).updateProfile(name: name);
      ref.read(authStateProvider.notifier).setUser(user);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.profileUpdated)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _showLanguagePicker() async {
    final s = AppStrings.of(context);
    final current = ref.read(localeProvider);
    await showAppModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Text(s.selectLanguage, style: Theme.of(ctx).textTheme.titleMedium),
                ),
                ...AppLanguage.values.map((lang) {
                  return ListTile(
                    leading: Icon(
                      current == lang ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: Theme.of(ctx).colorScheme.primary,
                    ),
                    title: Text(lang.label),
                    onTap: () async {
                      await ref.read(localeProvider.notifier).setLanguage(lang);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                  );
                }),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showAddVehicleSheet() async {
    final created = await showAppModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _AddVehicleSheet(
        onSubmit: (number, model, vehicleType) {
          return ref.read(vehicleRepositoryProvider).createVehicle({
            'vehicle_number': number,
            'make_model': model,
            'vehicle_type': vehicleType,
            'is_primary': true,
          });
        },
      ),
    );

    if (created == true && mounted) {
      ref.invalidate(vehiclesProvider);
      final s = AppStrings.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.vehicleAdded)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final vehiclesAsync = ref.watch(vehiclesProvider);
    final themeMode = ref.watch(themeModeProvider);
    final language = ref.watch(localeProvider);
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    if (user != null && !_hydrated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _nameController.text = user.name;
          _phoneController.text = user.phone;
          _hydrated = true;
        });
      });
    }

    final keyboardInset = MediaQuery.viewInsetsOf(context).bottom;
    final bottomPad = keyboardInset > 80
        ? keyboardInset + 24
        : AppBottomNavBar.contentBottomPadding(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(s.profile),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPad),
        children: [
          Center(
            child: CircleAvatar(
              radius: 48,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(Icons.person, size: 48, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 24),
          GlassCard(
            child: Column(
              children: [
                MicTextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: s.name),
                ),
                const SizedBox(height: 8),
                TextField(
                  enabled: false,
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: s.phone),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saving ? null : _saveProfile,
                  child: _saving
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(s.saveProfile),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(s.myVehicles, style: theme.textTheme.headlineMedium),
              ),
              TextButton.icon(
                onPressed: _showAddVehicleSheet,
                icon: const Icon(Icons.add, size: 18),
                label: Text(s.addNew),
              ),
            ],
          ),
          const SizedBox(height: 12),
          vehiclesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Text(e.toString()),
            data: (vehicles) {
              if (vehicles.isEmpty) {
                return GlassCard(
                  child: Column(
                    children: [
                      Icon(
                        Icons.directions_car_outlined,
                        size: 40,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        s.noVehiclesYet,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Column(
                children: vehicles.map((v) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GlassCard(
                      child: ListTile(
                        leading: Icon(
                          v.vehicleType == 'bike'
                              ? Icons.two_wheeler
                              : Icons.directions_car,
                          color: theme.colorScheme.primary,
                        ),
                        title: Text(v.displayName),
                        subtitle: Text(
                          '${v.vehicleNumber} · ${v.vehicleType.toUpperCase()}',
                        ),
                        trailing: v.isPrimary
                            ? Chip(
                                label: Text(
                                  s.primary,
                                  style: theme.textTheme.labelSmall,
                                ),
                              )
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.translate, color: theme.colorScheme.primary),
                  title: Text(s.language),
                  subtitle: Text(language.label),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _showLanguagePicker,
                ),
                SwitchListTile(
                  title: Text(s.darkMode),
                  value: themeMode == AppThemeMode.dark,
                  onChanged: (enabled) {
                    ref.read(themeModeProvider.notifier).setDark(enabled);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: Text(s.logout, style: const TextStyle(color: Colors.red)),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _AddVehicleSheet extends StatefulWidget {
  const _AddVehicleSheet({required this.onSubmit});

  final Future<void> Function(String number, String model, String vehicleType)
      onSubmit;

  @override
  State<_AddVehicleSheet> createState() => _AddVehicleSheetState();
}

class _AddVehicleSheetState extends State<_AddVehicleSheet> {
  final _numberController = TextEditingController();
  final _modelController = TextEditingController();
  String _vehicleType = 'bike';
  bool _saving = false;

  @override
  void dispose() {
    _numberController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final s = AppStrings.of(context);
    final number = _numberController.text.trim().toUpperCase();
    if (number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.vehicleNumber)),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await widget.onSubmit(
        number,
        _modelController.text.trim(),
        _vehicleType,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 8,
          bottom: bottomInset + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(s.addNew, style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('Vehicle type', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'bike',
                  label: Text('Bike'),
                  icon: Icon(Icons.two_wheeler),
                ),
                ButtonSegment(
                  value: 'car',
                  label: Text('Car'),
                  icon: Icon(Icons.directions_car),
                ),
              ],
              selected: {_vehicleType},
              onSelectionChanged: (v) => setState(() => _vehicleType = v.first),
            ),
            const SizedBox(height: 16),
            MicTextField(
              controller: _numberController,
              textCapitalization: TextCapitalization.characters,
              decoration: InputDecoration(
                labelText: s.vehicleNumber,
                prefixIcon: const Icon(Icons.pin),
              ),
            ),
            const SizedBox(height: 12),
            MicTextField(
              controller: _modelController,
              decoration: InputDecoration(
                labelText: s.makeModel,
                prefixIcon: Icon(
                  _vehicleType == 'bike'
                      ? Icons.two_wheeler
                      : Icons.directions_car,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(s.addNew),
            ),
          ],
        ),
      ),
    );
  }
}
