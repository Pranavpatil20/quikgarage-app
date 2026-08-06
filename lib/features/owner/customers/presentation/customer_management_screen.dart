import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/customer_provider.dart';
import '../../../../core/utils/status_utils.dart';
import '../../../../core/widgets/booking_card.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../models/booking_model.dart';
import '../../../../models/user_model.dart';
import '../../../../repositories/booking_repository.dart';

final customerHistoryProvider =
    FutureProvider.autoDispose.family<List<BookingModel>, int>((ref, customerId) async {
  return ref.watch(bookingRepositoryProvider).getOwnerBookings(customerId: customerId);
});

class CustomerManagementScreen extends ConsumerWidget {
  const CustomerManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(customersProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Management'),
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
            return const Center(child: Text('No customers yet'));
          }
          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(customersProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GlassCard(
                    onTap: () => context.push('/owner/customers/${customer.id}', extra: customer),
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
                                customer.name.isNotEmpty ? customer.name : 'Customer',
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
                                'Tap to view service history',
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
    final titleName = customer?.name.isNotEmpty == true
        ? customer!.name
        : (customer?.phone ?? 'Customer');

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
            return const Center(child: Text('No service history yet'));
          }
          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(customerHistoryProvider(customerId)),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (customer != null) ...[
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Customer', style: theme.textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        Text(customer!.name.isNotEmpty ? customer!.name : '—'),
                        Text(
                          customer!.phone,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${bookings.length} service${bookings.length == 1 ? '' : 's'}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Text('Service History', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 12),
                ...bookings.map((booking) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BookingCard(booking: booking),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, top: 4),
                          child: Text(
                            'Service: ${StatusUtils.serviceLabel(booking.serviceType)}'
                            '${booking.notes.isNotEmpty ? ' · Notes: ${booking.notes}' : ''}',
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
