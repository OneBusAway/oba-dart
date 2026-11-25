import 'dart:collection';

import 'package:onebusaway/onebusaway.dart';

/// A small least-recently-used cache of `stops-for-route` responses (a
/// route's stops and shapes), which are static for a region and requested
/// by several screens (the stop page's map shapes, route stops, alerts).
///
/// Entries belong to one [OneBusAwayClient]: asking with a different client
/// (the region changed) clears the cache first. Concurrent requests for the
/// same route share one HTTP request. A failed request is not cached, so
/// the next call retries.
///
/// `ObaCoreApplication.stopsForRoute` owns one per application and clears
/// it when the region's clients are rebuilt.
class StopsForRouteCache {
  StopsForRouteCache({this.capacity = 24}) : assert(capacity > 0);

  /// The most routes kept; the least recently used is dropped first.
  final int capacity;

  final LinkedHashMap<String, Future<ObaEntryResponse<StopsForRoute>>>
  _entries = LinkedHashMap();
  OneBusAwayClient? _client;

  /// How many routes are cached (including requests still in flight).
  int get length => _entries.length;

  /// The route's stops and shapes, from the cache or [client].
  Future<ObaEntryResponse<StopsForRoute>> get(
    OneBusAwayClient client,
    String routeId,
  ) {
    if (!identical(client, _client)) {
      _entries.clear();
      _client = client;
    }
    final hit = _entries.remove(routeId);
    if (hit != null) {
      // Re-insert: most recently used last.
      _entries[routeId] = hit;
      return hit;
    }
    late final Future<ObaEntryResponse<StopsForRoute>> request;
    request = client.stops
        .forRoute(routeId)
        .then(
          (r) => r,
          onError: (Object e, StackTrace st) {
            if (identical(_entries[routeId], request)) _entries.remove(routeId);
            Error.throwWithStackTrace(e, st);
          },
        );
    _entries[routeId] = request;
    while (_entries.length > capacity) {
      _entries.remove(_entries.keys.first);
    }
    return request;
  }

  /// Drops every entry (in-flight requests still complete for their
  /// callers, but are not kept).
  void clear() {
    _entries.clear();
    _client = null;
  }
}
