import 'dart:async';

import 'package:flutter/material.dart';
import 'package:oba_arrivals/oba_arrivals.dart' show parseHexColor;
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as oba show Route;

import '../../widgets/text_scale.dart';
import '../../widgets/heading.dart';
import '../../app/polling.dart';
import '../../app/application.dart';
import '../../app/location_holder.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/memo.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import '../map/map_coordinator.dart';
import 'departure_row.dart';
import 'stop_actions.dart';
import 'stop_arrivals_controller.dart';
import '../../widgets/departure_format.dart';
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

  /// Each route's shapes, decoded once when they arrive.
  Map<String, List<List<Coordinate>>> _shapes = const {};
  bool _shapesRequested = false;
  int _shapesGeneration = 0;

  /// The walk to the stop. A location fix updates only this (and the
  /// header that shows it); the page itself rebuilds only when the walk's
  /// whole minutes change ([_walkMinutes]).
  final ValueNotifier<WalkTime?> _walk = ValueNotifier(null);
  final ValueNotifier<int?> _walkMinutes = ValueNotifier(null);
  ObaCoreApplication? _listening;

  /// What the page rebuilds for; created once per controller/application.
  Listenable? _listenable;

  final StopDeparturesMemo _departures = StopDeparturesMemo();
  final ObaMemo<ObaMapOverlay> _overlayMemo = ObaMemo();

  @override
  void initState() {
    super.initState();
    _controller = _resolve();
    _controller.addListener(_onData);
  }

  void _listenTo(ObaCoreApplication? core) {
    if (identical(core, _listening)) return;
    _listening?.locationListenable.removeListener(_updateWalk);
    _listening?.settings.removeListener(_updateWalk);
    _listening = core;
    core?.locationListenable.addListener(_updateWalk);
    core?.settings.addListener(_updateWalk);
    _listenable = null;
    _updateWalk();
  }

  void _updateWalk() {
    final core = _listening;
    if (core == null) return;
    final walk = WalkTime.compute(
      user: core.currentLocation?.coordinate,
      stop: _controller.state.stop?.coordinate,
      metersPerSecond: core.settings.effectiveTravelSpeedMetersPerSecond,
    );
    _walk.value = walk;
    _walkMinutes.value = walk?.minutes;
  }

  Listenable _pageListenable(ObaCoreApplication core) =>
      _listenable ??= Listenable.merge([
        _controller,
        ObaListenableAdapter(core.userData),
        ObaListenableAdapter(core.settings),
        _walkMinutes,
      ]);

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
    _listenTo(_app!.core);
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
      _listenable = null;
      _recorded = false;
      _shapes = const {};
      _shapesRequested = false;
      _shapesGeneration++;
      _expandedRoutes.clear();
      _updateWalk();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onData);
    _owned?.dispose();
    _listenTo(null);
    _walk.dispose();
    _walkMinutes.dispose();
    super.dispose();
  }

  void _onData() {
    final s = _controller.state;
    final stop = s.stop;
    final core = _app?.core;
    _updateWalk();
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
            : const ObaFormatters().distance(
                distanceBetween(here, stop.coordinate),
              ),
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

  /// How many routes' shapes are drawn, and how many are fetched at once.
  static const _maxShapeRoutes = 8;
  static const _shapeConcurrency = 3;

  Future<void> _loadShapes(Stop stop) async {
    _shapesRequested = true;
    final core = _app?.core;
    final client = core?.restClient;
    if (core == null || client == null) return;
    final generation = ++_shapesGeneration;
    bool current() => mounted && generation == _shapesGeneration;
    final ids = stop.routeIds.take(_maxShapeRoutes).toList();
    final decoded = <String, List<List<Coordinate>>>{};
    var next = 0;
    Future<void> worker() async {
      while (current() && next < ids.length) {
        final id = ids[next++];
        try {
          // Shared, cached per region: other pages ask for the same routes.
          final r = await core.stopsForRoute.get(client, id);
          decoded[id] = [for (final p in r.entry.polylines) Polyline.decode(p)];
        } catch (_) {
          // Shapes are decoration; skip a route that fails.
        }
      }
    }

    await Future.wait([for (var i = 0; i < _shapeConcurrency; i++) worker()]);
    if (!current()) return;
    setState(() => _shapes = {for (final id in ids) id: ?decoded[id]});
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
    _listenTo(core);
    return ObaLocationHolder(
      child: ObaPollingHolder(
        controller: _controller,
        child: ListenableBuilder(
          listenable: _pageListenable(core),
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
    final walkMinutes = _walkMinutes.value;
    final departures = _departures.build(
      s.rawArrivals,
      references: s.references,
      now: now,
      preferences: prefs,
      filter: core.settings.arrivalDepartureFilter,
      showHiddenRoutes: _showHiddenRoutes,
      walkMinutes: walkMinutes,
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
            child: ValueListenableBuilder<WalkTime?>(
              valueListenable: _walk,
              builder: (context, walk, _) => StopHeader(
                stop: stop,
                routes: routes,
                references: s.references,
                walkTime: walk,
                bikeMode: core.settings.bikeModeEnabled,
                transfer: widget.transfer,
              ),
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
        ..._departureSlivers(
          context,
          core,
          s,
          departures,
          prefs,
          now,
          walkMinutes,
        ),
      ],
    );

    // The same overlay instance while nothing it draws changed, so the map
    // is not updated on every rebuild. Vehicles still refresh with each
    // response (new departures).
    final overlay = _overlayMemo([
      s.stop,
      s.references,
      departures,
      _shapes,
      ObaTheme.of(context).routeLine,
      Localizations.localeOf(context),
    ], () => _overlay(context, s, routes, departures));
    return ObaMapOverlays(overlay: overlay, child: page);
  }

  // -- Map --------------------------------------------------------------------

  ObaMapOverlay _overlay(
    BuildContext context,
    StopArrivalsState s,
    List<oba.Route> routes,
    StopDepartures departures,
  ) {
    final stop = s.stop;
    if (stop == null) return ObaMapOverlay.empty;
    final oba = ObaTheme.of(context);
    final byId = {for (final r in routes) r.id: r};
    Color colorOf(String routeId) =>
        parseHexColor(byId[routeId]?.color) ?? oba.routeLine;

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
                routeLabel(a, s.references.route(a.routeId)),
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
          for (final points in e.value)
            ObaMapPolyline(points: points, color: colorOf(e.key)),
      ],
      markers: vehicles,
    );
  }

  // -- Header actions ---------------------------------------------------------

  static bool _compactHeader(BuildContext context) => obaIsLargeText(context);

  /// The bookmark action, for the header button and the overflow menu:
  /// edit the stop's bookmark, or add one (null [onPressed] while neither
  /// is possible).
  ({IconData icon, String label, bool bookmarked, VoidCallback? onPressed})
  _bookmarkAction(BuildContext context, ObaCoreApplication core, Stop? stop) {
    final l10n = context.obaL10n;
    final bookmark = core.userData.findBookmarkForStop(
      widget.stopId,
      regionId: _regionId,
    );
    final nav = ObaNavigator.of(context);
    return (
      icon: bookmark == null ? Icons.bookmark_border : Icons.bookmark,
      label: bookmark == null ? l10n.stopPageBookmark : l10n.stopPageBookmarked,
      bookmarked: bookmark != null,
      onPressed: bookmark != null
          ? () => nav.push(BookmarkEditorRoute(bookmark: bookmark))
          : stop != null
          ? () => nav.push(BookmarkEditorRoute(stop: stop))
          : null,
    );
  }

  Widget _bookmarkButton(
    BuildContext context,
    ObaCoreApplication core,
    Stop? stop,
  ) {
    final action = _bookmarkAction(context, core, stop);
    return IconButton(
      icon: Icon(action.icon),
      tooltip: action.label,
      isSelected: action.bookmarked,
      onPressed: action.onPressed,
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
    final bookmark = _bookmarkAction(context, core, stop);
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
          if (bookmark.onPressed case final onPressed?)
            item(bookmark.icon, bookmark.label, onPressed),
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
          ObaHeading(l10n.stopPageDeparturesHeader),
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
    int? walkMinutes,
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

    // One pass over the stored alarms for every row.
    final alarms = core.alarms.lookup();
    // Rows are built lazily (only those on screen), and so are their
    // actions (see ObaDepartureRow.actionsBuilder).
    Widget Function() row(ArrivalAndDeparture a, ObaDepartureRowStyle style) =>
        () {
          final hasAlarm = alarms.alarmFor(a) != null;
          return ObaDepartureRow(
            key: ValueKey('${a.visitId}-${style.name}'),
            arrival: a,
            now: now,
            references: s.references,
            style: style,
            isTransfer: isTransfer(a),
            hasAlarm: hasAlarm,
            onTap: () =>
                ObaNavigator.of(context)
                    .push(TripRoute(TripRef.fromArrival(a))),
            actionsBuilder: () => departureActions(
              context,
              a,
              now: now,
              stop: s.stop,
              hasAlarm: hasAlarm,
            ),
          );
        };
    Widget Function() fixed(Widget w) =>
        () => w;

    final children = <Widget Function()>[];
    if (prefs.sortType == StopSort.time) {
      if (d.past.isNotEmpty) {
        children.add(
          fixed(
            _ExpandToggle(
              expanded: _pastExpanded,
              label: _pastExpanded
                  ? l10n.stopPageHideEarlier
                  : l10n.stopPageEarlier(d.past.length),
              onPressed: () => setState(() => _pastExpanded = !_pastExpanded),
            ),
          ),
        );
        if (_pastExpanded) {
          children.addAll(d.past.map((a) => row(a, ObaDepartureRowStyle.past)));
          children.add(fixed(const Divider(height: 1)));
        }
      }
      // The divider may also go after the last row (every row missed).
      for (var i = 0; i <= d.upcoming.length; i++) {
        if (i == d.walkDividerIndex && walkMinutes != null) {
          children.add(
            fixed(
              WalkTimeDivider(
                minutes: walkMinutes,
                bike: core.settings.bikeModeEnabled,
                onTap: s.stop == null
                    ? null
                    : () => openStopDirections(context, s.stop!.coordinate),
              ),
            ),
          );
        }
        if (i == d.upcoming.length) break;
        final missed = d.walkDividerIndex != null && i < d.walkDividerIndex!;
        children.add(
          row(
            d.upcoming[i],
            missed ? ObaDepartureRowStyle.missed : ObaDepartureRowStyle.normal,
          ),
        );
      }
    } else {
      for (final g in d.groups) {
        final open = _expandedRoutes.contains(g.routeId);
        children.add(
          fixed(
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
        children.add(fixed(const Divider(height: 1)));
      }
    }
    return [
      SliverList.builder(
        itemCount: children.length,
        itemBuilder: (context, i) => children[i](),
      ),
      footer,
    ];
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
