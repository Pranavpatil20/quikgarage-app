import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/booking_provider.dart';
import '../../../../core/widgets/booking_card.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../theme/app_colors.dart';

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final bookingsAsync = ref.watch(customerBookingsProvider(null));
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    final activeBooking = bookingsAsync.maybeWhen(
      data: (list) {
        final active = list.where(
          (b) => b.status == 'in_progress' || b.status == 'confirmed',
        );
        return active.isEmpty ? null : active.first;
      },
      orElse: () => null,
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: () async => ref.invalidate(customerBookingsProvider),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(Icons.person, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          s.customerHi(user?.name ?? ''),
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () => context.push('/customer/notifications'),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 240,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            'https://images.unsplash.com/photo-1617788138017-80e456137b25?w=800',
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => ColoredBox(
                              color: theme.colorScheme.primaryContainer,
                            ),
                          ),
                          // Dark gradient so white text stays readable.
                          const DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0x33000000),
                                  Color(0x99000000),
                                  Color(0xE6000000),
                                ],
                                stops: [0.0, 0.45, 1.0],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  s.readyForCheckup,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    height: 1.2,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 8,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  s.bookPremiumService,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.95),
                                    height: 1.35,
                                    shadows: const [
                                      Shadow(
                                        blurRadius: 6,
                                        color: Colors.black45,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 14),
                                ElevatedButton.icon(
                                  onPressed: () => context.push('/customer/book'),
                                  icon: const Icon(Icons.arrow_forward),
                                  label: Text(s.bookService),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.primary,
                                    disabledForegroundColor:
                                        AppColors.primary.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (activeBooking != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(s.serviceStatus, style: theme.textTheme.headlineMedium),
                            Text(
                              s.liveTrack,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GlassCard(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          activeBooking.vehicleDetail?.displayName ??
                                              s.vehicleLabel,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.headlineMedium?.copyWith(
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                        Text(
                                          activeBooking.vehicleDetail?.vehicleNumber ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  StatusChip(
                                    status: activeBooking.status,
                                    icon: Icons.sync,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _ServiceProgressTracker(status: activeBooking.status),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(s.myBookings, style: theme.textTheme.headlineMedium),
                      TextButton(
                        onPressed: () => context.go('/customer/bookings'),
                        child: Text(s.viewAll),
                      ),
                    ],
                  ),
                ),
              ),
              bookingsAsync.when(
                loading: () => const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SliverFillRemaining(child: Center(child: Text(e.toString()))),
                data: (bookings) => SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index >= bookings.take(3).length) return null;
                      final booking = bookings[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: BookingCard(booking: booking),
                      );
                    },
                    childCount: bookings.take(3).length,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceProgressTracker extends StatelessWidget {
  const _ServiceProgressTracker({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = AppStrings.of(context);
    final steps = [s.stepInGarage, s.stepStarted, s.stepWashing, s.stepReady];
    final activeIndex = switch (status) {
      'pending' || 'confirmed' => 0,
      'in_progress' => 1,
      'completed' => 3,
      _ => 0,
    };

    return Row(
      children: List.generate(steps.length, (index) {
        final done = index <= activeIndex;
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHigh,
                  border: done ? null : Border.all(color: theme.colorScheme.outlineVariant, width: 2),
                ),
                child: done
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(height: 8),
              Text(
                steps[index],
                style: theme.textTheme.labelSmall?.copyWith(
                  color: done ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }),
    );
  }
}
