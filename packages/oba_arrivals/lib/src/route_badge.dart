import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'theme.dart';

/// Colored route short-name badge (Wayfinder's `RouteBadge`).
///
/// [color] and [textColor] are raw GTFS hex strings, as found on `Route`.
class RouteBadge extends StatelessWidget {
  const RouteBadge({super.key, required this.label, this.color, this.textColor});

  final String label;
  final String? color;
  final String? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = ObaArrivalsTheme.of(context);
    final background = parseHexColor(color) ?? theme.badgeFallbackColor;
    final foreground = parseHexColor(textColor) ?? contrastingTextColor(background);
    return ExcludeSemantics(
      child: SizedBox.fromSize(
        size: theme.badgeSize,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(theme.badgeRadius),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.alphaBlend(Colors.white.withValues(alpha: 0.18), background),
                background,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Center(
              // The box is fixed-size, so the label ignores the text scale setting.
              child: MediaQuery.withNoTextScaling(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: foreground,
                    fontSize: badgeFontSize(label),
                    fontWeight: FontWeight.w700,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
