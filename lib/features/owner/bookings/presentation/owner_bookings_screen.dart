import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/providers/booking_provider.dart';
import '../../../../core/providers/dashboard_provider.dart';
import '../../../../core/providers/invoice_provider.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/whatsapp_share.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_overlays.dart';
import '../../../../core/widgets/booking_card.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/segmented_tabs.dart';
import '../../../../l10n/app_strings.dart';
import '../../../../models/booking_model.dart';
import '../../../../repositories/booking_repository.dart';
import '../../../../theme/app_colors.dart';

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
                onRetry: () => refreshBookings(ref),
              ),
              data: (bookings) {
                var filtered = bookings;
                if (_tabIndex == 0) {
                  filtered = bookings
                      .where((b) => b.bookingDate == today && b.status != 'cancelled')
                      .toList();
                } else if (_tabIndex == 1) {
                  // Keep In Progress visible so owners can mark Completed.
                  filtered = bookings
                      .where(
                        (b) =>
                            b.status == 'pending' ||
                            b.status == 'confirmed' ||
                            b.status == 'in_progress',
                      )
                      .toList();
                }
                if (filtered.isEmpty) {
                  return Center(child: Text(s.noBookingsFound));
                }
                return RefreshIndicator(
                  onRefresh: () async => refreshBookings(ref),
                  child: ListView.separated(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      16,
                      16,
                      AppBottomNavBar.contentBottomPadding(context),
                    ),
                    itemCount: filtered.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final booking = filtered[index];
                      return BookingCard(
                        booking: booking,
                        onTap: () => _showStatusSheet(context, booking),
                        onWhatsApp: () => WhatsAppShare.send(
                          context: context,
                          phone: booking.customerDetail?.phone,
                          message: WhatsAppShare.bookingMessage(
                            booking,
                            s,
                            locale: Localizations.localeOf(context).toString(),
                          ),
                        ),
                        trailing: booking.status == 'completed' ||
                                booking.status == 'cancelled'
                            ? null
                            : PopupMenuButton<String>(
                                onSelected: (value) => _updateStatus(booking, value),
                                itemBuilder: (_) => _menuItems(s, booking.status),
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

  List<PopupMenuItem<String>> _menuItems(AppStrings s, String status) {
    switch (status) {
      case 'pending':
        return [
          PopupMenuItem(value: 'confirmed', child: Text(s.confirm)),
          PopupMenuItem(value: 'in_progress', child: Text(s.bookingStatus('in_progress'))),
          PopupMenuItem(value: 'completed', child: Text(s.complete)),
          PopupMenuItem(value: 'cancelled', child: Text(s.cancel)),
        ];
      case 'confirmed':
        return [
          PopupMenuItem(value: 'in_progress', child: Text(s.bookingStatus('in_progress'))),
          PopupMenuItem(value: 'completed', child: Text(s.complete)),
          PopupMenuItem(value: 'cancelled', child: Text(s.cancel)),
        ];
      case 'in_progress':
        return [
          PopupMenuItem(value: 'completed', child: Text(s.complete)),
          PopupMenuItem(value: 'cancelled', child: Text(s.cancel)),
        ];
      default:
        return [];
    }
  }

  void _showStatusSheet(BuildContext context, BookingModel booking) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    final actions = <({String value, String label, IconData icon, Color? color})>[];

    switch (booking.status) {
      case 'pending':
        actions.addAll([
          (value: 'confirmed', label: s.markConfirmed, icon: Icons.check_circle_outline, color: null),
          (value: 'in_progress', label: s.markInProgress, icon: Icons.play_circle_outline, color: null),
          (value: 'completed', label: s.markCompleted, icon: Icons.task_alt, color: AppColors.brandGreen),
          (value: 'cancelled', label: s.cancel, icon: Icons.cancel_outlined, color: theme.colorScheme.error),
        ]);
      case 'confirmed':
        actions.addAll([
          (value: 'in_progress', label: s.markInProgress, icon: Icons.play_circle_outline, color: null),
          (value: 'completed', label: s.markCompleted, icon: Icons.task_alt, color: AppColors.brandGreen),
          (value: 'cancelled', label: s.cancel, icon: Icons.cancel_outlined, color: theme.colorScheme.error),
        ]);
      case 'in_progress':
        actions.addAll([
          (value: 'completed', label: s.markCompleted, icon: Icons.task_alt, color: AppColors.brandGreen),
          (value: 'cancelled', label: s.cancel, icon: Icons.cancel_outlined, color: theme.colorScheme.error),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                child: Text(
                  '${s.bookingStatus(booking.status)} · Update status',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              ListTile(
                leading: Icon(Icons.chat, color: theme.colorScheme.primary),
                title: Text(s.sendWhatsAppDetails),
                subtitle: Text(booking.customerDetail?.phone ?? ''),
                onTap: () {
                  Navigator.pop(ctx);
                  WhatsAppShare.send(
                    context: context,
                    phone: booking.customerDetail?.phone,
                    message: WhatsAppShare.bookingMessage(
                      booking,
                      s,
                      locale: Localizations.localeOf(context).toString(),
                    ),
                  );
                },
              ),
              for (final action in actions)
                ListTile(
                  leading: Icon(action.icon, color: action.color ?? theme.colorScheme.primary),
                  title: Text(
                    action.label,
                    style: TextStyle(
                      color: action.color,
                      fontWeight: action.value == 'completed' ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(ctx);
                    _updateStatus(booking, action.value);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateStatus(BookingModel booking, String status) async {
    final s = AppStrings.of(context);
    try {
      await ref.read(bookingRepositoryProvider).updateStatus(booking.id, status);
      refreshBookings(ref);
      ref.invalidate(dashboardMetricsProvider);
      ref.invalidate(invoicesProvider);

      // If Completed/Cancelled, jump to that tab so the change is obvious.
      if (status == 'completed' && mounted) {
        setState(() => _tabIndex = 2);
      } else if (status == 'cancelled' && mounted) {
        setState(() => _tabIndex = 3);
      } else if (status == 'in_progress' && mounted && _tabIndex == 1) {
        // Stay on Upcoming — in_progress remains visible there.
        setState(() {});
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${s.statusUpdated}: ${s.bookingStatus(status)}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}
