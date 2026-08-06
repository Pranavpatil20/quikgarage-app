import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData light() {
    final scheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: Colors.white,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      surfaceContainerHighest: AppColors.surfaceContainerHigh,
      surfaceContainerHigh: AppColors.surfaceContainerHigh,
      surfaceContainer: AppColors.surfaceContainer,
      surfaceContainerLow: AppColors.surfaceContainerLow,
      surfaceContainerLowest: AppColors.surfaceContainerLowest,
    );

    return _build(
      brightness: Brightness.light,
      scheme: scheme,
      scaffoldBackground: AppColors.background,
      onSurface: AppColors.onBackground,
      cardColor: AppColors.surfaceContainerLowest,
      cardBorder: AppColors.outlineVariant,
      inputFill: AppColors.surfaceContainerLowest,
      buttonBg: AppColors.primary,
      buttonFg: AppColors.onPrimary,
      navBg: AppColors.surfaceContainerLowest,
      navIndicator: AppColors.secondaryContainer,
    );
  }

  static ThemeData dark() {
    final scheme = ColorScheme.dark(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkBackground,
      primaryContainer: AppColors.primary,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondaryContainer,
      onSecondary: AppColors.darkBackground,
      secondaryContainer: AppColors.darkSurfaceHigh,
      onSecondaryContainer: AppColors.darkOnSurface,
      tertiary: AppColors.tertiaryContainer,
      onTertiary: AppColors.darkBackground,
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFF93000A),
      onErrorContainer: const Color(0xFFFFDAD6),
      surface: AppColors.darkSurface,
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      outline: AppColors.darkOnSurfaceVariant,
      outlineVariant: AppColors.darkOutlineVariant,
      surfaceContainerHighest: AppColors.darkSurfaceHigh,
      surfaceContainerHigh: AppColors.darkSurfaceHigh,
      surfaceContainer: AppColors.darkSurface,
      surfaceContainerLow: AppColors.darkBackground,
      surfaceContainerLowest: AppColors.darkBackground,
    );

    return _build(
      brightness: Brightness.dark,
      scheme: scheme,
      scaffoldBackground: AppColors.darkBackground,
      onSurface: AppColors.darkOnSurface,
      cardColor: AppColors.darkSurface,
      cardBorder: AppColors.darkOutlineVariant,
      inputFill: AppColors.darkSurface,
      buttonBg: AppColors.primaryContainer,
      buttonFg: AppColors.onPrimary,
      navBg: AppColors.darkSurface,
      navIndicator: AppColors.darkSurfaceHigh,
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme scheme,
    required Color scaffoldBackground,
    required Color onSurface,
    required Color cardColor,
    required Color cardBorder,
    required Color inputFill,
    required Color buttonBg,
    required Color buttonFg,
    required Color navBg,
    required Color navIndicator,
  }) {
    final textTheme = AppTypography.textTheme(onSurface, brightness: brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBackground,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: scaffoldBackground,
        foregroundColor: scheme.primary,
        titleTextStyle: textTheme.headlineMedium?.copyWith(color: scheme.primary),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cardBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFill,
        labelStyle: TextStyle(color: scheme.onSurfaceVariant),
        hintStyle: TextStyle(color: scheme.onSurfaceVariant),
        prefixIconColor: scheme.onSurfaceVariant,
        suffixIconColor: scheme.onSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: textTheme.bodyMedium,
        menuStyle: MenuStyle(
          backgroundColor: WidgetStatePropertyAll(cardColor),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: cardColor,
        textStyle: textTheme.bodyMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          backgroundColor: buttonBg,
          foregroundColor: buttonFg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: navBg,
        indicatorColor: navIndicator,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600);
          }
          return textTheme.labelSmall;
        }),
      ),
      dividerTheme: DividerThemeData(color: scheme.outlineVariant),
    );
  }
}
