import 'package:flutter/material.dart';

/// Material 3 color tokens from Stitch design system.
abstract final class AppColors {
  // Light
  static const Color primary = Color(0xFF4F378A);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF6750A4);
  static const Color onPrimaryContainer = Color(0xFFE0D2FF);
  static const Color secondary = Color(0xFF63597C);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFE1D4FD);
  static const Color onSecondaryContainer = Color(0xFF645A7D);
  static const Color tertiary = Color(0xFF765B00);
  static const Color tertiaryContainer = Color(0xFFC9A74D);
  static const Color onTertiaryContainer = Color(0xFF503D00);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);
  static const Color background = Color(0xFFFDF7FF);
  static const Color onBackground = Color(0xFF1D1B20);
  static const Color surface = Color(0xFFFDF7FF);
  static const Color onSurface = Color(0xFF1D1B20);
  static const Color onSurfaceVariant = Color(0xFF494551);
  static const Color surfaceContainer = Color(0xFFF2ECF4);
  static const Color surfaceContainerHigh = Color(0xFFECE6EE);
  static const Color surfaceContainerLow = Color(0xFFF8F2FA);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFF7A7582);
  static const Color outlineVariant = Color(0xFFCBC4D2);
  static const Color inversePrimary = Color(0xFFCFBCFF);

  // Splash brand blue
  static const Color splashPrimary = Color(0xFF2563EB);

  // Status colors (design system)
  static const Color statusPending = Color(0xFF765B00);
  static const Color statusConfirmed = Color(0xFF2563EB);
  static const Color statusInProgress = Color(0xFF7C3AED);
  static const Color statusCompleted = Color(0xFF16A34A);
  static const Color statusCancelled = Color(0xFFBA1A1A);

  // Dark mode (owner_dashboard_dark_mode)
  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceHigh = Color(0xFF334155);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkOnSurfaceVariant = Color(0xFF94A3B8);
  static const Color darkPrimary = Color(0xFFCFBCFF);
  static const Color darkOutlineVariant = Color(0xFF334155);
}
