class AppConstants {
  static const String appName = 'quikgarage';
  static const String tagline = 'Fast. Reliable. Hassle-Free Vehicle Service';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_json';
  static const String themeModeKey = 'theme_mode';

  static const List<String> serviceTypes = [
    'general_service',
    'oil_change',
    'ac_service',
    'brake_service',
    'wash',
    'repair',
    'inspection',
    'other',
  ];

  static const Map<String, String> serviceTypeLabels = {
    'general_service': 'General Service',
    'oil_change': 'Oil Change',
    'ac_service': 'AC Service',
    'brake_service': 'Brake Service',
    'wash': 'Car Wash',
    'repair': 'Repair',
    'inspection': 'Inspection',
    'other': 'Other',
  };

  static const Map<String, String> bookingStatusLabels = {
    'pending': 'Pending',
    'confirmed': 'Confirmed',
    'in_progress': 'In Progress',
    'completed': 'Completed',
    'cancelled': 'Cancelled',
  };

  static const Map<String, String> paymentStatusLabels = {
    'pending': 'Pending',
    'paid': 'Paid',
    'partial': 'Partial',
    'refunded': 'Refunded',
  };
}
