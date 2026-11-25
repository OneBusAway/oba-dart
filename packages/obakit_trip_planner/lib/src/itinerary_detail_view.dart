import 'package:flutter/material.dart';

import 'api/api.dart';
import 'display/formatting.dart';
import 'display/itinerary_display.dart';
import 'map_config.dart';
import 'strings.dart';
import 'theme.dart';
import 'widgets/a11y.dart';
import 'widgets/icons.dart';
import 'widgets/itinerary_map.dart';

/// Step-by-step directions for one itinerary, under a map of the trip.
///
/// Fills its parent: a map of [mapHeight] above a scrolling list of legs.
/// [ItineraryDetailPage] wraps it in a [Scaffold] for pushing as a route.
///
/// The step list is the map's text alternative: everything the map shows is
/// also written out below it, so screen-reader and keyboard users never
/// need the map. Set [showMap] to false to omit it entirely.
class ItineraryDetailView extends StatelessWidget {
  const ItineraryDetailView({
    super.key,
    required this.itinerary,
    required this.mapConfig,
    this.originName,
    this.destinationName,
    this.distanceUnits,
    this.mapHeight = 280,
    this.showMap = true,
    this.strings = const TripPlannerStrings(),
  });

  final Itinerary itinerary;
  final TripMapConfig mapConfig;

  /// The rider's names for the endpoints ("Current Location", a search
  /// result). OTP's own names are used when null.
  final String? originName;
  final String? destinationName;

  /// Null picks units from the app locale.
  final DistanceUnits? distanceUnits;
  final double mapHeight;
  final bool showMap;
  final TripPlannerStrings strings;

  @override
  Widget build(BuildContext context) {
    final units =
        distanceUnits ??
        DistanceUnits.forLocale(Localizations.maybeLocaleOf(context));
    final legs = itinerary.legs;
    final destination =
        destinationName ??
        (legs.isEmpty ? strings.destination : strings.placeName(legs.last.to));

    return TripPlannerContrast.applyAccessibleScheme(
      context,
      _content(context, units, legs, destination),
    );
  }

  Widget _content(
    BuildContext context,
    DistanceUnits units,
    List<Leg> legs,
    String destination,
  ) {
    return Column(
      children: [
        if (showMap)
          SizedBox(
            height: mapHeight,
            child: ItineraryMap(
              itinerary: itinerary,
              config: mapConfig,
              strings: strings,
            ),
          ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _Summary(itinerary: itinerary, strings: strings, units: units),
              const Divider(height: 1),
              for (var i = 0; i < legs.length; i++)
                _LegTile(
                  leg: legs[i],
                  fromName: i == 0 ? originName : null,
                  strings: strings,
                  units: units,
                ),
              _Endpoint(
                time: itinerary.endTime,
                label: strings.arriveAt(destination),
                icon: Icons.location_on,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// [ItineraryDetailView] in a [Scaffold] with an app bar.
class ItineraryDetailPage extends StatelessWidget {
  const ItineraryDetailPage({
    super.key,
    required this.itinerary,
    required this.mapConfig,
    this.originName,
    this.destinationName,
    this.distanceUnits,
    this.strings = const TripPlannerStrings(),
  });

  final Itinerary itinerary;
  final TripMapConfig mapConfig;
  final String? originName;
  final String? destinationName;
  final DistanceUnits? distanceUnits;
  final TripPlannerStrings strings;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(strings.tripDetails)),
    body: SafeArea(
      top: false,
      child: ItineraryDetailView(
        itinerary: itinerary,
        mapConfig: mapConfig,
        originName: originName,
        destinationName: destinationName,
        distanceUnits: distanceUnits,
        strings: strings,
      ),
    ),
  );
}

String _time(BuildContext context, DateTime t) => formatClockTime(
  t,
  MaterialLocalizations.of(context),
  alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
);

class _Summary extends StatelessWidget {
  const _Summary({
    required this.itinerary,
    required this.strings,
    required this.units,
  });

  final Itinerary itinerary;
  final TripPlannerStrings strings;
  final DistanceUnits units;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final details = [
      if (itinerary.walkDistance > 0)
        strings.walkDistance(strings.distance(itinerary.walkDistance, units)),
      if (firstTransitLeg(itinerary) != null)
        strings.transfers(itinerary.transfers),
      if (itinerary.fare case final fare?) strings.fare(formatMoney(fare)),
    ].join(' · ');
    final spokenDetails = [
      if (itinerary.walkDistance > 0)
        strings.walkDistance(
          strings.distanceSemantics(itinerary.walkDistance, units),
        ),
      if (firstTransitLeg(itinerary) != null)
        strings.transfers(itinerary.transfers),
      if (itinerary.fare case final fare?) strings.fare(formatMoney(fare)),
    ].join(', ');
    final start = _time(context, itinerary.startTime);
    final end = _time(context, itinerary.endTime);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            container: true,
            header: true,
            child: Text(
              '${strings.timeRange(start, end)}'
              ' · ${strings.duration(itinerary.duration)}',
              semanticsLabel:
                  '${strings.timeRangeSemantics(start, end)}, '
                  '${strings.durationSemantics(itinerary.duration)}',
              style: theme.textTheme.titleLarge,
            ),
          ),
          if (details.isNotEmpty)
            Text(
              details,
              semanticsLabel: spokenDetails,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: TripPlannerContrast.ensure(
                  theme.colorScheme.onSurfaceVariant,
                  TripPlannerContrast.surfaceOf(context),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// A leg: a coloured rail on the left, instructions on the right, and an
/// expandable list of steps (walk/bike) or intermediate stops (transit).
class _LegTile extends StatelessWidget {
  const _LegTile({
    required this.leg,
    required this.strings,
    required this.units,
    this.fromName,
  });

  final Leg leg;
  final TripPlannerStrings strings;
  final DistanceUnits units;
  final String? fromName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tripTheme = TripPlannerTheme.of(context);
    final kind = LegKind.of(leg);
    final color = tripTheme.colorForLeg(leg);
    final to = strings.placeName(leg.to);
    final from = fromName ?? strings.placeName(leg.from);
    final surface = TripPlannerContrast.surfaceOf(context);
    final secondary = theme.textTheme.bodyMedium?.copyWith(
      color: TripPlannerContrast.ensure(
        theme.colorScheme.onSurfaceVariant,
        surface,
      ),
    );
    final large = isLargeTextScale(context);

    final title = switch (kind) {
      LegKind.walk => strings.walkTo(to),
      LegKind.bike => strings.bikeTo(to),
      LegKind.rentalBike => strings.rideRentalBikeTo(to),
      LegKind.car => strings.driveTo(to),
      LegKind.transit => strings.board(
        strings.legModeName(leg),
        leg.routeName,
        leg.headsign,
      ),
    };
    final status = leg.departureStatus;

    final children = <Widget>[
      // At large text sizes the time column is dropped and the time leads
      // the content instead, so neither is squeezed into a fixed width.
      if (large)
        Text(_time(context, leg.startTime), style: theme.textTheme.labelLarge),
      Text(title, style: theme.textTheme.titleMedium),
      if (kind == LegKind.transit) ...[
        Text(
          strings.departsAt(_time(context, leg.startTime), from),
          style: secondary,
        ),
        if (status is! ScheduledStatus)
          Text(
            strings.realTimeStatus(status),
            semanticsLabel: strings.realTimeStatusSemantics(status),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: tripTheme.readableStatusColor(
                status,
                theme.colorScheme,
                surface,
              ),
              fontWeight: FontWeight.w600,
            ),
          ),
        if (leg.agencyName case final agency?) Text(agency, style: secondary),
      ] else
        Text(
          strings.legDistanceDuration(
            strings.distance(leg.distance, units),
            strings.duration(leg.duration),
          ),
          semanticsLabel: strings.legDistanceDuration(
            strings.distanceSemantics(leg.distance, units),
            strings.durationSemantics(leg.duration),
          ),
          style: secondary,
        ),
      if (kind == LegKind.transit && leg.intermediateStops.isNotEmpty)
        _Expandable(
          collapsedLabel: strings.showStops(leg.intermediateStops.length),
          expandedLabel: strings.hideStops(leg.intermediateStops.length),
          children: [
            for (final stop in leg.intermediateStops)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(strings.placeName(stop), style: secondary),
              ),
          ],
        ),
      if (kind != LegKind.transit && leg.steps.isNotEmpty)
        _Expandable(
          collapsedLabel: strings.showSteps(leg.steps.length),
          expandedLabel: strings.hideSteps(leg.steps.length),
          children: [
            for (final step in leg.steps)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  strings.stepInstruction(step, units),
                  style: secondary,
                ),
              ),
          ],
        ),
      if (kind == LegKind.transit)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${_time(context, leg.endTime)} · ${strings.getOffAt(to)}',
            style: theme.textTheme.bodyLarge,
          ),
        ),
    ];

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (large)
            const SizedBox(width: 12)
          else
            SizedBox(
              width: 72,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 12, start: 8),
                child: Text(
                  _time(context, leg.startTime),
                  style: theme.textTheme.labelLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          SizedBox(
            width: 32,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    legIcon(leg),
                    size: 16,
                    color: tripTheme.onColorForLeg(leg),
                  ),
                ),
                Expanded(
                  child: kind == LegKind.walk
                      ? _DottedRail(color: color)
                      : Container(width: 4, color: color),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DottedRail extends StatelessWidget {
  const _DottedRail({required this.color});

  final Color color;

  // A painter, not a LayoutBuilder: the rail lives inside IntrinsicHeight,
  // and LayoutBuilder can't report intrinsic sizes.
  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _DotsPainter(color),
    child: const SizedBox(width: 4),
  );
}

class _DotsPainter extends CustomPainter {
  _DotsPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    for (var y = 6.0; y < size.height; y += 10) {
      canvas.drawCircle(Offset(size.width / 2, y), 2, paint);
    }
  }

  @override
  bool shouldRepaint(_DotsPainter oldDelegate) => oldDelegate.color != color;
}

/// A text button that reveals [children]. Lighter than an ExpansionTile
/// inside the leg rail.
class _Expandable extends StatefulWidget {
  const _Expandable({
    required this.collapsedLabel,
    required this.expandedLabel,
    required this.children,
  });

  final String collapsedLabel;
  final String expandedLabel;
  final List<Widget> children;

  @override
  State<_Expandable> createState() => _ExpandableState();
}

class _ExpandableState extends State<_Expandable> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Full 48dp target (no compact density), and the expanded state is
      // exposed to screen readers.
      TextButton.icon(
        style: TextButton.styleFrom(padding: EdgeInsets.zero),
        onPressed: () => setState(() => _expanded = !_expanded),
        icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
        // Merges into the button's semantics node.
        label: Semantics(
          expanded: _expanded,
          child: Text(_expanded ? widget.expandedLabel : widget.collapsedLabel),
        ),
      ),
      if (_expanded) ...widget.children,
    ],
  );
}

class _Endpoint extends StatelessWidget {
  const _Endpoint({
    required this.time,
    required this.label,
    required this.icon,
  });

  final DateTime time;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final large = isLargeTextScale(context);
    final timeText = Text(
      _time(context, time),
      style: theme.textTheme.labelLarge,
      textAlign: large ? TextAlign.start : TextAlign.center,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          if (large)
            const SizedBox(width: 12)
          else
            SizedBox(
              width: 72,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(start: 8),
                child: timeText,
              ),
            ),
          SizedBox(
            width: 32,
            child: Icon(icon, color: theme.colorScheme.error),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsetsDirectional.only(end: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (large) timeText,
                  Text(label, style: theme.textTheme.titleMedium),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
