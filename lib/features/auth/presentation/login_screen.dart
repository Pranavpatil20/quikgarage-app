import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../theme/app_colors.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
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
          'Please tap Sign In again.';
    }
    return msg
        .replaceFirst('Exception: ', '')
        .replaceFirst('AuthException: ', '');
  }

  Future<void> _navigateAfterLogin() async {
    if (!mounted) return;
    final user = ref.read(authStateProvider).value;
    if (user == null) return;

    if (user.isOwner) {
      context.go('/owner');
    } else {
      context.go('/customer');
    }
  }

  Future<void> _signIn() async {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;
    if (phone.length < 10) {
      setState(() => _error = 'Enter a valid 10-digit phone number');
      return;
    }
    if (password.isEmpty) {
      setState(() => _error = 'Enter your password');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref.read(authStateProvider.notifier).loginWithPassword(
            phone: phone,
            password: password,
          );
      await _navigateAfterLogin();
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
    return Scaffold(
      backgroundColor: AppColors.brandYellow,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              const Center(child: AppLogo(size: 84)),
              const SizedBox(height: 16),
              Text(
                'QuikGarage',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: AppColors.onYellow,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in with your phone & password',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.onYellow.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(height: 40),
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        onSubmitted: (_) => _loading ? null : _signIn(),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
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
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: _loading ? null : _signIn,
                        child: _loading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Sign In'),
                      ),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _loading ? null : () => context.push('/signup'),
                        child: const Text("Don't have an account? Sign Up"),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 16),
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
