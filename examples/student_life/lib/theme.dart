import 'package:flutter/material.dart';

/// Student Life brand colours.
abstract final class Brand {
  /// Primary brand colour. White text on it.
  static const navy = Color(0xFF1B2F52);

  /// Accent. Fills carry navy text; gold text sits on navy.
  static const gold = Color(0xFFE0A526);

  /// Light page background.
  static const ground = Color(0xFFF6F7FA);

  /// Body text in light mode, page background in dark mode.
  static const ink = Color(0xFF121826);
}

/// Material 3 themes for the host app. The OBA screens read these too: they
/// use `Theme.of(context)` for text and surfaces and pick their own status
/// colours from the `ObaTheme` defaults for the brightness.
ThemeData buildStudentLifeTheme(Brightness brightness) {
  final light = brightness == Brightness.light;
  final scheme =
      ColorScheme.fromSeed(
        seedColor: Brand.navy,
        brightness: brightness,
      ).copyWith(
        // Light: navy actions with white text. Dark: navy is too dark on
        // the ink background, so gold actions carry navy text instead.
        primary: light ? Brand.navy : Brand.gold,
        onPrimary: light ? Colors.white : Brand.navy,
        secondary: Brand.gold,
        onSecondary: Brand.navy,
        secondaryContainer: Brand.gold,
        onSecondaryContainer: Brand.navy,
        surface: light ? Brand.ground : Brand.ink,
        onSurface: light ? Brand.ink : Brand.ground,
      );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: const AppBarTheme(
      backgroundColor: Brand.navy,
      foregroundColor: Colors.white,
    ),
    navigationBarTheme: NavigationBarThemeData(
      indicatorColor: Brand.gold,
      iconTheme: WidgetStateProperty.resolveWith(
        (states) => IconThemeData(
          color: states.contains(WidgetState.selected)
              ? Brand.navy
              : scheme.onSurfaceVariant,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: light ? Colors.white : scheme.surfaceContainerHigh,
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
  );
}
