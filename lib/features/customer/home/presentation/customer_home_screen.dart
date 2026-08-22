import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/booking_provider.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/bike_service_carousel.dart';
import '../../../../core/widgets/booking_card.dart';
import '../../../../core/widgets/brand_header.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/notification_bell_button.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../services/fcm_service.dart';
import '../../../../theme/app_colors.dart';

class CustomerHomeScreen extends ConsumerWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final bookingsAsync = ref.watch(customerBookingsProvider(null));
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    bookingsAsync.whenData((list) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        ref.read(fcmServiceProvider).syncServiceReminders(list);
      });
    });
    ref.listen(customerBookingsProvider(null), (prev, next) {
      next.whenData((list) {
        ref.read(fcmServiceProvider).syncServiceReminders(list);
      });
    });

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
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(customerBookingsProvider),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: BrandHeader(
                child: Row(
                  children: [
                    const AppLogo(size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        s.customerHi(user?.name ?? ''),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onYellow,
                        ),
                      ),
                    ),
                    NotificationBellButton(
                      onPressed: () => context.push('/customer/notifications'),
                    ),
                  ],
                ),
              ),
            ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BikeServiceCarousel.customer(),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/customer/book'),
                        icon: const Icon(Icons.arrow_forward),
                        label: Text(s.bookService),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brandYellow,
                          foregroundColor: AppColors.onYellow,
                          disabledForegroundColor:
                              AppColors.onYellow.withValues(alpha: 0.6),
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ],
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
              SliverToBoxAdapter(
                child: SizedBox(height: AppBottomNavBar.contentBottomPadding(context)),
              ),
            ],
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
