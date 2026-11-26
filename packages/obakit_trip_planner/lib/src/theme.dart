import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'api/api.dart';
import 'display/formatting.dart';
import 'display/itinerary_display.dart';

/// Mode and status colours for the trip planner. Register one in
/// `ThemeData.extensions` to customize; otherwise [TripPlannerTheme.of]
/// derives one from the host's [ColorScheme].
///
/// Transit legs use their GTFS route colour when the feed has one; these
/// colours are the fallback.
///
/// Accessibility: the default status colours are at least 4.5:1 (WCAG 2.1
/// AA) on every Material 3 surface role in both brightnesses, and the
/// widgets also pass them through [TripPlannerContrast.ensure] against the
/// surface they are drawn on, so a host override that is too faint is
/// darkened (or lightened) instead of shown unreadable. Text on route
/// colours is always at least 4.5:1, whatever the feed's
/// `route_text_color` says.
@immutable
class TripPlannerTheme extends ThemeExtension<TripPlannerTheme> {
  const TripPlannerTheme({
    required this.transit,
    required this.walk,
    required this.bike,
    required this.car,
    required this.onTime,
    required this.late,
    required this.early,
    this.scheduled,
    this.polylineWidth = 5,
  });

  /// Mode colours from [scheme]; status colours match `ObaArrivalsTheme`
  /// (green-800 / violet-700 / red-700 in light, green-400 / violet-300 /
  /// red-300 in dark, or the 900 / 200-300 shades when [highContrast]).
  factory TripPlannerTheme.fromColorScheme(
    ColorScheme scheme, {
    bool highContrast = false,
  }) {
    final dark = scheme.brightness == Brightness.dark;
    return TripPlannerTheme(
      transit: scheme.primary,
      walk: scheme.outline,
      bike: scheme.tertiary,
      car: scheme.secondary,
      onTime: switch ((dark, highContrast)) {
        (false, false) => const Color(0xFF166534),
        (true, false) => const Color(0xFF4ADE80),
        (false, true) => const Color(0xFF14532D),
        (true, true) => const Color(0xFF86EFAC),
      },
      late: switch ((dark, highContrast)) {
        (false, false) => const Color(0xFF6D28D9),
        (true, false) => const Color(0xFFC4B5FD),
        (false, true) => const Color(0xFF4C1D95),
        (true, true) => const Color(0xFFDDD6FE),
      },
      early: switch ((dark, highContrast)) {
        (false, false) => const Color(0xFFB91C1C),
        (true, false) => const Color(0xFFFCA5A5),
        (false, true) => const Color(0xFF7F1D1D),
        (true, true) => const Color(0xFFFECACA),
      },
    );
  }

  /// The host's registered extension, else [TripPlannerTheme.fromColorScheme]
  /// (high-contrast when `MediaQuery.highContrastOf` is set).
  static TripPlannerTheme of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<TripPlannerTheme>() ??
        TripPlannerTheme.fromColorScheme(
          theme.colorScheme,
          highContrast: MediaQuery.maybeHighContrastOf(context) ?? false,
        );
  }

  final Color transit;
  final Color walk;
  final Color bike;
  final Color car;
  final Color onTime;
  final Color late;
  final Color early;

  /// Null means `colorScheme.onSurfaceVariant`.
  final Color? scheduled;

  /// Logical pixels; walk legs are drawn dotted at the same width.
  final double polylineWidth;

  Color colorForKind(LegKind kind) => switch (kind) {
    LegKind.walk => walk,
    LegKind.bike || LegKind.rentalBike => bike,
    LegKind.car => car,
    LegKind.transit => transit,
  };

  /// The route colour for transit legs that have one, else the mode colour.
  Color colorForLeg(Leg leg) {
    final kind = LegKind.of(leg);
    if (kind == LegKind.transit) {
      final route = parseHexColor(leg.routeColor);
      if (route != null) return route;
    }
    return colorForKind(kind);
  }

  /// Text colour on [colorForLeg]: the GTFS route text colour when given
  /// alongside a route colour and at least 4.5:1 on it, else black or white
  /// by contrast (agencies sometimes publish unreadable pairs).
  Color onColorForLeg(Leg leg) {
    final background = colorForLeg(leg);
    if (LegKind.of(leg) == LegKind.transit &&
        parseHexColor(leg.routeColor) != null) {
      final text = parseHexColor(leg.routeTextColor);
      return TripPlannerContrast.readableText(text, background);
    }
    return contrastingTextColor(background);
  }

  Color statusColor(RealTimeStatus status, ColorScheme scheme) =>
      switch (status) {
        OnTimeStatus() => onTime,
        LateStatus() => late,
        EarlyStatus() => early,
        ScheduledStatus() => scheduled ?? scheme.onSurfaceVariant,
      };

  /// [statusColor], adjusted to reach [minRatio] against [background].
  Color readableStatusColor(
    RealTimeStatus status,
    ColorScheme scheme,
    Color background, {
    double minRatio = 4.5,
  }) => TripPlannerContrast.ensure(
    statusColor(status, scheme),
    background,
    minRatio: minRatio,
  );

  @override
  TripPlannerTheme copyWith({
    Color? transit,
    Color? walk,
    Color? bike,
    Color? car,
    Color? onTime,
    Color? late,
    Color? early,
    Color? scheduled,
    double? polylineWidth,
  }) => TripPlannerTheme(
    transit: transit ?? this.transit,
    walk: walk ?? this.walk,
    bike: bike ?? this.bike,
    car: car ?? this.car,
    onTime: onTime ?? this.onTime,
    late: late ?? this.late,
    early: early ?? this.early,
    scheduled: scheduled ?? this.scheduled,
    polylineWidth: polylineWidth ?? this.polylineWidth,
  );

  @override
  TripPlannerTheme lerp(TripPlannerTheme? other, double t) {
    if (other == null) return this;
    return TripPlannerTheme(
      transit: Color.lerp(transit, other.transit, t)!,
      walk: Color.lerp(walk, other.walk, t)!,
      bike: Color.lerp(bike, other.bike, t)!,
      car: Color.lerp(car, other.car, t)!,
      onTime: Color.lerp(onTime, other.onTime, t)!,
      late: Color.lerp(late, other.late, t)!,
      early: Color.lerp(early, other.early, t)!,
      scheduled: Color.lerp(scheduled, other.scheduled, t),
      polylineWidth: lerpDouble(polylineWidth, other.polylineWidth, t)!,
    );
  }
}

/// Parses GTFS-style `RRGGBB` / `RGB`, with or without `#`.
Color? parseHexColor(String? hex) {
  if (hex == null) return null;
  var value = hex.trim().replaceFirst('#', '');
  if (value.length == 3) {
    value = value.split('').map((c) => '$c$c').join();
  }
  if (value.length != 6) return null;
  final rgb = int.tryParse(value, radix: 16);
  if (rgb == null) return null;
  return Color(0xFF000000 | rgb);
}

/// Black or white, whichever has the higher WCAG contrast on [background].
///
/// (This used `ThemeData.estimateBrightnessForColor`, which picks white on
/// mid greens and blues such as `00A651` at 3.2:1, where black gives 6.6:1.)
Color contrastingTextColor(Color background) =>
    TripPlannerContrast.ratio(Colors.black, background) >=
        TripPlannerContrast.ratio(Colors.white, background)
    ? Colors.black
    : Colors.white;

/// WCAG 2.1 contrast helpers used by the trip planner widgets.
abstract final class TripPlannerContrast {
  /// Contrast ratio (1 to 21). A translucent [a] is composited over [b].
  static double ratio(Color a, Color b) {
    final background = b.withValues(alpha: 1);
    final foreground = a.a < 1 ? Color.alphaBlend(a, background) : a;
    final l1 = foreground.computeLuminance();
    final l2 = background.computeLuminance();
    return (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05);
  }

  /// [preferred] when it reaches [minRatio] on [background], else
  /// [contrastingTextColor].
  static Color readableText(
    Color? preferred,
    Color background, {
    double minRatio = 4.5,
  }) {
    if (preferred != null && ratio(preferred, background) >= minRatio) {
      return preferred;
    }
    return contrastingTextColor(background);
  }

  /// [color] moved toward black (light backgrounds) or white (dark ones)
  /// just enough to reach [minRatio] on [background]; unchanged if it
  /// already does.
  static Color ensure(Color color, Color background, {double minRatio = 4.5}) {
    if (ratio(color, background) >= minRatio) return color;
    final opaque = color.a < 1
        ? Color.alphaBlend(color, background.withValues(alpha: 1))
        : color;
    final target = contrastingTextColor(background);
    if (ratio(target, background) < minRatio) return target;
    var lo = 0.0;
    var hi = 1.0;
    for (var i = 0; i < 16; i++) {
      final mid = (lo + hi) / 2;
      if (ratio(Color.lerp(opaque, target, mid)!, background) >= minRatio) {
        hi = mid;
      } else {
        lo = mid;
      }
    }
    return Color.lerp(opaque, target, hi)!;
  }

  /// [scheme] with its foreground roles adjusted (only where needed) to
  /// reach 4.5:1 for text (`onSurface`, `onSurfaceVariant`, `primary`,
  /// `secondary`, `error`) and 3:1 for `outline` on both `surface` and
  /// `surfaceContainerHighest`. Material components such as chips and text
  /// buttons read these roles directly, so the planner applies this to the
  /// host's scheme. Material 3 seeded schemes are returned unchanged.
  static ColorScheme accessibleScheme(ColorScheme scheme) {
    Color fix(Color c, double min) => ensure(
      ensure(c, scheme.surface, minRatio: min),
      scheme.surfaceContainerHighest,
      minRatio: min,
    );
    final fixed = scheme.copyWith(
      onSurface: fix(scheme.onSurface, 4.5),
      onSurfaceVariant: fix(scheme.onSurfaceVariant, 4.5),
      primary: fix(scheme.primary, 4.5),
      secondary: fix(scheme.secondary, 4.5),
      error: fix(scheme.error, 4.5),
      outline: fix(scheme.outline, 3),
    );
    return fixed == scheme ? scheme : fixed;
  }

  /// Wraps [child] in a [Theme] using [accessibleScheme] when the host's
  /// scheme needs adjusting; otherwise returns [child].
  static Widget applyAccessibleScheme(BuildContext context, Widget child) {
    final theme = Theme.of(context);
    final scheme = accessibleScheme(theme.colorScheme);
    if (identical(scheme, theme.colorScheme)) return child;
    return Theme(
      data: theme.copyWith(colorScheme: scheme),
      child: child,
    );
  }

  /// The opaque colour of the nearest [Material] (a `Card`, the `Scaffold`),
  /// or the theme's surface.
  static Color surfaceOf(BuildContext context) {
    final color = Material.maybeOf(context)?.color;
    final surface = Theme.of(context).colorScheme.surface;
    if (color == null || color.a == 0) return surface;
    return color.a == 1 ? color : Color.alphaBlend(color, surface);
  }
}
