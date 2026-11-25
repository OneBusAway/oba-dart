import 'package:flutter/foundation.dart';

import 'api/request.dart';

/// A named point the rider can travel from or to.
@immutable
class TripPlace {
  const TripPlace({
    required this.name,
    required this.lat,
    required this.lon,
    this.subtitle,
    this.isCurrentLocation = false,
  });

  /// The rider-facing name ("Geisel Library", "Current Location").
  final String name;

  /// Secondary text such as an address. Shown under [name] in search
  /// results.
  final String? subtitle;
  final double lat;
  final double lon;

  /// Marks the device location, so the UI can label it with
  /// `TripPlannerStrings.currentLocation` and an icon.
  final bool isCurrentLocation;

  OtpCoordinate get coordinate => OtpCoordinate(lat, lon);

  @override
  bool operator ==(Object other) =>
      other is TripPlace &&
      other.name == name &&
      other.subtitle == subtitle &&
      other.lat == lat &&
      other.lon == lon &&
      other.isCurrentLocation == isCurrentLocation;

  @override
  int get hashCode => Object.hash(name, subtitle, lat, lon, isCurrentLocation);

  @override
  String toString() => 'TripPlace($name, $lat, $lon)';
}

/// Place lookup supplied by the host app (a geocoder, OBA stop search, a
/// list of campus buildings...). The trip planner calls it as the rider
/// types in the origin or destination field.
abstract interface class TripPlaceSearch {
  /// Places matching [query], best first. [near] is the other endpoint or
  /// the current location when known, to bias results. Throwing shows a
  /// search error; return an empty list for "no matches".
  Future<List<TripPlace>> search(String query, {TripPlace? near});
}

/// Returns the device location, or null when unavailable or denied.
typedef CurrentLocationProvider = Future<TripPlace?> Function();
