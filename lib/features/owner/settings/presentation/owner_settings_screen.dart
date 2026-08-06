import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/garage_provider.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../repositories/garage_repository.dart';
import '../../../../repositories/user_repository.dart';

class OwnerSettingsScreen extends ConsumerStatefulWidget {
  const OwnerSettingsScreen({super.key});

  @override
  ConsumerState<OwnerSettingsScreen> createState() => _OwnerSettingsScreenState();
}

class _OwnerSettingsScreenState extends ConsumerState<OwnerSettingsScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _garageNameController = TextEditingController();
  final _addressController = TextEditingController();
  TimeOfDay _opening = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closing = const TimeOfDay(hour: 18, minute: 0);
  bool _saving = false;
  bool _savingProfile = false;
  bool _fieldsHydrated = false;
  int? _hydratedUserId;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _garageNameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(_hydrateProfile);
  }

  void _hydrateProfile() {
    final user = ref.read(authStateProvider).value;
    if (user == null || !mounted) return;
    setState(() {
      _nameController.text = user.name;
      _phoneController.text = user.phone;
      _hydratedUserId = user.id;
    });
  }

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return const TimeOfDay(hour: 9, minute: 0);
    return TimeOfDay(
      hour: int.tryParse(parts[0]) ?? 9,
      minute: int.tryParse(parts[1]) ?? 0,
    );
  }

  String _formatApiTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your name')),
      );
      return;
    }
    setState(() => _savingProfile = true);
    try {
      final user = await ref.read(userRepositoryProvider).updateProfile(name: name);
      ref.read(authStateProvider.notifier).setUser(user);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _createGarage() async {
    final name = _garageNameController.text.trim();
    final address = _addressController.text.trim();
    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter garage name and address')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(garageRepositoryProvider).createGarage({
        'garage_name': name,
        'address': address,
        'opening_time': _formatApiTime(_opening),
        'closing_time': _formatApiTime(_closing),
      });
      ref.invalidate(myGarageProvider);
      ref.invalidate(garagesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Garage created successfully')),
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

  Future<void> _saveGarage(int id) async {
    final name = _garageNameController.text.trim();
    final address = _addressController.text.trim();
    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter garage name and address')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(garageRepositoryProvider).updateGarage(id, {
        'garage_name': name,
        'address': address,
        'opening_time': _formatApiTime(_opening),
        'closing_time': _formatApiTime(_closing),
      });
      ref.invalidate(myGarageProvider);
      ref.invalidate(garagesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Garage updated')),
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

  Widget _garageForm({
    required ThemeData theme,
    required bool isCreate,
    int? garageId,
  }) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCreate ? 'Create Your Garage' : 'Garage Details',
            style: theme.textTheme.headlineMedium,
          ),
          if (isCreate) ...[
            const SizedBox(height: 8),
            Text(
              'Customers can only book after you create a garage.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _garageNameController,
            decoration: const InputDecoration(
              labelText: 'Garage Name',
              hintText: 'e.g. Raj Garage',
              prefixIcon: Icon(Icons.store),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _addressController,
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Address',
              hintText: 'Full garage address',
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Opening Time'),
            subtitle: Text(_opening.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final t = await showTimePicker(context: context, initialTime: _opening);
              if (t != null) setState(() => _opening = t);
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Closing Time'),
            subtitle: Text(_closing.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final t = await showTimePicker(context: context, initialTime: _closing);
              if (t != null) setState(() => _closing = t);
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saving
                ? null
                : () {
                    if (isCreate) {
                      _createGarage();
                    } else if (garageId != null) {
                      _saveGarage(garageId);
                    }
                  },
            child: _saving
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(isCreate ? 'Create Garage' : 'Save Garage'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final garageAsync = ref.watch(myGarageProvider);
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

    if (user != null) {
      final shouldHydrate = _hydratedUserId != user.id ||
          (_nameController.text.isEmpty && user.name.isNotEmpty);
      if (shouldHydrate) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          setState(() {
            _nameController.text = user.name;
            _phoneController.text = user.phone;
            _hydratedUserId = user.id;
          });
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Profile', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 16),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  enabled: false,
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _savingProfile ? null : _saveProfile,
                  child: _savingProfile
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          garageAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, __) => _garageForm(theme: theme, isCreate: true),
            data: (garage) {
              if (!_fieldsHydrated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  setState(() {
                    _garageNameController.text = garage.garageName;
                    _addressController.text = garage.address;
                    _opening = _parseTime(garage.openingTime);
                    _closing = _parseTime(garage.closingTime);
                    _fieldsHydrated = true;
                  });
                });
              }
              return _garageForm(
                theme: theme,
                isCreate: false,
                garageId: garage.id,
              );
            },
          ),
          const SizedBox(height: 16),
          GlassCard(
            child: SwitchListTile(
              title: const Text('Dark Mode'),
              value: themeMode == AppThemeMode.dark,
              onChanged: (enabled) {
                ref.read(themeModeProvider.notifier).setDark(enabled);
              },
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authStateProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout, color: Colors.red),
            label: const Text('Sign Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class OwnerGarageSetupScreen extends ConsumerStatefulWidget {
  const OwnerGarageSetupScreen({super.key});

  @override
  ConsumerState<OwnerGarageSetupScreen> createState() => _OwnerGarageSetupScreenState();
}

class _OwnerGarageSetupScreenState extends ConsumerState<OwnerGarageSetupScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  TimeOfDay _opening = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _closing = const TimeOfDay(hour: 18, minute: 0);
  bool _loading = false;
  bool _checking = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(_redirectIfGarageExists);
  }

  Future<void> _redirectIfGarageExists() async {
    try {
      await ref.read(garageRepositoryProvider).getMyGarage();
      if (mounted) context.go('/owner');
    } catch (_) {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String _formatApiTime(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  Future<void> _create() async {
    final name = _nameController.text.trim();
    final address = _addressController.text.trim();
    if (name.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter garage name and address')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(garageRepositoryProvider).createGarage({
        'garage_name': name,
        'address': address,
        'opening_time': _formatApiTime(_opening),
        'closing_time': _formatApiTime(_closing),
      });
      ref.invalidate(myGarageProvider);
      ref.invalidate(garagesProvider);
      if (mounted) context.go('/owner');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Your Garage'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(Icons.garage, size: 64, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              'Create your garage to start receiving bookings',
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Customers will only see your garage after you create it here.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Garage Name',
                hintText: 'e.g. Raj Garage',
                prefixIcon: Icon(Icons.store),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _addressController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Address',
                hintText: 'Full garage address',
                prefixIcon: Icon(Icons.location_on),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Opening Time'),
              subtitle: Text(_opening.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final t = await showTimePicker(context: context, initialTime: _opening);
                if (t != null) setState(() => _opening = t);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Closing Time'),
              subtitle: Text(_closing.format(context)),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final t = await showTimePicker(context: context, initialTime: _closing);
                if (t != null) setState(() => _closing = t);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _create,
              child: _loading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Garage & Continue'),
            ),
            TextButton(
              onPressed: () => context.go('/owner'),
              child: const Text('Skip for now'),
            ),
          ],
        ),
      ),
    );
  }
}
