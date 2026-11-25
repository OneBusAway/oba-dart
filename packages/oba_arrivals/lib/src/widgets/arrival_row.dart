import 'package:flutter/material.dart' hide Route;
import 'package:onebusaway/onebusaway.dart';

import '../display/arrival_display.dart';
import '../display/stop_display.dart';
import '../route_badge.dart';
import '../strings.dart';
import '../surface.dart';
import '../theme.dart';
import 'focus_ring.dart';

/// Formats [time] as a local time of day using the host's
/// MaterialLocalizations and 24-hour preference.
String formatArrivalTime(BuildContext context, DateTime time) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(time.toLocal()),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

/// One arrival. Reads as a single sentence ("Route IL, Inside Loop,
/// arriving in 5 minutes, at 10:47 PM, 2 minutes late, real-time"); the
/// status is always written out, never shown by colour alone. At large text
/// sizes the badge and ETA move above the headsign so nothing truncates.
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
    final color = obaTheme.readableColorFor(
      statusKind(arrival),
      theme.colorScheme,
      surfaceColorOf(context),
    );
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
      strings.routeSemantics(label),
      headsign,
      eta == 0 ? strings.arrivingNow : strings.arrivingInMinutes(eta),
      if (time != null) strings.atTime(format(time)),
      statusSemantics(arrival, now, strings, formatTime: format),
      if (predicted) strings.realtime,
    ].where((part) => part.isNotEmpty).join(', ');

    final tap = onTap;
    final large = isLargeTextScale(context);

    final badge = RouteBadge(
      label: label,
      color: route?.color,
      textColor: route?.textColor,
    );
    final headsignText = Text(
      headsign,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
    final statusLine = Text.rich(
      TextSpan(
        children: [
          if (time != null) TextSpan(text: '${format(time)} · '),
          TextSpan(
            text: status,
            style: TextStyle(color: color),
          ),
        ],
      ),
      style: theme.textTheme.bodyMedium?.copyWith(
        color: readableOnSurface(context, theme.colorScheme.onSurfaceVariant),
      ),
    );
    final etaRow = Row(
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
        // Real-time vs scheduled, also spoken in the row label.
        Icon(
          predicted ? Icons.rss_feed : Icons.schedule,
          size: scaledIconSize(context, 16),
          color: color,
        ),
      ],
    );
    final chevron = tap == null
        ? null
        : Icon(
            Icons.chevron_right,
            size: scaledIconSize(context, 24),
            color: readableOnSurface(
              context,
              theme.colorScheme.onSurfaceVariant,
              minRatio: 3,
            ),
          );

    final Widget content;
    if (large) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(child: badge),
              const SizedBox(width: 12),
              const Spacer(),
              etaRow,
              ?chevron,
            ],
          ),
          const SizedBox(height: 8),
          headsignText,
          const SizedBox(height: 2),
          statusLine,
        ],
      );
    } else {
      content = Row(
        children: [
          badge,
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [headsignText, const SizedBox(height: 2), statusLine],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [etaRow, ?chevron],
          ),
        ],
      );
    }

    final padded = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: content,
    );

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: semanticsLabel,
      button: tap != null,
      onTap: tap == null ? null : () => tap(arrival),
      onTapHint: tap == null ? null : strings.rowTapHint,
      child: tap == null
          ? KeyedSubtree(
              key: ValueKey('oba-arrival-row-${arrival.tripId}'),
              child: padded,
            )
          : FocusRingInkWell(
              key: ValueKey('oba-arrival-row-${arrival.tripId}'),
              onTap: () => tap(arrival),
              child: padded,
            ),
    );
  }
}
