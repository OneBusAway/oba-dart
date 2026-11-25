import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as core show Route;

import '../../l10n/l10n.dart';
import '../../widgets/departure_format.dart';
import '../../widgets/rows.dart';

/// The arrivals still to come at [now] (not yet left).
List<ArrivalAndDeparture> upcomingArrivals(
  Iterable<ArrivalAndDeparture> arrivals,
  DateTime now,
) => [
  for (final a in arrivals)
    if ((a.minutesUntil(now) ?? -1) >= 0) a,
];

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
    final routeName = routeLabel(arrival, route);
    final headsign = arrival.tripHeadsign;
    final minutes = arrival.minutesUntil(now) ?? 0;
    final status = DepartureStatusInfo.of(context, arrival);
    final sentence = l10n.bookmarksDepartureSemantics(
      headsign == null || headsign.isEmpty
          ? l10n.bookmarksDepartureRouteOnly(routeName)
          : l10n.bookmarksDepartureRoute(routeName, headsign),
      etaA11y(l10n, arrival, minutes),
      status.a11y,
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
                    Text(
                      obaBidiIsolate(context, headsign),
                      style: theme.textTheme.bodyMedium,
                    ),
                  Text(
                    status.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: status.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              countdownText(l10n, minutes),
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
