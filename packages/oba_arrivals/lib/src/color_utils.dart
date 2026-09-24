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

/// Black or white, whichever has the higher WCAG contrast on [background].
Color contrastingTextColor(Color background) {
  final l = background.computeLuminance();
  final withWhite = 1.05 / (l + 0.05);
  final withBlack = (l + 0.05) / 0.05;
  return withBlack >= withWhite ? Colors.black : Colors.white;
}

/// Wayfinder's badge font size: shrink long or multi-word names, 8–24 px.
double badgeFontSize(String label) {
  final words = label.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return 24;
  final longest = words.map((w) => w.length).reduce(math.max);
  final size = math.min(24, math.min((90 / longest).round(), (42 / words.length).round()));
  return math.max(8, size).toDouble();
}
