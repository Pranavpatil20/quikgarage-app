import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/booking_provider.dart';
import '../../../../core/providers/dashboard_provider.dart';
import '../../../../core/providers/invoice_provider.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/booking_card.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/segmented_tabs.dart';
import '../../../../models/booking_model.dart';
import '../../../../repositories/booking_repository.dart';

class OwnerBookingsScreen extends ConsumerStatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  ConsumerState<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends ConsumerState<OwnerBookingsScreen> {
  int _tabIndex = 0;
  static const _tabs = ['Today', 'Upcoming', 'Completed', 'Cancelled'];
  static const _statusMap = [null, null, 'completed', 'cancelled'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = AppDateUtils.toApiDate(DateTime.now());
    final status = _statusMap[_tabIndex];

    final bookingsAsync = ref.watch(
      ownerBookingsProvider((
        status: _tabIndex == 2
            ? 'completed'
            : _tabIndex == 3
                ? 'cancelled'
                : _tabIndex == 1
                    ? null
                    : null,
        date: _tabIndex == 0 ? today : null,
      )),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Management'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/owner/bookings/add'),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedTabs(
              tabs: _tabs,
              selectedIndex: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
          Expanded(
            child: bookingsAsync.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(
                message: e.toString(),
                onRetry: () => ref.invalidate(ownerBookingsProvider),
              ),
              data: (bookings) {
                var filtered = bookings;
                if (_tabIndex == 0) {
                  filtered = bookings
                      .where((b) => b.bookingDate == today && b.status != 'cancelled')
                      .toList();
                } else if (_tabIndex == 1) {
                  filtered = bookings
                      .where((b) =>
                          b.status == 'pending' || b.status == 'confirmed')
                      .toList();
                }
                if (filtered.isEmpty) {
                  return const Center(child: Text('No bookings found'));
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(ownerBookingsProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final booking = filtered[index];
                      return BookingCard(
                        booking: booking,
                        onTap: () => _showStatusSheet(context, booking),
                        trailing: booking.status == 'completed' ||
                                booking.status == 'cancelled'
                            ? null
                            : PopupMenuButton<String>(
                                onSelected: (s) => _updateStatus(booking.id, s),
                                itemBuilder: (_) {
                                  final items = <PopupMenuItem<String>>[];
                                  switch (booking.status) {
                                    case 'pending':
                                      items.addAll(const [
                                        PopupMenuItem(value: 'confirmed', child: Text('Confirm')),
                                        PopupMenuItem(value: 'in_progress', child: Text('In Progress')),
                                        PopupMenuItem(value: 'completed', child: Text('Complete')),
                                        PopupMenuItem(value: 'cancelled', child: Text('Cancel')),
                                      ]);
                                    case 'confirmed':
                                      items.addAll(const [
                                        PopupMenuItem(value: 'in_progress', child: Text('In Progress')),
                                        PopupMenuItem(value: 'completed', child: Text('Complete')),
                                        PopupMenuItem(value: 'cancelled', child: Text('Cancel')),
                                      ]);
                                    case 'in_progress':
                                      items.addAll(const [
                                        PopupMenuItem(value: 'completed', child: Text('Complete')),
                                        PopupMenuItem(value: 'cancelled', child: Text('Cancel')),
                                      ]);
                                  }
                                  return items;
                                },
                              ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showStatusSheet(BuildContext context, BookingModel booking) {
    final actions = <({String value, String label})>[];
    switch (booking.status) {
      case 'pending':
        actions.addAll(const [
          (value: 'confirmed', label: 'Mark Confirmed'),
          (value: 'in_progress', label: 'Mark In Progress'),
          (value: 'completed', label: 'Mark Completed'),
          (value: 'cancelled', label: 'Cancel'),
        ]);
      case 'confirmed':
        actions.addAll(const [
          (value: 'in_progress', label: 'Mark In Progress'),
          (value: 'completed', label: 'Mark Completed'),
          (value: 'cancelled', label: 'Cancel'),
        ]);
      case 'in_progress':
        actions.addAll(const [
          (value: 'completed', label: 'Mark Completed'),
          (value: 'cancelled', label: 'Cancel'),
        ]);
      default:
        break;
    }

    if (actions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No further status changes for ${booking.status}')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final action in actions)
              ListTile(
                title: Text(action.label),
                onTap: () {
                  Navigator.pop(ctx);
                  _updateStatus(booking.id, action.value);
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus(int id, String status) async {
    try {
      await ref.read(bookingRepositoryProvider).updateStatus(id, status);
      ref.invalidate(ownerBookingsProvider);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidate(invoicesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to $status')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
