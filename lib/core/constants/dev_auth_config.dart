import '../../firebase_options.dart';

/// Development login bypasses Firebase OTP and talks to the Django dev endpoint.
abstract final class DevAuthConfig {
  static const bool forceDev = bool.fromEnvironment('DEV_AUTH', defaultValue: false);

  static bool get useDevAuth => forceDev || !DefaultFirebaseOptions.isConfigured;
}
