import 'package:flutter/material.dart';

import 'color_utils.dart';

/// The opaque colour of the nearest [Material] above [context] (a host
/// `Card`, `Scaffold`, sheet…), or the theme's surface when there is none or
/// it is translucent. Status colours are checked for contrast against it.
Color surfaceColorOf(BuildContext context) {
  final color = Material.maybeOf(context)?.color;
  if (color != null && color.a == 1) return color;
  final scheme = Theme.of(context).colorScheme;
  if (color != null && color.a > 0) {
    return Color.alphaBlend(color, scheme.surface);
  }
  return scheme.surface;
}

/// Whether the text is large enough that rows should stack instead of
/// squeezing side by side (at or above 130% of the base size).
bool isLargeTextScale(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(100) >= 130;

/// [size] scaled with the user's text size, for icons that sit beside text.
double scaledIconSize(BuildContext context, double size) =>
    MediaQuery.textScalerOf(context).scale(size);

/// [color] adjusted to reach [minRatio] against [surfaceColorOf].
Color readableOnSurface(
  BuildContext context,
  Color color, {
  double minRatio = 4.5,
}) => ensureContrast(color, surfaceColorOf(context), minRatio: minRatio);
