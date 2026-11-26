import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Parses GTFS hex colors (`ffcd00`, `FFFFFF`, `#20183D`). Null if absent or
/// malformed.
Color? parseHexColor(String? hex) {
  if (hex == null) return null;
  var value = hex.trim();
  if (value.startsWith('#')) value = value.substring(1);
  if (value.length != 6) return null;
  final rgb = int.tryParse(value, radix: 16);
  return rgb == null ? null : Color(0xFF000000 | rgb);
}

/// WCAG 2.1 contrast ratio (1 to 21) between [a] and [b]. A translucent
/// [a] is composited over [b] first; [b] is treated as opaque.
double contrastRatio(Color a, Color b) {
  final background = b.withValues(alpha: 1);
  final foreground = a.a < 1 ? Color.alphaBlend(a, background) : a;
  final l1 = foreground.computeLuminance();
  final l2 = background.computeLuminance();
  return (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05);
}

/// Black or white, whichever has the higher WCAG contrast on [background].
Color contrastingTextColor(Color background) {
  final l = background.computeLuminance();
  final withWhite = 1.05 / (l + 0.05);
  final withBlack = (l + 0.05) / 0.05;
  return withBlack >= withWhite ? Colors.black : Colors.white;
}

/// [preferred] when it reaches [minRatio] against [background] (WCAG AA body
/// text by default), otherwise [contrastingTextColor].
///
/// Use it for feed-supplied pairs such as GTFS `route_color` /
/// `route_text_color`, which agencies sometimes get wrong.
Color readableTextColor(
  Color? preferred,
  Color background, {
  double minRatio = 4.5,
}) {
  if (preferred != null && contrastRatio(preferred, background) >= minRatio) {
    return preferred;
  }
  return contrastingTextColor(background);
}

/// [color], darkened (on light backgrounds) or lightened (on dark ones)
/// just enough to reach [minRatio] against [background]. Returns [color]
/// unchanged when it already passes, and black or white when nothing in
/// between does.
///
/// The panel uses it so that host-supplied status colours stay readable on
/// whatever surface the host places the panel on.
Color ensureContrast(Color color, Color background, {double minRatio = 4.5}) {
  if (contrastRatio(color, background) >= minRatio) return color;
  final opaque = color.a < 1
      ? Color.alphaBlend(color, background.withValues(alpha: 1))
      : color;
  final target = contrastingTextColor(background);
  // Binary search for the smallest step toward [target] that passes.
  var lo = 0.0;
  var hi = 1.0;
  if (contrastRatio(target, background) < minRatio) return target;
  for (var i = 0; i < 16; i++) {
    final mid = (lo + hi) / 2;
    if (contrastRatio(Color.lerp(opaque, target, mid)!, background) >=
        minRatio) {
      hi = mid;
    } else {
      lo = mid;
    }
  }
  return Color.lerp(opaque, target, hi)!;
}

/// Wayfinder's badge font size: shrink long or multi-word names, 8–24 px.
///
/// `RouteBadge` treats the result as a fraction of 24 and applies it to the
/// host's `TextTheme`, then to the user's text scale.
double badgeFontSize(String label) {
  final words = label
      .trim()
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();
  if (words.isEmpty) return 24;
  final longest = words.map((w) => w.length).reduce(math.max);
  return math
      .min((90 / longest).round(), (42 / words.length).round())
      .clamp(8, 24)
      .toDouble();
}

/// [scheme] with its foreground roles adjusted (only where needed) to reach
/// 4.5:1 for text (`onSurface`, `onSurfaceVariant`, `primary`, `error`)
/// and 3:1 for `outline` on both `surface` and `surfaceContainerHighest`.
/// Material components inside the panel (the refresh button, Retry) read
/// these roles directly, so the panel applies this to the host's scheme.
/// Material 3 seeded schemes come back unchanged (the same instance).
ColorScheme accessibleColorScheme(ColorScheme scheme) {
  Color fix(Color c, double min) => ensureContrast(
    ensureContrast(c, scheme.surface, minRatio: min),
    scheme.surfaceContainerHighest,
    minRatio: min,
  );
  final fixed = scheme.copyWith(
    onSurface: fix(scheme.onSurface, 4.5),
    onSurfaceVariant: fix(scheme.onSurfaceVariant, 4.5),
    primary: fix(scheme.primary, 4.5),
    error: fix(scheme.error, 4.5),
    outline: fix(scheme.outline, 3),
  );
  return fixed == scheme ? scheme : fixed;
}
