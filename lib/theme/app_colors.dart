import 'package:flutter/material.dart';

/// Blinkit-inspired QuikGarage brand tokens.
/// Yellow = brand surfaces / headers. Green = actions / selected states.
abstract final class AppColors {
  // Brand
  static const Color brandYellow = Color(0xFFF8CB46);
  static const Color brandYellowDeep = Color(0xFFE6B422);
  static const Color brandGreen = Color(0xFF318616);
  static const Color brandGreenDark = Color(0xFF1F5C0E);
  static const Color onYellow = Color(0xFF1C1C1C);

  // Light
  static const Color primary = brandGreen;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFDFF5D4);
  static const Color onPrimaryContainer = Color(0xFF16380B);
  static const Color secondary = Color(0xFFB8860B);
  static const Color onSecondary = Color(0xFF1C1C1C);
  static const Color secondaryContainer = Color(0xFFFFF3C4);
  static const Color onSecondaryContainer = Color(0xFF4A3B00);
  static const Color tertiary = brandYellowDeep;
  static const Color tertiaryContainer = Color(0xFFFFE99A);
  static const Color onTertiaryContainer = Color(0xFF3D2E00);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color background = Color(0xFFFFFDF5);
  static const Color onBackground = Color(0xFF1C1C1C);
  static const Color surface = Color(0xFFFFFDF5);
  static const Color onSurface = Color(0xFF1C1C1C);
  static const Color onSurfaceVariant = Color(0xFF4A5346);
  static const Color surfaceContainer = Color(0xFFF7F3E4);
  static const Color surfaceContainerHigh = Color(0xFFF0EBD4);
  static const Color surfaceContainerLow = Color(0xFFFFFBF0);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFF7A8174);
  static const Color outlineVariant = Color(0xFFD8D4C2);
  static const Color inversePrimary = Color(0xFF9FDE86);

  static const Color splashPrimary = brandYellow;

  static const Color statusPending = Color(0xFFB8860B);
  static const Color statusConfirmed = brandGreen;
  static const Color statusInProgress = Color(0xFF2E7D32);
  static const Color statusCompleted = Color(0xFF188038);
  static const Color statusCancelled = Color(0xFFBA1A1A);

  // Dark
  static const Color darkBackground = Color(0xFF10180E);
  static const Color darkSurface = Color(0xFF1A2417);
  static const Color darkSurfaceHigh = Color(0xFF2A3826);
  static const Color darkOnSurface = Color(0xFFF5F5F0);
  static const Color darkOnSurfaceVariant = Color(0xFFB5C0AE);
  static const Color darkPrimary = brandYellow;
  static const Color darkOutlineVariant = Color(0xFF2A3826);
}
