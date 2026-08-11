import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/booking_provider.dart';
import '../../../../core/providers/dashboard_provider.dart';
import '../../../../core/providers/invoice_provider.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/app_overlays.dart';
import '../../../../core/widgets/booking_card.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/segmented_tabs.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../models/booking_model.dart';
import '../../../../repositories/booking_repository.dart';

class OwnerBookingsScreen extends ConsumerStatefulWidget {
  const OwnerBookingsScreen({super.key});

  @override
  ConsumerState<OwnerBookingsScreen> createState() => _OwnerBookingsScreenState();
}

class _OwnerBookingsScreenState extends ConsumerState<OwnerBookingsScreen> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final today = AppDateUtils.toApiDate(DateTime.now());
    final s = AppStrings.of(context);
    final tabs = [s.tabToday, s.tabUpcoming, s.tabCompleted, s.tabCancelled];

    final bookingsAsync = ref.watch(
      ownerBookingsProvider((
        status: _tabIndex == 2
            ? 'completed'
            : _tabIndex == 3
                ? 'cancelled'
                : null,
        date: _tabIndex == 0 ? today : null,
      )),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(s.bookingManagement),
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
                  return Center(child: Text(s.noBookingsFound));
                }
                return RefreshIndicator(
                  onRefresh: () async => ref.invalidate(ownerBookingsProvider),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final booking = filtered[index];
                      return BookingCard(
                        booking: booking,
                        onTap: () => _showStatusSheet(context, booking),
                        trailing: booking.status == 'completed' ||
                                booking.status == 'cancelled'
                            ? null
                            : PopupMenuButton<String>(
                                onSelected: (value) => _updateStatus(booking.id, value),
                                itemBuilder: (_) {
                                  final items = <PopupMenuItem<String>>[];
                                  switch (booking.status) {
                                    case 'pending':
                                      items.addAll([
                                        PopupMenuItem(value: 'confirmed', child: Text(s.confirm)),
                                        PopupMenuItem(value: 'in_progress', child: Text(s.bookingStatus('in_progress'))),
                                        PopupMenuItem(value: 'completed', child: Text(s.complete)),
                                        PopupMenuItem(value: 'cancelled', child: Text(s.cancel)),
                                      ]);
                                    case 'confirmed':
                                      items.addAll([
                                        PopupMenuItem(value: 'in_progress', child: Text(s.bookingStatus('in_progress'))),
                                        PopupMenuItem(value: 'completed', child: Text(s.complete)),
                                        PopupMenuItem(value: 'cancelled', child: Text(s.cancel)),
                                      ]);
                                    case 'in_progress':
                                      items.addAll([
                                        PopupMenuItem(value: 'completed', child: Text(s.complete)),
                                        PopupMenuItem(value: 'cancelled', child: Text(s.cancel)),
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
    final s = AppStrings.of(context);
    final actions = <({String value, String label})>[];
    switch (booking.status) {
      case 'pending':
        actions.addAll([
          (value: 'confirmed', label: s.markConfirmed),
          (value: 'in_progress', label: s.markInProgress),
          (value: 'completed', label: s.markCompleted),
          (value: 'cancelled', label: s.cancel),
        ]);
      case 'confirmed':
        actions.addAll([
          (value: 'in_progress', label: s.markInProgress),
          (value: 'completed', label: s.markCompleted),
          (value: 'cancelled', label: s.cancel),
        ]);
      case 'in_progress':
        actions.addAll([
          (value: 'completed', label: s.markCompleted),
          (value: 'cancelled', label: s.cancel),
        ]);
      default:
        break;
    }

    if (actions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(s.noFurtherStatusChanges)),
      );
      return;
    }

    showAppModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
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
      ),
    );
  }

  Future<void> _updateStatus(int id, String status) async {
    final s = AppStrings.of(context);
    try {
      await ref.read(bookingRepositoryProvider).updateStatus(id, status);
      ref.invalidate(ownerBookingsProvider);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidate(invoicesProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${s.statusUpdated}: ${s.bookingStatus(status)}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }
}
