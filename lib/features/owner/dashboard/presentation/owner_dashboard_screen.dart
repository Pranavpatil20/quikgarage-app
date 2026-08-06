import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/dashboard_provider.dart';
import '../../../../core/providers/garage_provider.dart';
import '../../../../core/widgets/booking_card.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/metric_card.dart';
import '../../../../core/widgets/quick_action_button.dart';

class OwnerDashboardScreen extends ConsumerWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final metricsAsync = ref.watch(dashboardMetricsProvider);
    final garageAsync = ref.watch(myGarageProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(dashboardMetricsProvider);
            ref.invalidate(myGarageProvider);
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(Icons.person, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning, ${user?.name ?? 'Owner'}',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            Text(
                              'Manage your services today',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined),
                        onPressed: () => context.push('/owner/notifications'),
                      ),
                    ],
                  ),
                ),
              ),
              if (garageAsync.hasError)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'No garage yet',
                            style: theme.textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Create your garage so customers can book services.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => context.go('/owner/setup'),
                            icon: const Icon(Icons.add_business),
                            label: const Text('Create Garage'),
                          ),
                          TextButton(
                            onPressed: () => context.go('/owner/settings'),
                            child: const Text('Or set up in Settings'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              metricsAsync.when(
                loading: () => const SliverFillRemaining(child: LoadingView()),
                error: (e, _) => SliverFillRemaining(
                  child: ErrorView(
                    message: e.toString(),
                    onRetry: () => ref.invalidate(dashboardMetricsProvider),
                  ),
                ),
                data: (metrics) => SliverList(
                  delegate: SliverChildListDelegate([
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.05,
                        children: [
                          MetricCard(
                            icon: Icons.calendar_today,
                            label: 'Today Bookings',
                            value: '${metrics.todayBookings}',
                          ),
                          MetricCard(
                            icon: Icons.pending_actions,
                            label: 'Pending Bookings',
                            value: '${metrics.pendingBookings}',
                            iconColor: theme.colorScheme.tertiary,
                            valueColor: theme.colorScheme.tertiary,
                          ),
                          MetricCard(
                            icon: Icons.event,
                            label: 'Upcoming Bookings',
                            value: '${metrics.upcomingBookings}',
                            iconColor: theme.colorScheme.secondary,
                            valueColor: theme.colorScheme.secondary,
                          ),
                          MetricCard(
                            icon: Icons.payments,
                            label: "Today's Revenue",
                            value: '₹${metrics.todayRevenue}',
                            valueColor: theme.colorScheme.primaryContainer,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('Quick Actions', style: theme.textTheme.headlineMedium),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          QuickActionButton(
                            icon: Icons.add_box,
                            label: 'Add Booking',
                            filled: true,
                            onTap: () => context.push('/owner/bookings/add'),
                          ),
                          const SizedBox(width: 16),
                          QuickActionButton(
                            icon: Icons.list_alt,
                            label: 'View Bookings',
                            onTap: () => context.go('/owner/bookings'),
                          ),
                          const SizedBox(width: 16),
                          QuickActionButton(
                            icon: Icons.groups,
                            label: 'Customers',
                            onTap: () => context.go('/owner/customers'),
                          ),
                          const SizedBox(width: 16),
                          QuickActionButton(
                            icon: Icons.receipt_long,
                            label: 'Billing',
                            onTap: () => context.go('/owner/billing'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: GlassCard(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Weekly Revenue',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.titleLarge,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      '₹${metrics.weeklyRevenue}',
                                      maxLines: 1,
                                      style: theme.textTheme.titleLarge?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 120,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: metrics.weeklyBreakdown.map((day) {
                                  final amount = double.tryParse(day.revenue) ?? 0;
                                  final max = metrics.weeklyBreakdown
                                      .map((d) => double.tryParse(d.revenue) ?? 0)
                                      .fold<double>(0, (a, b) => a > b ? a : b);
                                  final height = max > 0 ? (amount / max) * 80 : 0.0;
                                  return Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: height + 8,
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.primaryContainer,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(day.day, style: theme.textTheme.labelSmall),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Recent Bookings',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.headlineMedium,
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/owner/bookings'),
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                    ),
                    ...metrics.recentBookings.map(
                      (b) => Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: BookingCard(booking: b),
                      ),
                    ),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
