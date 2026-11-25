import 'package:onebusaway/onebusaway.dart';

/// A geocoded place (address, point of interest).
class Place {
  const Place({
    required this.name,
    required this.coordinate,
    this.subtitle,
    this.id,
  });

  final String name;
  final String? subtitle;
  final Coordinate coordinate;

  /// Provider-specific identifier, if any.
  final String? id;

  @override
  bool operator ==(Object other) =>
      other is Place &&
      other.name == name &&
      other.subtitle == subtitle &&
      other.coordinate == coordinate &&
      other.id == id;

  @override
  int get hashCode => Object.hash(name, subtitle, coordinate, id);

  @override
  String toString() => 'Place($name, $coordinate)';
}

/// Address search, supplied by the host (the obakit package ships a
/// Nominatim-backed default).
abstract interface class PlaceSearchProvider {
  Future<List<Place>> search(
    String query, {
    Coordinate? near,
    RegionRect? within,
  });
}
