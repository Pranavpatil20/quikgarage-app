import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/vehicle_provider.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../repositories/user_repository.dart';

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
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter your name')),
      );
      return;
    }
    setState(() => _saving = true);
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
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;
    final vehiclesAsync = ref.watch(vehiclesProvider);
    final themeMode = ref.watch(themeModeProvider);
    final theme = Theme.of(context);

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
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
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 8),
                TextField(
                  enabled: false,
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Phone'),
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
                      : const Text('Save Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('My Vehicles', style: theme.textTheme.headlineMedium),
          const SizedBox(height: 12),
          vehiclesAsync.when(
            loading: () => const CircularProgressIndicator(),
            error: (e, _) => Text(e.toString()),
            data: (vehicles) {
              if (vehicles.isEmpty) {
                return Text(
                  'No vehicles added yet.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                );
              }
              return Column(
                children: vehicles.map((v) {
                  return GlassCard(
                    child: ListTile(
                      leading: Icon(Icons.directions_car, color: theme.colorScheme.primary),
                      title: Text(v.displayName),
                      subtitle: Text(v.vehicleNumber),
                      trailing: v.isPrimary
                          ? Chip(label: Text('Primary', style: theme.textTheme.labelSmall))
                          : null,
                    ),
                  );
                }).toList(),
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
          const SizedBox(height: 24),
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
