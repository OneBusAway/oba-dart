import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as core show Route;

import 'map_logic.dart';

/// Loads the stops for the map's visible area. Owned by the map view's
/// State and disposed with it.
///
/// Call [onCameraIdle] whenever the camera settles (the view debounces it
/// by [ObaMapLogic.stopsRequestDebounce]). Stops accumulate in a cache so
/// panning back is instant; [stops] is what to draw.
class StopsLoader extends ChangeNotifier {
  StopsLoader({
    required this.client,
    this.maxMarkers = 300,
    this.maxCached = 2000,
  });

  /// Reads the current region's REST client (null before a region is
  /// chosen). Read on every request; never cached.
  final OneBusAwayClient? Function() client;
  final int maxMarkers;
  final int maxCached;

  final Map<String, Stop> _cache = {};
  final Map<String, core.Route> _routes = {};
  StopsRequest? _lastRequest;
  RegionRect? _bounds;
  int _generation = 0;

  List<Stop> _stops = const [];
  bool _zoomedOut = false;
  bool _loading = false;
  Object? _error;

  /// The stops to draw, nearest to the centre first.
  List<Stop> get stops => _stops;

  /// Routes of the loaded stops, by id: a read-only live view (no copy).
  late final Map<String, core.Route> routes = UnmodifiableMapView(_routes);

  /// True when the camera is too far out to show stops.
  bool get isZoomedOut => _zoomedOut;
  bool get isLoading => _loading;
  Object? get error => _error;

  /// The route types serving [stop], from the loaded references.
  Iterable<RouteType> routeTypesFor(Stop stop) sync* {
    for (final id in stop.routeIds) {
      final r = _routes[id];
      if (r != null) yield r.routeType;
    }
  }

  Future<void> onCameraIdle(RegionRect bounds) async {
    _bounds = bounds;
    final request = ObaMapLogic.stopsRequestFor(bounds);
    if (request == null) {
      final changed = !_zoomedOut || _stops.isNotEmpty;
      _zoomedOut = true;
      _stops = const [];
      if (changed) notifyListeners();
      return;
    }
    final wasZoomedOut = _zoomedOut;
    _zoomedOut = false;
    _refreshVisible();
    if (wasZoomedOut) notifyListeners();

    final last = _lastRequest;
    if (last != null && ObaMapLogic.requestCovers(last, bounds)) return;
    final c = client();
    if (c == null) return;

    final generation = ++_generation;
    _loading = true;
    // Ask for a little more than the viewport so small pans need no
    // request; just under the zoom threshold the larger area counts as
    // zoomed out, so fall back to the viewport itself.
    final inflated =
        ObaMapLogic.stopsRequestFor(ObaMapLogic.inflate(bounds, 0.15)) ??
        request;
    try {
      final response = await c.stops.forLocation(
        inflated.center,
        latSpan: inflated.latSpan,
        lonSpan: inflated.lonSpan,
      );
      if (generation != _generation) return;
      _lastRequest = inflated;
      for (final s in response.list) {
        _cache.remove(s.id);
        _cache[s.id] = s;
      }
      _routes.addAll(response.references.routes);
      if (_cache.length > maxCached) {
        while (_cache.length > maxCached) {
          _cache.remove(_cache.keys.first);
        }
        // Drop the routes only evicted stops used.
        final used = {for (final stop in _cache.values) ...stop.routeIds};
        _routes.removeWhere((id, _) => !used.contains(id));
      }
      _error = null;
    } catch (e) {
      if (generation != _generation) return;
      _error = e;
    } finally {
      if (generation == _generation) {
        _loading = false;
        _refreshVisible();
        notifyListeners();
      }
    }
  }

  void _refreshVisible() {
    final b = _bounds;
    if (b == null || _zoomedOut) {
      _stops = const [];
      return;
    }
    _stops = ObaMapLogic.capStops(
      _cache.values,
      center: b.center,
      max: maxMarkers,
      within: ObaMapLogic.inflate(b, 0.1),
    );
  }

  /// Forgets everything (region change).
  void reset() {
    _generation++;
    _cache.clear();
    _routes.clear();
    _lastRequest = null;
    _stops = const [];
    _loading = false;
    _error = null;
    notifyListeners();
  }

  /// Retries the last viewport, ignoring the cache.
  Future<void> reload() async {
    _lastRequest = null;
    final b = _bounds;
    if (b != null) await onCameraIdle(b);
  }
}
