import 'dart:math' as math;

import 'package:onebusaway/onebusaway.dart';

double _rad(double d) => d * math.pi / 180;

/// Great-circle (haversine) distance in metres ([Coordinate.distanceTo]).
double distanceBetween(Coordinate a, Coordinate b) => a.distanceTo(b);

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
