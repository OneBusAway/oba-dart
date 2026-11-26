import 'dart:async';

import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../widgets/heading.dart';
import '../../app/polling.dart';
import '../../app/application.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../l10n/strings_bridge.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/memo.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import '../map/map_coordinator.dart';
import '../map/map_logic.dart';
import 'report_pages.dart';
import 'stop_actions.dart';
import '../../widgets/departure_format.dart';
import 'stop_sections.dart';
import 'trip_controller.dart';

/// One run of a trip (iOS `TripViewController`): a summary of the
/// vehicle's progress toward the rider's stop, the trip's stops with the
/// vehicle's position and collapsed runs, the adjacent trips of the block,
/// and actions. Draws the trip's shape, stops and vehicle on the map when
/// one is present. Embeddable: needs only an `ObaScope`.
class TripPage extends StatefulWidget {
  const TripPage({super.key, required this.trip});

  final TripRef trip;

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  late TripController _controller;
  ObaApplication? _app;
  final Set<String> _expanded = {};

  /// The trip's shape, decoded once when it arrives.
  List<Coordinate>? _shape;
  bool _shapeRequested = false;
  final ObaMemo<ObaMapOverlay> _overlayMemo = ObaMemo();
  Listenable? _listenable;

  @override
  void initState() {
    super.initState();
    _controller = _make();
    _controller.addListener(_onData);
  }

  TripController _make() =>
      TripController(trip: widget.trip, client: () => _app?.core.restClient);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _app = ObaScope.of(context);
  }

  @override
  void didUpdateWidget(TripPage old) {
    super.didUpdateWidget(old);
    if (old.trip != widget.trip) {
      _controller
        ..removeListener(_onData)
        ..dispose();
      _controller = _make()..addListener(_onData);
      _listenable = null;
      _expanded.clear();
      _shape = null;
      _shapeRequested = false;
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onData)
      ..dispose();
    super.dispose();
  }

  void _onData() {
    final s = _controller.state;
    if (_shapeRequested || !s.hasData || !mounted) return;
    if (ObaMapCoordinator.maybeOf(context) == null) return;
    final shapeId = s.references.trip(widget.trip.tripId)?.shapeId;
    final client = _app?.core.restClient;
    if (shapeId == null || client == null) return;
    _shapeRequested = true;
    unawaited(
      client.shapes
          .byId(shapeId)
          .then((r) {
            if (!mounted) return;
            final points = Polyline.decode(r.entry.points);
            setState(() => _shape = points);
          })
          .catchError((Object _) {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final core = ObaScope.of(context).core;
    return ObaPollingHolder(
      controller: _controller,
      child: ListenableBuilder(
        listenable: _listenable ??= Listenable.merge([
          _controller,
          ObaListenableAdapter(core.userData),
        ]),
        builder: (context, _) => _build(context, core),
      ),
    );
  }

  Widget _build(BuildContext context, ObaCoreApplication core) {
    final l10n = context.obaL10n;
    final s = _controller.state;
    final now = _controller.now();
    final details = s.details;
    final trip = s.references.trip(widget.trip.tripId);
    final route = trip == null ? null : s.references.route(trip.routeId);
    final routeName =
        route?.shortName ??
        s.arrival?.routeShortName ??
        trip?.routeShortName ??
        route?.longName;
    final headsign = s.arrival?.tripHeadsign ?? trip?.tripHeadsign;
    final title = [?routeName, ?headsign].join(' · ');

    final entries = details == null
        ? const <TripStopEntry>[]
        : TripStopEntry.fromTripDetails(details, s.references);
    final list = TripStopList.build(
      entries,
      userStopId: widget.trip.stopId,
      userStopSequence: widget.trip.stopSequence,
      closestStopId: s.status?.closestStopId,
      destinationStopId: widget.trip.destinationStopId,
    );

    final slivers = <Widget>[];
    if (!s.hasData) {
      slivers.add(
        ObaLoadingOrErrorSliver(error: s.error, onRetry: _controller.refresh),
      );
    } else {
      slivers.addAll([
        SliverToBoxAdapter(
          child: _TripSummary(
            state: s,
            now: now,
            routeName: routeName ?? '',
            headsign: headsign ?? '',
          ),
        ),
        if (s.isStale)
          SliverToBoxAdapter(
            child: StopStaleBanner(
              error: s.error,
              updatedAt: s.updatedAt,
              now: now,
              isRetrying: s.isRefreshing,
              onRetry: _controller.refresh,
            ),
          ),
        SliverToBoxAdapter(child: _actions(context, core, s, now)),
        ..._blockTrips(context, s),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
            child: ObaHeading(l10n.stopTripStopsHeader),
          ),
        ),
        SliverList.list(
          children: [
            for (final item in list.items(expanded: _expanded))
              switch (item) {
                TripStopItemStop(:final row) => TripStopTile(
                  row: row,
                  vehicleLabel: routeName,
                ),
                TripStopItemGroup(:final group, :final isExpanded) =>
                  _GroupTile(
                    group: group,
                    expanded: isExpanded,
                    onToggle: () => setState(() {
                      if (!_expanded.remove(group.id)) _expanded.add(group.id);
                    }),
                  ),
              },
          ],
        ),
      ]);
    }

    // Unchanged between responses (a user-data change or an expanded group
    // rebuilds the page without touching the map).
    final overlay = _overlayMemo([
      s.details,
      s.arrival,
      s.references,
      _shape,
      routeName,
      Localizations.localeOf(context),
    ], () => _overlay(context, s, list, routeName));
    return ObaMapOverlays(
      overlay: overlay,
      child: ObaSheetPage(
        title: title.isEmpty ? l10n.titleTrip : title,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.stopPageRefresh,
            onPressed: s.isRefreshing ? null : _controller.refresh,
          ),
        ],
        slivers: slivers,
      ),
    );
  }

  ObaMapOverlay _overlay(
    BuildContext context,
    TripState s,
    TripStopList list,
    String? routeName,
  ) {
    if (!s.hasData) return ObaMapOverlay.empty;
    final status = s.status;
    final position = status?.position ?? status?.lastKnownLocation;
    final stops = [
      for (final r in list.rows) ?s.references.stop(r.entry.stopId),
    ];
    final orientation = status?.orientation ?? status?.lastKnownOrientation;
    final shape = _shape;
    final line = shape != null
        ? ObaMapPolyline(points: shape)
        : stops.length > 1
        ? ObaMapPolyline(points: [for (final st in stops) st.coordinate])
        : null;
    return ObaMapOverlay(
      hideStopPins: true,
      stops: stops,
      polylines: [?line],
      // Fit the trip (not the moving vehicle, so a refresh doesn't pull
      // the camera back while the rider pans).
      fitBounds: line == null || line.points.isEmpty
          ? null
          : ObaMapLogic.boundsOf(line.points),
      markers: [
        if (position != null)
          ObaMapMarker(
            coordinate: position,
            kind: ObaMapMarkerKind.vehicle,
            // OBA orientation is degrees counter-clockwise from east.
            heading: orientation == null ? null : (90 - orientation) % 360,
            label: context.obaL10n.stopTripVehicleLabel(routeName ?? ''),
          ),
      ],
    );
  }

  Widget _actions(
    BuildContext context,
    ObaCoreApplication core,
    TripState s,
    DateTime now,
  ) {
    final l10n = context.obaL10n;
    final nav = ObaNavigator.of(context);
    final arrival = s.arrival;
    final region = core.currentRegion;
    final stop = arrival == null ? null : s.references.stop(arrival.stopId);
    final routeId =
        arrival?.routeId ?? s.references.trip(widget.trip.tripId)?.routeId;
    final hasAlarm = arrival != null && core.alarms.alarmFor(arrival) != null;
    final shareUrl = arrival == null || region == null
        ? null
        : DeepLinkRouter.tripShareUrl(
            region: region,
            arrival: arrival,
            destinationStopId: widget.trip.destinationStopId,
          );
    Widget button(IconData icon, String label, VoidCallback onPressed) =>
        FilledButton.tonalIcon(
          icon: Icon(icon),
          label: Text(label),
          onPressed: onPressed,
        );
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (arrival != null && stop != null)
            button(
              Icons.bookmark_add_outlined,
              l10n.stopRowBookmarkTrip,
              () => nav.push(BookmarkEditorRoute(stop: stop, arrival: arrival)),
            ),
          if (arrival != null &&
              (hasAlarm || core.alarms.canCreateAlarm(arrival, now)))
            button(
              hasAlarm
                  ? Icons.notifications_off_outlined
                  : Icons.notifications_outlined,
              hasAlarm ? l10n.stopRowRemoveAlarm : l10n.stopRowAddAlarm,
              () => toggleStopAlarm(context, arrival, now: now),
            ),
          if (routeId != null && (region?.supportsScheduleForRoute ?? false))
            button(
              Icons.calendar_month_outlined,
              l10n.stopRowRouteSchedule,
              () => nav.push(
                RouteScheduleRoute(routeId, stopId: widget.trip.stopId),
              ),
            ),
          if (routeId != null)
            button(
              Icons.route_outlined,
              l10n.stopTripRouteStops,
              () => nav.push(RouteStopsRoute(routeId)),
            ),
          if (shareUrl != null)
            button(
              Icons.share_outlined,
              l10n.stopRowShareTrip,
              () => stopShare(
                context,
                shareUrl,
                subject: arrival!.routeAndHeadsign(),
              ),
            ),
          button(
            Icons.report_outlined,
            l10n.stopTripReport,
            () =>
                nav.push(ReportTripProblemRoute(widget.trip, arrival: arrival)),
          ),
          if (arrival != null && core.problemReports.canReportGhostBus)
            button(
              Icons.visibility_off_outlined,
              l10n.stopTripGhostBus,
              () => nav.push(GhostBusReportRoute(arrival)),
            ),
        ],
      ),
    );
  }

  List<Widget> _blockTrips(BuildContext context, TripState s) {
    final l10n = context.obaL10n;
    final schedule = s.details?.schedule;
    if (schedule == null) return const [];
    String name(String id) {
      final t = s.references.trip(id);
      final r = t == null ? null : s.references.route(t.routeId);
      return [
        ?(r?.shortName ?? t?.routeShortName),
        ?t?.tripHeadsign,
      ].join(' · ').ifEmpty(id);
    }

    // Back/forward in time along the block, not compass directions: the
    // arrows mirror in right-to-left locales (matchTextDirection).
    Widget tile(String id, String label, IconData icon) => SliverToBoxAdapter(
      child: ObaListRow(
        leading: Icon(icon),
        title: label,
        trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
        onTap: () => ObaNavigator.of(context).push(
          TripRoute(TripRef(tripId: id, serviceDate: widget.trip.serviceDate)),
        ),
      ),
    );
    return [
      if (schedule.previousTripId case final p? when p.isNotEmpty)
        tile(p, l10n.stopTripStartsAs(name(p)), Icons.arrow_back),
      if (schedule.nextTripId case final n? when n.isNotEmpty)
        tile(n, l10n.stopTripContinuesAs(name(n)), Icons.arrow_forward),
    ];
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}

class _TripSummary extends StatelessWidget {
  const _TripSummary({
    required this.state,
    required this.now,
    required this.routeName,
    required this.headsign,
  });

  final TripState state;
  final DateTime now;
  final String routeName;
  final String headsign;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final arrival = state.arrival;
    final status = state.status;
    final muted = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    final canceled = status?.statusModifier == TripStatusModifier.canceled;
    final updated = status?.lastLocationUpdateTime ?? status?.lastUpdateTime;
    final lines = <Widget>[];
    if (arrival != null) {
      final info = DepartureStatusInfo.of(context, arrival);
      final minutes = arrival.minutesUntil(now) ?? 0;
      final stopName =
          state.references.stop(arrival.stopId)?.name ?? arrival.stopId;
      final away = arrival.numberOfStopsAway;
      final distance = arrival.distanceFromStop;
      final atStop = away == 0 && minutes <= 0;
      final time = arrival.bestDate;
      lines.addAll([
        Row(
          children: [
            ObaRouteBadge(
              label: routeName,
              color: state.references.route(arrival.routeId)?.color,
              textColor: state.references.route(arrival.routeId)?.textColor,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                obaBidiIsolate(context, headsign),
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Not a live region: the countdown and "position updated" text
        // change on every refresh, and a screen reader would announce the
        // whole card each time.
        Semantics(
          child: Wrap(
            spacing: 12,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                atStop
                    ? l10n.stopTripArrivingAtYourStop
                    : countdownText(l10n, minutes),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: info.isRealTime ? info.color : null,
                ),
                semanticsLabel: atStop
                    ? l10n.stopTripArrivingAtYourStop
                    : etaA11y(l10n, arrival, minutes),
              ),
              if (time != null) Text(obaClockTime(context, time), style: muted),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(info.icon, size: 18, color: info.color),
                  const SizedBox(width: 4),
                  // Long status text (translations, 200%) wraps.
                  Flexible(
                    child: Text(
                      info.label,
                      semanticsLabel: info.a11y,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: info.color,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(l10n.stopTripAtStop(stopName), style: muted),
        if (!atStop && away != null && away >= 0)
          Text(
            [
              l10n.stopTripStopsAway(away),
              if (distance != null && distance > 0)
                l10n.stopTripDistanceAway(
                  context.obaFormatters.distance(distance),
                ),
            ].join(' · '),
            style: theme.textTheme.bodyMedium,
          ),
      ]);
    } else if (headsign.isNotEmpty || routeName.isNotEmpty) {
      lines.add(
        Row(
          children: [
            if (routeName.isNotEmpty) ObaRouteBadge(label: routeName),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                obaBidiIsolate(context, headsign),
                style: theme.textTheme.titleMedium,
              ),
            ),
          ],
        ),
      );
    }
    final frequency = state.details?.frequency;
    if (frequency != null) {
      lines.add(
        Text(
          l10n.stopTripFrequency((frequency.headway / 60).round()),
          style: muted,
        ),
      );
    }
    if (canceled) {
      lines.add(
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            children: [
              Icon(Icons.cancel_outlined, color: ObaTheme.of(context).canceled),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.stopTripCanceled,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: ObaTheme.of(context).canceled,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    lines.add(
      Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          updated != null && (status?.predicted ?? false)
              ? l10n.stopTripPositionUpdated(
                  context.obaFormatters.timeAgo(updated, now: now),
                )
              : l10n.stopTripNoPosition,
          style: muted,
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
      child: Card.filled(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines,
          ),
        ),
      ),
    );
  }
}

/// One stop of a trip, with a timeline marker: passed stops are muted,
/// the vehicle's stop shows a bus, the rider's stop and the terminal are
/// emphasised. Tapping opens the stop.
class TripStopTile extends StatelessWidget {
  const TripStopTile({super.key, required this.row, this.vehicleLabel});

  final TripStopRow row;
  final String? vehicleLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final oba = ObaTheme.of(context);
    final scheme = theme.colorScheme;
    final emphasised = row.isUserStop || row.isTerminal || row.isBoardingStop;
    final muted = row.isPassed || row.isOutsideRide;
    final time = row.entry.scheduledArrival;
    final clock = time == null ? null : obaClockTime(context, time);
    final badges = [
      if (row.isVehicleHere) l10n.stopTripVehicleHere,
      if (row.isUserStop) l10n.stopTripYourStop,
      if (row.isBoardingStop) l10n.stopTripBoarding,
      if (row.isTerminal) l10n.stopTripTerminal,
    ];
    final sentence = [
      row.entry.name,
      ?clock,
      if (row.isPassed) l10n.stopTripPassed,
      ...badges,
    ].join(', ');
    final IconData marker = row.isVehicleHere
        ? Icons.directions_bus
        : row.isUserStop
        ? Icons.person_pin_circle
        : row.isTerminal
        ? Icons.flag
        : (row.isPassed ? Icons.circle : Icons.circle_outlined);
    final markerColor = row.isVehicleHere || row.isUserStop
        ? oba.brand
        : (muted ? scheme.onSurfaceVariant : scheme.onSurface);
    void open() => ObaNavigator.of(context).push(StopRoute(row.entry.stopId));
    // excludeSemantics drops the InkWell's tap, so the node carries it.
    return Semantics(
      label: sentence,
      button: true,
      onTap: open,
      excludeSemantics: true,
      child: InkWell(
        onTap: open,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Icon(
                  marker,
                  size: row.isVehicleHere || emphasised ? 24 : 14,
                  color: markerColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      row.entry.name,
                      style:
                          (emphasised
                                  ? theme.textTheme.titleMedium
                                  : theme.textTheme.bodyLarge)
                              ?.copyWith(
                                color: muted ? scheme.onSurfaceVariant : null,
                                fontWeight: emphasised ? FontWeight.w700 : null,
                              ),
                    ),
                    if (badges.isNotEmpty)
                      Text(
                        badges.join(' · '),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: oba.brand,
                        ),
                      ),
                  ],
                ),
              ),
              if (clock != null) ...[
                const SizedBox(width: 8),
                Text(
                  clock,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: muted ? scheme.onSurfaceVariant : null,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _GroupTile extends StatelessWidget {
  const _GroupTile({
    required this.group,
    required this.expanded,
    required this.onToggle,
  });

  final TripStopGroup group;
  final bool expanded;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final count = group.rows.length;
    final label = group.isPassed
        ? l10n.stopTripRunPassed(count)
        : l10n.stopTripRunApproaching(count);
    final first = group.firstDate;
    final last = group.lastDate;
    final range = first == null || last == null
        ? null
        : l10n.stopTripRunRange(
            obaClockTime(context, first),
            obaClockTime(context, last),
          );
    return Semantics(
      label: [label, ?range].join(', '),
      button: true,
      expanded: expanded,
      onTap: onToggle,
      excludeSemantics: true,
      child: InkWell(
        onTap: onToggle,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 48),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
            child: Row(
              children: [
                SizedBox(
                  width: 32,
                  child: Icon(
                    Icons.more_vert,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    [label, ?range].join(' · '),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Icon(expanded ? Icons.expand_less : Icons.expand_more),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
