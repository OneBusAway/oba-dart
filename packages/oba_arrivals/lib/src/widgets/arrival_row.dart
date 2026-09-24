import 'package:flutter/material.dart' hide Route;
import 'package:onebusaway/onebusaway.dart';

import '../display/arrival_display.dart';
import '../display/stop_display.dart';
import '../route_badge.dart';
import '../strings.dart';
import '../theme.dart';

/// Formats [time] as a local time of day using the host's
/// MaterialLocalizations and 24-hour preference.
String formatArrivalTime(BuildContext context, DateTime time) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(time.toLocal()),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

class ArrivalRow extends StatelessWidget {
  const ArrivalRow({
    super.key,
    required this.arrival,
    required this.route,
    required this.now,
    required this.strings,
    this.onTap,
  });

  final ArrivalAndDeparture arrival;
  final Route? route;
  final DateTime now;
  final ObaArrivalsStrings strings;
  final void Function(ArrivalAndDeparture arrival)? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final obaTheme = ObaArrivalsTheme.of(context);
    final color = obaTheme.colorFor(statusKind(arrival), theme.colorScheme);
    final eta = minutesUntil(arrival, now) ?? 0;
    final predicted = hasPrediction(arrival);
    String format(DateTime t) => formatArrivalTime(context, t);

    final label =
        arrival.routeShortName ??
        route?.shortName ??
        stripAgencyPrefix(arrival.routeId);
    final headsign = arrival.tripHeadsign ?? route?.longName ?? '';
    final status = statusText(arrival, now, strings, formatTime: format);
    final time = displayTime(arrival);

    final semanticsLabel = [
      label,
      headsign,
      eta == 0 ? strings.arrivingNow : strings.arrivingInMinutes(eta),
      status,
      if (predicted) strings.realtime,
    ].where((part) => part.isNotEmpty).join(', ');

    final tap = onTap;
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: semanticsLabel,
      button: tap != null,
      onTap: tap == null ? null : () => tap(arrival),
      onTapHint: tap == null ? null : strings.rowTapHint,
      child: InkWell(
        key: ValueKey('oba-arrival-row-${arrival.tripId}'),
        onTap: tap == null ? null : () => tap(arrival),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              RouteBadge(
                label: label,
                color: route?.color,
                textColor: route?.textColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headsign,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(
                        children: [
                          if (time != null)
                            TextSpan(text: '${format(time)} · '),
                          TextSpan(
                            text: status,
                            style: TextStyle(color: color),
                          ),
                        ],
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        etaLabel(eta, strings),
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        predicted ? Icons.rss_feed : Icons.schedule,
                        size: 16,
                        color: color,
                      ),
                    ],
                  ),
                  if (tap != null)
                    Icon(
                      Icons.chevron_right,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
