import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:oba_arrivals/oba_arrivals.dart'
    show
        ObaArrivalsTheme,
        contrastRatio,
        contrastingTextColor,
        ensureContrast,
        readableTextColor;

/// OneBusAway-specific colours and metrics, as a [ThemeExtension].
///
/// Screens read it with [ObaTheme.of], which falls back to [ObaTheme.light]
/// or [ObaTheme.dark] (by the ambient brightness, and the high-contrast
/// variants when `MediaQuery.highContrast` is on) when the host registered
/// none. Everything else (text styles, surfaces, primary colour) comes from
/// the host's `Theme.of(context)`: screens never assume the brand theme.
///
/// Every text colour here meets WCAG 2.1 AA (4.5:1) on the colour it is
/// meant for, and every non-text pair (pin outline, glyph, focus ring)
/// meets 3:1; `test/theme_contrast_test.dart` enforces it.
@immutable
class ObaTheme extends ThemeExtension<ObaTheme> {
  const ObaTheme({
    required this.brand,
    required this.onBrand,
    required this.onTime,
    required this.late,
    required this.early,
    required this.scheduled,
    required this.canceled,
    required this.stopPinFill,
    required this.stopPinGlyph,
    required this.stopPinStroke,
    required this.bookmarkedPinFill,
    required this.bookmarkedPinGlyph,
    required this.selectedPinRing,
    required this.userLocation,
    required this.routeLine,
    required this.vehicle,
    required this.onVehicle,
    this.mapBackground = const Color(0xFFF2EFE9),
    this.stopPinSize = 40,
    this.sheetCornerRadius = 16,
    this.sidePanelWidth = 400,
    this.wideLayoutBreakpoint = 840,
    this.routeLineWidth = 5,
  });

  /// The OneBusAway green (iOS `ThemeColors.brand`, #78AA36), darkened to
  /// pass 4.5:1 with white text.
  static const brandGreen = Color(0xFF78AA36);

  factory ObaTheme.light() => const ObaTheme(
    brand: Color(0xFF3B6E11),
    onBrand: Color(0xFFFFFFFF),
    onTime: Color(0xFF166534), // green-800 (as oba_arrivals)
    late: Color(0xFF6D28D9), // violet-700
    early: Color(0xFFB91C1C), // red-700
    scheduled: Color(0xFF4B5563), // gray-600
    canceled: Color(0xFFB91C1C),
    stopPinFill: Color(0xFFFFFFFF),
    stopPinGlyph: Color(0xFF1F2937),
    stopPinStroke: Color(0xFF374151),
    bookmarkedPinFill: Color(0xFF3B6E11),
    bookmarkedPinGlyph: Color(0xFFFFFFFF),
    selectedPinRing: Color(0xFF1D4ED8),
    userLocation: Color(0xFF1D4ED8),
    routeLine: Color(0xFF1D4ED8),
    vehicle: Color(0xFF1D4ED8),
    onVehicle: Color(0xFFFFFFFF),
  );

  factory ObaTheme.dark() => const ObaTheme(
    brand: Color(0xFF9CCB5E),
    onBrand: Color(0xFF102000),
    onTime: Color(0xFF4ADE80), // green-400
    late: Color(0xFFC4B5FD), // violet-300
    early: Color(0xFFFCA5A5), // red-300
    scheduled: Color(0xFFD1D5DB), // gray-300
    canceled: Color(0xFFFCA5A5),
    stopPinFill: Color(0xFF1F2937),
    stopPinGlyph: Color(0xFFF9FAFB),
    stopPinStroke: Color(0xFFE5E7EB),
    bookmarkedPinFill: Color(0xFF9CCB5E),
    bookmarkedPinGlyph: Color(0xFF102000),
    selectedPinRing: Color(0xFF93C5FD),
    userLocation: Color(0xFF60A5FA),
    routeLine: Color(0xFF60A5FA),
    vehicle: Color(0xFF60A5FA),
    onVehicle: Color(0xFF0B1220),
    mapBackground: Color(0xFF1B1B1D),
  );

  /// Stronger colours for `MediaQuery.highContrast` (7:1 text).
  factory ObaTheme.highContrastLight() => ObaTheme.light().copyWith(
    brand: const Color(0xFF254A05),
    onTime: const Color(0xFF14532D),
    late: const Color(0xFF4C1D95),
    early: const Color(0xFF7F1D1D),
    scheduled: const Color(0xFF1F2937),
    canceled: const Color(0xFF7F1D1D),
    stopPinStroke: const Color(0xFF000000),
    stopPinGlyph: const Color(0xFF000000),
    bookmarkedPinFill: const Color(0xFF254A05),
    selectedPinRing: const Color(0xFF1E3A8A),
  );

  factory ObaTheme.highContrastDark() => ObaTheme.dark().copyWith(
    brand: const Color(0xFFC5E89A),
    onTime: const Color(0xFF86EFAC),
    late: const Color(0xFFDDD6FE),
    early: const Color(0xFFFECACA),
    scheduled: const Color(0xFFF3F4F6),
    canceled: const Color(0xFFFECACA),
    stopPinStroke: const Color(0xFFFFFFFF),
    stopPinGlyph: const Color(0xFFFFFFFF),
    stopPinFill: const Color(0xFF000000),
    bookmarkedPinFill: const Color(0xFFC5E89A),
    selectedPinRing: const Color(0xFFBFDBFE),
  );

  /// The registered extension, or the default for the ambient brightness
  /// and contrast setting.
  static ObaTheme of(BuildContext context) {
    final theme = Theme.of(context);
    final registered = theme.extension<ObaTheme>();
    if (registered != null) return registered;
    final highContrast = MediaQuery.maybeHighContrastOf(context) ?? false;
    final dark = theme.brightness == Brightness.dark;
    final key = (theme.colorScheme, dark, highContrast);
    final cached = _defaultsCache[key];
    if (cached != null) return cached;
    final base = highContrast
        ? (dark ? ObaTheme.highContrastDark() : ObaTheme.highContrastLight())
        : (dark ? ObaTheme.dark() : ObaTheme.light());
    if (_defaultsCache.length > 8) _defaultsCache.clear();
    return _defaultsCache[key] = base.readableOn(theme.colorScheme);
  }

  static final Map<(ColorScheme, bool, bool), ObaTheme> _defaultsCache = {};

  /// This theme with its status colours nudged (keeping their hue) until
  /// they reach 4.5:1 on every surface role of [scheme] that rows and cards
  /// use. [of] applies it to the defaults so a host's own surfaces never
  /// make status text unreadable; a registered extension is used as given.
  ObaTheme readableOn(ColorScheme scheme) {
    final surfaces = [
      scheme.surface,
      scheme.surfaceContainerLowest,
      scheme.surfaceContainerLow,
      scheme.surfaceContainer,
      scheme.surfaceContainerHigh,
      scheme.surfaceContainerHighest,
      scheme.secondaryContainer,
    ];
    Color fix(Color c) {
      var out = c;
      // Two passes: a nudge for one surface can undo another.
      for (var pass = 0; pass < 2; pass++) {
        for (final bg in surfaces) {
          out = ensureContrast(out, bg);
        }
      }
      return out;
    }

    return copyWith(
      onTime: fix(onTime),
      late: fix(late),
      early: fix(early),
      scheduled: fix(scheduled),
      canceled: fix(canceled),
    );
  }

  /// Brand colour for fills (buttons, bookmarked pins) and [onBrand] for
  /// text or icons on it.
  final Color brand;
  final Color onBrand;

  /// Arrival status text colours (on `colorScheme.surface`). Always pair
  /// them with text ("on time", "3 min late"): never colour alone.
  final Color onTime;
  final Color late;
  final Color early;
  final Color scheduled;
  final Color canceled;

  /// Stop pin: [stopPinGlyph] (route-type icon) on [stopPinFill], outlined
  /// with [stopPinStroke]. Fill and stroke contrast with each other, so the
  /// pin stands out on light and dark map tiles alike.
  final Color stopPinFill;
  final Color stopPinGlyph;
  final Color stopPinStroke;
  final Color bookmarkedPinFill;
  final Color bookmarkedPinGlyph;

  /// Ring drawn around the selected stop pin.
  final Color selectedPinRing;
  final Color userLocation;

  /// Default colour of a route shape when the route has no GTFS colour.
  final Color routeLine;
  final Color vehicle;
  final Color onVehicle;

  /// Assumed map background for contrast checks and the map's backdrop
  /// while tiles load.
  final Color mapBackground;

  /// Outer size of a stop pin, including the direction-arrow track. At
  /// least 48 logical pixels of touch target are always provided.
  final double stopPinSize;
  final double sheetCornerRadius;

  /// Width of the side panel on wide layouts.
  final double sidePanelWidth;

  /// At or above this width the sheet becomes a side panel.
  final double wideLayoutBreakpoint;
  final double routeLineWidth;

  /// The matching [ObaArrivalsTheme], so the reused arrivals widgets use
  /// the same (accessible) status colours.
  ObaArrivalsTheme toArrivalsTheme() => ObaArrivalsTheme(
    onTime: onTime,
    late: late,
    early: early,
    scheduled: scheduled,
    canceled: canceled,
  );

  /// A complete [ThemeData] for the standalone app: a Material 3 scheme
  /// seeded from the brand green, with [ObaTheme] and [ObaArrivalsTheme]
  /// registered. Hosts that embed screens keep their own theme instead.
  static ThemeData buildThemeData({
    Brightness brightness = Brightness.light,
    bool highContrast = false,
    Color seed = brandGreen,
  }) {
    var scheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: brightness,
      contrastLevel: highContrast ? 1.0 : 0.0,
    );
    if (highContrast) {
      // At full contrast the seeded secondaryContainer (selected rows and
      // segments) turns nearly as dark (or light) as the status colours
      // drawn on it. Keep it a light tint (dark in dark mode) instead.
      scheme = scheme.copyWith(
        secondaryContainer: Color.alphaBlend(
          scheme.secondary.withValues(alpha: 0.16),
          scheme.surface,
        ),
        onSecondaryContainer: scheme.onSurface,
      );
    }
    final oba = switch ((brightness, highContrast)) {
      (Brightness.dark, true) => ObaTheme.highContrastDark(),
      (Brightness.dark, false) => ObaTheme.dark(),
      (_, true) => ObaTheme.highContrastLight(),
      _ => ObaTheme.light(),
    };
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [oba, oba.toArrivalsTheme()],
    );
  }

  @override
  ObaTheme copyWith({
    Color? brand,
    Color? onBrand,
    Color? onTime,
    Color? late,
    Color? early,
    Color? scheduled,
    Color? canceled,
    Color? stopPinFill,
    Color? stopPinGlyph,
    Color? stopPinStroke,
    Color? bookmarkedPinFill,
    Color? bookmarkedPinGlyph,
    Color? selectedPinRing,
    Color? userLocation,
    Color? routeLine,
    Color? vehicle,
    Color? onVehicle,
    Color? mapBackground,
    double? stopPinSize,
    double? sheetCornerRadius,
    double? sidePanelWidth,
    double? wideLayoutBreakpoint,
    double? routeLineWidth,
  }) => ObaTheme(
    brand: brand ?? this.brand,
    onBrand: onBrand ?? this.onBrand,
    onTime: onTime ?? this.onTime,
    late: late ?? this.late,
    early: early ?? this.early,
    scheduled: scheduled ?? this.scheduled,
    canceled: canceled ?? this.canceled,
    stopPinFill: stopPinFill ?? this.stopPinFill,
    stopPinGlyph: stopPinGlyph ?? this.stopPinGlyph,
    stopPinStroke: stopPinStroke ?? this.stopPinStroke,
    bookmarkedPinFill: bookmarkedPinFill ?? this.bookmarkedPinFill,
    bookmarkedPinGlyph: bookmarkedPinGlyph ?? this.bookmarkedPinGlyph,
    selectedPinRing: selectedPinRing ?? this.selectedPinRing,
    userLocation: userLocation ?? this.userLocation,
    routeLine: routeLine ?? this.routeLine,
    vehicle: vehicle ?? this.vehicle,
    onVehicle: onVehicle ?? this.onVehicle,
    mapBackground: mapBackground ?? this.mapBackground,
    stopPinSize: stopPinSize ?? this.stopPinSize,
    sheetCornerRadius: sheetCornerRadius ?? this.sheetCornerRadius,
    sidePanelWidth: sidePanelWidth ?? this.sidePanelWidth,
    wideLayoutBreakpoint: wideLayoutBreakpoint ?? this.wideLayoutBreakpoint,
    routeLineWidth: routeLineWidth ?? this.routeLineWidth,
  );

  @override
  ObaTheme lerp(ObaTheme? other, double t) {
    if (other == null) return this;
    Color c(Color a, Color b) => Color.lerp(a, b, t)!;
    double d(double a, double b) => lerpDouble(a, b, t)!;
    return ObaTheme(
      brand: c(brand, other.brand),
      onBrand: c(onBrand, other.onBrand),
      onTime: c(onTime, other.onTime),
      late: c(late, other.late),
      early: c(early, other.early),
      scheduled: c(scheduled, other.scheduled),
      canceled: c(canceled, other.canceled),
      stopPinFill: c(stopPinFill, other.stopPinFill),
      stopPinGlyph: c(stopPinGlyph, other.stopPinGlyph),
      stopPinStroke: c(stopPinStroke, other.stopPinStroke),
      bookmarkedPinFill: c(bookmarkedPinFill, other.bookmarkedPinFill),
      bookmarkedPinGlyph: c(bookmarkedPinGlyph, other.bookmarkedPinGlyph),
      selectedPinRing: c(selectedPinRing, other.selectedPinRing),
      userLocation: c(userLocation, other.userLocation),
      routeLine: c(routeLine, other.routeLine),
      vehicle: c(vehicle, other.vehicle),
      onVehicle: c(onVehicle, other.onVehicle),
      mapBackground: c(mapBackground, other.mapBackground),
      stopPinSize: d(stopPinSize, other.stopPinSize),
      sheetCornerRadius: d(sheetCornerRadius, other.sheetCornerRadius),
      sidePanelWidth: d(sidePanelWidth, other.sidePanelWidth),
      wideLayoutBreakpoint: d(wideLayoutBreakpoint, other.wideLayoutBreakpoint),
      routeLineWidth: d(routeLineWidth, other.routeLineWidth),
    );
  }
}

/// WCAG 2.1 contrast helpers. Thin forwarders to `oba_arrivals`'
/// `color_utils.dart`, kept so obakit code and hosts have one name for them.
abstract final class ObaContrast {
  /// Relative luminance of an opaque colour.
  static double luminance(Color c) => c.computeLuminance();

  /// Contrast ratio (1 to 21) between two colours; translucent [a] is
  /// composited over [b] first.
  static double ratio(Color a, Color b) => contrastRatio(a, b);

  /// Black or white, whichever is more readable on [background]. Use it for
  /// text on route colours from the feed.
  static Color readableOn(Color background) => contrastingTextColor(background);

  /// [preferred] when it reaches [minRatio] on [background], otherwise
  /// [readableOn]. For GTFS `route_text_color`, which feeds sometimes get
  /// wrong.
  static Color ensureReadable(
    Color? preferred,
    Color background, {
    double minRatio = 4.5,
  }) => readableTextColor(preferred, background, minRatio: minRatio);
}
