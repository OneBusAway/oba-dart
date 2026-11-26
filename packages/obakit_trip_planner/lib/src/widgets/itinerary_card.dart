import 'package:flutter/material.dart';

import '../api/api.dart';
import '../display/formatting.dart';
import '../display/itinerary_display.dart';
import '../strings.dart';
import '../theme.dart';
import 'a11y.dart';
import 'focus_ring.dart';
import 'leg_chip.dart';

/// One itinerary in the results list: time range, duration, leg chips, and
/// walk/transfer/fare details.
///
/// Screen readers hear one sentence ("9:04 AM to 9:46 AM, 41 minutes. Walk
/// 5 minutes, then Tram Blue, 32 minutes. …, real-time, 2 minutes late");
/// keyboard users get a visible focus ring and Enter/Space to open it.
class ItineraryCard extends StatelessWidget {
  const ItineraryCard({
    super.key,
    required this.itinerary,
    required this.distanceUnits,
    this.onTap,
    this.selected = false,
    this.strings = const TripPlannerStrings(),
  });

  final Itinerary itinerary;
  final DistanceUnits distanceUnits;
  final VoidCallback? onTap;
  final bool selected;
  final TripPlannerStrings strings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);
    final use24h = MediaQuery.alwaysUse24HourFormatOf(context);
    String time(DateTime t) =>
        formatClockTime(t, localizations, alwaysUse24HourFormat: use24h);

    final range = strings.timeRange(
      time(itinerary.startTime),
      time(itinerary.endTime),
    );
    final duration = strings.duration(itinerary.duration);
    final chips = legSummary(itinerary);
    final details = [
      if (itinerary.walkDistance > 0)
        strings.walkDistance(
          strings.distance(itinerary.walkDistance, distanceUnits),
        ),
      if (firstTransitLeg(itinerary) != null)
        strings.transfers(itinerary.transfers),
      if (itinerary.fare case final fare?) strings.fare(formatMoney(fare)),
    ].join(' · ');

    final transit = firstTransitLeg(itinerary);
    final departure = transit == null
        ? null
        : strings.departsAt(
            time(transit.startTime),
            strings.placeName(transit.from),
          );
    final status = transit?.departureStatus;
    final statusText = status == null || status is ScheduledStatus
        ? null
        : strings.realTimeStatus(status);

    final spokenDetails = [
      if (itinerary.walkDistance > 0)
        strings.walkDistance(
          strings.distanceSemantics(itinerary.walkDistance, distanceUnits),
        ),
      if (transit != null) strings.transfers(itinerary.transfers),
      if (itinerary.fare case final fare?) strings.fare(formatMoney(fare)),
    ].join(', ');
    final semantics = strings.itinerarySemantics(
      timeRange: strings.timeRangeSemantics(
        time(itinerary.startTime),
        time(itinerary.endTime),
      ),
      duration: strings.durationSemantics(itinerary.duration),
      legs: chips.map(strings.legChipSemantics).join(', ${strings.then} '),
      details: [
        spokenDetails,
        if (departure != null)
          '$departure, ${strings.realTimeStatusSemantics(status!)}',
      ].where((s) => s.isNotEmpty).join('. '),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      color: selected ? theme.colorScheme.secondaryContainer : null,
      child: Semantics(
        button: true,
        selected: selected,
        label: semantics,
        onTap: onTap,
        onTapHint: strings.openItineraryHint,
        excludeSemantics: true,
        child: FocusRingInkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(range, style: theme.textTheme.titleMedium),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      duration,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    for (var i = 0; i < chips.length; i++) ...[
                      if (i > 0)
                        Icon(
                          Icons.chevron_right,
                          size: scaledIconSize(context, 16),
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      LegChip(item: chips[i], strings: strings),
                    ],
                  ],
                ),
                if (departure != null) ...[
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: departure),
                        if (statusText != null) ...[
                          const TextSpan(text: ' · '),
                          TextSpan(
                            text: statusText,
                            style: TextStyle(
                              color: TripPlannerTheme.of(context)
                                  .readableStatusColor(
                                    status!,
                                    theme.colorScheme,
                                    TripPlannerContrast.surfaceOf(context),
                                  ),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                if (details.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    details,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: TripPlannerContrast.ensure(
                        theme.colorScheme.onSurfaceVariant,
                        TripPlannerContrast.surfaceOf(context),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
