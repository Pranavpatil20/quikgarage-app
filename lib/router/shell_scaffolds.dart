import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/notification_provider.dart';
import '../core/widgets/app_bottom_nav_bar.dart';
import '../l10n/app_strings.dart';

class OwnerShell extends ConsumerWidget {
  const OwnerShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  int get _index {
    if (location.startsWith('/owner/bookings')) return 1;
    if (location.startsWith('/owner/customers')) return 2;
    if (location.startsWith('/owner/billing')) return 3;
    if (location.startsWith('/owner/settings')) return 4;
    return 0;
  }

  bool get _hideNav {
    if (location.startsWith('/owner/bookings/add')) return true;
    if (location.startsWith('/owner/notifications')) return true;
    if (location.startsWith('/owner/setup')) return true;
    if (location.startsWith('/owner/payment-lock')) return true;
    if (RegExp(r'^/owner/customers/\d+').hasMatch(location)) return true;
    return false;
  }

  bool get _isMainTab {
    return location == '/owner' ||
        location == '/owner/bookings' ||
        location == '/owner/customers' ||
        location == '/owner/billing' ||
        location == '/owner/settings';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final onHomeTab = _isMainTab && _index == 0;
    final media = MediaQuery.of(context);
    final keyboardOpen = media.viewInsets.bottom > 80;

    return PopScope(
      canPop: onHomeTab,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_hideNav) {
          if (location.startsWith('/owner/bookings/add')) {
            context.go('/owner/bookings');
          } else if (RegExp(r'^/owner/customers/\d+').hasMatch(location)) {
            context.go('/owner/customers');
          } else {
            context.go('/owner');
          }
          return;
        }
        if (_index != 0) {
          context.go('/owner');
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Zero bottom padding so SafeArea does NOT paint a full-width color band.
            MediaQuery(
              data: media.copyWith(
                padding: media.padding.copyWith(bottom: 0),
              ),
              child: child,
            ),
            if (!_hideNav && !keyboardOpen)
              Align(
                alignment: Alignment.bottomCenter,
                child: AppBottomNavBar(
                  selectedIndex: _index.clamp(0, 4),
                  onSelected: (index) {
                    switch (index) {
                      case 0:
                        context.go('/owner');
                      case 1:
                        context.go('/owner/bookings');
                      case 2:
                        context.go('/owner/customers');
                      case 3:
                        context.go('/owner/billing');
                      case 4:
                        context.go('/owner/settings');
                    }
                  },
                  items: [
                    AppBottomNavItem(
                      icon: Icons.dashboard_outlined,
                      selectedIcon: Icons.dashboard_rounded,
                      label: s.dashboard,
                    ),
                    AppBottomNavItem(
                      icon: Icons.list_alt_outlined,
                      selectedIcon: Icons.list_alt_rounded,
                      label: s.bookings,
                    ),
                    AppBottomNavItem(
                      icon: Icons.groups_outlined,
                      selectedIcon: Icons.groups_rounded,
                      label: s.customers,
                    ),
                    AppBottomNavItem(
                      icon: Icons.receipt_long_outlined,
                      selectedIcon: Icons.receipt_long_rounded,
                      label: s.billing,
                    ),
                    AppBottomNavItem(
                      icon: Icons.settings_outlined,
                      selectedIcon: Icons.settings_rounded,
                      label: s.settings,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomerShell extends ConsumerWidget {
  const CustomerShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  int get _index {
    if (location.startsWith('/customer/bookings')) return 1;
    if (location.startsWith('/customer/notifications')) return 2;
    if (location.startsWith('/customer/support')) return 3;
    if (location.startsWith('/customer/profile')) return 4;
    return 0;
  }

  bool get _hideNav =>
      location == '/customer/book' || location.startsWith('/customer/book/');

  bool get _isMainTab {
    return location == '/customer' ||
        location == '/customer/bookings' ||
        location == '/customer/notifications' ||
        location == '/customer/support' ||
        location == '/customer/profile';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = AppStrings.of(context);
    final onHomeTab = _isMainTab && _index == 0;
    final media = MediaQuery.of(context);
    final keyboardOpen = media.viewInsets.bottom > 80;

    return PopScope(
      canPop: onHomeTab,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_hideNav) {
          context.go('/customer');
          return;
        }
        if (_index != 0) {
          context.go('/customer');
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        resizeToAvoidBottomInset: false,
        body: Stack(
          fit: StackFit.expand,
          children: [
            MediaQuery(
              data: media.copyWith(
                padding: media.padding.copyWith(bottom: 0),
              ),
              child: child,
            ),
            if (!_hideNav && !keyboardOpen)
              Align(
                alignment: Alignment.bottomCenter,
                child: AppBottomNavBar(
                  selectedIndex: _index.clamp(0, 4),
                  onSelected: (index) {
                    switch (index) {
                      case 0:
                        context.go('/customer');
                      case 1:
                        context.go('/customer/bookings');
                      case 2:
                        context.go('/customer/notifications');
                      case 3:
                        context.go('/customer/support');
                      case 4:
                        context.go('/customer/profile');
                    }
                  },
                  items: [
                    AppBottomNavItem(
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                      label: s.home,
                    ),
                    AppBottomNavItem(
                      icon: Icons.calendar_month_outlined,
                      selectedIcon: Icons.calendar_month_rounded,
                      label: s.bookings,
                    ),
                    AppBottomNavItem(
                      icon: Icons.notifications_outlined,
                      selectedIcon: Icons.notifications_rounded,
                      label: s.alerts,
                      badgeCount: ref.watch(unreadCountProvider),
                    ),
                    AppBottomNavItem(
                      icon: Icons.support_agent_outlined,
                      selectedIcon: Icons.support_agent,
                      label: s.support,
                    ),
                    AppBottomNavItem(
                      icon: Icons.person_outline_rounded,
                      selectedIcon: Icons.person_rounded,
                      label: s.profile,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
