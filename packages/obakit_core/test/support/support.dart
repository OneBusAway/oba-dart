import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:obakit_core/obakit_core.dart';

/// Reads `test/fixtures/<name>`, falling back to the onebusaway package's
/// fixtures. Tests run with the package as the working directory.
String fixture(String name) {
  final local = File('test/fixtures/$name');
  if (local.existsSync()) return local.readAsStringSync();
  return File('../onebusaway/test/fixtures/$name').readAsStringSync();
}

/// A MockClient that answers by path substring, recording every request.
class FakeHttp {
  FakeHttp(this.routes);

  /// Path substring -> (status, body).
  final Map<String, (int, String)> routes;
  final List<http.Request> requests = [];

  late final MockClient client = MockClient((request) async {
    requests.add(request);
    for (final e in routes.entries) {
      if (request.url.toString().contains(e.key)) {
        return http.Response(
          e.value.$2,
          e.value.$1,
          headers: {'content-type': 'application/json'},
        );
      }
    }
    return http.Response('not found', 404);
  });
}

List<Region> regionsFixture() =>
    Region.listFromJson(fixture('regions-v3.json'));

Region regionNamed(String name) =>
    regionsFixture().firstWhere((r) => r.regionName == name);

/// Seattle, inside Puget Sound's bounds.
final seattle = ObaLocation(
  lat: 47.6,
  lon: -122.33,
  accuracy: 10,
  timestamp: DateTime.utc(2024),
);

/// Tampa, inside Tampa Bay's bounds.
final tampa = ObaLocation(
  lat: 27.95,
  lon: -82.45,
  timestamp: DateTime.utc(2024),
);

ArrivalAndDeparture arrival({
  String routeId = '1_10',
  String tripId = 't1',
  String stopId = '1_100',
  int stopSequence = 5,
  DateTime? scheduled,
  DateTime? predicted,
  bool isPredicted = false,
  String? routeShortName = '10',
  String? headsign = 'Downtown',
  String? vehicleId,
  DateTime? lastUpdate,
  DateTime? serviceDate,
  List<String> situationIds = const [],
}) => ArrivalAndDeparture(
  routeId: routeId,
  tripId: tripId,
  serviceDate: serviceDate ?? DateTime.utc(2024, 1, 1),
  stopId: stopId,
  stopSequence: stopSequence,
  routeShortName: routeShortName,
  tripHeadsign: headsign,
  scheduledArrivalTime: scheduled,
  scheduledDepartureTime: scheduled,
  predictedArrivalTime: predicted,
  predictedDepartureTime: predicted,
  predicted: isPredicted,
  vehicleId: vehicleId,
  lastUpdateTime: lastUpdate,
  situationIds: situationIds,
);

StoredStop storedStop({
  String id = '1_100',
  String name = 'Pine St & 3rd Ave',
  double lat = 47.61,
  double lon = -122.34,
  List<StoredRoute> routes = const [],
}) => StoredStop(
  id: id,
  name: name,
  lat: lat,
  lon: lon,
  code: id.split('_').last,
  direction: 'N',
  routeIds: [for (final r in routes) r.id],
  routes: routes,
);

/// Parses an arrivals-and-departures fixture through the real client.
Future<ObaEntryResponse<StopWithArrivalsAndDepartures>> loadArrivals(
  String name,
  String stopId,
) {
  final http = FakeHttp({
    'arrivals-and-departures-for-stop': (200, fixture(name)),
  });
  return OneBusAwayClient(
    baseUrl: Uri.parse('https://api.example.com/'),
    apiKey: 'test',
    httpClient: http.client,
  ).arrivalsAndDepartures.forStop(stopId);
}
