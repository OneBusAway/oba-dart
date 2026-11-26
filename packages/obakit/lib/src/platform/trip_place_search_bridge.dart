import 'package:obakit_core/obakit_core.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

/// Lets the trip planner search places through the app's
/// [PlaceSearchProvider] (Nominatim by default), biased to the other trip
/// endpoint and limited to the current region's service area.
class PlaceSearchTripBridge implements tp.TripPlaceSearch {
  PlaceSearchTripBridge(this.provider, {this.region});

  final PlaceSearchProvider provider;

  /// Returns the region whose service rect bounds the search, if any.
  final RegionRect? Function()? region;

  @override
  Future<List<tp.TripPlace>> search(String query, {tp.TripPlace? near}) async {
    final places = await provider.search(
      query,
      near: near == null ? null : Coordinate(near.lat, near.lon),
      within: region?.call(),
    );
    return [for (final p in places) toTripPlace(p)];
  }

  static tp.TripPlace toTripPlace(Place p) => tp.TripPlace(
    name: p.name,
    subtitle: p.subtitle,
    lat: p.coordinate.lat,
    lon: p.coordinate.lon,
  );
}
