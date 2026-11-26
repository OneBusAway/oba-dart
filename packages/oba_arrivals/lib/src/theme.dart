import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'display/arrival_display.dart';

/// OBA-specific colors and badge metrics. Register it in
/// `ThemeData.extensions` to customize; otherwise light/dark defaults are
/// picked from the host theme's brightness (and the platform's
/// high-contrast setting).
///
/// The defaults meet WCAG 2.1 AA (4.5:1) as text on every Material 3
/// surface role (`surface` through `surfaceContainerHighest`, and
/// `secondaryContainer`) of any `ColorScheme.fromSeed` scheme. The panel
/// also passes each status colour through [ensureContrast] against the
/// surface it is drawn on, so a host override that is too light (or too
/// dark) is adjusted rather than shown unreadable.
@immutable
class ObaArrivalsTheme extends ThemeExtension<ObaArrivalsTheme> {
  const ObaArrivalsTheme({
    required this.onTime,
    required this.late,
    required this.early,
    this.scheduled,
    this.canceled,
    this.badgeSize = const Size(64, 56),
    this.badgeRadius = 8,
    this.badgeFallbackColor = const Color(0xFF374151),
  });

  /// At least 5:1 on light Material 3 surfaces (green-800, violet-700,
  /// red-700). The previous green-600 / red-600 measured 3.1:1 and 4.6:1 on
  /// white and failed AA.
  factory ObaArrivalsTheme.light() => const ObaArrivalsTheme(
    onTime: Color(0xFF166534), // green-800
    late: Color(0xFF6D28D9), // violet-700
    early: Color(0xFFB91C1C), // red-700
  );

  /// At least 4.9:1 on dark Material 3 surfaces (green-400, violet-300,
  /// red-300).
  factory ObaArrivalsTheme.dark() => const ObaArrivalsTheme(
    onTime: Color(0xFF4ADE80), // green-400
    late: Color(0xFFC4B5FD), // violet-300
    early: Color(0xFFFCA5A5), // red-300
  );

  /// At least 7:1 (WCAG AAA) on light surfaces; used when the platform asks
  /// for more contrast.
  factory ObaArrivalsTheme.highContrastLight() => const ObaArrivalsTheme(
    onTime: Color(0xFF14532D), // green-900
    late: Color(0xFF4C1D95), // violet-900
    early: Color(0xFF7F1D1D), // red-900
    badgeFallbackColor: Color(0xFF1F2937),
  );

  /// At least 6.4:1 on dark surfaces; used when the platform asks for more
  /// contrast.
  factory ObaArrivalsTheme.highContrastDark() => const ObaArrivalsTheme(
    onTime: Color(0xFF86EFAC), // green-300
    late: Color(0xFFDDD6FE), // violet-200
    early: Color(0xFFFECACA), // red-200
    badgeFallbackColor: Color(0xFF1F2937),
  );

  /// The host's registered extension, else the default for the theme's
  /// brightness, using the high-contrast variant when
  /// `MediaQuery.highContrastOf` is set.
  static ObaArrivalsTheme of(BuildContext context) {
    final theme = Theme.of(context);
    final registered = theme.extension<ObaArrivalsTheme>();
    if (registered != null) return registered;
    final highContrast = MediaQuery.maybeHighContrastOf(context) ?? false;
    final dark = theme.brightness == Brightness.dark;
    return switch ((dark, highContrast)) {
      (false, false) => ObaArrivalsTheme.light(),
      (true, false) => ObaArrivalsTheme.dark(),
      (false, true) => ObaArrivalsTheme.highContrastLight(),
      (true, true) => ObaArrivalsTheme.highContrastDark(),
    };
  }

  final Color onTime;
  final Color late;
  final Color early;

  /// Null means `colorScheme.onSurfaceVariant`.
  final Color? scheduled;

  /// Null means `colorScheme.error`.
  final Color? canceled;
  final Size badgeSize;
  final double badgeRadius;
  final Color badgeFallbackColor;

  Color colorFor(ArrivalStatusKind kind, ColorScheme scheme) => switch (kind) {
    ArrivalStatusKind.onTime => onTime,
    ArrivalStatusKind.late => late,
    ArrivalStatusKind.early => early,
    ArrivalStatusKind.scheduled => scheduled ?? scheme.onSurfaceVariant,
    ArrivalStatusKind.canceled => canceled ?? scheme.error,
  };

  /// [colorFor], adjusted with [ensureContrast] to reach [minRatio] against
  /// [background] (the surface the status is drawn on).
  Color readableColorFor(
    ArrivalStatusKind kind,
    ColorScheme scheme,
    Color background, {
    double minRatio = 4.5,
  }) => ensureContrast(colorFor(kind, scheme), background, minRatio: minRatio);

  @override
  ObaArrivalsTheme copyWith({
    Color? onTime,
    Color? late,
    Color? early,
    Color? scheduled,
    Color? canceled,
    Size? badgeSize,
    double? badgeRadius,
    Color? badgeFallbackColor,
  }) => ObaArrivalsTheme(
    onTime: onTime ?? this.onTime,
    late: late ?? this.late,
    early: early ?? this.early,
    scheduled: scheduled ?? this.scheduled,
    canceled: canceled ?? this.canceled,
    badgeSize: badgeSize ?? this.badgeSize,
    badgeRadius: badgeRadius ?? this.badgeRadius,
    badgeFallbackColor: badgeFallbackColor ?? this.badgeFallbackColor,
  );

  @override
  ObaArrivalsTheme lerp(ObaArrivalsTheme? other, double t) {
    if (other == null) return this;
    return ObaArrivalsTheme(
      onTime: Color.lerp(onTime, other.onTime, t)!,
      late: Color.lerp(late, other.late, t)!,
      early: Color.lerp(early, other.early, t)!,
      scheduled: Color.lerp(scheduled, other.scheduled, t),
      canceled: Color.lerp(canceled, other.canceled, t),
      badgeSize: Size.lerp(badgeSize, other.badgeSize, t)!,
      badgeRadius: lerpDouble(badgeRadius, other.badgeRadius, t)!,
      badgeFallbackColor: Color.lerp(
        badgeFallbackColor,
        other.badgeFallbackColor,
        t,
      )!,
    );
  }
}
