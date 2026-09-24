# OBA Arrivals for Flutter Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build an embeddable, Wayfinder-style arrivals & departures panel for
UCSD's Flutter Student Life app. It rests on a pure-Dart OneBusAway client that
can grow to cover the full OBA REST API. A demo host app shows it embedded.

**Architecture:** This is a pub workspace with three members:
- `packages/onebusaway` is a pure-Dart client. It has a transport/envelope/
  references core, a resource class per OBA endpoint group, and hand-written
  models.
- `packages/oba_arrivals` is the Flutter UI: an `ArrivalsController`
  (`ChangeNotifier`, polling), pure display logic ported from Wayfinder, a
  theme extension, and the `ObaArrivalsPanel` widget.
- The workspace root is the `oba_dart` demo app, which embeds the panel in a
  Student-Life-like shell.

**Tech Stack:** Flutter 3.47.5 / Dart 3.13.4 (via `mise`), `package:http`
1.6, `package:test`, `flutter_test`, and `fake_async`.

**Spec:** `docs/superpowers/specs/2026-09-23-oba-arrivals-design.md`. Read it
before starting any task.

## Global Constraints

- Run every Flutter/Dart command through mise from the repo root, or from the
  package directory named in the step: `mise exec -- flutter …` /
  `mise exec -- dart …`.
- The SDK constraint in every pubspec is exactly `sdk: ^3.13.4`.
  `oba_arrivals` also sets `flutter: ">=3.47.0"`.
- Only member packages set `resolution: workspace`. The root pubspec declares
  `workspace:`.
- `oba_arrivals` depends on `onebusaway` via `path: ../onebusaway`, never a
  version constraint.
- `onebusaway` must not import Flutter. Its only runtime dependency is
  `http: ^1.6.0`. Its `test` dev-dependency is `">=1.25.0 <2.0.0"`.
- `baseUrl` is the OBA server root, and endpoints live at
  `{baseUrl}api/where/{method}[/{id}].json`. The SDMTS root is
  `https://realtime.sdmts.com/api/`.
- Demo defaults: `OBA_BASE_URL=https://realtime.sdmts.com/api/` and
  `OBA_API_KEY=org.onebusaway.iphone`. The packages have no defaults.
- Do not use the UCSD logo or any UCSD artwork in the demo. Text only.
- Status colors:

  | Status | Light | Dark |
  |---|---|---|
  | On time | `#16A34A` | `#4ADE80` |
  | Late | `#7C3AED` | `#A78BFA` |
  | Early | `#DC2626` | `#F87171` |

  - The badge fallback background is `#374151`.
  - The badge is 64 wide × 56 tall with an 8 px radius.
- Keep the server's arrival order. There is no client-side sort.
- No `intl` or `gen_l10n` dependency. All strings live in
  `ObaArrivalsStrings`.
- Commit after each task with a plain message. Add no attribution trailer.

## Review Focus

These are the input classes most likely to break real use that the spec
implies but doesn't spell out. Each one has a pinned test in the task named.

1. **Rows go stale between polls.** A bus whose ETA passes zero must disappear
   on the widget's 30-second tick without a new fetch. The Task 7 test is
   "departed row disappears on tick".
2. **Phone clock is wrong.** ETAs must follow the server's `currentTime`, not
   the device clock. The Task 6 test is "now() follows server time", and the
   Task 7 fixture-based tests only pass with the offset applied.
3. **SDMTS answers an unknown stop or a bad key with HTTP 200 and an empty
   body.** The user must see "Stop not found or service unavailable" with a
   Retry button, not a crash or a spinner. The Task 3 test covers the
   `emptyResponse` branch, and the Task 7 test is "empty body shows not-found
   message and retry refetches".
4. **UCSD routes send `textColor: ""` on light backgrounds.** For example, the
   IL route (`ffcd00`) needs black text. The Task 5 test is "UCSD IL badge uses
   black text".
5. **A panel hidden under a pushed route, or an app in the background, must
   stop polling.** Otherwise two panels poll the same stop. The Task 7 tests
   are "pauses while TickerMode disabled" and "pauses when app is paused".

---

## File Structure

```
pubspec.yaml                                   # root: oba_dart app + workspace
lib/main.dart                                  # entry: builds client, runs app
lib/config.dart                                # --dart-define config
lib/demo_stops.dart                            # hardcoded UCSD stops
lib/app.dart                                   # MaterialApp, themes, dark toggle
lib/home_page.dart                             # Student-Life-like feed
lib/shuttle_card.dart                          # card embedding the panel
lib/all_arrivals_page.dart                     # full-screen panel
test/widget_test.dart                          # demo smoke test
README.md                                      # root docs

packages/onebusaway/
  pubspec.yaml, analysis_options.yaml, README.md
  lib/onebusaway.dart                          # public exports
  lib/src/core/errors.dart                     # ObaException hierarchy
  lib/src/core/json.dart                       # JsonMap + read* helpers
  lib/src/core/references.dart                 # References
  lib/src/core/responses.dart                  # ObaEntryResponse / ObaListResponse
  lib/src/core/transport.dart                  # URL building, GET, envelope decode
  lib/src/models/agency.dart, route.dart, stop.dart, trip.dart
  lib/src/models/frequency.dart, trip_status.dart
  lib/src/models/arrival_and_departure.dart
  lib/src/models/stop_with_arrivals_and_departures.dart
  lib/src/resources/arrivals_and_departures.dart
  lib/src/client.dart                          # OneBusAwayClient
  test/fixtures/arrivals_mts_24151.json        # hand-made, deterministic
  test/fixtures/arrivals_live.json             # captured live
  test/fixtures/error_envelope.json
  test/json_test.dart, models_test.dart, transport_test.dart, client_test.dart

packages/oba_arrivals/
  pubspec.yaml, analysis_options.yaml, dart_test.yaml, README.md
  lib/oba_arrivals.dart                        # public exports
  lib/src/strings.dart                         # ObaArrivalsStrings
  lib/src/display/arrival_display.dart         # ETA, delay, status, time
  lib/src/display/arrival_filtering.dart       # departed + layover filters
  lib/src/display/stop_display.dart            # subtitle, agency prefix
  lib/src/theme.dart                           # ObaArrivalsTheme
  lib/src/color_utils.dart                     # hex parse, contrast, font size
  lib/src/route_badge.dart                     # RouteBadge
  lib/src/arrivals_controller.dart             # ArrivalsController + ArrivalsState
  lib/src/widgets/stop_header.dart
  lib/src/widgets/arrival_row.dart
  lib/src/widgets/panel_states.dart            # skeleton, empty, error, stale
  lib/src/arrivals_panel.dart                  # ObaArrivalsPanel
  test/support/fixtures.dart                   # MockClient helpers
  test/display_test.dart, filtering_test.dart, stop_display_test.dart
  test/theme_and_badge_test.dart, controller_test.dart, panel_test.dart
  test/golden/panel_golden_test.dart (+ golden PNGs)
```

---

### Task 1: Workspace + `onebusaway` package skeleton, errors and JSON helpers

**Files:**
- Modify: `pubspec.yaml`
- Create: `packages/onebusaway/pubspec.yaml`
- Create: `packages/onebusaway/analysis_options.yaml`
- Create: `packages/onebusaway/lib/onebusaway.dart`
- Create: `packages/onebusaway/lib/src/core/errors.dart`
- Create: `packages/onebusaway/lib/src/core/json.dart`
- Test: `packages/onebusaway/test/json_test.dart`

**Interfaces:**
- Produces:
  - `sealed class ObaException implements Exception { String get message; }`
  - `enum ObaApiErrorKind { httpStatus, emptyResponse, envelope }`
  - `final class ObaApiException extends ObaException { ObaApiException(ObaApiErrorKind kind, {int? code, String? text}); }`
  - `final class ObaNetworkException extends ObaException { ObaNetworkException(Object cause); }`
  - `final class ObaFormatException extends ObaException { ObaFormatException(String message); }`
  - `typedef JsonMap = Map<String, Object?>`
  - Helpers:
    - `String readString(JsonMap, String)`
    - `String? readOptString(JsonMap, String)` (`""` → null)
    - `int readInt(JsonMap, String)`
    - `int? readOptInt(JsonMap, String)`
    - `double? readOptDouble(JsonMap, String)`
    - `bool readBool(JsonMap, String, {bool defaultValue = false})`
    - `JsonMap readMap(JsonMap, String)`
    - `JsonMap? readOptMap(JsonMap, String)`
    - `List<T> readList<T>(JsonMap, String, T Function(Object?) parse)`
    - `List<String> readStringList(JsonMap, String)`
    - `DateTime? readEpochMs(JsonMap, String)` (0/missing → null, UTC)
    - `JsonMap asJsonMap(Object?, String context)`

- [ ] **Step 1: Add the workspace to the root pubspec**

In `pubspec.yaml`, insert after the `environment:` block:

```yaml
workspace:
  - packages/onebusaway
  - packages/oba_arrivals
```

`oba_arrivals` doesn't exist until Task 4. Create its minimal pubspec now so
the workspace resolves.

`packages/oba_arrivals/pubspec.yaml`:

```yaml
name: oba_arrivals
description: Embeddable OneBusAway arrivals and departures panel for Flutter apps.
version: 0.1.0
publish_to: none

environment:
  sdk: ^3.13.4
  flutter: ">=3.47.0"

resolution: workspace

dependencies:
  flutter:
    sdk: flutter
  onebusaway:
    path: ../onebusaway
  clock: ^1.1.3

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  fake_async: ^1.3.3
  http: ^1.6.0

flutter:
```

- [ ] **Step 2: Create the `onebusaway` package files**

`packages/onebusaway/pubspec.yaml`:

```yaml
name: onebusaway
description: A Dart client for the OneBusAway REST API.
version: 0.1.0
publish_to: none

environment:
  sdk: ^3.13.4

resolution: workspace

dependencies:
  http: ^1.6.0

dev_dependencies:
  lints: ^6.1.0
  test: ">=1.25.0 <2.0.0"
```

`packages/onebusaway/analysis_options.yaml`:

```yaml
include: package:lints/recommended.yaml
```

`packages/onebusaway/lib/onebusaway.dart` (it grows in later tasks):

```dart
/// A Dart client for the OneBusAway REST API.
library;

export 'src/core/errors.dart';
```

`packages/onebusaway/lib/src/core/errors.dart`:

```dart
/// Base class for every error thrown by the OneBusAway client.
sealed class ObaException implements Exception {
  const ObaException();

  String get message;

  @override
  String toString() => '$runtimeType: $message';
}

enum ObaApiErrorKind {
  /// The server answered with a non-2xx HTTP status.
  httpStatus,

  /// The server answered 2xx with an empty body. SDMTS does this for an
  /// unknown id and for a rejected API key; the two can't be told apart.
  emptyResponse,

  /// The JSON envelope's `code` was not 200.
  envelope,
}

final class ObaApiException extends ObaException {
  const ObaApiException(this.kind, {this.code, this.text});

  final ObaApiErrorKind kind;
  final int? code;
  final String? text;

  @override
  String get message => switch (kind) {
        ObaApiErrorKind.httpStatus => 'HTTP status $code',
        ObaApiErrorKind.emptyResponse =>
          'Empty response (unknown id or rejected API key)',
        ObaApiErrorKind.envelope => 'OneBusAway error $code: ${text ?? ''}',
      };
}

final class ObaNetworkException extends ObaException {
  const ObaNetworkException(this.cause);

  final Object cause;

  @override
  String get message => cause.toString();
}

final class ObaFormatException extends ObaException {
  const ObaFormatException(this.message);

  @override
  final String message;
}
```

- [ ] **Step 3: Write the failing JSON helper tests**

`packages/onebusaway/test/json_test.dart`:

```dart
import 'package:onebusaway/onebusaway.dart';
import 'package:onebusaway/src/core/json.dart';
import 'package:test/test.dart';

void main() {
  group('readString / readOptString', () {
    test('reads a string', () {
      expect(readString({'a': 'x'}, 'a'), 'x');
    });

    test('throws ObaFormatException naming the field when missing', () {
      expect(
        () => readString({}, 'name'),
        throwsA(isA<ObaFormatException>()
            .having((e) => e.message, 'message', contains('"name"'))),
      );
    });

    test('optional: empty string and null become null', () {
      expect(readOptString({'a': ''}, 'a'), isNull);
      expect(readOptString({'a': null}, 'a'), isNull);
      expect(readOptString({}, 'a'), isNull);
      expect(readOptString({'a': 'SW'}, 'a'), 'SW');
    });

    test('optional: wrong type throws', () {
      expect(() => readOptString({'a': 3}, 'a'),
          throwsA(isA<ObaFormatException>()));
    });
  });

  group('numbers and bools', () {
    test('readInt accepts ints and integral doubles', () {
      expect(readInt({'a': 3}, 'a'), 3);
      expect(readInt({'a': 3.0}, 'a'), 3);
    });

    test('readOptInt / readOptDouble', () {
      expect(readOptInt({}, 'a'), isNull);
      expect(readOptDouble({'a': 745.76}, 'a'), 745.76);
      expect(readOptDouble({'a': 2}, 'a'), 2.0);
    });

    test('readBool uses default when missing, throws on wrong type', () {
      expect(readBool({}, 'a'), isFalse);
      expect(readBool({}, 'a', defaultValue: true), isTrue);
      expect(readBool({'a': true}, 'a'), isTrue);
      expect(() => readBool({'a': 'yes'}, 'a'),
          throwsA(isA<ObaFormatException>()));
    });
  });

  group('readEpochMs', () {
    test('converts epoch ms to UTC DateTime', () {
      final t = readEpochMs({'t': 1790228579290}, 't')!;
      expect(t.isUtc, isTrue);
      expect(t.millisecondsSinceEpoch, 1790228579290);
    });

    test('0 and missing mean "no value"', () {
      expect(readEpochMs({'t': 0}, 't'), isNull);
      expect(readEpochMs({}, 't'), isNull);
    });
  });

  group('collections', () {
    test('readList maps items and treats missing as empty', () {
      expect(readList({'a': [1, 2]}, 'a', (v) => (v as int) * 2), [2, 4]);
      expect(readList({}, 'a', (v) => v), isEmpty);
    });

    test('readStringList', () {
      expect(readStringList({'ids': ['A', 'B']}, 'ids'), ['A', 'B']);
    });

    test('readMap requires an object', () {
      expect(readMap({'m': {'x': 1}}, 'm'), {'x': 1});
      expect(() => readMap({'m': []}, 'm'), throwsA(isA<ObaFormatException>()));
      expect(readOptMap({}, 'm'), isNull);
    });
  });
}
```

- [ ] **Step 4: Resolve the workspace and run the tests to see them fail**

Run from the repo root: `mise exec -- flutter pub get`
Expected: "Got dependencies!" (or "Resolving dependencies… Got dependencies").

Run: `cd packages/onebusaway && mise exec -- dart test test/json_test.dart`
Expected: FAIL with a compile error, because `package:onebusaway/src/core/json.dart` does not exist.

- [ ] **Step 5: Implement the JSON helpers**

`packages/onebusaway/lib/src/core/json.dart`:

```dart
import 'errors.dart';

typedef JsonMap = Map<String, Object?>;

Never _wrongType(String key, String expected, Object? value) =>
    throw ObaFormatException(
        'Expected $expected at "$key", got ${value.runtimeType}');

String readString(JsonMap json, String key) {
  final value = json[key];
  if (value is String) return value;
  _wrongType(key, 'string', value);
}

/// Reads an optional string. OBA servers send `""` for absent values
/// (e.g. `textColor`, `direction`), so empty strings become null.
String? readOptString(JsonMap json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is String) return value.isEmpty ? null : value;
  _wrongType(key, 'string', value);
}

int readInt(JsonMap json, String key) {
  final value = json[key];
  if (value is num) return value.toInt();
  _wrongType(key, 'number', value);
}

int? readOptInt(JsonMap json, String key) =>
    json[key] == null ? null : readInt(json, key);

double? readOptDouble(JsonMap json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is num) return value.toDouble();
  _wrongType(key, 'number', value);
}

bool readBool(JsonMap json, String key, {bool defaultValue = false}) {
  final value = json[key];
  if (value == null) return defaultValue;
  if (value is bool) return value;
  _wrongType(key, 'bool', value);
}

JsonMap asJsonMap(Object? value, String context) {
  if (value is Map<String, Object?>) return value;
  _wrongType(context, 'object', value);
}

JsonMap readMap(JsonMap json, String key) => asJsonMap(json[key], key);

JsonMap? readOptMap(JsonMap json, String key) =>
    json[key] == null ? null : readMap(json, key);

List<T> readList<T>(JsonMap json, String key, T Function(Object? item) parse) {
  final value = json[key];
  if (value == null) return const [];
  if (value is List) return List.unmodifiable(value.map(parse));
  _wrongType(key, 'list', value);
}

List<String> readStringList(JsonMap json, String key) =>
    readList(json, key, (item) {
      if (item is String) return item;
      _wrongType(key, 'list of strings', item);
    });

/// Reads epoch milliseconds as a UTC [DateTime]. OBA uses 0 for "no value".
DateTime? readEpochMs(JsonMap json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is! num) _wrongType(key, 'epoch milliseconds', value);
  if (value == 0) return null;
  return DateTime.fromMillisecondsSinceEpoch(value.toInt(), isUtc: true);
}
```

- [ ] **Step 6: Run the tests to see them pass**

Run: `cd packages/onebusaway && mise exec -- dart test test/json_test.dart`
Expected: PASS, "All tests passed!"

Run: `cd packages/onebusaway && mise exec -- dart analyze`
Expected: "No issues found!"

- [ ] **Step 7: Commit**

```bash
git add pubspec.yaml pubspec.lock packages/
git commit -m "Add pub workspace and onebusaway core errors and JSON helpers"
```

---

### Task 2: `onebusaway` models and References

**Files:**
- Create: `packages/onebusaway/lib/src/models/agency.dart`
- Create: `packages/onebusaway/lib/src/models/route.dart`
- Create: `packages/onebusaway/lib/src/models/stop.dart`
- Create: `packages/onebusaway/lib/src/models/trip.dart`
- Create: `packages/onebusaway/lib/src/models/frequency.dart`
- Create: `packages/onebusaway/lib/src/models/trip_status.dart`
- Create: `packages/onebusaway/lib/src/models/arrival_and_departure.dart`
- Create: `packages/onebusaway/lib/src/models/stop_with_arrivals_and_departures.dart`
- Create: `packages/onebusaway/lib/src/core/references.dart`
- Create: `packages/onebusaway/test/fixtures/arrivals_mts_24151.json`
- Modify: `packages/onebusaway/lib/onebusaway.dart`
- Test: `packages/onebusaway/test/models_test.dart`

**Interfaces:**
- Consumes: the `json.dart` helpers from Task 1.
- Produces (all constructors are `const`, with named parameters; each class
  has `factory X.fromJson(JsonMap json)`):
  - `Agency({required String id, required String name, String? url, String? timezone, String? phone})`
  - `Route({required String id, required String agencyId, String? shortName, String? longName, String? description, int? type, String? color, String? textColor, String? url})`
  - `Stop({required String id, String? code, required String name, required double lat, required double lon, String? direction, List<String> routeIds = const [], String? wheelchairBoarding})`
  - `Trip({required String id, required String routeId, String? tripHeadsign, String? directionId, String? serviceId, String? blockId, String? shapeId})`
  - `Frequency({required DateTime startTime, required DateTime endTime, required int headway})`, where `headway` is in seconds.
  - `TripStatus({String? status, String? phase, bool predicted = false, int scheduleDeviation = 0, String? vehicleId, String? activeTripId, DateTime? serviceDate})`
  - `ArrivalAndDeparture`, with these named fields:
    - required: `String routeId`, `String tripId`, `DateTime serviceDate`,
      `String stopId`, `int stopSequence`;
    - `int? totalStopsInTrip`, `int? blockTripSequence`;
    - `String? routeShortName`, `String? routeLongName`, `String? tripHeadsign`;
    - `DateTime? scheduledArrivalTime`, `DateTime? predictedArrivalTime`,
      `DateTime? scheduledDepartureTime`, `DateTime? predictedDepartureTime`;
    - `bool predicted = false`, `bool arrivalEnabled = true`,
      `bool departureEnabled = true`;
    - `String? vehicleId`, `int? numberOfStopsAway`,
      `double? distanceFromStop`, `String? status`;
    - `Frequency? frequency`, `TripStatus? tripStatus`.
  - `StopWithArrivalsAndDepartures({required String stopId, List<ArrivalAndDeparture> arrivalsAndDepartures = const [], List<String> nearbyStopIds = const [], List<String> situationIds = const []})`
  - `References({Map<String, Agency> agencies, Map<String, Route> routes, Map<String, Stop> stops, Map<String, Trip> trips})`
    - `factory References.fromJson(JsonMap? json)`, where null means empty.
    - `static const References empty`.
    - Lookups `Agency? agency(String id)`, `Route? route(String id)`,
      `Stop? stop(String id)`, `Trip? trip(String id)`.
  - Everything is exported from `package:onebusaway/onebusaway.dart`.

- [ ] **Step 1: Create the deterministic fixture**

`packages/onebusaway/test/fixtures/arrivals_mts_24151.json`. It has
`currentTime` 1790228579290 (2026-09-24T04:22:59.290Z) and four arrivals:
- Old Town (30): predicted, on time, ETA 4 min.
- Inside Loop (IL): predicted, 2 min late, ETA 5 min.
- SIO (S): scheduled only, ETA 8 min.
- UTC (30): already departed, ETA −3.

The references also include `MTS_201`, which does not serve the stop.

```json
{
  "code": 200,
  "currentTime": 1790228579290,
  "text": "OK",
  "version": 2,
  "data": {
    "limitExceeded": false,
    "entry": {
      "stopId": "MTS_24151",
      "nearbyStopIds": ["MTS_24150"],
      "situationIds": [],
      "arrivalsAndDepartures": [
        {
          "arrivalEnabled": true, "departureEnabled": true,
          "blockTripSequence": 15, "distanceFromStop": 0.0,
          "frequency": null, "numberOfStopsAway": -1,
          "predicted": true,
          "predictedArrivalTime": 1790228400000, "predictedDepartureTime": 1790228400000,
          "scheduledArrivalTime": 1790228400000, "scheduledDepartureTime": 1790228400000,
          "routeId": "MTS_30", "routeLongName": "Old Town  - UTC via Pacific Beach",
          "routeShortName": "30", "serviceDate": 1790146800000, "situationIds": [],
          "status": "default", "stopId": "MTS_24151", "stopSequence": 40,
          "totalStopsInTrip": 58, "tripHeadsign": "UTC", "tripId": "MTS_19630023",
          "tripStatus": null, "vehicleId": "MTS_812"
        },
        {
          "arrivalEnabled": true, "departureEnabled": true,
          "blockTripSequence": 16, "distanceFromStop": 745.7646433271584,
          "frequency": null, "numberOfStopsAway": 1,
          "predicted": true,
          "predictedArrivalTime": 1790228760000, "predictedDepartureTime": 1790228760000,
          "scheduledArrivalTime": 1790228760000, "scheduledDepartureTime": 1790228760000,
          "routeId": "MTS_30", "routeLongName": "Old Town  - UTC via Pacific Beach",
          "routeShortName": "30", "serviceDate": 1790146800000, "situationIds": [],
          "status": "default", "stopId": "MTS_24151", "stopSequence": 9,
          "totalStopsInTrip": 58, "tripHeadsign": "Old Town", "tripId": "MTS_19630024",
          "tripStatus": {
            "activeTripId": "MTS_19630024", "blockTripSequence": 16,
            "phase": "in_progress", "predicted": true, "scheduleDeviation": 0,
            "serviceDate": 1790146800000, "status": "default", "vehicleId": "MTS_813"
          },
          "vehicleId": "MTS_813"
        },
        {
          "arrivalEnabled": true, "departureEnabled": true,
          "blockTripSequence": 4, "distanceFromStop": 1210.5,
          "frequency": null, "numberOfStopsAway": 3,
          "predicted": true,
          "predictedArrivalTime": 1790228820000, "predictedDepartureTime": 1790228820000,
          "scheduledArrivalTime": 1790228700000, "scheduledDepartureTime": 1790228700000,
          "routeId": "UCSD_1040", "routeLongName": "Inside Loop",
          "routeShortName": "IL", "serviceDate": 1790146800000, "situationIds": [],
          "status": "default", "stopId": "MTS_24151", "stopSequence": 3,
          "totalStopsInTrip": 12, "tripHeadsign": "Inside Loop", "tripId": "UCSD_5501",
          "tripStatus": {
            "activeTripId": "UCSD_5501", "phase": "in_progress", "predicted": true,
            "scheduleDeviation": 120, "serviceDate": 1790146800000,
            "status": "default", "vehicleId": "UCSD_12"
          },
          "vehicleId": "UCSD_12"
        },
        {
          "arrivalEnabled": true, "departureEnabled": true,
          "blockTripSequence": 2, "distanceFromStop": 0.0,
          "frequency": null, "numberOfStopsAway": 0,
          "predicted": false,
          "predictedArrivalTime": 0, "predictedDepartureTime": 0,
          "scheduledArrivalTime": 1790229000000, "scheduledDepartureTime": 1790229000000,
          "routeId": "UCSD_1020", "routeLongName": "SIO",
          "routeShortName": "S", "serviceDate": 1790146800000, "situationIds": [],
          "status": "default", "stopId": "MTS_24151", "stopSequence": 5,
          "totalStopsInTrip": 20, "tripHeadsign": "SIO", "tripId": "UCSD_7702",
          "tripStatus": null, "vehicleId": ""
        }
      ]
    },
    "references": {
      "agencies": [
        {"id": "MTS", "name": "MTS", "url": "http://www.sdmts.com",
         "timezone": "America/Los_Angeles", "phone": "619-233-3004",
         "lang": "en", "privateService": false},
        {"id": "UCSD", "name": "UC San Diego", "url": "https://transportation.ucsd.edu",
         "timezone": "US/Pacific", "phone": "", "lang": "en", "privateService": false}
      ],
      "routes": [
        {"id": "MTS_30", "agencyId": "MTS", "shortName": "30",
         "longName": "Old Town  - UTC via Pacific Beach", "description": "",
         "type": 3, "color": "000099", "textColor": "FFFFFF",
         "url": "https://www.sdmts.com/schedules-real-time?fragment=30"},
        {"id": "MTS_201", "agencyId": "MTS", "shortName": "201",
         "longName": "SuperLoop", "description": "", "type": 3,
         "color": "E31837", "textColor": "FFFFFF", "url": ""},
        {"id": "NCTD_301", "agencyId": "NCTD", "shortName": "101",
         "longName": "Oceanside - UTC", "description": "", "type": 3,
         "color": "", "textColor": "", "url": ""},
        {"id": "UCSD_1040", "agencyId": "UCSD", "shortName": "IL",
         "longName": "Inside Loop", "description": "", "type": 3,
         "color": "ffcd00", "textColor": "", "url": ""},
        {"id": "UCSD_1020", "agencyId": "UCSD", "shortName": "S",
         "longName": "SIO", "description": "", "type": 3,
         "color": "90a7d3", "textColor": "", "url": ""}
      ],
      "stops": [
        {"id": "MTS_24151", "code": "24151", "direction": "SW",
         "name": "Eighth College / Theatre District (North)",
         "lat": 32.871718, "lon": -117.242206, "locationType": 0,
         "routeIds": ["MTS_30", "NCTD_301", "UCSD_1040", "UCSD_1020"],
         "wheelchairBoarding": "UNKNOWN"}
      ],
      "trips": [
        {"id": "MTS_19630024", "routeId": "MTS_30", "tripHeadsign": "Old Town",
         "directionId": "1", "serviceId": "MTS_88312-1111100-0",
         "blockId": "MTS_103004", "shapeId": "MTS_30_1_349",
         "routeShortName": "", "timeZone": "", "tripShortName": ""}
      ],
      "situations": []
    }
  }
}
```

- [ ] **Step 2: Write the failing model tests**

`packages/onebusaway/test/models_test.dart`:

```dart
import 'dart:convert';
import 'dart:io';

import 'package:onebusaway/onebusaway.dart';
import 'package:onebusaway/src/core/json.dart';
import 'package:test/test.dart';

JsonMap loadFixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync()) as JsonMap;

void main() {
  final data = loadFixture('arrivals_mts_24151.json')['data'] as JsonMap;
  final entry = StopWithArrivalsAndDepartures.fromJson(data['entry'] as JsonMap);
  final refs = References.fromJson(data['references'] as JsonMap);

  test('entry parses stop id and all arrivals in server order', () {
    expect(entry.stopId, 'MTS_24151');
    expect(entry.nearbyStopIds, ['MTS_24150']);
    expect(entry.arrivalsAndDepartures.map((a) => a.tripHeadsign),
        ['UTC', 'Old Town', 'Inside Loop', 'SIO']);
  });

  test('predicted arrival fields', () {
    final il = entry.arrivalsAndDepartures[2];
    expect(il.routeId, 'UCSD_1040');
    expect(il.routeShortName, 'IL');
    expect(il.predicted, isTrue);
    expect(il.predictedArrivalTime,
        DateTime.fromMillisecondsSinceEpoch(1790228820000, isUtc: true));
    expect(il.scheduledArrivalTime!.millisecondsSinceEpoch, 1790228700000);
    expect(il.stopSequence, 3);
    expect(il.totalStopsInTrip, 12);
    expect(il.blockTripSequence, 4);
    expect(il.vehicleId, 'UCSD_12');
    expect(il.distanceFromStop, 1210.5);
    expect(il.tripStatus!.scheduleDeviation, 120);
    expect(il.tripStatus!.phase, 'in_progress');
    expect(il.frequency, isNull);
  });

  test('scheduled-only arrival: 0 times and "" vehicle become null', () {
    final sio = entry.arrivalsAndDepartures[3];
    expect(sio.predicted, isFalse);
    expect(sio.predictedArrivalTime, isNull);
    expect(sio.vehicleId, isNull);
    expect(sio.tripStatus, isNull);
  });

  test('frequency parses headway in seconds', () {
    final f = Frequency.fromJson(
        {'startTime': 1790200000000, 'endTime': 1790240000000, 'headway': 600});
    expect(f.headway, 600);
    expect(f.startTime.millisecondsSinceEpoch, 1790200000000);
  });

  test('frequency without times is a format error', () {
    expect(() => Frequency.fromJson({'headway': 600}),
        throwsA(isA<ObaFormatException>()));
  });

  group('References', () {
    test('looks up stops, routes, agencies and trips by id', () {
      final stop = refs.stop('MTS_24151')!;
      expect(stop.code, '24151');
      expect(stop.direction, 'SW');
      expect(stop.name, 'Eighth College / Theatre District (North)');
      expect(stop.routeIds, ['MTS_30', 'NCTD_301', 'UCSD_1040', 'UCSD_1020']);
      expect(refs.route('UCSD_1040')!.color, 'ffcd00');
      expect(refs.route('UCSD_1040')!.textColor, isNull); // "" -> null
      expect(refs.route('NCTD_301')!.shortName, '101');
      expect(refs.agency('MTS')!.timezone, 'America/Los_Angeles');
      expect(refs.trip('MTS_19630024')!.blockId, 'MTS_103004');
    });

    test('missing ids return null; null json is empty', () {
      expect(refs.route('nope'), isNull);
      expect(References.fromJson(null).routes, isEmpty);
      expect(References.empty.stop('MTS_24151'), isNull);
    });
  });
}
```

- [ ] **Step 3: Run the tests to see them fail**

Run: `cd packages/onebusaway && mise exec -- dart test test/models_test.dart`
Expected: FAIL with compile errors (`StopWithArrivalsAndDepartures` undefined).

- [ ] **Step 4: Implement the models**

`packages/onebusaway/lib/src/models/agency.dart`:

```dart
import '../core/json.dart';

class Agency {
  const Agency({
    required this.id,
    required this.name,
    this.url,
    this.timezone,
    this.phone,
  });

  factory Agency.fromJson(JsonMap json) => Agency(
        id: readString(json, 'id'),
        name: readString(json, 'name'),
        url: readOptString(json, 'url'),
        timezone: readOptString(json, 'timezone'),
        phone: readOptString(json, 'phone'),
      );

  final String id;
  final String name;
  final String? url;
  final String? timezone;
  final String? phone;
}
```

`packages/onebusaway/lib/src/models/route.dart`:

```dart
import '../core/json.dart';

class Route {
  const Route({
    required this.id,
    required this.agencyId,
    this.shortName,
    this.longName,
    this.description,
    this.type,
    this.color,
    this.textColor,
    this.url,
  });

  factory Route.fromJson(JsonMap json) => Route(
        id: readString(json, 'id'),
        agencyId: readString(json, 'agencyId'),
        shortName: readOptString(json, 'shortName'),
        longName: readOptString(json, 'longName'),
        description: readOptString(json, 'description'),
        type: readOptInt(json, 'type'),
        color: readOptString(json, 'color'),
        textColor: readOptString(json, 'textColor'),
        url: readOptString(json, 'url'),
      );

  final String id;
  final String agencyId;
  final String? shortName;
  final String? longName;
  final String? description;

  /// GTFS route_type (3 = bus).
  final int? type;

  /// GTFS hex color without `#`, possibly lowercase, e.g. `ffcd00`.
  final String? color;
  final String? textColor;
  final String? url;
}
```

`packages/onebusaway/lib/src/models/stop.dart`:

```dart
import '../core/json.dart';

class Stop {
  const Stop({
    required this.id,
    this.code,
    required this.name,
    required this.lat,
    required this.lon,
    this.direction,
    this.routeIds = const [],
    this.wheelchairBoarding,
  });

  factory Stop.fromJson(JsonMap json) => Stop(
        id: readString(json, 'id'),
        code: readOptString(json, 'code'),
        name: readString(json, 'name'),
        lat: readOptDouble(json, 'lat') ?? 0,
        lon: readOptDouble(json, 'lon') ?? 0,
        direction: readOptString(json, 'direction'),
        routeIds: readStringList(json, 'routeIds'),
        wheelchairBoarding: readOptString(json, 'wheelchairBoarding'),
      );

  final String id;

  /// Rider-facing stop number, e.g. `24151`.
  final String? code;
  final String name;
  final double lat;
  final double lon;

  /// Compass direction code such as `SW`, or null.
  final String? direction;
  final List<String> routeIds;
  final String? wheelchairBoarding;
}
```

`packages/onebusaway/lib/src/models/trip.dart`:

```dart
import '../core/json.dart';

class Trip {
  const Trip({
    required this.id,
    required this.routeId,
    this.tripHeadsign,
    this.directionId,
    this.serviceId,
    this.blockId,
    this.shapeId,
  });

  factory Trip.fromJson(JsonMap json) => Trip(
        id: readString(json, 'id'),
        routeId: readString(json, 'routeId'),
        tripHeadsign: readOptString(json, 'tripHeadsign'),
        directionId: readOptString(json, 'directionId'),
        serviceId: readOptString(json, 'serviceId'),
        blockId: readOptString(json, 'blockId'),
        shapeId: readOptString(json, 'shapeId'),
      );

  final String id;
  final String routeId;
  final String? tripHeadsign;
  final String? directionId;
  final String? serviceId;
  final String? blockId;
  final String? shapeId;
}
```

`packages/onebusaway/lib/src/models/frequency.dart`:

```dart
import '../core/errors.dart';
import '../core/json.dart';

class Frequency {
  const Frequency({
    required this.startTime,
    required this.endTime,
    required this.headway,
  });

  factory Frequency.fromJson(JsonMap json) => Frequency(
        startTime: _requireTime(json, 'startTime'),
        endTime: _requireTime(json, 'endTime'),
        headway: readInt(json, 'headway'),
      );

  static DateTime _requireTime(JsonMap json, String key) =>
      readEpochMs(json, key) ??
      (throw ObaFormatException('Missing "$key" in frequency'));

  final DateTime startTime;
  final DateTime endTime;

  /// Seconds between departures.
  final int headway;
}
```

`packages/onebusaway/lib/src/models/trip_status.dart`:

```dart
import '../core/json.dart';

class TripStatus {
  const TripStatus({
    this.status,
    this.phase,
    this.predicted = false,
    this.scheduleDeviation = 0,
    this.vehicleId,
    this.activeTripId,
    this.serviceDate,
  });

  factory TripStatus.fromJson(JsonMap json) => TripStatus(
        status: readOptString(json, 'status'),
        phase: readOptString(json, 'phase'),
        predicted: readBool(json, 'predicted'),
        scheduleDeviation: readOptInt(json, 'scheduleDeviation') ?? 0,
        vehicleId: readOptString(json, 'vehicleId'),
        activeTripId: readOptString(json, 'activeTripId'),
        serviceDate: readEpochMs(json, 'serviceDate'),
      );

  /// e.g. `default` or `CANCELED`.
  final String? status;
  final String? phase;
  final bool predicted;

  /// Seconds; positive means late.
  final int scheduleDeviation;
  final String? vehicleId;
  final String? activeTripId;
  final DateTime? serviceDate;
}
```

`packages/onebusaway/lib/src/models/arrival_and_departure.dart`:

```dart
import '../core/errors.dart';
import '../core/json.dart';
import 'frequency.dart';
import 'trip_status.dart';

class ArrivalAndDeparture {
  const ArrivalAndDeparture({
    required this.routeId,
    required this.tripId,
    required this.serviceDate,
    required this.stopId,
    required this.stopSequence,
    this.totalStopsInTrip,
    this.blockTripSequence,
    this.routeShortName,
    this.routeLongName,
    this.tripHeadsign,
    this.scheduledArrivalTime,
    this.predictedArrivalTime,
    this.scheduledDepartureTime,
    this.predictedDepartureTime,
    this.predicted = false,
    this.arrivalEnabled = true,
    this.departureEnabled = true,
    this.vehicleId,
    this.numberOfStopsAway,
    this.distanceFromStop,
    this.status,
    this.frequency,
    this.tripStatus,
  });

  factory ArrivalAndDeparture.fromJson(JsonMap json) {
    final frequency = readOptMap(json, 'frequency');
    final tripStatus = readOptMap(json, 'tripStatus');
    return ArrivalAndDeparture(
      routeId: readString(json, 'routeId'),
      tripId: readString(json, 'tripId'),
      serviceDate: readEpochMs(json, 'serviceDate') ??
          (throw const ObaFormatException('Missing "serviceDate"')),
      stopId: readString(json, 'stopId'),
      stopSequence: readInt(json, 'stopSequence'),
      totalStopsInTrip: readOptInt(json, 'totalStopsInTrip'),
      blockTripSequence: readOptInt(json, 'blockTripSequence'),
      routeShortName: readOptString(json, 'routeShortName'),
      routeLongName: readOptString(json, 'routeLongName'),
      tripHeadsign: readOptString(json, 'tripHeadsign'),
      scheduledArrivalTime: readEpochMs(json, 'scheduledArrivalTime'),
      predictedArrivalTime: readEpochMs(json, 'predictedArrivalTime'),
      scheduledDepartureTime: readEpochMs(json, 'scheduledDepartureTime'),
      predictedDepartureTime: readEpochMs(json, 'predictedDepartureTime'),
      predicted: readBool(json, 'predicted'),
      arrivalEnabled: readBool(json, 'arrivalEnabled', defaultValue: true),
      departureEnabled: readBool(json, 'departureEnabled', defaultValue: true),
      vehicleId: readOptString(json, 'vehicleId'),
      numberOfStopsAway: readOptInt(json, 'numberOfStopsAway'),
      distanceFromStop: readOptDouble(json, 'distanceFromStop'),
      status: readOptString(json, 'status'),
      frequency: frequency == null ? null : Frequency.fromJson(frequency),
      tripStatus: tripStatus == null ? null : TripStatus.fromJson(tripStatus),
    );
  }

  final String routeId;
  final String tripId;
  final DateTime serviceDate;
  final String stopId;

  /// Zero-based index of this stop in the trip.
  final int stopSequence;
  final int? totalStopsInTrip;
  final int? blockTripSequence;
  final String? routeShortName;
  final String? routeLongName;
  final String? tripHeadsign;
  final DateTime? scheduledArrivalTime;
  final DateTime? predictedArrivalTime;
  final DateTime? scheduledDepartureTime;
  final DateTime? predictedDepartureTime;

  /// True when real-time data is available for this trip.
  final bool predicted;
  final bool arrivalEnabled;
  final bool departureEnabled;
  final String? vehicleId;
  final int? numberOfStopsAway;
  final double? distanceFromStop;
  final String? status;
  final Frequency? frequency;
  final TripStatus? tripStatus;
}
```

`packages/onebusaway/lib/src/models/stop_with_arrivals_and_departures.dart`:

```dart
import '../core/json.dart';
import 'arrival_and_departure.dart';

class StopWithArrivalsAndDepartures {
  const StopWithArrivalsAndDepartures({
    required this.stopId,
    this.arrivalsAndDepartures = const [],
    this.nearbyStopIds = const [],
    this.situationIds = const [],
  });

  factory StopWithArrivalsAndDepartures.fromJson(JsonMap json) =>
      StopWithArrivalsAndDepartures(
        stopId: readString(json, 'stopId'),
        arrivalsAndDepartures: readList(
          json,
          'arrivalsAndDepartures',
          (item) => ArrivalAndDeparture.fromJson(
              asJsonMap(item, 'arrivalsAndDepartures[]')),
        ),
        nearbyStopIds: readStringList(json, 'nearbyStopIds'),
        situationIds: readStringList(json, 'situationIds'),
      );

  final String stopId;

  /// In server order.
  final List<ArrivalAndDeparture> arrivalsAndDepartures;
  final List<String> nearbyStopIds;
  final List<String> situationIds;
}
```

`packages/onebusaway/lib/src/core/references.dart`:

```dart
import '../models/agency.dart';
import '../models/route.dart';
import '../models/stop.dart';
import '../models/trip.dart';
import 'json.dart';

/// The `references` block shared by every OBA response, indexed by id.
///
/// Note: `routes` can include routes that don't serve the requested stop;
/// filter by `Stop.routeIds` when you need the stop's routes.
class References {
  const References({
    this.agencies = const {},
    this.routes = const {},
    this.stops = const {},
    this.trips = const {},
  });

  factory References.fromJson(JsonMap? json) {
    if (json == null) return empty;
    Map<String, T> index<T>(
      String key,
      T Function(JsonMap) parse,
      String Function(T) id,
    ) =>
        {
          for (final item in readList(
              json, key, (v) => parse(asJsonMap(v, '$key[]'))))
            id(item): item,
        };
    return References(
      agencies: index('agencies', Agency.fromJson, (a) => a.id),
      routes: index('routes', Route.fromJson, (r) => r.id),
      stops: index('stops', Stop.fromJson, (s) => s.id),
      trips: index('trips', Trip.fromJson, (t) => t.id),
    );
  }

  static const References empty = References();

  final Map<String, Agency> agencies;
  final Map<String, Route> routes;
  final Map<String, Stop> stops;
  final Map<String, Trip> trips;

  Agency? agency(String id) => agencies[id];
  Route? route(String id) => routes[id];
  Stop? stop(String id) => stops[id];
  Trip? trip(String id) => trips[id];
}
```

Replace `packages/onebusaway/lib/onebusaway.dart` with:

```dart
/// A Dart client for the OneBusAway REST API.
library;

export 'src/core/errors.dart';
export 'src/core/references.dart';
export 'src/models/agency.dart';
export 'src/models/arrival_and_departure.dart';
export 'src/models/frequency.dart';
export 'src/models/route.dart';
export 'src/models/stop.dart';
export 'src/models/stop_with_arrivals_and_departures.dart';
export 'src/models/trip.dart';
export 'src/models/trip_status.dart';
```

- [ ] **Step 5: Run the tests to see them pass**

Run: `cd packages/onebusaway && mise exec -- dart test && mise exec -- dart analyze`
Expected: all tests pass, and "No issues found!"

- [ ] **Step 6: Commit**

```bash
git add packages/onebusaway
git commit -m "Add onebusaway models and references"
```

---

### Task 3: Transport, responses, client, arrivals resource, README

**Files:**
- Create: `packages/onebusaway/lib/src/core/responses.dart`
- Create: `packages/onebusaway/lib/src/core/transport.dart`
- Create: `packages/onebusaway/lib/src/resources/arrivals_and_departures.dart`
- Create: `packages/onebusaway/lib/src/client.dart`
- Create: `packages/onebusaway/test/fixtures/error_envelope.json`
- Create: `packages/onebusaway/test/fixtures/arrivals_live.json` (captured)
- Create: `packages/onebusaway/README.md`
- Modify: `packages/onebusaway/lib/onebusaway.dart`
- Test: `packages/onebusaway/test/transport_test.dart`
- Test: `packages/onebusaway/test/client_test.dart`

**Interfaces:**
- Consumes: the Task 1 errors/helpers and the Task 2 models/References.
- Produces:
  - `class ObaEntryResponse<T> { final T entry; final References references; final DateTime currentTime; final int version; }`
  - `class ObaListResponse<T> { final List<T> list; final References references; final DateTime currentTime; final int version; final bool limitExceeded; final bool outOfRange; }`
  - `class ObaEnvelope`, with:
    - `DateTime currentTime`, `int version`, `JsonMap data`;
    - `ObaEntryResponse<T> toEntry<T>(T Function(JsonMap) parse)`;
    - `ObaListResponse<T> toList<T>(T Function(JsonMap) parse)`.
  - `class Transport`, with:
    - `Transport({required Uri baseUrl, required String apiKey, required http.Client httpClient, required Duration timeout})`;
    - `Uri buildUri(String method, {String? id, Map<String, String> params = const {}})`;
    - `Future<ObaEnvelope> get(String method, {String? id, Map<String, String> params = const {}})`;
    - `static ObaEnvelope decode(http.Response response)`.
  - `class ArrivalsAndDeparturesResource { Future<ObaEntryResponse<StopWithArrivalsAndDepartures>> forStop(String stopId, {int? minutesBefore, int? minutesAfter, DateTime? time}); }`
  - `class OneBusAwayClient`, with:
    - `OneBusAwayClient({required Uri baseUrl, required String apiKey, http.Client? httpClient, Duration timeout = const Duration(seconds: 15)})`;
    - `final ArrivalsAndDeparturesResource arrivalsAndDepartures`;
    - `void close()`.
  - The public exports add `ObaEntryResponse`, `ObaListResponse`,
    `ArrivalsAndDeparturesResource` and `OneBusAwayClient`. `Transport` and
    `ObaEnvelope` stay internal, under `src/`.

- [ ] **Step 1: Create the error fixture and capture a live fixture**

`packages/onebusaway/test/fixtures/error_envelope.json`:

```json
{"code": 401, "currentTime": 1790228579290, "text": "permission denied", "version": 2}
```

Run from the repo root:

```bash
curl -sf "https://realtime.sdmts.com/api/api/where/arrivals-and-departures-for-stop/MTS_24151.json?key=org.onebusaway.iphone&minutesAfter=120" \
  | python3 -m json.tool > packages/onebusaway/test/fixtures/arrivals_live.json
head -c 200 packages/onebusaway/test/fixtures/arrivals_live.json
```

Expected: the output begins with `{` and contains `"code": 200`. It's fine if
the arrivals list is empty outside service hours. The test only checks that
real server output parses.

- [ ] **Step 2: Write the failing transport tests**

`packages/onebusaway/test/transport_test.dart`:

```dart
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onebusaway/onebusaway.dart';
import 'package:onebusaway/src/core/transport.dart';
import 'package:test/test.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

Transport transportWith(MockClient client,
        {String base = 'https://realtime.sdmts.com/api/',
        Duration timeout = const Duration(seconds: 15)}) =>
    Transport(
      baseUrl: Uri.parse(base),
      apiKey: 'org.onebusaway.iphone',
      httpClient: client,
      timeout: timeout,
    );

void main() {
  final unused = MockClient((_) async => http.Response('', 500));

  group('buildUri', () {
    test('uses the SDMTS server root + api/where', () {
      final uri = transportWith(unused).buildUri(
        'arrivals-and-departures-for-stop',
        id: 'MTS_24151',
      );
      expect(
        uri.toString(),
        'https://realtime.sdmts.com/api/api/where/arrivals-and-departures-for-stop/MTS_24151.json?key=org.onebusaway.iphone',
      );
    });

    test('adds a missing trailing slash to baseUrl', () {
      final uri = transportWith(unused, base: 'https://realtime.sdmts.com/api')
          .buildUri('current-time');
      expect(uri.toString(),
          'https://realtime.sdmts.com/api/api/where/current-time.json?key=org.onebusaway.iphone');
    });

    test('encodes the id and appends params', () {
      final uri = transportWith(unused)
          .buildUri('stop', id: 'A B/1', params: {'minutesAfter': '60'});
      expect(uri.path, '/api/api/where/stop/A%20B%2F1.json');
      expect(uri.queryParameters,
          {'key': 'org.onebusaway.iphone', 'minutesAfter': '60'});
    });
  });

  group('decoding order', () {
    Future<Object?> errorFor(http.Response response) async {
      try {
        await transportWith(MockClient((_) async => response)).get('stop', id: 'X');
        return null;
      } catch (e) {
        return e;
      }
    }

    test('1. non-2xx is httpStatus and the HTML body is not parsed', () async {
      final e = await errorFor(
          http.Response('<!DOCTYPE html><html>404</html>', 404));
      expect(e, isA<ObaApiException>()
          .having((e) => e.kind, 'kind', ObaApiErrorKind.httpStatus)
          .having((e) => e.code, 'code', 404));
    });

    test('2. empty 200 body is emptyResponse', () async {
      final e = await errorFor(http.Response('', 200));
      expect(e, isA<ObaApiException>()
          .having((e) => e.kind, 'kind', ObaApiErrorKind.emptyResponse));
    });

    test('3. non-JSON 200 body is ObaFormatException', () async {
      expect(await errorFor(http.Response('not json', 200)),
          isA<ObaFormatException>());
    });

    test('4. envelope code != 200 is envelope error with text', () async {
      final e = await errorFor(http.Response(fixture('error_envelope.json'), 200));
      expect(e, isA<ObaApiException>()
          .having((e) => e.kind, 'kind', ObaApiErrorKind.envelope)
          .having((e) => e.code, 'code', 401)
          .having((e) => e.text, 'text', 'permission denied'));
    });

    test('network failure is ObaNetworkException', () async {
      final client = MockClient((_) async => throw http.ClientException('boom'));
      await expectLater(transportWith(client).get('stop', id: 'X'),
          throwsA(isA<ObaNetworkException>()));
    });

    test('timeout is ObaNetworkException', () async {
      final never = Completer<http.Response>();
      final client = MockClient((_) => never.future);
      await expectLater(
        transportWith(client, timeout: const Duration(milliseconds: 20))
            .get('stop', id: 'X'),
        throwsA(isA<ObaNetworkException>()),
      );
    });

    test('success exposes currentTime, version and data', () async {
      final client = MockClient(
          (_) async => http.Response(fixture('arrivals_mts_24151.json'), 200));
      final envelope = await transportWith(client).get('x');
      expect(envelope.currentTime.millisecondsSinceEpoch, 1790228579290);
      expect(envelope.currentTime.isUtc, isTrue);
      expect(envelope.version, 2);
      expect(envelope.data.containsKey('entry'), isTrue);
    });

    test('toList parses list responses and flags', () {
      final envelope = Transport.decode(http.Response(
          '{"code":200,"currentTime":1,"text":"OK","version":2,'
          '"data":{"list":[{"id":"MTS","name":"MTS"}],"limitExceeded":true,'
          '"outOfRange":false,"references":{}}}',
          200));
      final list = envelope.toList(Agency.fromJson);
      expect(list.list.single.id, 'MTS');
      expect(list.limitExceeded, isTrue);
      expect(list.outOfRange, isFalse);
    });
  });
}
```

- [ ] **Step 3: Write the failing client tests**

`packages/onebusaway/test/client_test.dart`:

```dart
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onebusaway/onebusaway.dart';
import 'package:test/test.dart';

String fixture(String name) => File('test/fixtures/$name').readAsStringSync();

void main() {
  test('arrivalsAndDepartures.forStop builds the request and parses the entry',
      () async {
    late Uri requested;
    final client = OneBusAwayClient(
      baseUrl: Uri.parse('https://realtime.sdmts.com/api/'),
      apiKey: 'org.onebusaway.iphone',
      httpClient: MockClient((request) async {
        requested = request.url;
        return http.Response(fixture('arrivals_mts_24151.json'), 200,
            headers: {'content-type': 'application/json'});
      }),
    );

    final response = await client.arrivalsAndDepartures.forStop(
      'MTS_24151',
      minutesBefore: 0,
      minutesAfter: 60,
      time: DateTime.fromMillisecondsSinceEpoch(1790228579290, isUtc: true),
    );

    expect(requested.path,
        '/api/api/where/arrivals-and-departures-for-stop/MTS_24151.json');
    expect(requested.queryParameters, {
      'key': 'org.onebusaway.iphone',
      'minutesBefore': '0',
      'minutesAfter': '60',
      'time': '1790228579290',
    });
    expect(response.entry.stopId, 'MTS_24151');
    expect(response.entry.arrivalsAndDepartures, hasLength(4));
    expect(response.references.stop('MTS_24151')!.code, '24151');
    expect(response.currentTime.millisecondsSinceEpoch, 1790228579290);
  });

  test('omits optional params that were not given', () async {
    late Uri requested;
    final client = OneBusAwayClient(
      baseUrl: Uri.parse('https://example.org/'),
      apiKey: 'k',
      httpClient: MockClient((request) async {
        requested = request.url;
        return http.Response(fixture('arrivals_mts_24151.json'), 200);
      }),
    );
    await client.arrivalsAndDepartures.forStop('MTS_24151');
    expect(requested.queryParameters, {'key': 'k'});
  });

  test('parses a live SDMTS response', () async {
    final client = OneBusAwayClient(
      baseUrl: Uri.parse('https://realtime.sdmts.com/api/'),
      apiKey: 'k',
      httpClient:
          MockClient((_) async => http.Response(fixture('arrivals_live.json'), 200)),
    );
    final response = await client.arrivalsAndDepartures.forStop('MTS_24151');
    expect(response.entry.stopId, 'MTS_24151');
    expect(response.references.stop('MTS_24151'), isNotNull);
  });

  test('close() closes only an http client it created', () {
    var closed = false;
    final injected = _TrackingClient(() => closed = true);
    OneBusAwayClient(baseUrl: Uri.parse('https://x/'), apiKey: 'k', httpClient: injected)
        .close();
    expect(closed, isFalse);
  });
}

class _TrackingClient extends http.BaseClient {
  _TrackingClient(this.onClose);
  final void Function() onClose;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) =>
      throw UnimplementedError();

  @override
  void close() => onClose();
}
```

- [ ] **Step 4: Run the tests to see them fail**

Run: `cd packages/onebusaway && mise exec -- dart test test/transport_test.dart test/client_test.dart`
Expected: FAIL with compile errors (`Transport` / `OneBusAwayClient` undefined).

- [ ] **Step 5: Implement responses, transport, resource and client**

`packages/onebusaway/lib/src/core/responses.dart`:

```dart
import 'references.dart';

/// A response whose `data` holds a single `entry`.
class ObaEntryResponse<T> {
  const ObaEntryResponse({
    required this.entry,
    required this.references,
    required this.currentTime,
    required this.version,
  });

  final T entry;
  final References references;

  /// The server's clock when it answered. Use it to correct device clock skew.
  final DateTime currentTime;
  final int version;
}

/// A response whose `data` holds a `list`.
class ObaListResponse<T> {
  const ObaListResponse({
    required this.list,
    required this.references,
    required this.currentTime,
    required this.version,
    required this.limitExceeded,
    required this.outOfRange,
  });

  final List<T> list;
  final References references;
  final DateTime currentTime;
  final int version;
  final bool limitExceeded;
  final bool outOfRange;
}
```

`packages/onebusaway/lib/src/core/transport.dart`:

```dart
import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'errors.dart';
import 'json.dart';
import 'references.dart';
import 'responses.dart';

/// A decoded, successful (`code == 200`) OBA response envelope.
class ObaEnvelope {
  const ObaEnvelope({
    required this.currentTime,
    required this.version,
    required this.data,
  });

  final DateTime currentTime;
  final int version;
  final JsonMap data;

  ObaEntryResponse<T> toEntry<T>(T Function(JsonMap json) parse) =>
      ObaEntryResponse(
        entry: parse(readMap(data, 'entry')),
        references: References.fromJson(readOptMap(data, 'references')),
        currentTime: currentTime,
        version: version,
      );

  ObaListResponse<T> toList<T>(T Function(JsonMap json) parse) =>
      ObaListResponse(
        list: readList(data, 'list', (item) => parse(asJsonMap(item, 'list[]'))),
        references: References.fromJson(readOptMap(data, 'references')),
        currentTime: currentTime,
        version: version,
        limitExceeded: readBool(data, 'limitExceeded'),
        outOfRange: readBool(data, 'outOfRange'),
      );
}

/// Builds OBA URLs, performs GETs and decodes the shared envelope.
/// Every resource class goes through this; endpoints never touch HTTP directly.
class Transport {
  Transport({
    required Uri baseUrl,
    required this.apiKey,
    required this.httpClient,
    required this.timeout,
  }) : baseUrl = baseUrl.path.endsWith('/')
            ? baseUrl
            : baseUrl.replace(path: '${baseUrl.path}/');

  /// The OBA server root; endpoints live under `{baseUrl}api/where/`.
  final Uri baseUrl;
  final String apiKey;
  final http.Client httpClient;
  final Duration timeout;

  Uri buildUri(
    String method, {
    String? id,
    Map<String, String> params = const {},
  }) {
    final file = id == null
        ? '$method.json'
        : '$method/${Uri.encodeComponent(id)}.json';
    return baseUrl
        .resolve('api/where/$file')
        .replace(queryParameters: {'key': apiKey, ...params});
  }

  Future<ObaEnvelope> get(
    String method, {
    String? id,
    Map<String, String> params = const {},
  }) async {
    final uri = buildUri(method, id: id, params: params);
    final http.Response response;
    try {
      // Note: the timeout stops waiting but does not abort the request.
      response = await httpClient
          .get(uri, headers: const {'Accept': 'application/json'})
          .timeout(timeout);
    } on TimeoutException catch (e) {
      throw ObaNetworkException(e);
    } on http.ClientException catch (e) {
      throw ObaNetworkException(e);
    }
    return decode(response);
  }

  static ObaEnvelope decode(http.Response response) {
    final status = response.statusCode;
    if (status < 200 || status >= 300) {
      throw ObaApiException(ObaApiErrorKind.httpStatus, code: status);
    }
    final Object? decoded;
    try {
      final body = utf8.decode(response.bodyBytes);
      if (body.trim().isEmpty) {
        throw const ObaApiException(ObaApiErrorKind.emptyResponse);
      }
      decoded = jsonDecode(body);
    } on FormatException catch (e) {
      throw ObaFormatException('Response is not valid JSON: ${e.message}');
    }
    final json = asJsonMap(decoded, 'response');
    final code = readInt(json, 'code');
    if (code != 200) {
      throw ObaApiException(ObaApiErrorKind.envelope,
          code: code, text: readOptString(json, 'text'));
    }
    return ObaEnvelope(
      currentTime: readEpochMs(json, 'currentTime') ??
          (throw const ObaFormatException('Missing "currentTime"')),
      version: readOptInt(json, 'version') ?? 1,
      data: readMap(json, 'data'),
    );
  }
}
```

`packages/onebusaway/lib/src/resources/arrivals_and_departures.dart`:

```dart
import '../core/responses.dart';
import '../core/transport.dart';
import '../models/stop_with_arrivals_and_departures.dart';

/// `arrivals-and-departures-for-stop` and (later) related endpoints.
class ArrivalsAndDeparturesResource {
  ArrivalsAndDeparturesResource(this._transport);

  final Transport _transport;

  /// Real-time arrivals and departures for [stopId].
  ///
  /// [minutesBefore] / [minutesAfter] widen the window (server defaults 5 / 35).
  /// [time] queries the system as of that instant instead of "now".
  Future<ObaEntryResponse<StopWithArrivalsAndDepartures>> forStop(
    String stopId, {
    int? minutesBefore,
    int? minutesAfter,
    DateTime? time,
  }) async {
    final envelope = await _transport.get(
      'arrivals-and-departures-for-stop',
      id: stopId,
      params: {
        if (minutesBefore != null) 'minutesBefore': '$minutesBefore',
        if (minutesAfter != null) 'minutesAfter': '$minutesAfter',
        if (time != null) 'time': '${time.millisecondsSinceEpoch}',
      },
    );
    return envelope.toEntry(StopWithArrivalsAndDepartures.fromJson);
  }
}
```

`packages/onebusaway/lib/src/client.dart`:

```dart
import 'package:http/http.dart' as http;

import 'core/transport.dart';
import 'resources/arrivals_and_departures.dart';

/// Entry point to the OneBusAway REST API.
///
/// ```dart
/// final client = OneBusAwayClient(
///   baseUrl: Uri.parse('https://realtime.sdmts.com/api/'), // server root
///   apiKey: 'org.onebusaway.iphone',
/// );
/// final r = await client.arrivalsAndDepartures.forStop('MTS_24151');
/// ```
class OneBusAwayClient {
  factory OneBusAwayClient({
    required Uri baseUrl,
    required String apiKey,
    http.Client? httpClient,
    Duration timeout = const Duration(seconds: 15),
  }) {
    final client = httpClient ?? http.Client();
    return OneBusAwayClient._(
      Transport(
        baseUrl: baseUrl,
        apiKey: apiKey,
        httpClient: client,
        timeout: timeout,
      ),
      ownsHttpClient: httpClient == null,
    );
  }

  OneBusAwayClient._(this._transport, {required bool ownsHttpClient})
      : _ownsHttpClient = ownsHttpClient,
        arrivalsAndDepartures = ArrivalsAndDeparturesResource(_transport);

  final Transport _transport;
  final bool _ownsHttpClient;

  final ArrivalsAndDeparturesResource arrivalsAndDepartures;

  /// Closes the underlying HTTP client if this instance created it.
  void close() {
    if (_ownsHttpClient) _transport.httpClient.close();
  }
}
```

Add to the exports in `packages/onebusaway/lib/onebusaway.dart`, keeping the
list alphabetical:

```dart
export 'src/client.dart';
export 'src/core/responses.dart';
export 'src/resources/arrivals_and_departures.dart';
```

- [ ] **Step 6: Run the tests to see them pass**

Run: `cd packages/onebusaway && mise exec -- dart test && mise exec -- dart analyze`
Expected: all tests pass, and "No issues found!"

- [ ] **Step 7: Write the package README**

`packages/onebusaway/README.md`:

````markdown
# onebusaway

A pure-Dart client for the [OneBusAway REST API](https://developer.onebusaway.org/api/where).
It has no Flutter dependency.

## Install (git dependency)

```yaml
dependencies:
  onebusaway:
    git:
      url: <this repository>
      path: packages/onebusaway
```

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
````

- [ ] **Step 8: Commit**

```bash
git add packages/onebusaway
git commit -m "Add onebusaway transport, client and arrivals-and-departures resource"
```

---

### Task 4: `oba_arrivals` skeleton, strings and display logic

**Files:**
- Create: `packages/oba_arrivals/analysis_options.yaml`
- Create: `packages/oba_arrivals/dart_test.yaml`
- Create: `packages/oba_arrivals/lib/oba_arrivals.dart`
- Create: `packages/oba_arrivals/lib/src/strings.dart`
- Create: `packages/oba_arrivals/lib/src/display/arrival_display.dart`
- Create: `packages/oba_arrivals/lib/src/display/arrival_filtering.dart`
- Create: `packages/oba_arrivals/lib/src/display/stop_display.dart`
- Test: `packages/oba_arrivals/test/display_test.dart`
- Test: `packages/oba_arrivals/test/filtering_test.dart`
- Test: `packages/oba_arrivals/test/stop_display_test.dart`

(`packages/oba_arrivals/pubspec.yaml` already exists from Task 1.)

**Interfaces:**
- Consumes: from `package:onebusaway/onebusaway.dart`, the classes
  `ArrivalAndDeparture`, `Frequency`, `TripStatus`, `Stop`, `Route` and
  `References`.
- Produces:
  - `class ObaArrivalsStrings { const ObaArrivalsStrings(); … }`. Its members
    are listed in Step 3.
  - `enum ArrivalStatusKind { onTime, late, early, scheduled, canceled }`
  - Display functions:
    - `bool hasPrediction(ArrivalAndDeparture a)`
    - `DateTime? displayTime(ArrivalAndDeparture a)`
    - `int? minutesUntil(ArrivalAndDeparture a, DateTime now)`
    - `int? delayMinutes(ArrivalAndDeparture a)`
    - `bool isCanceled(ArrivalAndDeparture a)`
    - `ArrivalStatusKind statusKind(ArrivalAndDeparture a)`
    - `String statusText(ArrivalAndDeparture a, DateTime now, ObaArrivalsStrings strings, {required String Function(DateTime) formatTime})`
    - `String etaLabel(int eta, ObaArrivalsStrings strings)`
  - Filtering functions:
    - `List<ArrivalAndDeparture> filterDeparted(List<ArrivalAndDeparture> arrivals, DateTime now)`
    - `List<ArrivalAndDeparture> collapseLayovers(List<ArrivalAndDeparture> arrivals)`
    - `List<ArrivalAndDeparture> visibleArrivals(List<ArrivalAndDeparture> raw, DateTime now)`
  - Stop display functions:
    - `String stripAgencyPrefix(String id)`
    - `List<String> routeShortNamesForStop(Stop stop, References refs)`
    - `String stopSubtitle(Stop stop, References refs, ObaArrivalsStrings strings)`

- [ ] **Step 1: Create package config files**

`packages/oba_arrivals/analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml
```

`packages/oba_arrivals/dart_test.yaml`:

```yaml
tags:
  golden:
```

`packages/oba_arrivals/lib/oba_arrivals.dart` (it grows in later tasks):

```dart
/// Embeddable OneBusAway arrivals and departures panel.
library;

export 'src/display/arrival_display.dart';
export 'src/display/arrival_filtering.dart';
export 'src/display/stop_display.dart';
export 'src/strings.dart';
```

- [ ] **Step 2: Write the failing display, filtering and stop tests**

`packages/oba_arrivals/test/display_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:onebusaway/onebusaway.dart';

DateTime t(int hour, int minute, [int second = 0]) =>
    DateTime.utc(2026, 9, 24, hour, minute, second);

ArrivalAndDeparture arrival({
  DateTime? scheduled,
  DateTime? predictedTime,
  bool predicted = false,
  Frequency? frequency,
  TripStatus? tripStatus,
}) =>
    ArrivalAndDeparture(
      routeId: 'R',
      tripId: 'T',
      serviceDate: DateTime.utc(2026, 9, 24),
      stopId: 'S',
      stopSequence: 1,
      scheduledArrivalTime: scheduled,
      predictedArrivalTime: predictedTime,
      predicted: predicted,
      frequency: frequency,
      tripStatus: tripStatus,
    );

String fmt(DateTime d) => '${d.hour}:${d.minute.toString().padLeft(2, '0')}';

void main() {
  const strings = ObaArrivalsStrings();
  final now = t(13, 50, 40);

  group('minutesUntil', () {
    test('uses predicted time when predicted, flooring to minutes', () {
      final a = arrival(
          scheduled: t(13, 51), predictedTime: t(13, 53, 59), predicted: true);
      expect(minutesUntil(a, now), 3); // 13:53 - 13:50
    });

    test('falls back to scheduled when not predicted', () {
      final a = arrival(scheduled: t(13, 58), predictedTime: t(13, 59));
      expect(minutesUntil(a, now), 8);
    });

    test('falls back to scheduled when predicted but no predicted time', () {
      final a = arrival(scheduled: t(13, 58), predicted: true);
      expect(minutesUntil(a, now), 8);
      expect(hasPrediction(a), isFalse);
    });

    test('same minute is 0, past is negative, no times is null', () {
      expect(minutesUntil(arrival(scheduled: t(13, 50, 5)), now), 0);
      expect(minutesUntil(arrival(scheduled: t(13, 47)), now), -3);
      expect(minutesUntil(arrival(), now), isNull);
    });
  });

  group('status', () {
    ArrivalAndDeparture withDelay(int minutes) => arrival(
        scheduled: t(14, 0),
        predictedTime: t(14, 0).add(Duration(minutes: minutes)),
        predicted: true);

    test('late', () {
      expect(delayMinutes(withDelay(4)), 4);
      expect(statusKind(withDelay(4)), ArrivalStatusKind.late);
      expect(statusText(withDelay(4), now, strings, formatTime: fmt), '4 min late');
    });

    test('1 min early: early text but on-time color (matches Wayfinder)', () {
      expect(statusText(withDelay(-1), now, strings, formatTime: fmt), '1 min early');
      expect(statusKind(withDelay(-1)), ArrivalStatusKind.onTime);
    });

    test('2 min early: early text and early color', () {
      expect(statusText(withDelay(-2), now, strings, formatTime: fmt), '2 min early');
      expect(statusKind(withDelay(-2)), ArrivalStatusKind.early);
    });

    test('on time', () {
      expect(statusText(withDelay(0), now, strings, formatTime: fmt), 'on time');
      expect(statusKind(withDelay(0)), ArrivalStatusKind.onTime);
    });

    test('scheduled only', () {
      final a = arrival(scheduled: t(14, 0));
      expect(delayMinutes(a), isNull);
      expect(statusKind(a), ArrivalStatusKind.scheduled);
      expect(statusText(a, now, strings, formatTime: fmt), 'scheduled');
    });

    test('canceled via tripStatus wins over everything', () {
      final a = arrival(
          scheduled: t(14, 0),
          predictedTime: t(14, 5),
          predicted: true,
          tripStatus: const TripStatus(status: 'CANCELED'));
      expect(isCanceled(a), isTrue);
      expect(statusKind(a), ArrivalStatusKind.canceled);
      expect(statusText(a, now, strings, formatTime: fmt), 'canceled');
    });

    test('frequency: headway seconds -> minutes, from/until', () {
      final before = arrival(
          scheduled: t(14, 0),
          frequency: Frequency(startTime: t(14, 0), endTime: t(18, 0), headway: 600));
      expect(statusText(before, now, strings, formatTime: fmt), 'every 10 min from 14:00');
      final during = arrival(
          scheduled: t(14, 0),
          frequency: Frequency(startTime: t(13, 0), endTime: t(18, 0), headway: 450));
      expect(statusText(during, now, strings, formatTime: fmt), 'every 7 min until 18:00');
    });
  });

  test('displayTime prefers predicted when predicted', () {
    expect(displayTime(arrival(scheduled: t(14, 0), predictedTime: t(14, 2), predicted: true)),
        t(14, 2));
    expect(displayTime(arrival(scheduled: t(14, 0), predictedTime: t(14, 2))), t(14, 0));
  });

  test('etaLabel', () {
    expect(etaLabel(0, strings), 'now');
    expect(etaLabel(13, strings), '13m');
  });
}
```

`packages/oba_arrivals/test/filtering_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:onebusaway/onebusaway.dart';

final serviceDate = DateTime.utc(2026, 9, 24);
final now = DateTime.utc(2026, 9, 24, 14, 0);

ArrivalAndDeparture a(
  String trip, {
  required int minutesFromNow,
  int stopSequence = 3,
  int? totalStopsInTrip = 10,
  int? blockTripSequence,
  String? vehicleId,
}) =>
    ArrivalAndDeparture(
      routeId: 'R',
      tripId: trip,
      serviceDate: serviceDate,
      stopId: 'S',
      stopSequence: stopSequence,
      totalStopsInTrip: totalStopsInTrip,
      blockTripSequence: blockTripSequence,
      vehicleId: vehicleId,
      scheduledArrivalTime: now.add(Duration(minutes: minutesFromNow)),
    );

void main() {
  test('filterDeparted drops negative ETAs and rows without times', () {
    final rows = [
      a('past', minutesFromNow: -1),
      a('now', minutesFromNow: 0),
      a('soon', minutesFromNow: 5),
      ArrivalAndDeparture(
          routeId: 'R', tripId: 'none', serviceDate: serviceDate, stopId: 'S', stopSequence: 1),
    ];
    expect(filterDeparted(rows, now).map((r) => r.tripId), ['now', 'soon']);
  });

  group('collapseLayovers', () {
    final arrivalAtEnd = a('t1',
        minutesFromNow: 2, stopSequence: 9, blockTripSequence: 4, vehicleId: 'V1');
    final departureNext = a('t2',
        minutesFromNow: 6, stopSequence: 0, blockTripSequence: 5, vehicleId: 'V1');

    test('drops the final-stop arrival when the same vehicle departs next', () {
      expect(collapseLayovers([arrivalAtEnd, departureNext]).map((r) => r.tripId), ['t2']);
    });

    test('keeps it when vehicle differs', () {
      final other = a('t2',
          minutesFromNow: 6, stopSequence: 0, blockTripSequence: 5, vehicleId: 'V2');
      expect(collapseLayovers([arrivalAtEnd, other]), hasLength(2));
    });

    test('keeps it when block sequence is not +1', () {
      final later = a('t2',
          minutesFromNow: 6, stopSequence: 0, blockTripSequence: 6, vehicleId: 'V1');
      expect(collapseLayovers([arrivalAtEnd, later]), hasLength(2));
    });

    test('keeps it without a vehicle id', () {
      final noVehicle =
          a('t1', minutesFromNow: 2, stopSequence: 9, blockTripSequence: 4);
      expect(collapseLayovers([noVehicle, departureNext]), hasLength(2));
    });
  });

  test('visibleArrivals filters then collapses and keeps server order', () {
    final rows = [
      a('late-in-list', minutesFromNow: 9),
      a('gone', minutesFromNow: -2),
      a('early-in-list', minutesFromNow: 1),
    ];
    expect(visibleArrivals(rows, now).map((r) => r.tripId),
        ['late-in-list', 'early-in-list']);
  });
}
```

`packages/oba_arrivals/test/stop_display_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:onebusaway/onebusaway.dart';

void main() {
  const strings = ObaArrivalsStrings();
  const refs = References(routes: {
    'MTS_30': Route(id: 'MTS_30', agencyId: 'MTS', shortName: '30'),
    'NCTD_301': Route(id: 'NCTD_301', agencyId: 'NCTD', shortName: '101'),
    'UCSD_1040': Route(id: 'UCSD_1040', agencyId: 'UCSD', shortName: 'IL'),
    'UCSD_1020': Route(id: 'UCSD_1020', agencyId: 'UCSD', shortName: 'S'),
    'MTS_201': Route(id: 'MTS_201', agencyId: 'MTS', shortName: '201'),
    'UCSD_9': Route(id: 'UCSD_9', agencyId: 'UCSD'),
  });

  const stop = Stop(
    id: 'MTS_24151',
    code: '24151',
    name: 'Eighth College / Theatre District (North)',
    lat: 0,
    lon: 0,
    direction: 'SW',
    routeIds: ['MTS_30', 'NCTD_301', 'UCSD_1040', 'UCSD_1020'],
  );

  test('subtitle matches Wayfinder: only routes serving the stop, sorted', () {
    expect(stopSubtitle(stop, refs, strings),
        'Stop #24151 · Southwest bound · 101, 30, IL, S');
  });

  test('falls back to id without agency prefix; omits empty direction', () {
    const s = Stop(id: 'MTS_99', name: 'X', lat: 0, lon: 0, routeIds: ['UCSD_9']);
    expect(stopSubtitle(s, refs, strings), 'Stop #99 · 9');
  });

  test('unknown direction code is shown as-is', () {
    const s = Stop(id: 'A_1', code: '1', name: 'X', lat: 0, lon: 0, direction: 'NNW');
    expect(stopSubtitle(s, refs, strings), 'Stop #1 · NNW bound');
  });

  test('stripAgencyPrefix keeps everything after the first underscore', () {
    expect(stripAgencyPrefix('MTS_24151'), '24151');
    expect(stripAgencyPrefix('A_B_C'), 'B_C');
    expect(stripAgencyPrefix('plain'), 'plain');
  });
}
```

- [ ] **Step 3: Run the tests to see them fail**

Run: `cd packages/oba_arrivals && mise exec -- flutter test test/display_test.dart test/filtering_test.dart test/stop_display_test.dart`
Expected: FAIL with compile errors (the exported files don't exist).

- [ ] **Step 4: Implement the strings and display logic**

`packages/oba_arrivals/lib/src/strings.dart`:

```dart
/// Every user-facing string in the panel. Subclass and override to localize.
class ObaArrivalsStrings {
  const ObaArrivalsStrings();

  String get now => 'now';
  String minutesCompact(int minutes) => '${minutes}m';
  String minLate(int minutes) => '$minutes min late';
  String minEarly(int minutes) => '$minutes min early';
  String get onTime => 'on time';
  String get scheduled => 'scheduled';
  String get canceled => 'canceled';
  String everyMinutesFrom(int minutes, String time) => 'every $minutes min from $time';
  String everyMinutesUntil(int minutes, String time) => 'every $minutes min until $time';

  String stopNumber(String code) => 'Stop #$code';

  /// [code] is a compass code like `SW`; unknown codes are shown as-is.
  String directionBound(String code) {
    final name = switch (code) {
      'N' => 'North',
      'NE' => 'Northeast',
      'E' => 'East',
      'SE' => 'Southeast',
      'S' => 'South',
      'SW' => 'Southwest',
      'W' => 'West',
      'NW' => 'Northwest',
      _ => code,
    };
    return '$name bound';
  }

  String get refresh => 'Refresh arrivals';
  String get retry => 'Retry';
  String noArrivals(int minutes) => 'No arrivals in the next $minutes minutes';
  String get stopNotFound => 'Stop not found or service unavailable';
  String get networkError => "Couldn't reach the transit server. Check your connection.";
  String get loadError => "Couldn't load arrivals.";
  String staleNotice(String time) => "Couldn't update. Showing results from $time";

  // Accessibility.
  String get arrivingNow => 'arriving now';
  String arrivingInMinutes(int minutes) =>
      minutes == 1 ? 'arriving in 1 minute' : 'arriving in $minutes minutes';
  String get realtime => 'real-time';
  String get rowTapHint => 'show details';
}
```

`packages/oba_arrivals/lib/src/display/arrival_display.dart`:

```dart
import 'package:onebusaway/onebusaway.dart';

import '../strings.dart';

enum ArrivalStatusKind { onTime, late, early, scheduled, canceled }

int _floorMinutes(DateTime t) => t.millisecondsSinceEpoch ~/ 60000;

/// True when the row has a usable real-time prediction.
bool hasPrediction(ArrivalAndDeparture a) =>
    a.predicted && a.predictedArrivalTime != null;

/// The time shown in the row: predicted when available, else scheduled.
DateTime? displayTime(ArrivalAndDeparture a) =>
    hasPrediction(a) ? a.predictedArrivalTime : a.scheduledArrivalTime;

/// Whole minutes from [now] until the row's display time (floored, like
/// Wayfinder). Negative when already passed; null when the row has no times.
int? minutesUntil(ArrivalAndDeparture a, DateTime now) {
  final time = displayTime(a);
  if (time == null) return null;
  return _floorMinutes(time) - _floorMinutes(now);
}

/// Predicted minus scheduled, in whole minutes; null without a prediction.
int? delayMinutes(ArrivalAndDeparture a) {
  final scheduled = a.scheduledArrivalTime;
  if (!hasPrediction(a) || scheduled == null) return null;
  return _floorMinutes(a.predictedArrivalTime!) - _floorMinutes(scheduled);
}

bool isCanceled(ArrivalAndDeparture a) => a.tripStatus?.status == 'CANCELED';

/// Drives the status color. Deliberately differs from [statusText] at
/// exactly 1 minute early, matching Wayfinder.
ArrivalStatusKind statusKind(ArrivalAndDeparture a) {
  if (isCanceled(a)) return ArrivalStatusKind.canceled;
  final delay = delayMinutes(a);
  if (delay == null) return ArrivalStatusKind.scheduled;
  if (delay > 0) return ArrivalStatusKind.late;
  if (delay < -1) return ArrivalStatusKind.early;
  return ArrivalStatusKind.onTime;
}

String statusText(
  ArrivalAndDeparture a,
  DateTime now,
  ObaArrivalsStrings strings, {
  required String Function(DateTime time) formatTime,
}) {
  if (isCanceled(a)) return strings.canceled;
  final frequency = a.frequency;
  if (frequency != null) {
    final headwayMinutes = frequency.headway ~/ 60;
    return now.isBefore(frequency.startTime)
        ? strings.everyMinutesFrom(headwayMinutes, formatTime(frequency.startTime))
        : strings.everyMinutesUntil(headwayMinutes, formatTime(frequency.endTime));
  }
  final delay = delayMinutes(a);
  if (delay == null) return strings.scheduled;
  if (delay > 0) return strings.minLate(delay);
  if (delay < 0) return strings.minEarly(-delay);
  return strings.onTime;
}

String etaLabel(int eta, ObaArrivalsStrings strings) =>
    eta == 0 ? strings.now : strings.minutesCompact(eta);
```

`packages/oba_arrivals/lib/src/display/arrival_filtering.dart`:

```dart
import 'package:onebusaway/onebusaway.dart';

import 'arrival_display.dart';

/// Drops rows that already arrived (negative ETA) or have no times.
List<ArrivalAndDeparture> filterDeparted(
  List<ArrivalAndDeparture> arrivals,
  DateTime now,
) =>
    arrivals.where((a) {
      final eta = minutesUntil(a, now);
      return eta != null && eta >= 0;
    }).toList();

/// Drops the arrival-at-final-stop row when the same vehicle's next trip in
/// the block departs from this stop, so a layover shows as one row
/// (port of Wayfinder's `collapseLayovers`).
List<ArrivalAndDeparture> collapseLayovers(List<ArrivalAndDeparture> arrivals) =>
    arrivals.where((a) {
      final total = a.totalStopsInTrip;
      final vehicle = a.vehicleId;
      final block = a.blockTripSequence;
      if (total == null || vehicle == null || block == null) return true;
      if (a.stopSequence != total - 1) return true;
      final departsNext = arrivals.any((b) =>
          b.stopSequence == 0 &&
          b.vehicleId == vehicle &&
          b.serviceDate == a.serviceDate &&
          b.blockTripSequence == block + 1);
      return !departsNext;
    }).toList();

/// The rows the panel shows, in server order.
List<ArrivalAndDeparture> visibleArrivals(
  List<ArrivalAndDeparture> raw,
  DateTime now,
) =>
    collapseLayovers(filterDeparted(raw, now));
```

`packages/oba_arrivals/lib/src/display/stop_display.dart`:

```dart
import 'package:onebusaway/onebusaway.dart';

import '../strings.dart';

/// `MTS_24151` -> `24151`. Keeps everything after the first underscore.
String stripAgencyPrefix(String id) {
  final i = id.indexOf('_');
  return i < 0 ? id : id.substring(i + 1);
}

/// Short names of routes that serve [stop], sorted. References can include
/// routes that don't serve the stop, so only `stop.routeIds` count.
List<String> routeShortNamesForStop(Stop stop, References refs) => [
      for (final id in stop.routeIds)
        if (refs.route(id) case final route?)
          route.shortName ?? stripAgencyPrefix(route.id),
    ]..sort();

/// `Stop #24151 · Southwest bound · 101, 30, IL, S`
String stopSubtitle(Stop stop, References refs, ObaArrivalsStrings strings) {
  final routes = routeShortNamesForStop(stop, refs);
  return [
    strings.stopNumber(stop.code ?? stripAgencyPrefix(stop.id)),
    if (stop.direction case final direction?) strings.directionBound(direction),
    if (routes.isNotEmpty) routes.join(', '),
  ].join(' · ');
}
```

- [ ] **Step 5: Run the tests to see them pass**

Run: `cd packages/oba_arrivals && mise exec -- flutter test && mise exec -- flutter analyze`
Expected: all tests pass, and "No issues found!"

- [ ] **Step 6: Commit**

```bash
git add packages/oba_arrivals
git commit -m "Add oba_arrivals strings and Wayfinder display logic"
```

---

### Task 5: Theme extension, color utilities and RouteBadge

**Files:**
- Create: `packages/oba_arrivals/lib/src/theme.dart`
- Create: `packages/oba_arrivals/lib/src/color_utils.dart`
- Create: `packages/oba_arrivals/lib/src/route_badge.dart`
- Modify: `packages/oba_arrivals/lib/oba_arrivals.dart`
- Test: `packages/oba_arrivals/test/theme_and_badge_test.dart`

**Interfaces:**
- Consumes: `ArrivalStatusKind` from Task 4.
- Produces:
  - `class ObaArrivalsTheme extends ThemeExtension<ObaArrivalsTheme>`, with:
    - constructor `const ObaArrivalsTheme({required Color onTime, required Color late, required Color early, Color? scheduled, Color? canceled, Size badgeSize = const Size(64, 56), double badgeRadius = 8, Color badgeFallbackColor = const Color(0xFF374151)})`;
    - `factory ObaArrivalsTheme.light()` and `factory ObaArrivalsTheme.dark()`;
    - `static ObaArrivalsTheme of(BuildContext context)`;
    - `Color colorFor(ArrivalStatusKind kind, ColorScheme scheme)`;
    - `copyWith(...)` and `lerp(...)`.
  - Color utilities:
    - `Color? parseHexColor(String? hex)`
    - `Color contrastingTextColor(Color background)`
    - `double badgeFontSize(String label)`
  - `class RouteBadge extends StatelessWidget { const RouteBadge({Key? key, required String label, String? color, String? textColor}); }`

- [ ] **Step 1: Write the failing tests**

`packages/oba_arrivals/test/theme_and_badge_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';

void main() {
  group('parseHexColor', () {
    test('accepts lowercase, uppercase and #-prefixed hex', () {
      expect(parseHexColor('ffcd00'), const Color(0xFFFFCD00));
      expect(parseHexColor('000099'), const Color(0xFF000099));
      expect(parseHexColor('#20183D'), const Color(0xFF20183D));
    });

    test('null, empty and malformed are null', () {
      expect(parseHexColor(null), isNull);
      expect(parseHexColor(''), isNull);
      expect(parseHexColor('zzzzzz'), isNull);
      expect(parseHexColor('fff'), isNull);
    });
  });

  test('contrastingTextColor picks the higher WCAG contrast', () {
    expect(contrastingTextColor(const Color(0xFFFFCD00)), Colors.black); // IL
    expect(contrastingTextColor(const Color(0xFF90A7D3)), Colors.black); // S
    expect(contrastingTextColor(const Color(0xFF20183D)), Colors.white); // OL
    expect(contrastingTextColor(const Color(0xFF374151)), Colors.white);
  });

  test('badgeFontSize follows Wayfinder rule', () {
    expect(badgeFontSize('IL'), 24);
    expect(badgeFontSize('101'), 24);
    expect(badgeFontSize('Blue Line'), 21); // min(24, round(90/4)=23, round(42/2)=21)
    expect(badgeFontSize('Supercalifragilistic'), 8); // round(90/20)=5 -> floor 8
  });

  group('ObaArrivalsTheme', () {
    test('light and dark status colors', () {
      expect(ObaArrivalsTheme.light().onTime, const Color(0xFF16A34A));
      expect(ObaArrivalsTheme.dark().late, const Color(0xFFA78BFA));
    });

    testWidgets('of() uses brightness default unless host registers one',
        (tester) async {
      late ObaArrivalsTheme resolved;
      Widget probe(ThemeData theme) => MaterialApp(
            theme: theme,
            home: Builder(builder: (context) {
              resolved = ObaArrivalsTheme.of(context);
              return const SizedBox();
            }),
          );

      await tester.pumpWidget(probe(ThemeData(brightness: Brightness.dark)));
      expect(resolved.onTime, const Color(0xFF4ADE80));

      const custom = ObaArrivalsTheme(
          onTime: Colors.teal, late: Colors.orange, early: Colors.pink);
      await tester.pumpWidget(probe(ThemeData(extensions: const [custom])));
      expect(resolved.onTime, Colors.teal);
    });

    test('scheduled and canceled resolve from the color scheme', () {
      final scheme = ColorScheme.fromSeed(seedColor: Colors.blue);
      final theme = ObaArrivalsTheme.light();
      expect(theme.colorFor(ArrivalStatusKind.scheduled, scheme), scheme.onSurfaceVariant);
      expect(theme.colorFor(ArrivalStatusKind.canceled, scheme), scheme.error);
      expect(theme.colorFor(ArrivalStatusKind.late, scheme), const Color(0xFF7C3AED));
    });

    test('lerp and copyWith', () {
      final a = ObaArrivalsTheme.light();
      final b = ObaArrivalsTheme.dark();
      expect(a.lerp(b, 1).onTime, b.onTime);
      expect(a.copyWith(badgeRadius: 4).badgeRadius, 4);
    });
  });

  group('RouteBadge', () {
    Finder badgePart(Type type) =>
        find.descendant(of: find.byType(RouteBadge), matching: find.byType(type));

    Future<Text> pumpBadge(WidgetTester tester, Widget badge) async {
      await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Center(child: badge),
        ),
      ));
      return tester.widget<Text>(badgePart(Text));
    }

    testWidgets('UCSD IL badge uses black text on ffcd00 when textColor is empty',
        (tester) async {
      final text = await pumpBadge(
          tester, const RouteBadge(label: 'IL', color: 'ffcd00', textColor: null));
      expect(text.style!.color, Colors.black);
      final box = tester.widget<Container>(badgePart(Container));
      expect((box.decoration! as BoxDecoration).color, const Color(0xFFFFCD00));
    });

    testWidgets('GTFS textColor wins; missing color uses fallback', (tester) async {
      final text = await pumpBadge(
          tester, const RouteBadge(label: '30', color: null, textColor: 'FFFFFF'));
      expect(text.style!.color, const Color(0xFFFFFFFF));
      final box = tester.widget<Container>(badgePart(Container));
      expect((box.decoration! as BoxDecoration).color, const Color(0xFF374151));
    });

    testWidgets('is 64x56 and ignores text scaling', (tester) async {
      await pumpBadge(tester, const RouteBadge(label: 'IL', color: 'ffcd00'));
      expect(tester.getSize(find.byType(RouteBadge)), const Size(64, 56));
      final scaler = MediaQuery.textScalerOf(tester.element(badgePart(Text)));
      expect(scaler, TextScaler.noScaling);
    });
  });
}
```

- [ ] **Step 2: Run the tests to see them fail**

Run: `cd packages/oba_arrivals && mise exec -- flutter test test/theme_and_badge_test.dart`
Expected: FAIL with compile errors (`parseHexColor`, `ObaArrivalsTheme` and `RouteBadge` undefined).

- [ ] **Step 3: Implement the color utilities, theme and badge**

`packages/oba_arrivals/lib/src/color_utils.dart`:

```dart
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Parses GTFS hex colors (`ffcd00`, `FFFFFF`, `#20183D`). Null if absent or
/// malformed.
Color? parseHexColor(String? hex) {
  if (hex == null) return null;
  var value = hex.trim();
  if (value.startsWith('#')) value = value.substring(1);
  if (value.length != 6) return null;
  final rgb = int.tryParse(value, radix: 16);
  return rgb == null ? null : Color(0xFF000000 | rgb);
}

/// Black or white, whichever has the higher WCAG contrast on [background].
Color contrastingTextColor(Color background) {
  final l = background.computeLuminance();
  final withWhite = 1.05 / (l + 0.05);
  final withBlack = (l + 0.05) / 0.05;
  return withBlack >= withWhite ? Colors.black : Colors.white;
}

/// Wayfinder's badge font size: shrink long or multi-word names, 8–24 px.
double badgeFontSize(String label) {
  final words = label.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
  if (words.isEmpty) return 24;
  final longest = words.map((w) => w.length).reduce(math.max);
  final size = math.min(24, math.min((90 / longest).round(), (42 / words.length).round()));
  return math.max(8, size).toDouble();
}
```

`packages/oba_arrivals/lib/src/theme.dart`:

```dart
import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import 'display/arrival_display.dart';

/// OBA-specific colors and badge metrics. Register it in
/// `ThemeData.extensions` to customize; otherwise light/dark defaults are
/// picked from the host theme's brightness.
@immutable
class ObaArrivalsTheme extends ThemeExtension<ObaArrivalsTheme> {
  const ObaArrivalsTheme({
    required this.onTime,
    required this.late,
    required this.early,
    this.scheduled,
    this.canceled,
    this.badgeSize = const Size(64, 56),
    this.badgeRadius = 8,
    this.badgeFallbackColor = const Color(0xFF374151),
  });

  factory ObaArrivalsTheme.light() => const ObaArrivalsTheme(
        onTime: Color(0xFF16A34A), // green-600
        late: Color(0xFF7C3AED), // violet-600
        early: Color(0xFFDC2626), // red-600
      );

  factory ObaArrivalsTheme.dark() => const ObaArrivalsTheme(
        onTime: Color(0xFF4ADE80), // green-400
        late: Color(0xFFA78BFA), // violet-400
        early: Color(0xFFF87171), // red-400
      );

  static ObaArrivalsTheme of(BuildContext context) {
    final theme = Theme.of(context);
    return theme.extension<ObaArrivalsTheme>() ??
        (theme.brightness == Brightness.dark
            ? ObaArrivalsTheme.dark()
            : ObaArrivalsTheme.light());
  }

  final Color onTime;
  final Color late;
  final Color early;

  /// Null means `colorScheme.onSurfaceVariant`.
  final Color? scheduled;

  /// Null means `colorScheme.error`.
  final Color? canceled;
  final Size badgeSize;
  final double badgeRadius;
  final Color badgeFallbackColor;

  Color colorFor(ArrivalStatusKind kind, ColorScheme scheme) => switch (kind) {
        ArrivalStatusKind.onTime => onTime,
        ArrivalStatusKind.late => late,
        ArrivalStatusKind.early => early,
        ArrivalStatusKind.scheduled => scheduled ?? scheme.onSurfaceVariant,
        ArrivalStatusKind.canceled => canceled ?? scheme.error,
      };

  @override
  ObaArrivalsTheme copyWith({
    Color? onTime,
    Color? late,
    Color? early,
    Color? scheduled,
    Color? canceled,
    Size? badgeSize,
    double? badgeRadius,
    Color? badgeFallbackColor,
  }) =>
      ObaArrivalsTheme(
        onTime: onTime ?? this.onTime,
        late: late ?? this.late,
        early: early ?? this.early,
        scheduled: scheduled ?? this.scheduled,
        canceled: canceled ?? this.canceled,
        badgeSize: badgeSize ?? this.badgeSize,
        badgeRadius: badgeRadius ?? this.badgeRadius,
        badgeFallbackColor: badgeFallbackColor ?? this.badgeFallbackColor,
      );

  @override
  ObaArrivalsTheme lerp(ObaArrivalsTheme? other, double t) {
    if (other == null) return this;
    return ObaArrivalsTheme(
      onTime: Color.lerp(onTime, other.onTime, t)!,
      late: Color.lerp(late, other.late, t)!,
      early: Color.lerp(early, other.early, t)!,
      scheduled: Color.lerp(scheduled, other.scheduled, t),
      canceled: Color.lerp(canceled, other.canceled, t),
      badgeSize: Size.lerp(badgeSize, other.badgeSize, t)!,
      badgeRadius: lerpDouble(badgeRadius, other.badgeRadius, t)!,
      badgeFallbackColor: Color.lerp(badgeFallbackColor, other.badgeFallbackColor, t)!,
    );
  }
}
```

`packages/oba_arrivals/lib/src/route_badge.dart`:

```dart
import 'package:flutter/material.dart';

import 'color_utils.dart';
import 'theme.dart';

/// Colored route short-name badge (Wayfinder's `RouteBadge`).
///
/// [color] and [textColor] are raw GTFS hex strings, as found on `Route`.
class RouteBadge extends StatelessWidget {
  const RouteBadge({super.key, required this.label, this.color, this.textColor});

  final String label;
  final String? color;
  final String? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = ObaArrivalsTheme.of(context);
    final background = parseHexColor(color) ?? theme.badgeFallbackColor;
    final foreground = parseHexColor(textColor) ?? contrastingTextColor(background);
    return ExcludeSemantics(
      child: Container(
        width: theme.badgeSize.width,
        height: theme.badgeSize.height,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(theme.badgeRadius),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.alphaBlend(Colors.white.withValues(alpha: 0.18), background),
              background,
            ],
          ),
        ),
        // The box is fixed-size, so the label ignores the text scale setting.
        child: MediaQuery.withNoTextScaling(
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: foreground,
              fontSize: badgeFontSize(label),
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ),
      ),
    );
  }
}
```

`BoxDecoration` paints the gradient over `color`, but the tests read
`decoration.color`. Keep both, because the gradient only lightens the top
edge.

Add to the exports in `packages/oba_arrivals/lib/oba_arrivals.dart`:

```dart
export 'src/color_utils.dart';
export 'src/route_badge.dart';
export 'src/theme.dart';
```

- [ ] **Step 4: Run the tests to see them pass**

Run: `cd packages/oba_arrivals && mise exec -- flutter test && mise exec -- flutter analyze`
Expected: all tests pass, and "No issues found!"

- [ ] **Step 5: Commit**

```bash
git add packages/oba_arrivals
git commit -m "Add ObaArrivalsTheme, color utilities and RouteBadge"
```

---

### Task 6: ArrivalsController

**Files:**
- Create: `packages/oba_arrivals/lib/src/arrivals_controller.dart`
- Create: `packages/oba_arrivals/test/support/fixtures.dart`
- Modify: `packages/oba_arrivals/lib/oba_arrivals.dart`
- Test: `packages/oba_arrivals/test/controller_test.dart`

**Interfaces:**
- Consumes: `OneBusAwayClient`, `ObaEntryResponse`, `Stop`, `References`,
  `ArrivalAndDeparture` and `ObaException` from `onebusaway`. It also uses
  `package:clock`, which is declared in the Task 1 pubspec.
- The default clock is `clock.now()` from `package:clock`, never
  `DateTime.now`. `testWidgets` fakes only `package:clock`, so the panel's
  tick and departed-row tests depend on this.
- Produces:
  - `enum ArrivalsStatus { loading, loaded, error }`
  - `class ArrivalsState`:
    - Constructor `const ArrivalsState({ArrivalsStatus status = ArrivalsStatus.loading, Stop? stop, List<ArrivalAndDeparture> rawArrivals = const [], References references = References.empty, DateTime? updatedAt, Object? error, bool isRefreshing = false})`.
    - Getter `bool get hasData => updatedAt != null`.
    - The fields mean:
      - `loaded` means data exists.
      - `error` is set on a `loaded` state when the latest refresh failed.
      - `status == error` means there's no data and the last fetch failed.
  - `class ArrivalsController extends ChangeNotifier`:
    - `ArrivalsController({required OneBusAwayClient client, required String stopId, int minutesAfter = 35, Duration refreshInterval = const Duration(seconds: 30), DateTime Function()? clock})`
    - fields: `final String stopId; final int minutesAfter; final Duration refreshInterval;`
    - `ArrivalsState get state`, `bool get isRunning`, `DateTime now()`
    - `Future<void> refresh()`, `void resume()`, `void pause()`
  - Test support, in `test/support/fixtures.dart`:
    - `String arrivalsFixture()`, which reads the onebusaway fixture;
    - `const fixtureServerTime` (`DateTime` 1790228579290 UTC);
    - `OneBusAwayClient fakeClient(Future<http.Response> Function(http.Request) handler)`;
    - `http.Response okResponse()`.

- [ ] **Step 1: Create the test support**

`packages/oba_arrivals/test/support/fixtures.dart`:

```dart
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onebusaway/onebusaway.dart';

/// Tests run with the package directory as the working directory.
String arrivalsFixture() =>
    File('../onebusaway/test/fixtures/arrivals_mts_24151.json').readAsStringSync();

/// `currentTime` in the fixture: 2026-09-24T04:22:59.290Z.
final fixtureServerTime =
    DateTime.fromMillisecondsSinceEpoch(1790228579290, isUtc: true);

http.Response okResponse([String? body]) =>
    http.Response(body ?? arrivalsFixture(), 200,
        headers: {'content-type': 'application/json; charset=utf-8'});

OneBusAwayClient fakeClient(
        Future<http.Response> Function(http.Request request) handler) =>
    OneBusAwayClient(
      baseUrl: Uri.parse('https://realtime.sdmts.com/api/'),
      apiKey: 'test',
      httpClient: MockClient(handler),
    );
```

- [ ] **Step 2: Write the failing controller tests**

`packages/oba_arrivals/test/controller_test.dart`:

```dart
import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:onebusaway/onebusaway.dart';

import 'support/fixtures.dart';

void main() {
  final deviceStart = DateTime.utc(2026, 9, 24, 4, 0); // 23 min behind server

  ArrivalsController controllerFor(
    FakeAsync async,
    Future<http.Response> Function(http.Request) handler,
  ) =>
      ArrivalsController(
        client: fakeClient(handler),
        stopId: 'MTS_24151',
        clock: () => deviceStart.add(async.elapsed),
      );

  test('resume() loads the stop and arrivals', () {
    fakeAsync((async) {
      final c = controllerFor(async, (_) async => okResponse());
      expect(c.state.status, ArrivalsStatus.loading);
      c.resume();
      expect(c.state.isRefreshing, isTrue);
      async.flushMicrotasks();

      expect(c.state.status, ArrivalsStatus.loaded);
      expect(c.state.isRefreshing, isFalse);
      expect(c.state.stop!.name, 'Eighth College / Theatre District (North)');
      expect(c.state.rawArrivals, hasLength(4)); // unfiltered
      expect(c.state.error, isNull);
      c.dispose();
    });
  });

  test('requests minutesAfter', () {
    fakeAsync((async) {
      late Uri url;
      final c = controllerFor(async, (r) async {
        url = r.url;
        return okResponse();
      });
      c.resume();
      async.flushMicrotasks();
      expect(url.queryParameters['minutesAfter'], '35');
      c.dispose();
    });
  });

  test('polls refreshInterval after each response completes', () {
    fakeAsync((async) {
      var requests = 0;
      final c = controllerFor(async, (_) async {
        requests++;
        return okResponse();
      });
      c.resume();
      async.flushMicrotasks();
      expect(requests, 1);
      async.elapse(const Duration(seconds: 29));
      expect(requests, 1);
      async.elapse(const Duration(seconds: 1));
      expect(requests, 2);
      c.dispose();
    });
  });

  test('slow responses never pile up', () {
    fakeAsync((async) {
      var requests = 0;
      final pending = Completer<http.Response>();
      final c = controllerFor(async, (_) {
        requests++;
        return requests == 1 ? pending.future : Future.value(okResponse());
      });
      c.resume();
      async.elapse(const Duration(seconds: 10)); // < 15 s timeout
      expect(requests, 1);
      pending.complete(okResponse());
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 29));
      expect(requests, 1);
      async.elapse(const Duration(seconds: 1));
      expect(requests, 2);
      c.dispose();
    });
  });

  test('a stale response is discarded', () {
    fakeAsync((async) {
      final first = Completer<http.Response>();
      var requests = 0;
      final c = controllerFor(async, (_) {
        requests++;
        return requests == 1 ? first.future : Future.value(okResponse());
      });
      c.resume();
      async.flushMicrotasks();
      c.refresh(); // supersedes request 1
      async.flushMicrotasks();
      expect(c.state.status, ArrivalsStatus.loaded);
      first.complete(http.Response('', 500)); // late failure must be ignored
      async.flushMicrotasks();
      expect(c.state.error, isNull);
      c.dispose();
    });
  });

  test('a failed refresh keeps data and records the error', () {
    fakeAsync((async) {
      var requests = 0;
      final c = controllerFor(async, (_) async {
        requests++;
        return requests == 1 ? okResponse() : http.Response('', 500);
      });
      c.resume();
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 30));
      expect(c.state.status, ArrivalsStatus.loaded);
      expect(c.state.rawArrivals, hasLength(4));
      expect(c.state.error, isA<ObaApiException>());
      c.dispose();
    });
  });

  test('a failure with no data is the error state', () {
    fakeAsync((async) {
      final c = controllerFor(async, (_) async => http.Response('', 200));
      c.resume();
      async.flushMicrotasks();
      expect(c.state.status, ArrivalsStatus.error);
      expect(c.state.error, isA<ObaApiException>()
          .having((e) => e.kind, 'kind', ObaApiErrorKind.emptyResponse));
      expect(c.state.hasData, isFalse);
      c.dispose();
    });
  });

  test('pause() stops polling; resume() refreshes immediately', () {
    fakeAsync((async) {
      var requests = 0;
      final c = controllerFor(async, (_) async {
        requests++;
        return okResponse();
      });
      c.resume();
      async.flushMicrotasks();
      c.pause();
      expect(c.isRunning, isFalse);
      async.elapse(const Duration(minutes: 5));
      expect(requests, 1);
      c.resume();
      async.flushMicrotasks();
      expect(requests, 2);
      c.dispose();
    });
  });

  test('pause() during an in-flight request does not schedule a poll', () {
    fakeAsync((async) {
      var requests = 0;
      final pending = Completer<http.Response>();
      final c = controllerFor(async, (_) {
        requests++;
        return pending.future;
      });
      c.resume();
      c.pause();
      pending.complete(okResponse());
      async.flushMicrotasks();
      async.elapse(const Duration(minutes: 2));
      expect(requests, 1);
      expect(c.state.status, ArrivalsStatus.loaded); // result still applied
      c.dispose();
    });
  });

  test('now() follows server time, not the device clock', () {
    fakeAsync((async) {
      final c = controllerFor(async, (_) async => okResponse());
      expect(c.now(), deviceStart); // no offset before the first response
      c.resume();
      async.flushMicrotasks();
      expect(c.now(), fixtureServerTime);
      c.pause();
      async.elapse(const Duration(seconds: 90));
      expect(c.now(), fixtureServerTime.add(const Duration(seconds: 90)));
      c.dispose();
    });
  });

  test('dispose during a request is safe', () {
    fakeAsync((async) {
      final pending = Completer<http.Response>();
      final c = controllerFor(async, (_) => pending.future);
      c.resume();
      c.dispose();
      pending.complete(okResponse());
      async.flushMicrotasks();
      expect(async.pendingTimers, isEmpty); // no poll scheduled after dispose
    });
  });
}
```

- [ ] **Step 3: Run the tests to see them fail**

Run: `cd packages/oba_arrivals && mise exec -- flutter test test/controller_test.dart`
Expected: FAIL with compile errors (`ArrivalsController` undefined).

- [ ] **Step 4: Implement the controller**

`packages/oba_arrivals/lib/src/arrivals_controller.dart`:

```dart
import 'dart:async';

import 'package:clock/clock.dart' as clock_pkg;
import 'package:flutter/foundation.dart';
import 'package:onebusaway/onebusaway.dart';

enum ArrivalsStatus {
  /// No data yet; the first request is in flight.
  loading,

  /// Data is available. `ArrivalsState.error` is set if the latest refresh
  /// failed and the data is stale.
  loaded,

  /// No data and the last request failed.
  error,
}

@immutable
class ArrivalsState {
  const ArrivalsState({
    this.status = ArrivalsStatus.loading,
    this.stop,
    this.rawArrivals = const [],
    this.references = References.empty,
    this.updatedAt,
    this.error,
    this.isRefreshing = false,
  });

  final ArrivalsStatus status;
  final Stop? stop;

  /// Unfiltered, in server order. Filter with `visibleArrivals(raw, now)`.
  final List<ArrivalAndDeparture> rawArrivals;
  final References references;

  /// Server time of the last successful fetch.
  final DateTime? updatedAt;
  final Object? error;
  final bool isRefreshing;

  bool get hasData => updatedAt != null;
}

/// Fetches arrivals for one stop and polls while running.
///
/// Framework-agnostic: call [pause]/[resume] from lifecycle code (the panel
/// does this for you).
class ArrivalsController extends ChangeNotifier {
  ArrivalsController({
    required OneBusAwayClient client,
    required this.stopId,
    this.minutesAfter = 35,
    this.refreshInterval = const Duration(seconds: 30),
    DateTime Function()? clock,
  })  : _client = client,
        // package:clock, not DateTime.now, so fake_async / testWidgets can
        // control time.
        _clock = clock ?? (() => clock_pkg.clock.now());

  final OneBusAwayClient _client;
  final DateTime Function() _clock;
  final String stopId;
  final int minutesAfter;
  final Duration refreshInterval;

  ArrivalsState _state = const ArrivalsState();
  ArrivalsState get state => _state;

  Duration _serverOffset = Duration.zero;
  Timer? _timer;
  int _latestRequest = 0;
  bool _running = false;
  bool _disposed = false;

  bool get isRunning => _running;

  /// The current time on the server's clock.
  DateTime now() => _clock().add(_serverOffset);

  /// Starts polling, fetching immediately. No-op if already running.
  void resume() {
    if (_running) return;
    _running = true;
    unawaited(refresh());
  }

  /// Stops polling. An in-flight request still updates [state].
  void pause() {
    _running = false;
    _timer?.cancel();
    _timer = null;
  }

  /// Fetches now. When running, the next poll is scheduled
  /// [refreshInterval] after this request completes.
  Future<void> refresh() async {
    _timer?.cancel();
    _timer = null;
    final request = ++_latestRequest;
    _emit(ArrivalsState(
      status: _state.status == ArrivalsStatus.error
          ? ArrivalsStatus.loading
          : _state.status,
      stop: _state.stop,
      rawArrivals: _state.rawArrivals,
      references: _state.references,
      updatedAt: _state.updatedAt,
      error: _state.error,
      isRefreshing: true,
    ));

    ArrivalsState next;
    try {
      final response = await _client.arrivalsAndDepartures
          .forStop(stopId, minutesAfter: minutesAfter);
      _serverOffset = response.currentTime.difference(_clock());
      next = ArrivalsState(
        status: ArrivalsStatus.loaded,
        stop: response.references.stop(response.entry.stopId),
        rawArrivals: response.entry.arrivalsAndDepartures,
        references: response.references,
        updatedAt: response.currentTime,
      );
    } catch (error) {
      next = _state.hasData
          ? ArrivalsState(
              status: ArrivalsStatus.loaded,
              stop: _state.stop,
              rawArrivals: _state.rawArrivals,
              references: _state.references,
              updatedAt: _state.updatedAt,
              error: error,
            )
          : ArrivalsState(status: ArrivalsStatus.error, error: error);
    }

    if (_disposed || request != _latestRequest) return;
    _emit(next);
    if (_running) _timer = Timer(refreshInterval, () => unawaited(refresh()));
  }

  void _emit(ArrivalsState state) {
    if (_disposed) return;
    _state = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    pause();
    super.dispose();
  }
}
```

A retry after an error flips `status` back to `loading`, so the panel shows
skeletons instead of a stale error message.

Add to the exports in `packages/oba_arrivals/lib/oba_arrivals.dart`:

```dart
export 'src/arrivals_controller.dart';
```

- [ ] **Step 5: Run the tests to see them pass**

Run: `cd packages/oba_arrivals && mise exec -- flutter test && mise exec -- flutter analyze`
Expected: all tests pass, and "No issues found!"

- [ ] **Step 6: Commit**

```bash
git add packages/oba_arrivals
git commit -m "Add ArrivalsController with polling, stale-drop and clock skew"
```

---

### Task 7: ObaArrivalsPanel widget

**Files:**
- Create: `packages/oba_arrivals/lib/src/widgets/stop_header.dart`
- Create: `packages/oba_arrivals/lib/src/widgets/arrival_row.dart`
- Create: `packages/oba_arrivals/lib/src/widgets/panel_states.dart`
- Create: `packages/oba_arrivals/lib/src/arrivals_panel.dart`
- Modify: `packages/oba_arrivals/lib/oba_arrivals.dart`
- Test: `packages/oba_arrivals/test/panel_test.dart`

**Interfaces:**
- Consumes: everything from Tasks 4–6.
- Produces:
  - `class ObaArrivalsPanel extends StatefulWidget`, with:
    - constructor `const ObaArrivalsPanel({Key? key, OneBusAwayClient? client, String? stopId, ArrivalsController? controller, void Function(ArrivalAndDeparture)? onArrivalTap, int minutesAfter = 35, int? maxArrivals, Duration refreshInterval = const Duration(seconds: 30), ObaArrivalsStrings strings = const ObaArrivalsStrings()})`;
    - an assertion that either `controller` is given, or both `client` and `stopId` are.
  - `String formatArrivalTime(BuildContext context, DateTime time)`, exported
    for hosts.
  - Keys used by tests:
    - `ValueKey('oba-skeleton-row')`
    - `ValueKey('oba-refresh')`
    - `ValueKey('oba-stale-notice')`
    - `ValueKey('oba-arrival-row-<tripId>')`

- [ ] **Step 1: Write the failing widget tests**

`packages/oba_arrivals/test/panel_test.dart`:

```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:onebusaway/onebusaway.dart';

import 'support/fixtures.dart';

Widget host(Widget panel, {ThemeData? theme}) => MaterialApp(
      theme: theme,
      home: Scaffold(body: SingleChildScrollView(child: panel)),
    );

/// Lets MockClient futures resolve, then rebuilds.
Future<void> settle(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
}

String fixtureWith(void Function(Map<String, dynamic> entry) edit) {
  final json = jsonDecode(arrivalsFixture()) as Map<String, dynamic>;
  edit((json['data'] as Map<String, dynamic>)['entry'] as Map<String, dynamic>);
  return jsonEncode(json);
}

void main() {
  testWidgets('shows skeleton rows while loading', (tester) async {
    final pending = Completer<http.Response>();
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) => pending.future),
      stopId: 'MTS_24151',
    )));
    expect(find.byKey(const ValueKey('oba-skeleton-row')), findsNWidgets(3));
    pending.complete(okResponse());
    await settle(tester);
  });

  testWidgets('loaded: header, subtitle and visible rows in server order',
      (tester) async {
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse()),
      stopId: 'MTS_24151',
    )));
    await settle(tester);

    expect(find.text('Eighth College / Theatre District (North)'), findsOneWidget);
    expect(find.text('Stop #24151 · Southwest bound · 101, 30, IL, S'), findsOneWidget);
    expect(find.text('UTC'), findsNothing); // departed
    expect(find.text('Old Town'), findsOneWidget);
    expect(find.text('Inside Loop'), findsOneWidget);
    expect(find.text('SIO'), findsOneWidget);
    expect(find.text('4m'), findsOneWidget);
    expect(find.text('5m'), findsOneWidget);
    expect(find.text('8m'), findsOneWidget);
    expect(find.textContaining('2 min late'), findsOneWidget);
    expect(find.textContaining('on time'), findsOneWidget);
    expect(find.textContaining('scheduled'), findsOneWidget);
    expect(find.byIcon(Icons.rss_feed), findsNWidgets(2));
    expect(find.byIcon(Icons.schedule), findsOneWidget);
    final order = ['Old Town', 'Inside Loop', 'SIO']
        .map((t) => tester.getTopLeft(find.text(t)).dy)
        .toList();
    expect(order, orderedEquals([...order]..sort()));
  });

  testWidgets('maxArrivals caps rows', (tester) async {
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse()),
      stopId: 'MTS_24151',
      maxArrivals: 2,
    )));
    await settle(tester);
    expect(find.text('Inside Loop'), findsOneWidget);
    expect(find.text('SIO'), findsNothing);
  });

  testWidgets('empty list shows the no-arrivals message', (tester) async {
    final body = fixtureWith((e) => e['arrivalsAndDepartures'] = []);
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse(body)),
      stopId: 'MTS_24151',
      minutesAfter: 60,
    )));
    await settle(tester);
    expect(find.text('No arrivals in the next 60 minutes'), findsOneWidget);
  });

  testWidgets('empty body shows not-found message and retry refetches',
      (tester) async {
    var requests = 0;
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async {
        requests++;
        return requests == 1 ? http.Response('', 200) : okResponse();
      }),
      stopId: 'MTS_99999999',
    )));
    await settle(tester);
    expect(find.text('Stop not found or service unavailable'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Retry'));
    await settle(tester);
    expect(requests, 2);
    expect(find.text('Old Town'), findsOneWidget);
  });

  testWidgets('failed refresh keeps rows and shows stale notice', (tester) async {
    var requests = 0;
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async {
        requests++;
        return requests == 1 ? okResponse() : http.Response('', 503);
      }),
      stopId: 'MTS_24151',
    )));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('oba-refresh')));
    await settle(tester);
    expect(find.text('Old Town'), findsOneWidget);
    expect(find.byKey(const ValueKey('oba-stale-notice')), findsOneWidget);
  });

  testWidgets('departed row disappears on tick without refetching',
      (tester) async {
    var requests = 0;
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async {
        requests++;
        return okResponse();
      }),
      stopId: 'MTS_24151',
      refreshInterval: const Duration(minutes: 10),
    )));
    await settle(tester);
    expect(find.text('4m'), findsOneWidget);

    await tester.pump(const Duration(seconds: 60));
    expect(find.text('3m'), findsOneWidget); // Old Town ticked down

    await tester.pump(const Duration(minutes: 4));
    expect(find.text('Old Town'), findsNothing); // ETA now negative
    expect(find.text('Inside Loop'), findsOneWidget);
    expect(requests, 1);
  });

  testWidgets('onArrivalTap receives the arrival; chevron only when tappable',
      (tester) async {
    ArrivalAndDeparture? tapped;
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse()),
      stopId: 'MTS_24151',
      onArrivalTap: (a) => tapped = a,
    )));
    await settle(tester);
    expect(find.byIcon(Icons.chevron_right), findsNWidgets(3));
    await tester.tap(find.text('Old Town'));
    expect(tapped!.tripId, 'MTS_19630024');

    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse()),
      stopId: 'MTS_24151',
    )));
    await settle(tester);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets('rows expose a single semantics label', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async => okResponse()),
      stopId: 'MTS_24151',
    )));
    await settle(tester);
    expect(
      find.bySemanticsLabel(
          'IL, Inside Loop, arriving in 5 minutes, 2 min late, real-time'),
      findsOneWidget,
    );
    expect(find.bySemanticsLabel('S, SIO, arriving in 8 minutes, scheduled'),
        findsOneWidget);
    expect(find.byTooltip('Refresh arrivals'), findsOneWidget);
    handle.dispose();
  });

  testWidgets('pauses while TickerMode disabled', (tester) async {
    var requests = 0;
    final client = fakeClient((_) async {
      requests++;
      return okResponse();
    });
    Widget build(bool enabled) => host(TickerMode(
          enabled: enabled,
          child: ObaArrivalsPanel(client: client, stopId: 'MTS_24151'),
        ));

    await tester.pumpWidget(build(true));
    await settle(tester);
    expect(requests, 1);
    await tester.pumpWidget(build(false));
    await tester.pump(const Duration(minutes: 2));
    expect(requests, 1);
    await tester.pumpWidget(build(true));
    await settle(tester);
    expect(requests, 2);
  });

  testWidgets('pauses when app is paused, refreshes on resume', (tester) async {
    var requests = 0;
    await tester.pumpWidget(host(ObaArrivalsPanel(
      client: fakeClient((_) async {
        requests++;
        return okResponse();
      }),
      stopId: 'MTS_24151',
    )));
    await settle(tester);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump(const Duration(minutes: 2));
    expect(requests, 1);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await settle(tester);
    expect(requests, 2);
  });

  testWidgets('changing stopId reloads', (tester) async {
    final stops = <String>[];
    final client = fakeClient((r) async {
      stops.add(r.url.pathSegments.last);
      return okResponse();
    });
    await tester.pumpWidget(host(ObaArrivalsPanel(client: client, stopId: 'MTS_24151')));
    await settle(tester);
    await tester.pumpWidget(host(ObaArrivalsPanel(client: client, stopId: 'MTS_88986')));
    await settle(tester);
    expect(stops, ['MTS_24151.json', 'MTS_88986.json']);
  });

  testWidgets('lays out without overflow at 200% text scale', (tester) async {
    tester.view.physicalSize = const Size(360 * 3, 800 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
      home: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(2)),
        child: Scaffold(
          body: SingleChildScrollView(
            child: ObaArrivalsPanel(
              client: fakeClient((_) async => okResponse()),
              stopId: 'MTS_24151',
            ),
          ),
        ),
      ),
    ));
    await settle(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('host-provided controller is not disposed by the panel',
      (tester) async {
    final controller = ArrivalsController(
        client: fakeClient((_) async => okResponse()), stopId: 'MTS_24151');
    await tester.pumpWidget(host(ObaArrivalsPanel(controller: controller)));
    await settle(tester);
    await tester.pumpWidget(const SizedBox());
    expect(() => controller.addListener(() {}), returnsNormally);
    controller.dispose();
  });
}
```

- [ ] **Step 2: Run the tests to see them fail**

Run: `cd packages/oba_arrivals && mise exec -- flutter test test/panel_test.dart`
Expected: FAIL with compile errors (`ObaArrivalsPanel` undefined).

- [ ] **Step 3: Implement the header, row and state widgets**

`packages/oba_arrivals/lib/src/widgets/stop_header.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:onebusaway/onebusaway.dart';

import '../display/stop_display.dart';
import '../strings.dart';

class StopHeader extends StatelessWidget {
  const StopHeader({
    super.key,
    required this.stop,
    required this.references,
    required this.isRefreshing,
    required this.onRefresh,
    required this.strings,
  });

  /// Null while the first request is loading.
  final Stop? stop;
  final References references;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final ObaArrivalsStrings strings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stop = this.stop;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: stop == null
                ? const _HeaderPlaceholder()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stopSubtitle(stop, references, strings),
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
          ),
          IconButton(
            key: const ValueKey('oba-refresh'),
            tooltip: strings.refresh,
            onPressed: isRefreshing ? null : onRefresh,
            icon: isRefreshing
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class _HeaderPlaceholder extends StatelessWidget {
  const _HeaderPlaceholder();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    Widget bar(double width, double height) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [bar(220, 22), const SizedBox(height: 8), bar(160, 14)],
    );
  }
}
```

`packages/oba_arrivals/lib/src/widgets/arrival_row.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:onebusaway/onebusaway.dart';

import '../display/arrival_display.dart';
import '../display/stop_display.dart';
import '../route_badge.dart';
import '../strings.dart';
import '../theme.dart';

/// Formats [time] as a local time of day using the host's
/// MaterialLocalizations and 24-hour preference.
String formatArrivalTime(BuildContext context, DateTime time) =>
    MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(time.toLocal()),
      alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
    );

class ArrivalRow extends StatelessWidget {
  const ArrivalRow({
    super.key,
    required this.arrival,
    required this.route,
    required this.now,
    required this.strings,
    this.onTap,
  });

  final ArrivalAndDeparture arrival;
  final Route? route;
  final DateTime now;
  final ObaArrivalsStrings strings;
  final void Function(ArrivalAndDeparture arrival)? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final obaTheme = ObaArrivalsTheme.of(context);
    final color = obaTheme.colorFor(statusKind(arrival), theme.colorScheme);
    final eta = minutesUntil(arrival, now) ?? 0;
    final predicted = hasPrediction(arrival);
    String format(DateTime t) => formatArrivalTime(context, t);

    final label = arrival.routeShortName ??
        route?.shortName ??
        stripAgencyPrefix(arrival.routeId);
    final headsign = arrival.tripHeadsign ?? route?.longName ?? '';
    final status = statusText(arrival, now, strings, formatTime: format);
    final time = displayTime(arrival);

    final semanticsLabel = [
      label,
      headsign,
      eta == 0 ? strings.arrivingNow : strings.arrivingInMinutes(eta),
      status,
      if (predicted) strings.realtime,
    ].where((part) => part.isNotEmpty).join(', ');

    final tap = onTap;
    return Semantics(
      container: true,
      excludeSemantics: true,
      label: semanticsLabel,
      button: tap != null,
      onTap: tap == null ? null : () => tap(arrival),
      onTapHint: tap == null ? null : strings.rowTapHint,
      child: InkWell(
        key: ValueKey('oba-arrival-row-${arrival.tripId}'),
        onTap: tap == null ? null : () => tap(arrival),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              RouteBadge(
                label: label,
                color: route?.color,
                textColor: route?.textColor,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      headsign,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text.rich(
                      TextSpan(children: [
                        if (time != null) TextSpan(text: '${format(time)} · '),
                        TextSpan(text: status, style: TextStyle(color: color)),
                      ]),
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        etaLabel(eta, strings),
                        style: theme.textTheme.titleLarge?.copyWith(
                            color: color, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 2),
                      Icon(predicted ? Icons.rss_feed : Icons.schedule,
                          size: 16, color: color),
                    ],
                  ),
                  if (tap != null)
                    Icon(Icons.chevron_right,
                        color: theme.colorScheme.onSurfaceVariant),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

`packages/oba_arrivals/lib/src/widgets/panel_states.dart`:

```dart
import 'package:flutter/material.dart';

class SkeletonRow extends StatelessWidget {
  const SkeletonRow({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    Widget box(double w, double h, [double r = 4]) => Container(
          width: w,
          height: h,
          decoration:
              BoxDecoration(color: color, borderRadius: BorderRadius.circular(r)),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          box(64, 56, 8),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [box(140, 18), const SizedBox(height: 8), box(100, 14)],
            ),
          ),
          box(36, 22),
        ],
      ),
    );
  }
}

class PanelMessage extends StatelessWidget {
  const PanelMessage({super.key, required this.message, this.action});

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          if (action != null) ...[const SizedBox(height: 8), action!],
        ],
      ),
    );
  }
}

class StaleNotice extends StatelessWidget {
  const StaleNotice({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          Icon(Icons.cloud_off, size: 16, color: theme.colorScheme.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text(message,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error)),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Implement the panel**

`packages/oba_arrivals/lib/src/arrivals_panel.dart`:

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onebusaway/onebusaway.dart';

import 'arrivals_controller.dart';
import 'display/arrival_filtering.dart';
import 'strings.dart';
import 'widgets/arrival_row.dart';
import 'widgets/panel_states.dart';
import 'widgets/stop_header.dart';

/// Wayfinder-style arrivals and departures for one stop.
///
/// Lays out as a non-scrolling [Column]; wrap it in a scroll view for
/// full-screen use. Polls while visible and the app is in the foreground.
class ObaArrivalsPanel extends StatefulWidget {
  const ObaArrivalsPanel({
    super.key,
    this.client,
    this.stopId,
    this.controller,
    this.onArrivalTap,
    this.minutesAfter = 35,
    this.maxArrivals,
    this.refreshInterval = const Duration(seconds: 30),
    this.strings = const ObaArrivalsStrings(),
  }) : assert(controller != null || (client != null && stopId != null),
            'Pass a controller, or both client and stopId.');

  final OneBusAwayClient? client;
  final String? stopId;

  /// Optional host-owned controller. When given, [client], [stopId],
  /// [minutesAfter] and [refreshInterval] are ignored and the panel does not
  /// dispose it.
  final ArrivalsController? controller;
  final void Function(ArrivalAndDeparture arrival)? onArrivalTap;
  final int minutesAfter;

  /// Maximum rows to show; null shows all.
  final int? maxArrivals;
  final Duration refreshInterval;
  final ObaArrivalsStrings strings;

  @override
  State<ObaArrivalsPanel> createState() => _ObaArrivalsPanelState();
}

class _ObaArrivalsPanelState extends State<ObaArrivalsPanel> {
  static const _tickInterval = Duration(seconds: 30);

  ArrivalsController? _ownedController;
  late ArrivalsController _controller;
  late final AppLifecycleListener _lifecycle;
  Timer? _tick;
  bool _appActive = true;
  bool _visible = true;

  @override
  void initState() {
    super.initState();
    _controller = _resolveController();
    _controller.addListener(_onControllerChanged);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _appActive = lifecycle == null || _isActive(lifecycle);
    _lifecycle = AppLifecycleListener(onStateChange: (state) {
      _appActive = _isActive(state);
      _syncRunning();
    });
    _tick = Timer.periodic(_tickInterval, (_) {
      if (mounted) setState(() {});
    });
  }

  static bool _isActive(AppLifecycleState state) =>
      state == AppLifecycleState.resumed || state == AppLifecycleState.inactive;

  ArrivalsController _resolveController() {
    final external = widget.controller;
    if (external != null) return external;
    return _ownedController = ArrivalsController(
      client: widget.client!,
      stopId: widget.stopId!,
      minutesAfter: widget.minutesAfter,
      refreshInterval: widget.refreshInterval,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // False when a pushed route covers this one, among other cases.
    _visible = TickerMode.valuesOf(context).enabled;
    _syncRunning();
  }

  @override
  void didUpdateWidget(ObaArrivalsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final changed = widget.controller != oldWidget.controller ||
        (widget.controller == null &&
            (widget.stopId != oldWidget.stopId ||
                widget.client != oldWidget.client ||
                widget.minutesAfter != oldWidget.minutesAfter ||
                widget.refreshInterval != oldWidget.refreshInterval));
    if (!changed) return;
    _controller.removeListener(_onControllerChanged);
    if (_ownedController != null) {
      _ownedController!.dispose();
      _ownedController = null;
    } else {
      _controller.pause();
    }
    _controller = _resolveController();
    _controller.addListener(_onControllerChanged);
    _syncRunning();
  }

  void _syncRunning() {
    if (_appActive && _visible) {
      _controller.resume();
    } else {
      _controller.pause();
    }
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tick?.cancel();
    _lifecycle.dispose();
    _controller.removeListener(_onControllerChanged);
    if (_ownedController != null) {
      _ownedController!.dispose();
    } else {
      _controller.pause();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    final strings = widget.strings;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StopHeader(
          stop: state.stop,
          references: state.references,
          isRefreshing: state.isRefreshing,
          onRefresh: _controller.refresh,
          strings: strings,
        ),
        const Divider(height: 1),
        ..._body(context, state, strings),
      ],
    );
  }

  List<Widget> _body(
      BuildContext context, ArrivalsState state, ObaArrivalsStrings strings) {
    switch (state.status) {
      case ArrivalsStatus.loading:
        return [
          for (var i = 0; i < 3; i++)
            const SkeletonRow(key: ValueKey('oba-skeleton-row')),
        ];
      case ArrivalsStatus.error:
        return [
          PanelMessage(
            message: _errorMessage(state.error, strings),
            action: TextButton(
              onPressed: _controller.refresh,
              child: Text(strings.retry),
            ),
          ),
        ];
      case ArrivalsStatus.loaded:
        final now = _controller.now();
        var rows = visibleArrivals(state.rawArrivals, now);
        final max = widget.maxArrivals;
        if (max != null && rows.length > max) rows = rows.sublist(0, max);
        return [
          if (rows.isEmpty)
            PanelMessage(message: strings.noArrivals(_controller.minutesAfter)),
          for (final (i, arrival) in rows.indexed) ...[
            if (i > 0) const Divider(height: 1, indent: 16, endIndent: 16),
            ArrivalRow(
              arrival: arrival,
              route: state.references.route(arrival.routeId),
              now: now,
              strings: strings,
              onTap: widget.onArrivalTap,
            ),
          ],
          if (state.error != null && state.updatedAt != null)
            StaleNotice(
              key: const ValueKey('oba-stale-notice'),
              message: strings.staleNotice(
                  formatArrivalTime(context, state.updatedAt!)),
            ),
        ];
    }
  }

  static String _errorMessage(Object? error, ObaArrivalsStrings strings) =>
      switch (error) {
        ObaApiException(kind: ObaApiErrorKind.emptyResponse) =>
          strings.stopNotFound,
        ObaNetworkException() => strings.networkError,
        _ => strings.loadError,
      };
}
```

Add to the exports in `packages/oba_arrivals/lib/oba_arrivals.dart`:

```dart
export 'src/arrivals_panel.dart';
export 'src/widgets/arrival_row.dart' show formatArrivalTime;
```

- [ ] **Step 5: Run the tests to see them pass**

Run: `cd packages/oba_arrivals && mise exec -- flutter test && mise exec -- flutter analyze`
Expected: all tests pass, and "No issues found!"

If `'departed row disappears on tick'` fails because a later
`tester.pump(Duration)` also rebuilt the controller state, check that
`refreshInterval: 10 min` is being passed through. That test must see exactly
1 request.

- [ ] **Step 6: Commit**

```bash
git add packages/oba_arrivals
git commit -m "Add ObaArrivalsPanel with header, rows, states and lifecycle-aware polling"
```

---

### Task 8: Golden tests (light and dark)

**Files:**
- Create: `packages/oba_arrivals/test/golden/panel_golden_test.dart`
- Create (generated): `packages/oba_arrivals/test/golden/goldens/panel_light.png`
- Create (generated): `packages/oba_arrivals/test/golden/goldens/panel_dark.png`

**Interfaces:**
- Consumes: `ObaArrivalsPanel`, `fakeClient` and `okResponse` from the
  earlier tasks.
- Produces: golden images, regenerated with
  `TZ=America/Los_Angeles mise exec -- flutter test --tags golden --update-goldens`.

- [ ] **Step 1: Write the golden test**

`packages/oba_arrivals/test/golden/panel_golden_test.dart`:

```dart
@Tags(['golden'])
library;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';

import '../support/fixtures.dart';

/// Finds `<flutter>/bin/cache/artifacts/material_fonts` by walking up from
/// the flutter_tester executable.
Directory materialFontsDir() {
  var dir = File(Platform.resolvedExecutable).parent;
  while (dir.parent.path != dir.path) {
    final candidate =
        Directory('${dir.path}/bin/cache/artifacts/material_fonts');
    if (candidate.existsSync()) return candidate;
    dir = dir.parent;
  }
  throw StateError('material_fonts not found above ${Platform.resolvedExecutable}');
}

Future<void> loadFonts() async {
  final fonts = materialFontsDir();
  Future<ByteData> bytes(String name) async =>
      ByteData.sublistView(File('${fonts.path}/$name').readAsBytesSync());
  final roboto = FontLoader('Roboto')
    ..addFont(bytes('Roboto-Regular.ttf'))
    ..addFont(bytes('Roboto-Medium.ttf'))
    ..addFont(bytes('Roboto-Bold.ttf'));
  final icons = FontLoader('MaterialIcons')
    ..addFont(bytes('MaterialIcons-Regular.otf'));
  await Future.wait([roboto.load(), icons.load()]);
}

/// Goldens contain local times, so they only match in US Pacific time.
final bool inPacificTime =
    fixtureServerTime.toLocal().timeZoneOffset == const Duration(hours: -7);

void main() {
  final skip = !Platform.isMacOS || !inPacificTime
      ? 'Goldens are generated on macOS with TZ=America/Los_Angeles'
      : null;

  setUpAll(loadFonts);

  for (final (name, theme) in [
    ('light', ThemeData(colorSchemeSeed: const Color(0xFF182B49))),
    ('dark', ThemeData(
        colorSchemeSeed: const Color(0xFF182B49), brightness: Brightness.dark)),
  ]) {
    testWidgets('panel $name', (tester) async {
      tester.view.physicalSize = const Size(400, 520);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          body: ObaArrivalsPanel(
            client: fakeClient((_) async => okResponse()),
            stopId: 'MTS_24151',
            onArrivalTap: (_) {},
          ),
        ),
      ));
      await tester.pump();
      await tester.pump();

      await expectLater(
        find.byType(ObaArrivalsPanel),
        matchesGoldenFile('goldens/panel_$name.png'),
      );
    }, skip: skip != null);
  }
}
```

- [ ] **Step 2: Generate the goldens**

Run: `cd packages/oba_arrivals && TZ=America/Los_Angeles mise exec -- flutter test --tags golden --update-goldens`
Expected: PASS, and it creates `test/golden/goldens/panel_light.png` and
`panel_dark.png`.

- [ ] **Step 3: Inspect the goldens**

Open both PNGs with the Read tool. Check each one:
- Roboto text renders, not black boxes. Icons render, not squares.
- The header reads "Eighth College / Theatre District (North)" and
  "Stop #24151 · Southwest bound · 101, 30, IL, S".
- Three rows appear: 30 Old Town (4m, green), IL Inside Loop (5m, violet, "2
  min late"), and S SIO (8m, muted, clock icon).
- The IL badge is yellow with black text.
- The dark theme has light text on a dark surface.

If any check fails, fix the widget, not the golden.

- [ ] **Step 4: Verify the goldens pass without the update flag**

Run: `cd packages/oba_arrivals && TZ=America/Los_Angeles mise exec -- flutter test`
Expected: all tests pass, including the goldens.

- [ ] **Step 5: Commit**

```bash
git add packages/oba_arrivals/test/golden
git commit -m "Add light and dark golden tests for ObaArrivalsPanel"
```

---

### Task 9: Demo app (`oba_dart`)

**Files:**
- Modify: `pubspec.yaml` (dependencies)
- Create: `lib/config.dart`
- Create: `lib/demo_stops.dart`
- Create: `lib/app.dart`
- Create: `lib/home_page.dart`
- Create: `lib/shuttle_card.dart`
- Create: `lib/all_arrivals_page.dart`
- Modify: `lib/main.dart` (replace the template)
- Modify: `test/widget_test.dart` (replace the template)

**Interfaces:**
- Consumes: `OneBusAwayClient` and `ObaArrivalsPanel`.
- Produces:
  - `class StudentLifeDemoApp extends StatefulWidget { const StudentLifeDemoApp({Key? key, required OneBusAwayClient client}); }`
  - `const demoStops` (`List<DemoStop>`)
  - `class AppConfig { static const baseUrl; static const apiKey; }`

- [ ] **Step 1: Add dependencies**

In the root `pubspec.yaml`, change the `description` to
`"OneBusAway arrivals demo host for UCSD Student Life."` and set the
dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  oba_arrivals:
    path: packages/oba_arrivals
  onebusaway:
    path: packages/onebusaway

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
  http: ^1.6.0
```

Run: `mise exec -- flutter pub get`
Expected: "Got dependencies!"

- [ ] **Step 2: Write the failing smoke test**

Replace `test/widget_test.dart`:

```dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:oba_dart/app.dart';
import 'package:onebusaway/onebusaway.dart';

void main() {
  final fixture = File('packages/onebusaway/test/fixtures/arrivals_mts_24151.json')
      .readAsStringSync();

  OneBusAwayClient client(List<String> requested) => OneBusAwayClient(
        baseUrl: Uri.parse('https://realtime.sdmts.com/api/'),
        apiKey: 'test',
        httpClient: MockClient((r) async {
          requested.add(r.url.pathSegments.last);
          return http.Response(fixture, 200);
        }),
      );

  testWidgets('home feed embeds the shuttle panel capped at 3 rows',
      (tester) async {
    final requested = <String>[];
    await tester.pumpWidget(StudentLifeDemoApp(client: client(requested)));
    await tester.pump();
    await tester.pump();

    expect(find.text('UC San Diego'), findsOneWidget);
    expect(find.text('SHUTTLE'), findsOneWidget);
    expect(find.text('Old Town'), findsOneWidget);
    expect(requested, ['MTS_24151.json']);
  });

  testWidgets('See all pushes a full page and the card stops polling',
      (tester) async {
    final requested = <String>[];
    await tester.pumpWidget(StudentLifeDemoApp(client: client(requested)));
    await tester.pump();
    await tester.pump();

    await tester.tap(find.text('SEE ALL ARRIVALS'));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);
    final before = requested.length;
    await tester.pump(const Duration(seconds: 30));
    await tester.pump();
    // Only the full-page panel polls; the covered card is paused.
    expect(requested.length, before + 1);
  });

  testWidgets('tapping a row shows a snackbar', (tester) async {
    await tester.pumpWidget(StudentLifeDemoApp(client: client([])));
    await tester.pump();
    await tester.pump();
    await tester.tap(find.text('Old Town'));
    await tester.pump();
    expect(find.text('30 → Old Town'), findsOneWidget);
  });
}
```

- [ ] **Step 3: Run the test to see it fail**

Run: `mise exec -- flutter test test/widget_test.dart`
Expected: FAIL with a compile error (`package:oba_dart/app.dart` not found).

- [ ] **Step 4: Implement the demo app**

`lib/config.dart`:

```dart
/// Build-time configuration:
/// `flutter run --dart-define=OBA_BASE_URL=... --dart-define=OBA_API_KEY=...`
class AppConfig {
  /// OBA server root (endpoints live under `{baseUrl}api/where/`).
  static const baseUrl = String.fromEnvironment(
    'OBA_BASE_URL',
    defaultValue: 'https://realtime.sdmts.com/api/',
  );

  static const apiKey = String.fromEnvironment(
    'OBA_API_KEY',
    defaultValue: 'org.onebusaway.iphone',
  );
}
```

`lib/demo_stops.dart`:

```dart
class DemoStop {
  const DemoStop(this.id, this.label);

  final String id;
  final String label;
}

/// UCSD stops verified against realtime.sdmts.com on 2026-09-23.
const demoStops = [
  DemoStop('MTS_24151', 'Eighth College / Theatre District'),
  DemoStop('MTS_88986', 'UCSD Central Campus Trolley'),
  DemoStop('MTS_11902', 'Gilman Transit Center'),
];
```

`lib/main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:onebusaway/onebusaway.dart';

import 'app.dart';
import 'config.dart';

void main() {
  final client = OneBusAwayClient(
    baseUrl: Uri.parse(AppConfig.baseUrl),
    apiKey: AppConfig.apiKey,
  );
  runApp(StudentLifeDemoApp(client: client));
}
```

`lib/app.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:onebusaway/onebusaway.dart';

import 'home_page.dart';

const _navy = Color(0xFF182B49);
const _gold = Color(0xFFFFCD00);

/// A stand-in for the UCSD Student Life app shell.
class StudentLifeDemoApp extends StatefulWidget {
  const StudentLifeDemoApp({super.key, required this.client});

  final OneBusAwayClient client;

  @override
  State<StudentLifeDemoApp> createState() => _StudentLifeDemoAppState();
}

class _StudentLifeDemoAppState extends State<StudentLifeDemoApp> {
  ThemeMode _mode = ThemeMode.light;

  ThemeData _theme(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: _navy,
      brightness: brightness,
    ).copyWith(secondary: _gold, onSecondary: Colors.black);
    return ThemeData(
      colorScheme: scheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: _navy,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      scaffoldBackgroundColor:
          brightness == Brightness.light ? const Color(0xFFE9ECF2) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OBA Arrivals Demo',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      themeMode: _mode,
      home: HomePage(
        client: widget.client,
        isDark: _mode == ThemeMode.dark,
        onToggleDark: () => setState(() {
          _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
        }),
      ),
    );
  }
}
```

`lib/home_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:onebusaway/onebusaway.dart';

import 'shuttle_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
    required this.client,
    required this.isDark,
    required this.onToggleDark,
  });

  final OneBusAwayClient client;
  final bool isDark;
  final VoidCallback onToggleDark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'UC San Diego',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        actions: [
          IconButton(
            tooltip: isDark ? 'Light mode' : 'Dark mode',
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: onToggleDark,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ShuttleCard(client: client),
          const SizedBox(height: 12),
          const _PlaceholderCard(title: 'MY STUDENT CHART'),
        ],
      ),
    );
  }
}

class _PlaceholderCard extends StatelessWidget {
  const _PlaceholderCard({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
```

`lib/shuttle_card.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:onebusaway/onebusaway.dart';

import 'all_arrivals_page.dart';
import 'demo_stops.dart';

void showArrivalSnackBar(BuildContext context, ArrivalAndDeparture arrival) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text('${arrival.routeShortName ?? ''} → ${arrival.tripHeadsign ?? ''}'),
  ));
}

/// The Student Life "Shuttle" card, powered by ObaArrivalsPanel.
class ShuttleCard extends StatefulWidget {
  const ShuttleCard({super.key, required this.client});

  final OneBusAwayClient client;

  @override
  State<ShuttleCard> createState() => _ShuttleCardState();
}

class _ShuttleCardState extends State<ShuttleCard> {
  DemoStop _stop = demoStops.first;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 4, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text('SHUTTLE',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                ),
                PopupMenuButton<DemoStop>(
                  tooltip: 'Choose stop',
                  icon: const Icon(Icons.more_vert),
                  initialValue: _stop,
                  onSelected: (stop) => setState(() => _stop = stop),
                  itemBuilder: (_) => [
                    for (final stop in demoStops)
                      PopupMenuItem(value: stop, child: Text(stop.label)),
                  ],
                ),
              ],
            ),
          ),
          ObaArrivalsPanel(
            client: widget.client,
            stopId: _stop.id,
            maxArrivals: 3,
            onArrivalTap: (a) => showArrivalSnackBar(context, a),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                ),
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      AllArrivalsPage(client: widget.client, stop: _stop),
                )),
                child: const Text('SEE ALL ARRIVALS'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

`lib/all_arrivals_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:onebusaway/onebusaway.dart';

import 'demo_stops.dart';
import 'shuttle_card.dart';

class AllArrivalsPage extends StatelessWidget {
  const AllArrivalsPage({super.key, required this.client, required this.stop});

  final OneBusAwayClient client;
  final DemoStop stop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Arrivals')),
      body: SingleChildScrollView(
        child: SafeArea(
          child: ObaArrivalsPanel(
            client: client,
            stopId: stop.id,
            onArrivalTap: (a) => showArrivalSnackBar(context, a),
          ),
        ),
      ),
    );
  }
}
```

- [ ] **Step 5: Run the tests and analyzer**

Run: `mise exec -- flutter test && mise exec -- flutter analyze`
Expected: all tests pass, and "No issues found!"

- [ ] **Step 6: Run the app against live SDMTS**

Run: `mise exec -- flutter run -d macos`, or an iOS simulator via the
XcodeBuildMCP skill.
Expected:
- The feed shows the SHUTTLE card with live rows for Eighth College (if
  there's service) or "No arrivals in the next 35 minutes".
- The stop menu switches stops.
- "SEE ALL ARRIVALS" opens the full list.
- The dark-mode toggle restyles the panel.

Take a screenshot for the record.

- [ ] **Step 7: Commit**

```bash
git add pubspec.yaml pubspec.lock lib test
git commit -m "Build Student Life demo host embedding ObaArrivalsPanel"
```

---

### Task 10: READMEs and git-consumption verification

**Files:**
- Create: `packages/oba_arrivals/README.md`
- Modify: `README.md` (root, replace the template)

**Interfaces:**
- Consumes: the finished packages.
- Produces: documentation, plus proof that a git dependency resolves and
  builds.

- [ ] **Step 1: Write the `oba_arrivals` README**

`packages/oba_arrivals/README.md`:

````markdown
# oba_arrivals

A Wayfinder-style OneBusAway arrivals and departures panel for Flutter apps.

## Install

```yaml
dependencies:
  oba_arrivals:
    git:
      url: <this repository>
      path: packages/oba_arrivals
  onebusaway:
    git:
      url: <this repository>
      path: packages/onebusaway
```

## Embed

```dart
final client = OneBusAwayClient(
  baseUrl: Uri.parse('https://realtime.sdmts.com/api/'), // OBA server root
  apiKey: '<your key>',
);

ObaArrivalsPanel(
  client: client,
  stopId: 'MTS_24151',
  maxArrivals: 3,                    // optional; good for home-feed cards
  onArrivalTap: (arrival) { /* … */ }, // optional; rows are static without it
)
```

The panel is a non-scrolling `Column`. Wrap it in a scroll view for
full-screen use.

- It polls every 30 s while it is visible and the app is in the foreground.
- It pauses when a pushed route covers it.
- It corrects the device's clock using the server's time.

## Theming

Surfaces, text and fonts come from your `Theme`. Status colors and badge
metrics come from `ObaArrivalsTheme`. If you don't register one, the panel
picks the light or dark default from the theme's brightness.

```dart
ThemeData(extensions: [
  ObaArrivalsTheme.light().copyWith(late: Colors.deepOrange),
]);
```

## Strings

Subclass `ObaArrivalsStrings` and pass it as `strings:` to translate or
reword any text.

## Controller

To share state or trigger refreshes, create the controller yourself:

```dart
final controller = ArrivalsController(client: client, stopId: 'MTS_24151');
ObaArrivalsPanel(controller: controller);
// …
controller.refresh();
controller.dispose(); // you own it
```

## Goldens

```bash
TZ=America/Los_Angeles flutter test --tags golden --update-goldens
```

Goldens are skipped unless the tests run on macOS in US Pacific time.
````

- [ ] **Step 2: Replace the root README**

`README.md`:

````markdown
# oba_dart

This is a demo host app and the packages behind it. Together they let UCSD
embed OneBusAway real-time arrivals in its Flutter Student Life app.

| Path | What |
|---|---|
| `packages/onebusaway` | Pure-Dart OneBusAway REST client. It is built to grow toward the full API |
| `packages/oba_arrivals` | Flutter arrivals panel (`ObaArrivalsPanel`) |
| `lib/` | Demo app that mimics the Student Life home feed |
| `docs/superpowers/` | Design spec and implementation plan |

## Setup

The toolchain is pinned with [mise](https://mise.jdx.dev): Flutter 3.47.5 /
Dart 3.13.4.

```bash
mise install
mise exec -- flutter pub get
```

## Run the demo

```bash
mise exec -- flutter run
# Optional overrides:
mise exec -- flutter run \
  --dart-define=OBA_BASE_URL=https://realtime.sdmts.com/api/ \
  --dart-define=OBA_API_KEY=org.onebusaway.iphone
```

`OBA_BASE_URL` is the OBA *server root*. The API lives at
`{OBA_BASE_URL}api/where/…`.

## Test

```bash
mise exec -- flutter test                                     # demo app
(cd packages/onebusaway && mise exec -- dart test)
(cd packages/oba_arrivals && TZ=America/Los_Angeles mise exec -- flutter test)
```

## Platforms

iOS and Android are the primary targets, and macOS works for desktop runs.
The SDMTS server sends CORS headers for localhost, so `flutter run -d chrome`
works against it. Other OBA servers may not send those headers.
````

- [ ] **Step 3: Verify that a git consumer can resolve and build**

Commit first, because the git dependency reads committed history:

```bash
git add README.md packages/oba_arrivals/README.md
git commit -m "Add READMEs for demo and packages"
```

Then run the following from the repo root:

```bash
SCRATCH=$(mktemp -d)
cd "$SCRATCH"
cp /Users/aaron/repos/onebusaway/flutter-example/mise.toml .
mise trust -q .
mise exec -- flutter create --project-name git_consumer --platforms macos .
mise exec -- flutter pub add 'oba_arrivals:{"git":{"url":"/Users/aaron/repos/onebusaway/flutter-example","path":"packages/oba_arrivals"}}'
mise exec -- flutter pub add 'onebusaway:{"git":{"url":"/Users/aaron/repos/onebusaway/flutter-example","path":"packages/onebusaway"}}'
cat > lib/main.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:onebusaway/onebusaway.dart';

void main() {
  final client = OneBusAwayClient(
    baseUrl: Uri.parse('https://realtime.sdmts.com/api/'),
    apiKey: 'org.onebusaway.iphone',
  );
  runApp(MaterialApp(
    home: Scaffold(body: ObaArrivalsPanel(client: client, stopId: 'MTS_24151')),
  ));
}
EOF
mise exec -- flutter build macos --debug
```

Expected: `flutter pub add` resolves both packages from git without
contacting pub.dev for them, and the build ends with
"✓ Built build/macos/Build/Products/Debug/git_consumer.app".

If resolution fails, record the exact error and stop. Don't paper over it.
The likely cause is `oba_arrivals`'s `path: ../onebusaway` dependency inside
a git dependency. Report it, because it affects how UCSD consumes the
package. On success, delete `$SCRATCH`.

- [ ] **Step 4: Final full verification**

From the repo root:

```bash
mise exec -- flutter analyze
mise exec -- flutter test
(cd packages/onebusaway && mise exec -- dart test && mise exec -- dart analyze)
(cd packages/oba_arrivals && TZ=America/Los_Angeles mise exec -- flutter test && mise exec -- flutter analyze)
```

Expected: every command reports no issues and all tests pass.
````
