import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/auth_provider.dart';
import '../features/auth/presentation/login_screen.dart';
import '../features/auth/presentation/signup_screen.dart';
import '../features/auth/presentation/splash_screen.dart';
import '../features/customer/bookings/presentation/book_service_screen.dart';
import '../features/customer/bookings/presentation/my_bookings_screen.dart';
import '../features/customer/home/presentation/customer_home_screen.dart';
import '../features/customer/notifications/presentation/notifications_screen.dart';
import '../features/customer/profile/presentation/profile_screen.dart';
import '../features/customer/support/presentation/support_feedback_screen.dart';
import '../features/owner/billing/presentation/billing_screen.dart';
import '../features/owner/bookings/presentation/add_booking_screen.dart';
import '../features/owner/bookings/presentation/owner_bookings_screen.dart';
import '../features/owner/customers/presentation/customer_management_screen.dart';
import '../features/owner/dashboard/presentation/owner_dashboard_screen.dart';
import '../features/owner/settings/presentation/owner_settings_screen.dart';
import '../features/owner/subscription/presentation/owner_payment_lock_screen.dart';
import '../models/user_model.dart';
import 'shell_scaffolds.dart';

final routerProvider = Provider<GoRouter>((ref) {
  // Do NOT watch authState here — that recreates GoRouter and resets to '/'.
  final refresh = _RouterRefresh(ref);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refresh,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final path = state.matchedLocation;
      final isAuthRoute =
          path == '/' || path == '/login' || path == '/signup' || path == '/role-select';

      // Never bounce away from in-app screens while auth is reloading.
      if (authState.isLoading) {
        if (path == '/') return null;
        if (!isAuthRoute) return null;
        return null;
      }

      final user = authState.asData?.value;

      if (user == null && !isAuthRoute) return '/login';
      if (user != null && user.isOwnerLocked && path != '/owner/payment-lock') {
        return '/owner/payment-lock';
      }
      if (user != null &&
          user.isOwner &&
          !user.isPaymentLocked &&
          path == '/owner/payment-lock') {
        return '/owner';
      }
      if (user != null && (path == '/login' || path == '/signup' || path == '/')) {
        if (user.isOwner) return ownerHomeRoute(user);
        return '/customer';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
      GoRoute(
        path: '/role-select',
        redirect: (_, __) => '/login',
      ),
      // Owner tabs are siblings (not nested under /owner) so AppBar has no back stack.
      ShellRoute(
        builder: (_, state, child) => OwnerShell(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/owner',
            builder: (_, __) => const OwnerDashboardScreen(),
          ),
          GoRoute(
            path: '/owner/setup',
            builder: (_, __) => const OwnerGarageSetupScreen(),
          ),
          GoRoute(
            path: '/owner/bookings',
            builder: (_, __) => const OwnerBookingsScreen(),
            routes: [
              GoRoute(
                path: 'add',
                builder: (_, __) => const AddBookingScreen(),
              ),
            ],
          ),
          GoRoute(
            path: '/owner/customers',
            builder: (_, __) => const CustomerManagementScreen(),
            routes: [
              GoRoute(
                path: ':customerId',
                builder: (context, state) {
                  final id = int.tryParse(state.pathParameters['customerId'] ?? '') ?? 0;
                  final extra = state.extra;
                  return CustomerHistoryScreen(
                    customerId: id,
                    customer: extra is UserModel ? extra : null,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/owner/billing',
            builder: (_, __) => const BillingScreen(),
          ),
          GoRoute(
            path: '/owner/payment-lock',
            builder: (_, __) => const OwnerPaymentLockScreen(),
          ),
          GoRoute(
            path: '/owner/settings',
            builder: (_, __) => const OwnerSettingsScreen(),
          ),
          GoRoute(
            path: '/owner/notifications',
            builder: (_, __) => const NotificationsScreen(isOwner: true),
          ),
        ],
      ),
      // Customer tabs are siblings for the same reason.
      ShellRoute(
        builder: (_, state, child) => CustomerShell(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/customer',
            builder: (_, __) => const CustomerHomeScreen(),
          ),
          GoRoute(
            path: '/customer/book',
            builder: (_, __) => const BookServiceScreen(),
          ),
          GoRoute(
            path: '/customer/bookings',
            builder: (_, __) => const MyBookingsScreen(),
          ),
          GoRoute(
            path: '/customer/notifications',
            builder: (_, __) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/customer/support',
            builder: (_, __) => const SupportFeedbackScreen(),
          ),
          GoRoute(
            path: '/customer/profile',
            builder: (_, __) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
});

class _RouterRefresh extends ChangeNotifier {
  _RouterRefresh(this._ref) {
    _subscription = _ref.listen(authStateProvider, (_, __) => notifyListeners());
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<UserModel?>> _subscription;

  @override
  void dispose() {
    _subscription.close();
    super.dispose();
  }
}
