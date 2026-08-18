import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/garage_provider.dart';
import '../../../theme/app_colors.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _garageNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String _selectedRole = 'customer';
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _garageNameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _formatError(Object e) {
    final msg = e.toString();
    if (msg.contains('receiveTimeout') ||
        msg.contains('took longer than') ||
        msg.contains('Connection') ||
        msg.contains('SocketException') ||
        msg.contains('waking up')) {
      return 'Server is waking up (first request can take ~1 min).\n\n'
          'Please tap Submit again — it usually works on the second try.';
    }
    return msg
        .replaceFirst('Exception: ', '')
        .replaceFirst('AuthException: ', '');
  }

  Future<void> _submit() async {
    final phone = _phoneController.text.trim();
    final name = _nameController.text.trim();
    final password = _passwordController.text;
    final confirm = _confirmPasswordController.text;
    final garageName = _garageNameController.text.trim();

    if (_selectedRole.isEmpty) {
      setState(() => _error = 'Select Owner or Customer');
      return;
    }
    if (phone.length < 10) {
      setState(() => _error = 'Enter a valid 10-digit phone number');
      return;
    }
    if (name.isEmpty) {
      setState(() => _error = _selectedRole == 'owner'
          ? 'Enter owner name'
          : 'Enter customer name');
      return;
    }
    if (_selectedRole == 'owner' && garageName.isEmpty) {
      setState(() => _error = 'Enter garage name');
      return;
    }
    if (password.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }
    if (password != confirm) {
      setState(() => _error = 'Passwords do not match');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authStateProvider.notifier).register(
            phone: phone,
            name: name,
            password: password,
            confirmPassword: confirm,
            role: _selectedRole,
            garageName: _selectedRole == 'owner' ? garageName : null,
          );
      ref.invalidate(myGarageProvider);
      ref.invalidate(garagesProvider);
      if (!mounted) return;
      if (_selectedRole == 'owner') {
        context.go('/owner');
      } else {
        context.go('/customer');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = _formatError(e);
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOwner = _selectedRole == 'owner';

    return Scaffold(
      backgroundColor: AppColors.brandYellow,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'Create account',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: AppColors.onYellow,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppConstants.appName,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onYellow.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DropdownMenu<String>(
                        initialSelection: _selectedRole,
                        expandedInsets: EdgeInsets.zero,
                        label: const Text('I am a'),
                        leadingIcon: const Icon(Icons.person_outline),
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: 'owner', label: 'Owner'),
                          DropdownMenuEntry(value: 'customer', label: 'Customer'),
                        ],
                        onSelected: (value) {
                          if (value == null) return;
                          setState(() {
                            _selectedRole = value;
                            _error = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          prefixText: '+91 ',
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: isOwner ? 'Owner Name' : 'Customer Name',
                          prefixIcon: const Icon(Icons.badge_outlined),
                        ),
                      ),
                      if (isOwner) ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: _garageNameController,
                          decoration: const InputDecoration(
                            labelText: 'Garage Name',
                            prefixIcon: Icon(Icons.store),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirm,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () => setState(
                              () => _obscureConfirm = !_obscureConfirm,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loading ? null : _submit,
                        child: _loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Submit'),
                      ),
                      TextButton(
                        onPressed: _loading ? null : () => context.go('/login'),
                        child: const Text('Already have an account? Sign In'),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
