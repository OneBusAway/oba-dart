import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as core show Route;

import '../../app/application.dart';
import '../../app/location_holder.dart';
import '../../app/scope.dart';
import '../../features/map/map_coordinator.dart';
import '../../features/map/map_logic.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/feed_card.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'search_common.dart';

/// Where nearby stops are found around.
enum NearbyCenterSource {
  /// A coordinate the caller passed (a place's nearby stops).
  explicit,

  /// The rider's location.
  user,

  /// The map's centre, when the rider's location is unknown.
  map,
}

/// The point nearby stops are found around: [explicit], else the rider's
/// location, else the map centre. Null when none is known.
(Coordinate, NearbyCenterSource)? resolveNearbyCenter({
  Coordinate? explicit,
  ObaLocation? location,
  Coordinate? mapCenter,
}) {
  if (explicit != null) return (explicit, NearbyCenterSource.explicit);
  if (location != null) return (location.coordinate, NearbyCenterSource.user);
  if (mapCenter != null) return (mapCenter, NearbyCenterSource.map);
  return null;
}

// -- Controller -----------------------------------------------------------------

/// Loads the stops nearest a point and the next departures of the closest
/// few (iOS `HomeNearbyDeparturesSectionModel`).
///
/// Polite to the server: one stops request per [refetchDistance] of
/// movement, arrivals for at most [stopLimit] stops, fetched one after
/// another, each again only once older than
/// [NearbyDepartures.staleAfter], and only while [visible].
class NearbyDeparturesController extends ChangeNotifier {
  NearbyDeparturesController({
    required this.client,
    this.stopLimit = NearbyDepartures.stopLimit,
    this.radiusMeters = 800,
    this.refetchDistance = 150,
    this.excludedKeys,
  });

  /// The current region's REST client, read on every request.
  final OneBusAwayClient? Function() client;
  final int stopLimit;
  final double radiusMeters;
  final double refetchDistance;

  /// Departures shown elsewhere (trip bookmarks), read at each rebuild.
  final Set<TripBookmarkKey> Function()? excludedKeys;

  Coordinate? _center;
  Coordinate? _fetchedCenter;
  List<Stop> _stops = const [];
  final Map<String, core.Route> _routes = {};
  final Map<String, (List<ArrivalAndDeparture>, DateTime)> _loaded = {};
  final Set<String> _inFlight = {};
  bool _loadingStops = false;
  bool _stopsLoaded = false;
  Object? _error;
  Duration _serverOffset = Duration.zero;
  bool _visible = false;
  bool _disposed = false;
  int _generation = 0;
  Future<void>? _arrivalsTask;

  Coordinate? get center => _center;

  /// The nearest stops (at most [stopLimit]), nearest first.
  List<Stop> get stops => _stops;
  Map<String, core.Route> get routes => _routes;
  bool get isLoadingStops => _loadingStops;

  /// Whether a stops request has finished for the current centre.
  bool get hasLoadedStops => _stopsLoaded;

  /// The last stops error, until a request succeeds.
  Object? get error => _error;

  bool hasArrivalsFor(String stopId) => _loaded.containsKey(stopId);

  /// The current time, corrected by the server's clock.
  DateTime now() => clock.now().add(_serverOffset);

  bool get visible => _visible;
  set visible(bool value) {
    if (value == _visible) return;
    _visible = value;
    if (value) unawaited(loadIfNeeded());
  }

  /// The section's rows now.
  List<NearbyRow> rows({int limit = NearbyDepartures.rowLimit}) =>
      NearbyDepartures.rows(
        stops: _stops,
        arrivals: {for (final e in _loaded.entries) e.key: e.value.$1},
        now: now(),
        excluding: excludedKeys?.call() ?? const {},
        limit: limit,
      );

  /// Moves the search point. Stops are fetched again only when it moved
  /// more than [refetchDistance].
  void setCenter(Coordinate? value) {
    _center = value;
    if (value == null) return;
    final last = _fetchedCenter;
    if (last != null && distanceBetween(last, value) < refetchDistance) {
      return;
    }
    unawaited(_loadStops(value));
  }

  /// Uses stops someone else already loaded (the map's visible stops)
  /// around [center], instead of requesting them (iOS
  /// `HomeNearbyStopsSectionModel`, which re-slices the map's stops).
  void useStops(
    Coordinate center,
    Iterable<Stop> stops,
    Map<String, core.Route> routes,
  ) {
    _center = center;
    _fetchedCenter = null;
    _generation++;
    final nearest = nearestStops(stops, center, limit: stopLimit);
    final same =
        _stopsLoaded &&
        nearest.length == _stops.length &&
        Iterable.generate(nearest.length)
            .every((i) => nearest[i].id == _stops[i].id);
    if (same) return;
    _routes.addAll(routes);
    _stops = nearest;
    _stopsLoaded = true;
    _loadingStops = false;
    _error = null;
    notifyListeners();
    unawaited(loadIfNeeded());
  }

  /// Reloads the stops and every stop's departures.
  Future<void> refresh() async {
    final c = _center;
    if (c == null) return;
    _loaded.clear();
    await _loadStops(c);
  }

  Future<void> _loadStops(Coordinate c) async {
    final api = client();
    if (api == null) return;
    final generation = ++_generation;
    _fetchedCenter = c;
    _loadingStops = true;
    notifyListeners();
    try {
      final response = await api.stops.forLocation(c, radius: radiusMeters);
      if (_disposed || generation != _generation) return;
      _routes.addAll(response.references.routes);
      _stops = nearestStops(response.list, c, limit: stopLimit);
      final ids = {for (final s in _stops) s.id};
      final t = clock.now();
      _loaded.removeWhere(
        (id, v) =>
            !ids.contains(id) &&
            t.difference(v.$2) > NearbyDepartures.staleAfter,
      );
      _error = null;
      _stopsLoaded = true;
    } catch (e) {
      if (_disposed || generation != _generation) return;
      _error = e;
      _fetchedCenter = null;
      _stopsLoaded = true;
    } finally {
      if (!_disposed && generation == _generation) {
        _loadingStops = false;
        notifyListeners();
      }
    }
    if (!_disposed && generation == _generation) await loadIfNeeded();
  }

  /// Fetches departures, one stop at a time, for the stops with none or
  /// stale ones. Does nothing while hidden.
  Future<void> loadIfNeeded() {
    if (!_visible || _disposed) return Future.value();
    return _arrivalsTask ??= _loadArrivals().whenComplete(
      () => _arrivalsTask = null,
    );
  }

  Future<void> _loadArrivals() async {
    while (!_disposed && _visible) {
      final t = clock.now();
      final due = _stops
          .map((s) => s.id)
          .where(
            (id) =>
                !_inFlight.contains(id) &&
                (_loaded[id] == null ||
                    t.difference(_loaded[id]!.$2) >=
                        NearbyDepartures.staleAfter),
          )
          .firstOrNull;
      if (due == null) return;
      final api = client();
      if (api == null) return;
      _inFlight.add(due);
      try {
        final response = await api.arrivalsAndDepartures.forStop(
          due,
          minutesBefore: 0,
          minutesAfter: NearbyDepartures.minutesAfter,
        );
        if (_disposed) return;
        _serverOffset = response.currentTime.difference(clock.now());
        _routes.addAll(response.references.routes);
        _loaded[due] = (
          cleanArrivals(response.entry.arrivalsAndDepartures),
          clock.now(),
        );
        notifyListeners();
      } catch (_) {
        // The stop keeps what it had (or stays a plain stop row) and is due
        // again on the next activation. Stop this round to avoid a retry
        // storm.
        _inFlight.remove(due);
        return;
      } finally {
        _inFlight.remove(due);
      }
    }
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}

// -- Visibility -------------------------------------------------------------------

/// Tracks whether the widget is visible (not covered by a pushed route, not
/// in an off-screen tab) and the app is in the foreground.
mixin _VisibilityTracking<T extends StatefulWidget> on State<T>
    implements WidgetsBindingObserver {
  bool _appActive = true;
  bool _tickerEnabled = true;

  bool get isShown => _appActive && _tickerEnabled;

  void onVisibilityChanged();

  void initVisibility() {
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _appActive = lifecycle == null || _isActive(lifecycle);
    WidgetsBinding.instance.addObserver(this);
  }

  void disposeVisibility() => WidgetsBinding.instance.removeObserver(this);

  void updateTickerVisibility() {
    // A hidden IndexedStack child (a host's tab) keeps its tickers but
    // reports itself through Visibility.of.
    final enabled =
        TickerMode.valuesOf(context).enabled && Visibility.of(context);
    if (enabled == _tickerEnabled) return;
    _tickerEnabled = enabled;
    onVisibilityChanged();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final active = _isActive(state);
    if (active == _appActive) return;
    _appActive = active;
    onVisibilityChanged();
  }

  static bool _isActive(AppLifecycleState s) =>
      s == AppLifecycleState.resumed || s == AppLifecycleState.inactive;
}

// -- Home section and card -----------------------------------------------------------

/// Departures from the stops nearest the rider (or the map centre when the
/// rider's location is unknown), with a "See all" link to the full list
/// (iOS home sheet Nearby section).
///
/// A plain, non-scrolling `Column`: it works in the Home tab and in a host
/// feed. It fetches only while visible and refreshes every 30 seconds.
/// It holds live location ([ObaLocationHolder]) only while visible, and
/// not at all when [around] is set.
///
/// ```dart
/// NearbyStopsSection(around: const Coordinate(32.8801, -117.2340)) // near campus
/// ```
class NearbyStopsSection extends StatefulWidget {
  const NearbyStopsSection({
    super.key,
    this.around,
    this.maxStops = NearbyDepartures.stopLimit,
    this.maxRows = NearbyDepartures.rowLimit,
    this.title,
    this.showSeeAll = true,
    this.excludeBookmarkedTrips = false,
    this.refreshInterval = const Duration(seconds: 30),
  });

  /// How many of the nearest stops have their departures fetched.
  final int maxStops;

  /// Rows shown.
  final int maxRows;

  /// Defaults to "Nearby".
  final String? title;

  /// Show the "See all" link to [NearbyStopsRoute].
  final bool showSeeAll;

  /// Leave out departures the rider has bookmarked (the home sheet shows
  /// them in its Bookmarks section above).
  final bool excludeBookmarkedTrips;
  final Duration refreshInterval;

  /// Finds stops around this point instead of the rider's location. The
  /// location provider isn't used at all: no permission message, no
  /// location subscription. "See all" opens the list around it too.
  final Coordinate? around;

  @override
  State<NearbyStopsSection> createState() => _NearbyStopsSectionState();
}

class _NearbyStopsSectionState extends State<NearbyStopsSection>
    with WidgetsBindingObserver, _VisibilityTracking {
  ObaApplication? _app;
  NearbyDeparturesController? _controller;
  ObaMapCoordinator? _map;
  Listenable? _location;
  Listenable? _core;
  NearbyCenterSource? _source;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    initVisibility();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final app = ObaScope.of(context);
    if (!identical(app, _app)) {
      _detach();
      _app = app;
      _controller = NearbyDeparturesController(
        client: () => app.core.restClient,
        stopLimit: widget.maxStops,
        excludedKeys: widget.excludeBookmarkedTrips
            ? () => {for (final b in app.core.userData.bookmarks) ?b.tripKey}
            : null,
      )..addListener(_onChanged);
      _location = ObaListenableAdapter(app.core.locationListenable)
        ..addListener(_updateCenter);
      _core = ObaListenableAdapter(app.core)..addListener(_onCoreChanged);
    }
    final map = ObaMapCoordinator.maybeOf(context);
    if (!identical(map, _map)) {
      _map?.removeListener(_updateCenter);
      _map = map;
      _map?.addListener(_updateCenter);
    }
    updateTickerVisibility();
    _updateCenter();
    _syncVisible();
  }

  @override
  void didUpdateWidget(NearbyStopsSection old) {
    super.didUpdateWidget(old);
    if (old.around != widget.around) _updateCenter();
  }

  void _onCoreChanged() {
    _updateCenter();
    if (mounted) setState(() {});
  }

  void _detach() {
    _location?.removeListener(_updateCenter);
    _core?.removeListener(_onCoreChanged);
    _controller?.removeListener(_onChanged);
    _controller?.dispose();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _map?.removeListener(_updateCenter);
    _detach();
    disposeVisibility();
    super.dispose();
  }

  @override
  void onVisibilityChanged() => _syncVisible();

  void _syncVisible() {
    final c = _controller;
    if (c == null) return;
    c.visible = isShown;
    if (isShown) {
      _timer ??= Timer.periodic(widget.refreshInterval, (_) {
        _controller?.loadIfNeeded();
        if (mounted) setState(() {});
      });
    } else {
      _timer?.cancel();
      _timer = null;
    }
  }

  void _onChanged() {
    if (mounted) setState(() {});
  }

  void _updateCenter() {
    final app = _app;
    if (app == null) return;
    final around = widget.around;
    if (around != null) {
      if (_source != NearbyCenterSource.explicit && mounted) {
        setState(() => _source = NearbyCenterSource.explicit);
      }
      _controller?.setCenter(around);
      return;
    }
    final map = _map;
    // Without the rider's location, the map's centre stands in, but only
    // once the map shows stops (zoomed in): those are re-used, so this
    // costs no stops request.
    final mapCenter = map != null && map.visibleStops.isNotEmpty
        ? map.center
        : null;
    final resolved = resolveNearbyCenter(
      location: app.core.currentLocation,
      mapCenter: mapCenter,
    );
    final source = resolved?.$2;
    if (source != _source && mounted) setState(() => _source = source);
    if (source == NearbyCenterSource.map) {
      _controller?.useStops(resolved!.$1, map!.visibleStops, map.routes);
    } else {
      _controller?.setCenter(resolved?.$1);
    }
  }

  Future<void> _requestLocation() async {
    await _app?.core.requestLocationPermission();
    _updateCenter();
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final title = widget.title ?? l10n.homeSectionNearby;
    return ObaLocationHolder(
      enabled: widget.around == null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ObaSectionHeader(
            title: title,
            actionLabel: widget.showSeeAll ? l10n.commonSeeAll : null,
            onAction: widget.showSeeAll
                ? () =>
                      ObaNavigator.of(context)
                          .push(NearbyStopsRoute(coordinate: widget.around))
                : null,
          ),
          ..._body(context),
        ],
      ),
    );
  }

  List<Widget> _body(BuildContext context) {
    final l10n = context.obaL10n;
    final app = _app!;
    final c = _controller!;
    if (c.center == null) {
      return [
        _LocationPrompt(
          permission: app.core.locationPermission,
          available: app.core.isLocationAvailable,
          onRequest: _requestLocation,
        ),
      ];
    }
    if (c.stops.isEmpty) {
      if (!c.hasLoadedStops || c.isLoadingStops) {
        return [const ObaLoadingState()];
      }
      if (c.error != null) {
        return [
          _InlineMessage(
            text: ObaErrorState.messageFor(context, c.error),
            actionLabel: l10n.commonRetry,
            onAction: c.refresh,
          ),
        ];
      }
      return [_InlineMessage(text: l10n.searchNearbyEmpty)];
    }
    final here = c.center!;
    final now = c.now();
    return [
      if (_source == NearbyCenterSource.map)
        _InlineMessage(text: l10n.searchNearbyMapCenter),
      for (final row in c.rows(limit: widget.maxRows))
        KeyedSubtree(
          key: ValueKey(row.id),
          child: switch (row) {
            NearbyDepartureRow(:final stop, :final arrival) =>
              NearbyDepartureTile(
                stop: stop,
                arrival: arrival,
                route: c.routes[arrival.routeId],
                now: now,
                distanceMeters: distanceBetween(here, stop.coordinate),
              ),
            NearbyStopOnlyRow(:final stop) => ObaStopRow(
              stop: stop,
              routes: [for (final id in stop.routeIds) ?c.routes[id]],
              extraDetails: c.hasArrivalsFor(stop.id)
                  ? l10n.searchNearbyNoDepartures
                  : l10n.searchNearbyLoadingDepartures,
            ),
          },
        ),
    ];
  }
}

/// [NearbyStopsSection] in a `Card`, titled "Departures near you", for a
/// host's home feed. Same container as `ObaBookmarksCard`: the host's
/// `CardTheme` styles it, and its title is a heading.
///
/// ```dart
/// ObaScope(application: app, child: const ObaNearbyStopsCard())
/// ```
class ObaNearbyStopsCard extends StatelessWidget {
  const ObaNearbyStopsCard({
    super.key,
    this.around,
    this.maxStops = NearbyDepartures.stopLimit,
    this.maxRows = NearbyDepartures.rowLimit,
    this.title,
    this.showSeeAll = true,
    this.margin,
  });

  /// See [NearbyStopsSection.around].
  final Coordinate? around;
  final int maxStops;
  final int maxRows;
  final String? title;
  final bool showSeeAll;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) => ObaFeedCard(
    margin: margin,
    child: NearbyStopsSection(
      around: around,
      maxStops: maxStops,
      maxRows: maxRows,
      title: title ?? context.obaL10n.searchNearbyCardTitle,
      showSeeAll: showSeeAll,
    ),
  );
}

/// One nearby departure: route badge, headsign, the stop it leaves from and
/// the walk, and the countdown with its real-time status. Read as one
/// sentence; tapping opens the stop.
class NearbyDepartureTile extends StatelessWidget {
  const NearbyDepartureTile({
    super.key,
    required this.stop,
    required this.arrival,
    required this.now,
    this.route,
    this.distanceMeters,
  });

  final Stop stop;
  final ArrivalAndDeparture arrival;
  final core.Route? route;
  final DateTime now;
  final double? distanceMeters;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final display = DepartureDisplay.of(context, arrival, now);
    final routeName =
        arrival.routeShortName ??
        route?.shortName ??
        route?.longName ??
        arrival.routeId;
    final headsign = arrival.tripHeadsign ?? route?.longName ?? '';
    final distance = distanceMeters == null
        ? null
        : formatDistance(context, distanceMeters!);
    final subtitle = [
      l10n.searchNearbyStopFrom(stop.name),
      ?distance,
    ].join(' · ');
    final sentence = l10n.searchNearbyDepartureLabel(
      routeName,
      headsign,
      display.etaSpoken,
      display.status,
      [stop.name, ?distance].join(', '),
    );
    void open() => ObaNavigator.of(context).push(StopRoute(stop.id));

    final badge = ObaRouteBadge(
      label: routeName,
      color: route?.color,
      textColor: route?.textColor,
    );
    final countdown = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (display.isRealTime)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 4),
                child: Icon(
                  Icons.rss_feed,
                  size: 16,
                  color: display.statusColor,
                ),
              ),
            Text(
              display.eta,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Text(
          display.status,
          style: theme.textTheme.labelMedium?.copyWith(
            color: display.statusColor,
          ),
        ),
      ],
    );
    final texts = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          headsign.isEmpty ? routeName : headsign,
          style: theme.textTheme.titleSmall,
        ),
        Text(
          subtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
    // At large text sizes the countdown moves under the text instead of
    // squeezing it.
    final large = MediaQuery.textScalerOf(context).scale(16) > 24;
    final content = large
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              badge,
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    texts,
                    const SizedBox(height: 4),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: countdown,
                    ),
                  ],
                ),
              ),
            ],
          )
        : Row(
            children: [
              badge,
              const SizedBox(width: 12),
              Expanded(child: texts),
              const SizedBox(width: 8),
              countdown,
            ],
          );
    return MergeSemantics(
      child: Semantics(
        label: sentence,
        button: true,
        excludeSemantics: true,
        onTap: open,
        child: InkWell(
          onTap: open,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationPrompt extends StatelessWidget {
  const _LocationPrompt({
    required this.permission,
    required this.available,
    required this.onRequest,
  });

  final LocationPermissionStatus permission;

  /// False when the host gives the SDK no location.
  final bool available;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    if (!available) {
      return _InlineMessage(text: l10n.searchNearbyLocationUnavailable);
    }
    return switch (permission) {
      // No spinner: the first fix may never come (indoors, emulator).
      LocationPermissionStatus.whileInUse || LocationPermissionStatus.always =>
        _InlineMessage(text: l10n.searchNearbyLocating),
      LocationPermissionStatus.deniedForever => _InlineMessage(
        text: l10n.searchNearbyLocationDenied,
      ),
      LocationPermissionStatus.serviceDisabled => _InlineMessage(
        text: l10n.searchNearbyLocationServicesOff,
      ),
      LocationPermissionStatus.denied => _InlineMessage(
        text: l10n.searchNearbyLocationDenied,
        actionLabel: l10n.searchNearbyLocationButton,
        onAction: onRequest,
      ),
      LocationPermissionStatus.notDetermined => _InlineMessage(
        text: l10n.searchNearbyLocationPrompt,
        actionLabel: l10n.searchNearbyLocationButton,
        onAction: onRequest,
      ),
    };
  }
}

class _InlineMessage extends StatelessWidget {
  const _InlineMessage({required this.text, this.actionLabel, this.onAction});

  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 8),
            FilledButton.tonal(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}

// -- Full list ------------------------------------------------------------------------

/// Every stop near [coordinate] (or the rider, then the map centre), grouped
/// by direction of travel, nearest first, with distance and routes (iOS
/// `NearbyStopsViewController`). Pull to refresh, or use the refresh
/// button.
///
/// Embeddable: needs only an `ObaScope`; draws the stops on the map when
/// there is one. With [coordinate] set (the page's `around:`), the
/// location provider isn't used at all; otherwise it holds live location
/// while visible.
class NearbyStopsPage extends StatefulWidget {
  const NearbyStopsPage({super.key, this.coordinate, this.radiusMeters = 800});

  final Coordinate? coordinate;
  final double radiusMeters;

  @override
  State<NearbyStopsPage> createState() => _NearbyStopsPageState();
}

class _NearbyStopsPageState extends State<NearbyStopsPage> {
  ObaApplication? _app;
  ObaMapCoordinator? _map;
  Coordinate? _center;
  NearbyCenterSource? _source;
  List<Stop>? _stops;
  Map<String, core.Route> _routes = const {};
  Object? _error;
  bool _loading = false;
  int _generation = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final app = ObaScope.of(context);
    _map = ObaMapCoordinator.maybeOf(context);
    if (!identical(app, _app)) {
      _app?.core.removeListener(_onLocation);
      _app?.core.locationListenable.removeListener(_onLocation);
      _app = app;
      app.core.addListener(_onLocation);
      app.core.locationListenable.addListener(_onLocation);
      _resolve();
    }
  }

  @override
  void didUpdateWidget(NearbyStopsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coordinate != widget.coordinate) {
      _center = null;
      _resolve();
    }
  }

  @override
  void dispose() {
    _app?.core.removeListener(_onLocation);
    _app?.core.locationListenable.removeListener(_onLocation);
    super.dispose();
  }

  void _onLocation() {
    if (_center == null) _resolve();
    if (mounted) setState(() {});
  }

  void _resolve() {
    final resolved = resolveNearbyCenter(
      explicit: widget.coordinate,
      location: _app!.core.currentLocation,
      mapCenter: _map?.center,
    );
    if (resolved == null) return;
    _center = resolved.$1;
    _source = resolved.$2;
    _load();
  }

  Future<void> _load({bool announce = false}) async {
    final center = _center;
    final api = _app?.core.restClient;
    if (center == null) return;
    final l10n = context.obaL10n;
    final generation = ++_generation;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (api == null) {
        throw const SearchUnavailableException(
          SearchType.stopNumber,
          'No region selected',
        );
      }
      final response = await api.stops.forLocation(
        center,
        radius: widget.radiusMeters,
      );
      if (!mounted || generation != _generation) return;
      setState(() {
        _stops = response.list;
        _routes = response.references.routes;
      });
      if (announce) {
        obaAnnounce(context, l10n.searchNearbyStopsCount(response.list.length));
      }
    } catch (e) {
      if (!mounted || generation != _generation) return;
      setState(() => _error = e);
    } finally {
      if (mounted && generation == _generation) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _requestLocation() async {
    await _app?.core.requestLocationPermission();
    if (!mounted) return;
    _resolve();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final stops = _stops;
    final center = _center;
    final groups = stops == null || center == null
        ? const <NearbyStopGroup>[]
        : groupNearbyStopsByDirection(stops, center);

    final List<Widget> slivers;
    if (center == null) {
      slivers = [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _locationState(context),
        ),
      ];
    } else if (stops == null) {
      slivers = [
        SliverFillRemaining(
          hasScrollBody: false,
          child: _error != null && !_loading
              ? ObaErrorState(
                  message: searchErrorText(context, _error!),
                  onRetry: _load,
                )
              : const ObaLoadingState(),
        ),
      ];
    } else if (stops.isEmpty) {
      slivers = [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ObaEmptyState(
            icon: Icons.wrong_location_outlined,
            title: l10n.searchNearbyEmpty,
            message: l10n.searchNearbyEmptyBody,
          ),
        ),
      ];
    } else {
      slivers = [
        if (_source == NearbyCenterSource.map)
          SliverToBoxAdapter(
            child: _InlineMessage(text: l10n.searchNearbyMapCenter),
          ),
        if (_error != null)
          SliverToBoxAdapter(
            child: _InlineMessage(
              text: ObaErrorState.messageFor(context, _error),
            ),
          ),
        for (final g in groups) ...[
          SliverToBoxAdapter(
            child: ObaSectionHeader(
              title: switch (stopDirectionLabel(l10n, g.direction)) {
                final d? => l10n.searchNearbyDirectionHeader(d),
                null => l10n.searchNearbyOtherDirection,
              },
            ),
          ),
          SliverList.list(
            children: [
              for (final s in g.stops)
                ObaStopRow(
                  stop: s.stop,
                  routes: [for (final id in s.stop.routeIds) ?_routes[id]],
                  extraDetails: l10n.searchNearbyDistance(
                    formatDistance(context, s.distanceMeters),
                  ),
                ),
            ],
          ),
        ],
      ];
    }

    final page = ObaSheetPage(
      title: l10n.titleNearbyStops,
      actions: [
        if (center != null)
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: l10n.searchNearbyRefresh,
            onPressed: _loading ? null : () => _load(announce: true),
          ),
      ],
      body: RefreshIndicator(
        onRefresh: () => _load(announce: true),
        child: CustomScrollView(
          primary: true,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            ...slivers,
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.paddingOf(context).bottom + 16,
              ),
            ),
          ],
        ),
      ),
    );
    return ObaLocationHolder(
      enabled: widget.coordinate == null,
      child: _overlays(context, page, stops, center),
    );
  }

  Widget _overlays(
    BuildContext context,
    Widget page,
    List<Stop>? stops,
    Coordinate? center,
  ) {
    final l10n = context.obaL10n;
    return ObaMapOverlays(
      overlay: stops == null || stops.isEmpty
          ? ObaMapOverlay.empty
          : ObaMapOverlay(
              stops: stops,
              markers: [
                if (_source == NearbyCenterSource.explicit && center != null)
                  ObaMapMarker(
                    coordinate: center,
                    label: l10n.titlePlace,
                    kind: ObaMapMarkerKind.place,
                  ),
              ],
              fitBounds: ObaMapLogic.boundsOf([
                for (final s in stops) s.coordinate,
                ?center,
              ]),
            ),
      child: page,
    );
  }

  Widget _locationState(BuildContext context) {
    final l10n = context.obaL10n;
    final permission = _app!.core.locationPermission;
    if (!_app!.core.isLocationAvailable) {
      return ObaEmptyState(
        icon: Icons.location_off_outlined,
        title: l10n.searchNearbyLocationUnavailable,
      );
    }
    return switch (permission) {
      LocationPermissionStatus.whileInUse ||
      LocationPermissionStatus.always => ObaEmptyState(
        icon: Icons.my_location,
        title: l10n.searchNearbyLocating,
      ),
      LocationPermissionStatus.serviceDisabled => ObaEmptyState(
        icon: Icons.location_disabled,
        title: l10n.searchNearbyLocationServicesOff,
      ),
      LocationPermissionStatus.deniedForever => ObaEmptyState(
        icon: Icons.location_disabled,
        title: l10n.searchNearbyLocationDenied,
      ),
      LocationPermissionStatus.denied ||
      LocationPermissionStatus.notDetermined => ObaEmptyState(
        icon: Icons.my_location,
        title: l10n.searchNearbyLocationPrompt,
        action: FilledButton(
          onPressed: _requestLocation,
          child: Text(l10n.searchNearbyLocationButton),
        ),
      ),
    };
  }
}
