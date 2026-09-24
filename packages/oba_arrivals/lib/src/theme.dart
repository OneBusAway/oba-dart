import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'display/arrival_display.dart';

/// OBA-specific colors and badge metrics. Register it in
/// `ThemeData.extensions` to customize; otherwise light/dark defaults are
/// picked from the host theme's brightness.
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

  factory ObaArrivalsTheme.light() => const ObaArrivalsTheme(
        onTime: Color(0xFF16A34A), // green-600
        late: Color(0xFF7C3AED), // violet-600
        early: Color(0xFFDC2626), // red-600
      );

  factory ObaArrivalsTheme.dark() => const ObaArrivalsTheme(
        onTime: Color(0xFF4ADE80), // green-400
        late: Color(0xFFA78BFA), // violet-400
        early: Color(0xFFF87171), // red-400
      );

  static ObaArrivalsTheme of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<ObaArrivalsTheme>() ??
        (theme.brightness == Brightness.dark
            ? ObaArrivalsTheme.dark()
            : ObaArrivalsTheme.light());
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
  }) =>
      ObaArrivalsTheme(
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
      badgeFallbackColor: Color.lerp(badgeFallbackColor, other.badgeFallbackColor, t)!,
    );
  }
}
