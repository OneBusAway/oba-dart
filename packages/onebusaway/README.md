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

## Errors

Every failure is an `ObaException`:

| Type | When |
|---|---|
| `ObaApiException(kind: httpStatus)` | non-2xx HTTP status (for example, a wrong base URL gives an HTML 404) |
| `ObaApiException(kind: emptyResponse)` | 200 with an empty body. SDMTS does this for unknown ids **and** rejected keys |
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

## License

Licensed under the [Apache License, Version 2.0](LICENSE).
