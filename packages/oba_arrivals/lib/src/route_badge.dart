import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'theme.dart';

/// Colored route short-name badge (Wayfinder's `RouteBadge`).
///
/// [color] and [textColor] are raw GTFS hex strings, as found on `Route`.
///
/// Accessibility:
/// * The label is at least 4.5:1 against both ends of the badge's gradient.
///   A GTFS [textColor] that fails is replaced with black or white, and the
///   gradient is dropped for the rare mid-tone colours where neither passes
///   against both ends.
/// * The badge is `ObaArrivalsTheme.badgeSize` at 100% text size and grows
///   with the user's text size; the label wraps rather than truncating.
/// * It is excluded from the semantics tree unless [semanticLabel] is given,
///   because rows read the route as part of their own label.
class RouteBadge extends StatelessWidget {
  const RouteBadge({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.semanticLabel,
  });

  final String label;
  final String? color;
  final String? textColor;

  /// Read by screen readers when the badge stands alone (e.g. `Route 30`).
  /// Null keeps the badge out of the semantics tree.
  final String? semanticLabel;

  /// The minimum label contrast the badge guarantees.
  static const double minContrast = 4.5;

  /// The label colour, and whether the gradient can be kept, for
  /// [background] with an optional feed-supplied [preferred] text colour.
  static ({Color foreground, bool gradient}) colorsFor(
    Color background,
    Color? preferred,
  ) {
    final top = _gradientTop(background);
    double worst(Color c) =>
        math.min(contrastRatio(c, background), contrastRatio(c, top));
    if (preferred != null && worst(preferred) >= minContrast) {
      return (foreground: preferred, gradient: true);
    }
    final blackOrWhite = worst(Colors.black) >= worst(Colors.white)
        ? Colors.black
        : Colors.white;
    if (worst(blackOrWhite) >= minContrast) {
      return (foreground: blackOrWhite, gradient: true);
    }
    return (
      foreground: readableTextColor(preferred, background),
      gradient: false,
    );
  }

  static Color _gradientTop(Color background) =>
      Color.alphaBlend(Colors.white.withValues(alpha: 0.18), background);

  @override
  Widget build(BuildContext context) {
    final theme = ObaArrivalsTheme.of(context);
    final textTheme = Theme.of(context).textTheme;
    final scaler = MediaQuery.textScalerOf(context);
    final background = parseHexColor(color) ?? theme.badgeFallbackColor;
    final colors = colorsFor(background, parseHexColor(textColor));
    final base = textTheme.headlineSmall ?? const TextStyle();
    final baseSize = base.fontSize ?? 24;
    final size = theme.badgeSize;

    final badge = ConstrainedBox(
      constraints: BoxConstraints(
        minWidth: size.width,
        maxWidth: math.max(size.width, scaler.scale(size.width)),
        minHeight: math.max(size.height, scaler.scale(size.height)),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(theme.badgeRadius),
          gradient: colors.gradient
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [_gradientTop(background), background],
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: base.copyWith(
                color: colors.foreground,
                fontSize: baseSize * badgeFontSize(label) / 24,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ),
        ),
      ),
    );

    final semantic = semanticLabel;
    return semantic == null
        ? ExcludeSemantics(child: badge)
        : Semantics(label: semantic, excludeSemantics: true, child: badge);
  }
}
