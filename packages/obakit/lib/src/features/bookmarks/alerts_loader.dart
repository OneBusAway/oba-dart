import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/polling.dart';
import '../../widgets/loader.dart';
import '../../app/application.dart';

/// Loads the service alerts (REST `Situation`s) for a screen.
///
/// The REST API has no "all alerts" call, and the GTFS-realtime alerts feed
/// iOS uses for its region-wide list is not ported. So the alerts come from
/// the arrivals responses, which carry the situations that affect a stop:
///
/// - [stopId]: that stop's arrivals (the stop's and its arrivals' alerts);
/// - [routeId]: arrivals at up to three stops spread along the route, keeping
///   the alerts that name the route;
/// - neither (region-wide): arrivals at up to [maxRegionStops] stops the rider
///   cares about (bookmarked, then recent, then nearest to them), at most
///   three requests at a time.
class AlertsLoader extends ChangeNotifier with ObaDisposeSafeNotifier {
  AlertsLoader(this.app, {this.stopId, this.routeId, this.maxRegionStops = 8}) {
    app.core.clientsListenable.addListener(_onClientsChanged);
  }

  final ObaApplication app;
  final String? stopId;
  final String? routeId;
  final int maxRegionStops;

  List<Situation> _alerts = const [];
  Object? _error;
  bool _loading = true;
  int _generation = 0;
  DateTime? _loadedAt;
  bool _requested = false;

  /// Active alerts, most severe then newest first.
  List<Situation> get alerts => _alerts;
  Object? get error => _error;
  bool get isLoading => _loading;
  DateTime? get loadedAt => _loadedAt;
  bool get isRegionWide => stopId == null && routeId == null;

  /// Fetches the alerts again.
  Future<void> load() async {
    _requested = true;
    final generation = ++_generation;
    _loading = _alerts.isEmpty;
    _error = null;
    notifyListeners();
    try {
      final client = app.core.restClient;
      if (client == null) throw const ObaNoRegionException();
      final found = <Situation>[];
      final stops = await _stopsToAsk(client);
      var failures = 0;
      for (var i = 0; i < stops.length; i += 3) {
        final chunk = stops.skip(i).take(3);
        final results = await Future.wait(
          chunk.map((id) async {
            try {
              return await client.arrivalsAndDepartures.forStop(
                id,
                minutesBefore: 0,
                minutesAfter: 60,
              );
            } on Object {
              failures++;
              return null;
            }
          }),
        );
        for (final r in results) {
          if (r == null) continue;
          found.addAll(_situationsOf(r.entry, r.references));
        }
      }
      if (stops.isNotEmpty && failures == stops.length) {
        throw StateError('Every request failed');
      }
      if (generation != _generation) return;
      _alerts = alertsInScope(
        found,
        routeId: stopId == null ? routeId : null,
        now: clock.now(),
      );
      _loadedAt = clock.now();
    } on Object catch (e) {
      if (generation != _generation) return;
      _error = e;
    }
    _loading = false;
    notifyListeners();
  }

  /// The region (and so the server) changed: the alerts are the old
  /// region's. Drop them, and ask the new one if anyone asked before.
  void _onClientsChanged() {
    if (isDisposed) return;
    _generation++;
    _alerts = const [];
    _error = null;
    _loadedAt = null;
    if (_requested) {
      unawaited(load());
    } else {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    app.core.clientsListenable.removeListener(_onClientsChanged);
    super.dispose();
  }

  Iterable<Situation> _situationsOf(
    StopWithArrivalsAndDepartures entry,
    References references,
  ) {
    if (stopId != null) {
      return references.situationsWithIds([
        ...entry.situationIds,
        for (final a in entry.arrivalsAndDepartures) ...a.situationIds,
      ]);
    }
    return references.situations.values;
  }

  Future<List<String>> _stopsToAsk(OneBusAwayClient client) async {
    if (stopId != null) return [stopId!];
    final routeId = this.routeId;
    if (routeId != null) {
      // Shared, cached per region with the stop and route stops pages.
      final response = await app.core.stopsForRoute.get(client, routeId);
      final ids = response.entry.stopIds;
      if (ids.length <= 3) return ids;
      return [ids.first, ids[ids.length ~/ 2], ids.last];
    }
    final core = app.core;
    final regionId = core.currentRegion?.id;
    final ids = <String>{
      for (final b in core.userData.bookmarksInRegion(regionId)) b.stopId,
      for (final s in core.userData.recentStopsInRegion(regionId)) s.id,
    };
    final here = core.currentLocation?.coordinate;
    if (here != null && ids.length < maxRegionStops) {
      try {
        final near = await client.stops.forLocation(here, radius: 1500);
        for (final s in nearestStops(near.list, here, limit: 3)) {
          ids.add(s.id);
        }
      } on Object {
        // Nearby stops are a bonus.
      }
    }
    return ids.take(maxRegionStops).toList();
  }
}
