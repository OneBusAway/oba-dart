import '../core/responses.dart';
import '../core/transport.dart';
import '../models/coordinate.dart';
import '../models/stop.dart';
import '../models/stops_for_route.dart';

/// `stops-for-location`, `stop/{id}` and `stops-for-route/{id}`.
class StopsResource {
  StopsResource(this._transport);

  final Transport _transport;

  /// Stops near [center].
  ///
  /// - With [latSpan]/[lonSpan] (degrees), searches that box.
  /// - With [radius] (meters), searches that circle; the radius is clamped
  ///   to 1…15000 and sent as a whole number, as the iOS app does.
  /// - [query] matches stop codes / numbers.
  ///
  /// Check `outOfRange` on the response: it is true when [center] lies
  /// outside the server's coverage.
  Future<ObaListResponse<Stop>> forLocation(
    Coordinate center, {
    double? latSpan,
    double? lonSpan,
    double? radius,
    String? query,
  }) async {
    final envelope = await _transport.get(
      'stops-for-location',
      params: {
        'lat': '${center.lat}',
        'lon': '${center.lon}',
        if (latSpan != null) 'latSpan': '$latSpan',
        if (lonSpan != null) 'lonSpan': '$lonSpan',
        if (radius != null) 'radius': '${radius.clamp(1, 15000).toInt()}',
        'query': ?query,
      },
    );
    return envelope.toList(Stop.fromJson);
  }

  /// A single stop.
  Future<ObaEntryResponse<Stop>> byId(String stopId) async =>
      (await _transport.get('stop', id: stopId)).toEntry(Stop.fromJson);

  /// Every stop on a route, grouped by direction, with the route's shapes.
  Future<ObaEntryResponse<StopsForRoute>> forRoute(String routeId) async =>
      (await _transport.get(
        'stops-for-route',
        id: routeId,
      )).toEntry(StopsForRoute.fromJson);
}
