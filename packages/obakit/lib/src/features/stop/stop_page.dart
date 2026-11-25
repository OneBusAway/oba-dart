import 'dart:async';

import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as oba show Route;

import '../../app/application.dart';
import '../../app/location_holder.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import '../map/map_coordinator.dart';
import 'departure_row.dart';
import 'stop_actions.dart';
import 'stop_arrivals_controller.dart';
import 'stop_format.dart';
import 'stop_sections.dart';

/// Departures for one stop: the SDK's main screen (iOS `StopPageView`).
///
/// Embeddable: needs only an `ObaScope`. Works in the shell's sheet, the
/// side panel, as a full-screen route on a host navigator, and inline
/// (`ObaPresentation.embedded`). Polls every 30 s while visible and the app
/// is in the foreground. Declares map overlays (the stop, its routes'
/// shapes, live vehicles) when a map is present.
///
/// Pass [controller] to share one `StopArrivalsController` with other host
/// widgets; the page then never disposes it.
class StopPage extends StatefulWidget {
  const StopPage({
    super.key,
    required this.stopId,
    this.transfer,
    this.controller,
  });

  final String stopId;

  /// The trip the rider is transferring from; matching rows are
  /// highlighted.
  final ObaTransferContext? transfer;
  final StopArrivalsController? controller;

  @override
  State<StopPage> createState() => _StopPageState();
}

class _StopPageState extends State<StopPage> {
  StopArrivalsController? _owned;
  late StopArrivalsController _controller;
  ObaApplication? _app;
  final Set<String> _expandedRoutes = {};
  bool _pastExpanded = false;
  bool _showHiddenRoutes = false;
  bool _alertsExpanded = true;
  bool _recorded = false;
  bool _manualRefresh = false;
  Map<String, List<String>> _shapes = const {};
  bool _shapesRequested = false;

  @override
  void initState() {
    super.initState();
    _controller = _resolve();
    _controller.addListener(_onData);
  }

  StopArrivalsController _resolve() {
    final external = widget.controller;
    if (external != null) return external;
    return _owned = StopArrivalsController(
      stopId: widget.stopId,
      client: () => _app?.core.restClient,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _app = ObaScope.of(context);
  }

  @override
  void didUpdateWidget(StopPage old) {
    super.didUpdateWidget(old);
    if (old.stopId != widget.stopId || old.controller != widget.controller) {
      _controller.removeListener(_onData);
      _owned?.dispose();
      _owned = null;
      _controller = _resolve();
      _controller.addListener(_onData);
      _recorded = false;
      _shapes = const {};
      _shapesRequested = false;
      _expandedRoutes.clear();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onData);
    _owned?.dispose();
    super.dispose();
  }

  void _onData() {
    final s = _controller.state;
    final stop = s.stop;
    final core = _app?.core;
    if (stop != null && !_recorded && core != null) {
      _recorded = true;
      final region = core.currentRegion;
      if (region != null) {
        core.userData.addRecentStop(
          StoredStop.fromStop(stop, references: s.references),
          regionId: region.id,
        );
      }
      final here = core.currentLocation?.coordinate;
      core.analytics.reportStopViewed(
        name: stop.name,
        id: stop.id,
        stopDistance: here == null
            ? 'NA'
            // Analytics, not shown to the rider: always English.
            // l10n-exempt
            : core.formatters.distance(distanceBetween(here, stop.coordinate)),
      );
    }
    if (_manualRefresh && !s.isRefreshing) {
      _manualRefresh = false;
      if (mounted) {
        obaAnnounce(
          context,
          s.error == null
              ? context.obaL10n.stopPageRefreshed
              : context.obaL10n.stopPageStaleTitle,
        );
      }
    }
    if (stop != null && !_shapesRequested && mounted) {
      if (ObaMapCoordinator.maybeOf(context) != null) _loadShapes(stop);
    }
  }

  Future<void> _loadShapes(Stop stop) async {
    _shapesRequested = true;
    final client = _app?.core.restClient;
    if (client == null) return;
    final out = <String, List<String>>{};
    for (final id in stop.routeIds.take(8)) {
      try {
        final r = await client.stops.forRoute(id);
        out[id] = r.entry.polylines;
      } catch (_) {
        // Shapes are decoration; skip a route that fails.
      }
    }
    if (mounted) setState(() => _shapes = out);
  }

  void _refresh() {
    _manualRefresh = true;
    unawaited(_controller.refresh());
  }

  int? get _regionId => _app?.core.currentRegion?.id;

  StopPreferences _prefs(ObaCoreApplication core) {
    final r = _regionId;
    return r == null
        ? const StopPreferences()
        : core.userData.stopPreferences(r, widget.stopId);
  }

  void _setPrefs(StopPreferences p) {
    final r = _regionId;
    if (r == null) return;
    _app!.core.userData.setStopPreferences(r, widget.stopId, p);
  }

  @override
  Widget build(BuildContext context) {
    final app = ObaScope.of(context);
    final core = app.core;
    // Live location for the walk time, only while the page is visible.
    return ObaLocationHolder(
      child: ObaPollingHolder(
        controller: _controller,
        child: ListenableBuilder(
          listenable: Listenable.merge([
            _controller,
            ObaListenableAdapter(core.userData),
            ObaListenableAdapter(core.settings),
            ObaValueListenableAdapter(core.locationListenable),
          ]),
          builder: (context, _) => _build(context, core),
        ),
      ),
    );
  }

  Widget _build(BuildContext context, ObaCoreApplication core) {
    final l10n = context.obaL10n;
    final s = _controller.state;
    final stop = s.stop;
    final now = _controller.now();
    final prefs = _prefs(core);
    final walk = WalkTime.compute(
      user: core.currentLocation?.coordinate,
      stop: stop?.coordinate,
      metersPerSecond: core.settings.effectiveTravelSpeedMetersPerSecond,
    );
    final departures = StopDepartures.build(
      s.rawArrivals,
      references: s.references,
      now: now,
      preferences: prefs,
      filter: core.settings.arrivalDepartureFilter,
      showHiddenRoutes: _showHiddenRoutes,
      walkMinutes: walk?.minutes,
    );
    final alerts = s.entry == null
        ? const <Situation>[]
        : alertsForStop(stop: s.entry!, references: s.references, now: now);
    final routes = stop == null
        ? const <oba.Route>[]
        : [for (final id in stop.routeIds) ?s.references.route(id)];

    final page = ObaSheetPage(
      title: stop?.name ?? l10n.titleStop,
      // At large text sizes the header keeps only the overflow menu, so the
      // wrapping stop name leaves room for the list in a short sheet.
      actions: [
        if (!_compactHeader(context)) ...[
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.stopPageRefresh,
            onPressed: s.isRefreshing ? null : _refresh,
          ),
          _bookmarkButton(context, core, stop),
        ],
        _overflow(context, core, stop),
      ],
      slivers: [
        if (stop != null)
          SliverToBoxAdapter(
            child: StopHeader(
              stop: stop,
              routes: routes,
              references: s.references,
              walkTime: walk,
              bikeMode: core.settings.bikeModeEnabled,
              transfer: widget.transfer,
            ),
          ),
        if (s.hasData) ...[
          SliverToBoxAdapter(
            child: _controls(context, core, prefs, departures),
          ),
          if (alerts.isNotEmpty)
            SliverToBoxAdapter(
              child: StopAlertsSection(
                alerts: alerts,
                references: s.references,
                expanded: _alertsExpanded,
                onExpansionChanged: (v) => setState(() => _alertsExpanded = v),
              ),
            ),
          if (s.isStale)
            SliverToBoxAdapter(
              child: StopStaleBanner(
                error: s.error,
                updatedAt: s.updatedAt,
                now: now,
                isRetrying: s.isRefreshing,
                onRetry: _refresh,
              ),
            ),
        ],
        ..._departureSlivers(context, core, s, departures, prefs, now, walk),
      ],
    );

    return ObaMapOverlays(
      overlay: _overlay(context, s, routes, departures, now),
      child: page,
    );
  }

  // -- Map --------------------------------------------------------------------

  ObaMapOverlay _overlay(
    BuildContext context,
    StopArrivalsState s,
    List<oba.Route> routes,
    StopDepartures departures,
    DateTime now,
  ) {
    final stop = s.stop;
    if (stop == null) return ObaMapOverlay.empty;
    final oba = ObaTheme.of(context);
    final byId = {for (final r in routes) r.id: r};
    Color colorOf(String routeId) {
      final hex = byId[routeId]?.color;
      final v = hex == null ? null : int.tryParse(hex, radix: 16);
      return v == null ? oba.routeLine : Color(0xFF000000 | v);
    }

    final seenTrips = <String>{};
    final vehicles = [
      for (final a in departures.upcoming)
        if (a.tripStatus?.position case final p?)
          if (seenTrips.add(a.tripId))
            ObaMapMarker(
              coordinate: p,
              kind: ObaMapMarkerKind.vehicle,
              heading: a.tripStatus?.orientation == null
                  ? null
                  : (90 - a.tripStatus!.orientation!) % 360,
              color: colorOf(a.routeId),
              label: context.obaL10n.stopTripVehicleLabel(
                routeLabel(a, s.references),
              ),
              onTap: () =>
                  ObaNavigator.of(context)
                      .push(TripRoute(TripRef.fromArrival(a))),
            ),
    ];
    final c = stop.coordinate;
    return ObaMapOverlay(
      stops: [stop],
      // Centre the map on the stop (about a zoom-16 view around it), as
      // iOS does: a stop opened from search or a link is often elsewhere.
      fitBounds: RegionRect(
        minLat: c.lat - 0.002,
        maxLat: c.lat + 0.002,
        minLon: c.lon - 0.003,
        maxLon: c.lon + 0.003,
      ),
      polylines: [
        for (final e in _shapes.entries)
          for (final p in e.value)
            ObaMapPolyline.encoded(p, color: colorOf(e.key)),
      ],
      markers: vehicles,
    );
  }

  // -- Header actions ---------------------------------------------------------

  static bool _compactHeader(BuildContext context) =>
      MediaQuery.textScalerOf(context).scale(10) >= 15;

  Widget _bookmarkButton(
    BuildContext context,
    ObaCoreApplication core,
    Stop? stop,
  ) {
    final l10n = context.obaL10n;
    final bookmark = core.userData.findBookmarkForStop(
      widget.stopId,
      regionId: _regionId,
    );
    return IconButton(
      icon: Icon(bookmark == null ? Icons.bookmark_border : Icons.bookmark),
      tooltip: bookmark == null
          ? l10n.stopPageBookmark
          : l10n.stopPageBookmarked,
      isSelected: bookmark != null,
      onPressed: stop == null && bookmark == null
          ? null
          : () => ObaNavigator.of(context).push(
              bookmark != null
                  ? BookmarkEditorRoute(bookmark: bookmark)
                  : BookmarkEditorRoute(stop: stop),
            ),
    );
  }

  Widget _overflow(BuildContext context, ObaCoreApplication core, Stop? stop) {
    final l10n = context.obaL10n;
    final nav = ObaNavigator.of(context);
    final region = core.currentRegion;
    final shareUrl = region == null
        ? null
        : DeepLinkRouter.stopShareUrl(region: region, stopId: widget.stopId);
    final planning = core.tripPlanningStatus == FeatureStatus.running;
    final bike = core.settings.bikeModeEnabled;
    final bookmark = core.userData.findBookmarkForStop(
      widget.stopId,
      regionId: _regionId,
    );
    PopupMenuItem<VoidCallback> item(
      IconData icon,
      String label,
      VoidCallback action,
    ) => PopupMenuItem<VoidCallback>(
      value: action,
      child: Row(
        children: [
          ExcludeSemantics(child: Icon(icon)),
          const SizedBox(width: 12),
          Flexible(child: Text(label)),
        ],
      ),
    );
    Place? place() => stop == null
        ? null
        : Place(name: stop.name, coordinate: stop.coordinate, id: stop.id);
    return PopupMenuButton<VoidCallback>(
      icon: const Icon(Icons.more_vert),
      tooltip: l10n.stopPageMoreActions,
      onSelected: (action) => action(),
      itemBuilder: (_) => [
        if (_compactHeader(context)) ...[
          item(Icons.refresh, l10n.stopPageRefresh, _refresh),
          if (bookmark != null || stop != null)
            item(
              bookmark == null ? Icons.bookmark_border : Icons.bookmark,
              bookmark == null
                  ? l10n.stopPageBookmark
                  : l10n.stopPageBookmarked,
              () => nav.push(
                bookmark != null
                    ? BookmarkEditorRoute(bookmark: bookmark)
                    : BookmarkEditorRoute(stop: stop),
              ),
            ),
        ],
        item(
          Icons.calendar_month_outlined,
          l10n.stopPageSchedules,
          () => nav.push(StopScheduleRoute(widget.stopId)),
        ),
        item(
          Icons.warning_amber_outlined,
          l10n.stopPageServiceAlerts,
          () => nav.push(AlertsListRoute(stopId: widget.stopId)),
        ),
        if (stop != null) ...[
          item(
            Icons.near_me_outlined,
            l10n.stopPageNearbyStops,
            () => nav.push(NearbyStopsRoute(coordinate: stop.coordinate)),
          ),
          item(
            bike ? Icons.directions_bike : Icons.directions_walk,
            bike ? l10n.stopPageBikeDirections : l10n.stopPageWalkingDirections,
            () => openStopDirections(context, stop.coordinate),
          ),
          if (planning) ...[
            item(
              Icons.trip_origin,
              l10n.stopPagePlanTripFrom,
              () => nav.push(TripPlannerRoute(origin: place())),
            ),
            item(
              Icons.place_outlined,
              l10n.stopPagePlanTripTo,
              () => nav.push(TripPlannerRoute(destination: place())),
            ),
          ],
        ],
        if (shareUrl != null)
          item(
            Icons.share_outlined,
            l10n.stopPageShareStop,
            () => stopShare(context, shareUrl, subject: stop?.name),
          ),
        item(
          Icons.report_outlined,
          l10n.stopPageReportProblem,
          () => nav.push(ReportStopProblemRoute(widget.stopId)),
        ),
      ],
    );
  }

  // -- Controls ---------------------------------------------------------------

  Widget _controls(
    BuildContext context,
    ObaCoreApplication core,
    StopPreferences prefs,
    StopDepartures departures,
  ) {
    final l10n = context.obaL10n;
    final filter = core.settings.arrivalDepartureFilter;
    String filterLabel(ArrivalDepartureFilter f) => switch (f) {
      ArrivalDepartureFilter.all => l10n.stopPageFilterAll,
      ArrivalDepartureFilter.estimatedOnly => l10n.stopPageFilterRealtime,
      ArrivalDepartureFilter.scheduledOnly => l10n.stopPageFilterScheduled,
    };
    final hidden = prefs.hiddenRoutes.length;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            container: true,
            header: true,
            child: Text(
              l10n.stopPageDeparturesHeader,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          const SizedBox(height: 8),
          SegmentedButton<StopSort>(
            segments: [
              ButtonSegment(
                value: StopSort.time,
                icon: const Icon(Icons.schedule),
                label: Text(l10n.stopPageModeTime),
              ),
              ButtonSegment(
                value: StopSort.route,
                icon: const Icon(Icons.format_list_bulleted),
                label: Text(l10n.stopPageModeRoute),
              ),
            ],
            selected: {prefs.sortType},
            showSelectedIcon: false,
            onSelectionChanged: (v) {
              setState(_expandedRoutes.clear);
              _setPrefs(prefs.copyWith(sortType: v.first));
            },
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 0,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              PopupMenuButton<ArrivalDepartureFilter>(
                tooltip: l10n.stopPageDepartureTypes,
                initialValue: filter,
                onSelected: (f) => core.settings.arrivalDepartureFilter = f,
                itemBuilder: (_) => [
                  for (final f in ArrivalDepartureFilter.values)
                    CheckedPopupMenuItem(
                      value: f,
                      checked: f == filter,
                      child: Text(filterLabel(f)),
                    ),
                ],
                child: _ChipLike(
                  icon: Icons.filter_list,
                  label: filterLabel(filter),
                  semanticLabel:
                      '${l10n.stopPageDepartureTypes}, ${filterLabel(filter)}',
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.tune),
                label: Text(
                  hidden == 0
                      ? l10n.stopPageFilterRoutes
                      : '${l10n.stopPageFilterRoutes} · '
                            '${l10n.stopPageRoutesHidden(hidden)}',
                ),
                onPressed: () => _openFilterSheet(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openFilterSheet(BuildContext context) async {
    final s = _controller.state;
    final stop = s.stop;
    if (stop == null) return;
    final routes = [for (final id in stop.routeIds) ?s.references.route(id)]
      ..sort(
        (a, b) => naturalCompare(
          a.shortName ?? a.longName ?? a.id,
          b.shortName ?? b.longName ?? b.id,
        ),
      );
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => ObaScope.rewrap(
        context,
        StopFilterSheet(
          routes: routes,
          preferences: () => _prefs(_app!.core),
          onChanged: (p) {
            _setPrefs(p);
            setState(() => _showHiddenRoutes = false);
          },
        ),
      ),
    );
  }

  // -- Departures -------------------------------------------------------------

  List<Widget> _departureSlivers(
    BuildContext context,
    ObaCoreApplication core,
    StopArrivalsState s,
    StopDepartures d,
    StopPreferences prefs,
    DateTime now,
    WalkTime? walk,
  ) {
    final l10n = context.obaL10n;
    Widget fill(Widget child) =>
        SliverFillRemaining(hasScrollBody: false, child: child);
    if (s.stopIsMissing) {
      return [
        fill(
          ObaEmptyState(
            icon: Icons.wrong_location_outlined,
            title: l10n.stopPageMissingTitle,
            message: l10n.stopPageMissingBody,
          ),
        ),
      ];
    }
    if (!s.hasData) {
      return [
        fill(
          s.status == StopArrivalsStatus.error
              ? ObaErrorState(error: s.error, onRetry: _refresh)
              : const ObaLoadingState(),
        ),
      ];
    }
    final footer = SliverToBoxAdapter(
      child: StopFooter(
        minutesAfter: _controller.minutesAfter,
        exhausted: _controller.isLoadMoreExhausted,
        isLoading: s.isRefreshing,
        updatedAt: s.updatedAt,
        now: now,
        onLoadMore: () => unawaited(_controller.loadMore()),
      ),
    );
    if (d.isEmpty) {
      final Widget empty;
      if (d.isEmptyBecauseOfHiddenRoutes) {
        empty = ObaEmptyState(
          icon: Icons.visibility_off_outlined,
          title: l10n.stopPageEmptyTitle,
          message: l10n.stopPageEmptyHiddenRoutes,
          action: FilledButton.tonal(
            onPressed: () => setState(() => _showHiddenRoutes = true),
            child: Text(l10n.stopPageShowAllRoutes),
          ),
        );
      } else if (d.isEmptyBecauseOfFilter) {
        empty = ObaEmptyState(
          icon: Icons.filter_list_off,
          title: l10n.stopPageEmptyTitle,
          message: l10n.stopPageEmptyFilter,
          action: FilledButton.tonal(
            onPressed: () => core.settings.arrivalDepartureFilter =
                ArrivalDepartureFilter.all,
            child: Text(l10n.stopPageShowAllTypes),
          ),
        );
      } else {
        empty = ObaEmptyState(
          icon: Icons.event_busy_outlined,
          title: l10n.stopPageEmptyTitle,
          message: l10n.stopPageEmptyBody(_controller.minutesAfter),
        );
      }
      return [
        SliverToBoxAdapter(child: Semantics(liveRegion: true, child: empty)),
        footer,
      ];
    }

    final transferTrip = widget.transfer?.fromTripId;
    bool isTransfer(ArrivalAndDeparture a) =>
        transferTrip != null && a.tripId == transferTrip;

    Widget row(ArrivalAndDeparture a, ObaDepartureRowStyle style) =>
        ObaDepartureRow(
          key: ValueKey('${a.visitId}-${style.name}'),
          arrival: a,
          now: now,
          references: s.references,
          style: style,
          isTransfer: isTransfer(a),
          hasAlarm: core.alarms.alarmFor(a) != null,
          onTap: () =>
              ObaNavigator.of(context).push(TripRoute(TripRef.fromArrival(a))),
          actions: departureActions(context, a, now: now, stop: s.stop),
        );

    final children = <Widget>[];
    if (prefs.sortType == StopSort.time) {
      if (d.past.isNotEmpty) {
        children.add(
          _ExpandToggle(
            expanded: _pastExpanded,
            label: _pastExpanded
                ? l10n.stopPageHideEarlier
                : l10n.stopPageEarlier(d.past.length),
            onPressed: () => setState(() => _pastExpanded = !_pastExpanded),
          ),
        );
        if (_pastExpanded) {
          children.addAll(d.past.map((a) => row(a, ObaDepartureRowStyle.past)));
          children.add(const Divider(height: 1));
        }
      }
      for (var i = 0; i < d.upcoming.length; i++) {
        if (i == d.walkDividerIndex && walk != null) {
          children.add(
            WalkTimeDivider(
              minutes: walk.minutes,
              bike: core.settings.bikeModeEnabled,
              onTap: s.stop == null
                  ? null
                  : () => openStopDirections(context, s.stop!.coordinate),
            ),
          );
        }
        final missed = d.walkDividerIndex != null && i < d.walkDividerIndex!;
        children.add(
          row(
            d.upcoming[i],
            missed ? ObaDepartureRowStyle.missed : ObaDepartureRowStyle.normal,
          ),
        );
      }
      if (d.walkDividerIndex == d.upcoming.length && walk != null) {
        children.add(
          WalkTimeDivider(
            minutes: walk.minutes,
            bike: core.settings.bikeModeEnabled,
            onTap: s.stop == null
                ? null
                : () => openStopDirections(context, s.stop!.coordinate),
          ),
        );
      }
    } else {
      for (final g in d.groups) {
        final open = _expandedRoutes.contains(g.routeId);
        children.add(
          RouteGroupHeader(
            group: g,
            now: now,
            expanded: open,
            onToggle: () => setState(() {
              if (!_expandedRoutes.remove(g.routeId)) {
                _expandedRoutes.add(g.routeId);
              }
            }),
          ),
        );
        if (open) {
          for (final a in g.arrivals) {
            final past = (a.minutesUntil(now) ?? 0) < 0;
            children.add(
              row(
                a,
                past ? ObaDepartureRowStyle.past : ObaDepartureRowStyle.normal,
              ),
            );
          }
        }
        children.add(const Divider(height: 1));
      }
    }
    return [SliverList.list(children: children), footer];
  }
}

class _ExpandToggle extends StatelessWidget {
  const _ExpandToggle({
    required this.expanded,
    required this.label,
    required this.onPressed,
  });

  final bool expanded;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
    child: Semantics(
      expanded: expanded,
      child: TextButton.icon(
        style: TextButton.styleFrom(
          alignment: AlignmentDirectional.centerStart,
        ),
        icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
        label: Text(label),
        onPressed: onPressed,
      ),
    ),
  );
}

class _ChipLike extends StatelessWidget {
  const _ChipLike({
    required this.icon,
    required this.label,
    required this.semanticLabel,
  });

  final IconData icon;
  final String label;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: semanticLabel,
      button: true,
      excludeSemantics: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 48),
        child: Padding(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: theme.colorScheme.primary),
            ],
          ),
        ),
      ),
    );
  }
}
