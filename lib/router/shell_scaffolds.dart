import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OwnerShell extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final onHomeTab = _isMainTab && _index == 0;

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
        body: child,
        bottomNavigationBar: _hideNav
            ? null
            : NavigationBar(
                selectedIndex: _index.clamp(0, 4),
                onDestinationSelected: (index) {
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
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.dashboard), label: 'Dashboard'),
                  NavigationDestination(icon: Icon(Icons.list_alt), label: 'Bookings'),
                  NavigationDestination(icon: Icon(Icons.groups), label: 'Customers'),
                  NavigationDestination(icon: Icon(Icons.receipt_long), label: 'Billing'),
                  NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
                ],
              ),
      ),
    );
  }
}

class CustomerShell extends StatelessWidget {
  const CustomerShell({super.key, required this.child, required this.location});

  final Widget child;
  final String location;

  int get _index {
    if (location.startsWith('/customer/bookings')) return 1;
    if (location.startsWith('/customer/notifications')) return 2;
    if (location.startsWith('/customer/profile')) return 3;
    return 0;
  }

  bool get _hideNav =>
      location == '/customer/book' || location.startsWith('/customer/book/');

  bool get _isMainTab {
    return location == '/customer' ||
        location == '/customer/bookings' ||
        location == '/customer/notifications' ||
        location == '/customer/profile';
  }

  @override
  Widget build(BuildContext context) {
    final onHomeTab = _isMainTab && _index == 0;

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
        body: child,
        bottomNavigationBar: _hideNav
            ? null
            : NavigationBar(
                selectedIndex: _index.clamp(0, 3),
                onDestinationSelected: (index) {
                  switch (index) {
                    case 0:
                      context.go('/customer');
                    case 1:
                      context.go('/customer/bookings');
                    case 2:
                      context.go('/customer/notifications');
                    case 3:
                      context.go('/customer/profile');
                  }
                },
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
                  NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Bookings'),
                  NavigationDestination(icon: Icon(Icons.notifications), label: 'Alerts'),
                  NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
                ],
              ),
      ),
    );
  }
}
