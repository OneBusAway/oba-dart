import 'package:obakit/obakit.dart' show Coordinate;

/// A campus building the host app knows about.
class CampusPlace {
  const CampusPlace(this.name, this.coordinate);

  final String name;
  final Coordinate coordinate;
}

abstract final class CampusPlaces {
  static const centerHall = CampusPlace(
    'Center Hall',
    Coordinate(32.8775, -117.2373),
  );
  static const priceCenter = CampusPlace(
    'Price Center',
    Coordinate(32.8797, -117.2362),
  );
  static const geiselLibrary = CampusPlace(
    'Geisel Library',
    Coordinate(32.8811, -117.2376),
  );
  static const rimacArena = CampusPlace(
    'RIMAC Arena',
    Coordinate(32.8855, -117.2397),
  );

  /// Where the demo pretends the student is (also the OBA location).
  static const campusCenter = Coordinate(32.8801, -117.2340);
}

/// A real San Diego MTS stop on or next to campus.
class CampusStop {
  const CampusStop({
    required this.id,
    required this.name,
    required this.description,
  });

  /// The OneBusAway stop ID (agency prefix included).
  final String id;
  final String name;
  final String description;
}

const campusStops = [
  CampusStop(
    id: 'MTS_24151',
    name: 'Eighth College / Theatre District',
    description: 'Campus shuttle and buses on the east side of campus',
  ),
  CampusStop(
    id: 'MTS_88986',
    name: 'UCSD Central Campus Trolley',
    description: 'UC San Diego Blue Line trolley, next to Geisel Library',
  ),
  CampusStop(
    id: 'MTS_11902',
    name: 'Gilman Transit Center',
    description: 'Bus connections on Gilman Drive',
  ),
];
