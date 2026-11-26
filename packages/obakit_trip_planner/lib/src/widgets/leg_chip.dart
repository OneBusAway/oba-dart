import 'package:flutter/material.dart';

import '../display/itinerary_display.dart';
import '../strings.dart';
import '../theme.dart';
import 'a11y.dart';
import 'icons.dart';

/// A compact, non-interactive chip for one leg of an itinerary summary:
/// the mode icon plus the route name (transit) or duration (other modes).
class LegChip extends StatelessWidget {
  const LegChip({
    super.key,
    required this.item,
    this.strings = const TripPlannerStrings(),
  });

  final LegSummaryItem item;
  final TripPlannerStrings strings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripTheme = TripPlannerTheme.of(context);
    final isTransit = item.kind == LegKind.transit;
    final background = isTransit
        ? tripTheme.colorForLeg(item.leg)
        : theme.colorScheme.surfaceContainerHighest;
    final foreground = isTransit
        ? tripTheme.onColorForLeg(item.leg)
        : theme.colorScheme.onSurface;
    final label = isTransit
        ? (item.routeName ?? strings.legModeName(item.leg))
        : strings.duration(item.durationSeconds);

    return Semantics(
      label: strings.legChipSemantics(item),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              legIcon(item.leg),
              size: scaledIconSize(context, 18),
              color: foreground,
            ),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: foreground,
                  fontWeight: isTransit ? FontWeight.w700 : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
