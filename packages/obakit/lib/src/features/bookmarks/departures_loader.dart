import 'dart:async';
import 'dart:collection';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/polling.dart';
import '../../widgets/loader.dart';
import '../../app/application.dart';

/// What a [StopDeparturesLoader] knows about one stop.
@immutable
class BookmarkStopDepartures {
  const BookmarkStopDepartures({
    this.arrivals = const [],
    this.references,
    this.error,
    this.fetchedAt,
    this.hasData = false,
  });

  /// Cleaned arrivals (implausible dates and duplicate vehicle reports
  /// dropped), soonest first.
  final List<ArrivalAndDeparture> arrivals;
  final References? references;

  /// The latest failure. When [hasData] is true the arrivals are from an
  /// earlier fetch and are shown as possibly stale.
  final Object? error;
  final DateTime? fetchedAt;
  final bool hasData;

  /// Nothing fetched yet and nothing has failed.
  bool get isLoading => !hasData && error == null;

  /// The fetch failed and there is nothing earlier to show.
  bool get hasError => !hasData && error != null;

  /// A refresh failed, but earlier arrivals are shown.
  bool get isStale => hasData && error != null;
}

/// Fetches arrivals for a set of stops politely, for bookmark cards.
///
/// - one request per stop however many bookmarks use it;
/// - at most [maxConcurrent] requests in flight;
/// - interval refresh every [refreshInterval], only while [setActive] says
///   the owner is visible (and the app is in the foreground);
/// - a stop's earlier arrivals stay when a refresh fails.
///
/// Owned by a `State`, which calls [dispose]. It reads the REST client on
/// every fetch and starts over when the region (client) changes.
class StopDeparturesLoader extends ChangeNotifier with ObaDisposeSafeNotifier {
  StopDeparturesLoader(
    this.app, {
    this.maxConcurrent = 3,
    this.refreshInterval = const Duration(seconds: 30),
    this.minutesBefore = 0,
    this.minutesAfter = 90,
  }) {
    app.core.clientsListenable.addListener(_onClientsChanged);
  }

  final ObaApplication app;
  final int maxConcurrent;
  final Duration refreshInterval;
  final int minutesBefore;
  final int minutesAfter;

  final Map<String, BookmarkStopDepartures> _states = {};
  final Set<String> _wanted = {};
  final Queue<String> _queue = Queue();
  final Set<String> _inFlight = {};
  Timer? _timer;
  bool _active = false;
  int _generation = 0;
  Duration _serverOffset = Duration.zero;
  DateTime? _lastRefresh;
  Completer<void>? _idle;

  /// The state of [stopId]; loading when it is wanted but not fetched yet.
  BookmarkStopDepartures stateFor(String stopId) =>
      _states[stopId] ?? const BookmarkStopDepartures();

  /// The server-corrected time, for ETA maths.
  DateTime now() => clock.now().add(_serverOffset);

  /// Declares which stops are wanted. Stops no longer wanted are dropped;
  /// new ones are fetched (immediately when [fetchNew]).
  void setStops(Iterable<String> stopIds, {bool fetchNew = true}) {
    final next = stopIds.toSet();
    if (setEquals(next, _wanted)) return;
    final added = next.difference(_wanted);
    _wanted
      ..clear()
      ..addAll(next);
    _states.removeWhere((id, _) => !next.contains(id));
    _queue.removeWhere((id) => !next.contains(id));
    if (fetchNew) {
      for (final id in added) {
        _enqueue(id);
      }
      _pump();
    }
    notifyListeners();
  }

  /// Whether the owner is on screen. Interval refresh runs only while true;
  /// becoming active refreshes stale data at once.
  void setActive(bool active) {
    if (_active == active || isDisposed) return;
    _active = active;
    _timer?.cancel();
    _timer = null;
    if (!active) return;
    final last = _lastRefresh;
    if (_wanted.isNotEmpty &&
        (last == null || clock.now().difference(last) >= refreshInterval)) {
      unawaited(refresh());
    } else {
      // Stops added while hidden were not fetched then (`fetchNew: false`):
      // without this they would show as loading until the next interval.
      for (final id in _wanted) {
        if (!_states.containsKey(id)) _enqueue(id);
      }
      _pump();
    }
    _timer = Timer.periodic(refreshInterval, (_) => unawaited(refresh()));
  }

  /// Fetches every wanted stop again. Completes when the queue has drained.
  Future<void> refresh() {
    if (isDisposed) return Future.value();
    _lastRefresh = clock.now();
    for (final id in _wanted) {
      _enqueue(id);
    }
    _pump();
    if (_queue.isEmpty && _inFlight.isEmpty) return Future.value();
    return (_idle ??= Completer<void>()).future;
  }

  void _enqueue(String id) {
    if (_inFlight.contains(id) || _queue.contains(id)) return;
    _queue.add(id);
  }

  void _pump() {
    while (_inFlight.length < maxConcurrent && _queue.isNotEmpty) {
      final id = _queue.removeFirst();
      _inFlight.add(id);
      unawaited(_fetch(id, _generation));
    }
    if (_queue.isEmpty && _inFlight.isEmpty) {
      _idle?.complete();
      _idle = null;
    }
  }

  Future<void> _fetch(String stopId, int generation) async {
    BookmarkStopDepartures result;
    try {
      final client = app.core.restClient;
      if (client == null) throw const ObaNoRegionException();
      final response = await client.arrivalsAndDepartures.forStop(
        stopId,
        minutesBefore: minutesBefore,
        minutesAfter: minutesAfter,
      );
      if (generation == _generation) {
        _serverOffset = response.currentTime.difference(clock.now());
      }
      result = BookmarkStopDepartures(
        arrivals: sortByTime(
          cleanArrivals(response.entry.arrivalsAndDepartures),
        ),
        references: response.references,
        fetchedAt: clock.now(),
        hasData: true,
      );
    } on Object catch (e) {
      final earlier = _states[stopId];
      result = BookmarkStopDepartures(
        arrivals: earlier?.arrivals ?? const [],
        references: earlier?.references,
        fetchedAt: earlier?.fetchedAt,
        hasData: earlier?.hasData ?? false,
        error: e,
      );
    }
    // A request from before a region change is no longer tracked: the same
    // stop may be in flight again for the new region, and that entry is not
    // this request's to remove.
    if (isDisposed || generation != _generation) return;
    _inFlight.remove(stopId);
    if (_wanted.contains(stopId)) {
      _states[stopId] = result;
      notifyListeners();
    }
    _pump();
  }

  void _onClientsChanged() {
    // A new region means new ids: forget everything and refetch.
    _generation++;
    _states.clear();
    _queue.clear();
    _inFlight.clear();
    for (final id in _wanted) {
      _enqueue(id);
    }
    _pump();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    app.core.clientsListenable.removeListener(_onClientsChanged);
    _idle?.complete();
    _idle = null;
    super.dispose();
  }
}
