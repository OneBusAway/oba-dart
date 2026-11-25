import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as core show Route;

import '../../l10n/l10n.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/rows.dart';

/// Minutes until [a] leaves, never negative, or null without times.
int? departureMinutes(ArrivalAndDeparture a, DateTime now) =>
    a.minutesUntil(now);

/// The arrivals still to come at [now] (not yet left).
List<ArrivalAndDeparture> upcomingArrivals(
  Iterable<ArrivalAndDeparture> arrivals,
  DateTime now,
) => [
  for (final a in arrivals)
    if ((a.minutesUntil(now) ?? -1) >= 0) a,
];

/// The localized status of a departure, plus the colour kind that goes
/// with it (the colour never carries the status alone: the text does).
({String text, Color Function(ObaTheme) color}) departureStatus(
  ObaLocalizations l10n,
  ArrivalAndDeparture a,
) {
  if (a.tripStatus?.status == 'CANCELED') {
    return (text: l10n.bookmarksStatusCanceled, color: (t) => t.canceled);
  }
  switch (a.scheduleStatus) {
    case ScheduleStatus.unknown:
      return (text: l10n.bookmarksStatusScheduled, color: (t) => t.scheduled);
    case ScheduleStatus.onTime:
      return (text: l10n.bookmarksStatusOnTime, color: (t) => t.onTime);
    case ScheduleStatus.early:
      return (
        text: l10n.bookmarksStatusEarly(a.deviationFromScheduleInMinutes.abs()),
        color: (t) => t.early,
      );
    case ScheduleStatus.delayed:
      return (
        text: l10n.bookmarksStatusLate(a.deviationFromScheduleInMinutes),
        color: (t) => t.late,
      );
  }
}

/// One departure: route badge, destination, status text and the minutes
/// until it leaves. Read as one sentence. Wraps at large text sizes.
class DepartureLine extends StatelessWidget {
  const DepartureLine({
    super.key,
    required this.arrival,
    required this.now,
    this.route,
    this.onTap,
  });

  final ArrivalAndDeparture arrival;
  final DateTime now;

  /// From the response references, for the badge colour.
  final core.Route? route;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final routeName =
        arrival.routeShortName ??
        route?.shortName ??
        route?.longName ??
        arrival.routeId.split('_').last;
    final headsign = arrival.tripHeadsign;
    final minutes = arrival.minutesUntil(now) ?? 0;
    final eta = minutes <= 0
        ? l10n.bookmarksEtaNow
        : l10n.bookmarksEtaMinutes(minutes);
    final status = departureStatus(l10n, arrival);
    final statusColor = status.color(ObaTheme.of(context));
    final sentence = l10n.bookmarksDepartureSemantics(
      headsign == null || headsign.isEmpty
          ? l10n.bookmarksDepartureRouteOnly(routeName)
          : l10n.bookmarksDepartureRoute(routeName, headsign),
      l10n.bookmarksEtaSemantic(minutes < 0 ? 0 : minutes),
      status.text,
    );
    final row = ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ObaRouteBadge(
              label: routeName,
              color: route?.color,
              textColor: route?.textColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (headsign != null && headsign.isNotEmpty)
                    Text(headsign, style: theme.textTheme.bodyMedium),
                  Text(
                    status.text,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              eta,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: sentence,
      button: onTap != null,
      onTap: onTap,
      child: onTap == null ? row : InkWell(onTap: onTap, child: row),
    );
  }
}
