import 'package:flutter/material.dart';

/// Tapline brand colours. Tapline is a fictional fare app brand.
abstract final class TaplineColors {
  /// Primary: white text on it.
  static const teal = Color(0xFF0B4F5C);

  /// Accent: only on dark or teal grounds, or as a fill with [ink] text.
  static const saffron = Color(0xFFF2B33D);

  /// Light-mode ground.
  static const ground = Color(0xFFF4F1EA);

  /// Text on light grounds and on saffron.
  static const ink = Color(0xFF14181C);

  /// A lighter teal that keeps 4.5:1 on the dark ground.
  static const tealLight = Color(0xFF8FD3DF);

  /// The dark-mode surface.
  static const darkGround = Color(0xFF101417);
}

/// Material 3 themes built from the brand. No font sizes are set here: the
/// default text theme scales with the rider's text size.
abstract final class TaplineTheme {
  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: TaplineColors.teal,
      brightness: Brightness.light,
    );
    final scheme = base.copyWith(
      primary: TaplineColors.teal,
      onPrimary: Colors.white,
      secondary: TaplineColors.saffron,
      onSecondary: TaplineColors.ink,
      surface: TaplineColors.ground,
      onSurface: TaplineColors.ink,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: const Color(0xFFFBF9F4),
      surfaceContainer: const Color(0xFFEDE9DF),
    );
    return _build(scheme);
  }

  static ThemeData dark() {
    final base = ColorScheme.fromSeed(
      seedColor: TaplineColors.teal,
      brightness: Brightness.dark,
    );
    final scheme = base.copyWith(
      primary: TaplineColors.tealLight,
      onPrimary: TaplineColors.ink,
      secondary: TaplineColors.saffron,
      onSecondary: TaplineColors.ink,
      surface: TaplineColors.darkGround,
      onSurface: TaplineColors.ground,
    );
    return _build(scheme);
  }

  static ThemeData _build(ColorScheme scheme) {
    final isDark = scheme.brightness == Brightness.dark;
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      scaffoldBackgroundColor: scheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? scheme.surface : TaplineColors.teal,
        foregroundColor: isDark ? scheme.onSurface : Colors.white,
      ),
      cardTheme: CardThemeData(
        color: isDark
            ? scheme.surfaceContainerHigh
            : scheme.surfaceContainerLowest,
        elevation: 0,
        margin: const EdgeInsetsDirectional.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: scheme.outlineVariant),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: TaplineColors.saffron,
        foregroundColor: TaplineColors.ink,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: isDark
            ? TaplineColors.teal
            : TaplineColors.saffron.withValues(alpha: 0.6),
      ),
    );
  }
}
