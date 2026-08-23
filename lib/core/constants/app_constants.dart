class AppConstants {
  static const String appName = 'QuikGarage';
  static const String tagline = 'Fast. Reliable. Hassle-Free Vehicle Service';
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_json';
  static const String themeModeKey = 'theme_mode';
  static const String localeKey = 'app_locale';

  /// All service type keys (used for rates / fallbacks).
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

  static const List<String> bikeServiceTypes = [
    'general_service',
    'oil_change',
    'brake_service',
    'wash',
    'repair',
    'inspection',
    'other',
  ];

  static const List<String> carServiceTypes = [
    'general_service',
    'oil_change',
    'ac_service',
    'brake_service',
    'wash',
    'repair',
    'inspection',
    'other',
  ];

  static List<String> serviceTypesForVehicle(String vehicleType) {
    final t = vehicleType.toLowerCase().trim();
    if (t == 'bike') return bikeServiceTypes;
    return carServiceTypes;
  }

  static const Map<String, String> serviceTypeLabels = {
    'general_service': 'General Service',
    'oil_change': 'Oil Change',
    'ac_service': 'AC Service',
    'brake_service': 'Brake Service',
    'wash': 'Wash',
    'repair': 'Repair',
    'inspection': 'Inspection',
    'other': 'Other',
  };

  /// Vehicle-aware label (e.g. Bike Wash vs Car Wash).
  static String serviceTypeLabel(String key, {String? vehicleType}) {
    if (key == 'wash') {
      final t = (vehicleType ?? '').toLowerCase().trim();
      if (t == 'bike') return 'Bike Wash';
      if (t == 'car') return 'Car Wash';
      return 'Wash';
    }
    return serviceTypeLabels[key] ?? key;
  }

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
