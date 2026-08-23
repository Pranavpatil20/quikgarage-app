import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/support_contact_card.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../theme/app_colors.dart';

class OwnerPaymentLockScreen extends ConsumerWidget {
  const OwnerPaymentLockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              const Center(child: AppLogo(size: 72)),
              const SizedBox(height: 32),
              Icon(
                Icons.lock_outline_rounded,
                size: 56,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                s.subscriptionPaymentRequired,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                s.subscriptionPaymentMessage,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              const SupportContactCard(),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () async {
                  await ref.read(authStateProvider.notifier).signOut();
                  if (context.mounted) context.go('/login');
                },
                icon: const Icon(Icons.logout),
                label: Text(s.logout),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
