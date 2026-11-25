import 'dart:math' as math;

import 'package:onebusaway/onebusaway.dart';

/// Mean Earth radius in metres (IUGG), matching `Region.distanceFrom`.
const double earthRadiusMeters = 6371008.8;

double _rad(double d) => d * math.pi / 180;

/// Great-circle (haversine) distance in metres.
double distanceBetween(Coordinate a, Coordinate b) {
  final dLat = _rad(b.lat - a.lat);
  final dLon = _rad(b.lon - a.lon);
  final h =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(_rad(a.lat)) *
          math.cos(_rad(b.lat)) *
          math.pow(math.sin(dLon / 2), 2);
  return 2 * earthRadiusMeters * math.asin(math.min(1, math.sqrt(h)));
}

/// Squared planar distance with longitude scaled by `cos(latitude)`, for
/// ordering only (iOS `Stop.squaredDistance`).
double squaredDistanceForOrdering(Coordinate point, Coordinate center) {
  final dLat = point.lat - center.lat;
  final dLon = (point.lon - center.lon) * math.cos(_rad(center.lat));
  return dLat * dLat + dLon * dLon;
}

/// The [limit] items closest to [center], nearest first (iOS
/// `Stop.nearest`). [coordinateOf] extracts each item's position.
List<T> nearest<T>(
  Iterable<T> items,
  Coordinate center, {
  required Coordinate Function(T) coordinateOf,
  int? limit,
}) {
  if (limit != null && limit <= 0) return [];
  final scored = [
    for (final item in items)
      (item, squaredDistanceForOrdering(coordinateOf(item), center)),
  ]..sort((a, b) => a.$2.compareTo(b.$2));
  final sorted = [for (final s in scored) s.$1];
  return limit == null || sorted.length <= limit
      ? sorted
      : sorted.sublist(0, limit);
}

/// [stops] sorted nearest-first from [center], optionally capped at [limit].
List<Stop> nearestStops(
  Iterable<Stop> stops,
  Coordinate center, {
  int? limit,
}) => nearest(stops, center, coordinateOf: (s) => s.coordinate, limit: limit);
