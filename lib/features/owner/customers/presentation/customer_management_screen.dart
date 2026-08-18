import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/customer_provider.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/booking_card.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../models/booking_model.dart';
import '../../../../models/user_model.dart';
import '../../../../repositories/booking_repository.dart';

final customerHistoryProvider =
    FutureProvider.autoDispose.family<List<BookingModel>, int>((ref, customerId) async {
  // Prefer server filter; fall back to client filter if pagination/filter is incomplete.
  final filtered = await ref.watch(bookingRepositoryProvider).getOwnerBookings(
        customerId: customerId,
      );
  if (filtered.isNotEmpty) return filtered;

  final all = await ref.watch(bookingRepositoryProvider).getOwnerBookings();
  return all.where((b) => b.customer == customerId).toList();
});

class CustomerManagementScreen extends ConsumerWidget {
  const CustomerManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersProvider);
    final theme = Theme.of(context);
    final s = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(s.customerManagement),
        automaticallyImplyLeading: false,
      ),
      body: customersAsync.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(customersProvider),
        ),
        data: (customers) {
          if (customers.isEmpty) {
            return Center(child: Text(s.noCustomersYet));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(customersProvider),
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                AppBottomNavBar.contentBottomPadding(context),
              ),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    onTap: () => context.push(
                      '/owner/customers/${customer.id}',
                      extra: customer,
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: theme.colorScheme.primaryContainer,
                          child: Text(
                            (customer.name.isNotEmpty ? customer.name : customer.phone)[0]
                                .toUpperCase(),
                            style: TextStyle(color: theme.colorScheme.primary),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.name.isNotEmpty ? customer.name : s.customerLabel,
                                style: theme.textTheme.titleLarge,
                              ),
                              Text(
                                customer.phone,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                s.tapToViewHistory,
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class CustomerHistoryScreen extends ConsumerWidget {
  const CustomerHistoryScreen({
    super.key,
    required this.customerId,
    this.customer,
  });

  final int customerId;
  final UserModel? customer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(customerHistoryProvider(customerId));
    final theme = Theme.of(context);
    final s = AppStrings.of(context);
    final locale = Localizations.localeOf(context).toString();
    final titleName = customer?.name.isNotEmpty == true
        ? customer!.name
        : (customer?.phone ?? s.customerLabel);

    return Scaffold(
      appBar: AppBar(
        title: Text(titleName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: historyAsync.when(
        loading: () => const LoadingView(),
        error: (e, _) => ErrorView(
          message: e.toString(),
          onRetry: () => ref.invalidate(customerHistoryProvider(customerId)),
        ),
        data: (bookings) {
          if (bookings.isEmpty) {
            return Center(child: Text(s.noServiceHistoryYet));
          }
          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(customerHistoryProvider(customerId)),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.customerLabel, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(
                        customer?.name.isNotEmpty == true
                            ? customer!.name
                            : titleName,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (customer?.phone != null)
                        Text(
                          customer!.phone,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      const SizedBox(height: 8),
                      Text(
                        '${bookings.length} ${s.bookings.toLowerCase()}',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(s.serviceHistory, style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                ...bookings.map((booking) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BookingCard(booking: booking),
                        const SizedBox(height: 6),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            [
                              AppDateUtils.formatBookingDateTime(
                                booking.bookingDate,
                                booking.timeSlot,
                                locale: locale,
                              ),
                              s.serviceType(booking.serviceType),
                              if (booking.notes.isNotEmpty) booking.notes,
                            ].join(' · '),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
