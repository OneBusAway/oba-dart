import 'dart:math' as math;

import '../core/responses.dart';
import '../core/transport.dart';
import '../models/coordinate.dart';
import '../models/route.dart';

/// `routes-for-location`.
class RoutesResource {
  RoutesResource(this._transport);

  final Transport _transport;

  /// Routes near [center] whose names match [query].
  ///
  /// The radius sent is at least 40 km, as in the iOS app, so that a search
  /// finds every route sharing a name across the region
  /// (onebusaway-iphone#601).
  Future<ObaListResponse<Route>> forLocation(
    Coordinate center, {
    required String query,
    double radius = 0,
  }) async {
    final envelope = await _transport.get(
      'routes-for-location',
      params: {
        'lat': '${center.lat}',
        'lon': '${center.lon}',
        'query': query,
        'radius': '${math.max(radius, _minRadius)}',
      },
    );
    return envelope.toList(Route.fromJson);
  }

  static const double _minRadius = 40000;
}
