# onebusaway

A pure-Dart client for the [OneBusAway REST API](https://developer.onebusaway.org/api/where).
It has no Flutter dependency.

## Install (git dependency)

```yaml
dependencies:
  onebusaway:
    git:
      url: https://github.com/onebusaway/oba-dart.git
      path: packages/onebusaway
      ref: 0.1.0 # pin a release tag
```

Requires Dart 3.13.4 or later.

The `0.1.0` tag has only the arrivals endpoints. The other endpoints, the
Regions client, the Obaco client and the polyline codec described below are
unreleased: pin a commit or a branch in `ref:` to use them.

Flutter apps embedding the arrivals panel should depend on `oba_arrivals`
alone; it re-exports this package.

## Usage

```dart
final client = OneBusAwayClient(
  // The OBA *server root*. Endpoints live under {baseUrl}api/where/.
  baseUrl: Uri.parse('https://realtime.sdmts.com/api/'),
  apiKey: 'org.onebusaway.iphone',
);

final response = await client.arrivalsAndDepartures.forStop('MTS_24151');
final stop = response.references.stop(response.entry.stopId);
for (final a in response.entry.arrivalsAndDepartures) {
  print('${a.routeShortName} ${a.tripHeadsign} ${a.predictedArrivalTime ?? a.scheduledArrivalTime}');
}
client.close();
```

`response.currentTime` is the server's clock. Use it to correct the device's
clock skew.

Related entities (stops, routes, trips, agencies, service alerts) arrive in
`response.references`, indexed by id. Models hold ids (`stopId`,
`situationIds`, …); resolve them with `references.stop(id)`,
`references.situation(id)`, `references.stopsWithIds(ids)` and so on.

### Supported endpoints

All under `{baseUrl}api/where/`. Coordinates are `Coordinate(lat, lon)`.

| Endpoint | Call | Entry / list type |
|---|---|---|
| `current-time` | `currentTime.get()` | `CurrentTime` |
| `stops-for-location` | `stops.forLocation(center, {latSpan, lonSpan, radius, query})` | list of `Stop` |
| `stop/{id}` | `stops.byId(id)` | `Stop` |
| `stops-for-route/{id}` | `stops.forRoute(routeId)` | `StopsForRoute` |
| `arrivals-and-departures-for-stop/{id}` | `arrivalsAndDepartures.forStop(id, {minutesBefore, minutesAfter, time})` | `StopWithArrivalsAndDepartures` |
| `arrival-and-departure-for-stop/{id}` | `arrivalsAndDepartures.forTripAtStop(id, {tripId, serviceDate, vehicleId, stopSequence})` | `ArrivalAndDeparture` |
| `trip-details/{id}` | `trips.details(tripId, {serviceDate, vehicleId})` | `TripDetails` |
| `trip-for-vehicle/{id}` | `trips.forVehicle(vehicleId)` | `TripDetails` |
| `vehicle/{id}` | `vehicles.byId(vehicleId)` | `VehicleStatus` |
| `routes-for-location` | `routes.forLocation(center, {query, radius})` | list of `Route` |
| `shape/{id}` | `shapes.byId(shapeId)` | `Shape` |
| `agencies-with-coverage` | `agencies.withCoverage()` | list of `AgencyWithCoverage` |
| `schedule-for-stop/{id}` | `schedules.forStop(id, {date})` | `ScheduleForStop` |
| `schedule-for-route/{id}` | `schedules.forRoute(id, {date})` | `ScheduleForRoute` |
| `config` | `config.get()` | `ServerIdentity` |
| `report-problem-with-stop/{id}` | `problemReports.reportStop(id, {code, comment, userLocation, userLocationAccuracy})` | none |
| `report-problem-with-trip` | `problemReports.reportTrip({tripId, serviceDate, code, userOnVehicle, …})` | none |

Parameter rules follow the iOS app: `stops-for-location` clamps `radius` to
1…15000 m; `routes-for-location` sends a radius of at least 40 km;
`arrival-and-departure-for-stop` sends `stopSequence` only when it is above 0;
schedule `date`s are sent as `yyyy-MM-dd` from the `DateTime`'s own calendar
fields.

## Errors

Every failure is an `ObaException`:

| Type | When |
|---|---|
| `ObaApiException(kind: httpStatus)` | non-2xx HTTP status (for example, a wrong base URL gives an HTML 404) |
| `ObaApiException(kind: emptyResponse)` | 200 with an empty body. SDMTS does this for unknown ids **and** rejected keys |
| `ObaApiException(kind: emptyResponse, isNullBody: true)` | 200 with the body `null`, which Java servers send instead of a 404. For `arrivals-and-departures-for-stop`, `forStop` first checks `stop/{id}`: if the stop exists it returns an entry with no arrivals (the stop has no service today) and the stop in `references`; it throws this error only when the stop is missing too |
| `ObaApiException(kind: envelope)` | the JSON envelope `code` is not 200 |
| `ObaNetworkException` | socket/TLS failure or timeout |
| `ObaFormatException` | the body is not JSON, or a required field is missing or has the wrong type |

## Adding an endpoint

Every endpoint uses the same core, so adding one never changes the transport:

1. Add models under `lib/src/models/`. Give each a `fromJson(JsonMap)`
   factory built from the helpers in `lib/src/core/json.dart`. Use
   `readOptString` for fields OBA may send as `""`.
2. Add or extend a resource class under `lib/src/resources/`. Call
   `_transport.get('<method-name>', id: …, params: …)`, then
   `envelope.toEntry(Model.fromJson)` or `envelope.toList(Model.fromJson)`.
3. Expose the resource as a `final` field on `OneBusAwayClient`, and export
   the new files from `lib/onebusaway.dart`.
4. Add a fixture captured from a real server to `test/fixtures/`, plus a
   `MockClient` test.

## Regions

`RegionsClient` fetches the list of OneBusAway deployments (default
`https://regions.onebusaway.org/regions-v3.json`). `Region.listFromJson(body)`
parses a bundled regions file with the same envelope, and `Region.toJson()`
round-trips through `Region.fromJson` for caching. `Region.custom(...)` builds
a user-defined region.

```dart
final regions = await RegionsClient().fetch();
final here = regions.where((r) => r.contains(47.6062, -122.3321));
final nearest = (regions.toList()
      ..sort((a, b) => a
          .distanceFrom(47.6, -122.3)
          .compareTo(b.distanceFrom(47.6, -122.3))))
    .first;
```

Derived values: `supportsOtp`, `serviceRect`, `contains`, `distanceFrom`
(metres to the centre of the service rect) and `supportsScheduleForRoute`.

## Obaco (sidecar)

`ObacoClient` talks to a region's sidecar server (`Region.sidecarBaseUrl`):
weather, arrival alarms, vehicle search, ghost bus reports, push registrations
and surveys. Failures are `ObaException`s.

```dart
final obaco = ObacoClient(baseUrl: region.sidecarBaseUrl!, regionId: region.id);
final weather = await obaco.getWeather();
final vehicles = await obaco.getVehicles('1156');
final surveys = await obaco.getSurveys(userId: 'user-uuid');
```

## Polylines

`Polyline.decode` and `Polyline.encode` convert Google encoded polylines
(precision `1e5` by default) to and from `List<Coordinate>`, for example the
`points` of a shape.

## License

Licensed under the [Apache License, Version 2.0](LICENSE).
