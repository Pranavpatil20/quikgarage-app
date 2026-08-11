import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/booking_provider.dart';
import '../../../../core/widgets/app_overlays.dart';
import '../../../../core/widgets/booking_card.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/segmented_tabs.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../repositories/booking_repository.dart';

class MyBookingsScreen extends ConsumerStatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  ConsumerState<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends ConsumerState<MyBookingsScreen> {
  int _tabIndex = 0;
  static const _statusFilters = [null, 'completed', 'cancelled'];

  @override
  Widget build(BuildContext context) {
    final status = _statusFilters[_tabIndex];
    final bookingsAsync = ref.watch(customerBookingsProvider(status));
    final s = AppStrings.of(context);
    final tabs = [s.tabActive, s.tabCompleted, s.tabCancelled];

    return Scaffold(
      appBar: AppBar(
        title: Text(s.myBookings),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: SegmentedTabs(
              tabs: tabs,
              selectedIndex: _tabIndex,
              onChanged: (i) => setState(() => _tabIndex = i),
            ),
          ),
          Expanded(
            child: bookingsAsync.when(
              loading: () => const LoadingView(),
              error: (e, _) => ErrorView(
                message: e.toString(),
                onRetry: () => ref.invalidate(customerBookingsProvider),
              ),
              data: (bookings) {
                var filtered = bookings;
                if (_tabIndex == 0) {
                  filtered = bookings
                      .where((b) => b.status != 'completed' && b.status != 'cancelled')
                      .toList();
                }
                if (filtered.isEmpty) {
                  return Center(child: Text(s.noBookingsFound));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final booking = filtered[index];
                    return BookingCard(
                      booking: booking,
                      trailing: booking.canCancel
                          ? TextButton(
                              onPressed: () => _cancel(booking.id),
                              child: Text(s.cancel),
                            )
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancel(int id) async {
    final s = AppStrings.of(context);
    final confirmed = await showAppDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(s.cancel),
        content: Text(s.cancelBookingConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(s.no)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(s.yes)),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(bookingRepositoryProvider).cancelBooking(id);
      ref.invalidate(customerBookingsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
