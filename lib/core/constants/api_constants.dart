class ApiConstants {
  /// Default points at Render production API.
  /// Override anytime with:
  ///   flutter run --dart-define=API_BASE_URL=http://192.168.x.x:8000/api/v1
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://quikgarage-api.onrender.com/api/v1',
  );

  static const String authFirebase = '/auth/firebase/';
  static const String authDev = '/auth/dev/';
  static const String authLogin = '/auth/login/';
  static const String authRegister = '/auth/register/';
  static const String authRefresh = '/auth/token/refresh/';
  static const String usersMe = '/users/me/';
  static const String usersRole = '/users/me/role/';
  static const String usersCustomers = '/users/customers/';
  static const String garages = '/garages/';
  static const String garagesMine = '/garages/mine/';
  static const String vehicles = '/vehicles/';
  static const String bookings = '/bookings/';
  static const String bookingsToday = '/bookings/today/';
  static const String ownerBookings = '/bookings/owner/';
  static const String ownerBookingCreate = '/bookings/owner/create/';
  static const String invoices = '/invoices/';
  static const String notifications = '/notifications/';
  static const String notificationsReadAll = '/notifications/read-all/';
  static const String dashboardMetrics = '/dashboard/owner/metrics/';

  static String bookingStatus(int id) => '/bookings/owner/$id/status/';
  static String bookingServiceItems(int id) => '/bookings/owner/$id/service-items/';
  static String availableSlots(int garageId) => '/bookings/slots/$garageId/';
  static String notificationRead(int id) => '/notifications/$id/read/';
}
