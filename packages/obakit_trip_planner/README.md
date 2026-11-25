# obakit_trip_planner

An embeddable OpenTripPlanner (OTP) trip planner for Flutter apps: the
Flutter counterpart of the Swift
[OTPKit](https://github.com/OneBusAway/otpkit) package used by OneBusAway
for iOS.

It has three layers, usable separately:

- **OTP client** (`OtpClient`, pure Dart under `lib/src/api/`). It prefers
  the OTP 2.x GTFS GraphQL API and falls back to the OTP 1.x REST API. Both
  decode into the same models: `TripPlan`, `Itinerary`, `Leg`, `Place`,
  `LegStep`.
- **`TripPlannerController`**, a `ChangeNotifier` holding an immutable
  `TripPlannerState`: endpoints, time, mode, options, and results.
- **Material 3 widgets**: `TripPlannerView` (the form and results) and
  `ItineraryDetailView` / `ItineraryDetailPage` (step-by-step directions with
  a `flutter_map` map).

The package depends only on `http`, `flutter_map`, `latlong2` and `clock`. It
doesn't depend on the other packages in this repository.

## Install

```yaml
dependencies:
  obakit_trip_planner:
    git:
      url: https://github.com/onebusaway/oba-dart.git
      path: packages/obakit_trip_planner
      ref: <commit SHA or branch> # not in a release tag yet
```

This package is unreleased: the `0.1.0` tag predates it. Pin a commit or a
branch until the next tag.

Requires Flutter 3.47 or later (Dart 3.13.4 or later).

## Embed

```dart
import 'package:obakit_trip_planner/obakit_trip_planner.dart';

// Create the client once and reuse it. Close it when you're done.
final otp = OtpClient(
  graphqlBaseUrl: Uri.parse('https://sound-transit-otp.ibi-transit.com/otp/'),
  restBaseUrl: Uri.parse('https://otp.prod.sound.obaweb.org/otp/routers/default/'),
);

Scaffold(
  appBar: AppBar(title: const Text('Plan a trip')),
  body: TripPlannerView(
    service: otp,
    placeSearch: MyPlaceSearch(), // your geocoder; see below
    mapConfig: const TripMapConfig(userAgentPackageName: 'edu.example.app'),
    currentLocation: () async => myDeviceLocation(), // optional
    initialDestination: const TripPlace(name: 'Geisel Library', lat: 32.8811, lon: -117.2376), // optional
  ),
);
```

`TripPlannerView` is a scrolling `ListView` that fills its parent, so put it
in a `Scaffold` body or another bounded box. Tapping an itinerary pushes an
`ItineraryDetailPage`. To show the detail somewhere else, such as in a side
pane, pass `onItineraryTap`.

When the view gets a `service`, it creates and disposes its own controller.
To keep planner state outside the view (for example, to prefill it from a stop
page, or to share it between screens), create a `TripPlannerController` and
pass it as `controller:`. The view never disposes a controller it didn't
create.

```dart
final controller = TripPlannerController(
  service: otp,
  destination: stopAsTripPlace,
  enabledModes: [TransportMode.transit, TransportMode.walk, TransportMode.bike],
  onError: (error, stack) => log.warning('trip plan failed', error, stack),
);
```

### Place search

Place entry goes through an interface that the host app implements, so you
can use any geocoder: a platform geocoder, Pelias, OBA stop search, or a
fixed list of campus buildings.

```dart
class MyPlaceSearch implements TripPlaceSearch {
  @override
  Future<List<TripPlace>> search(String query, {TripPlace? near}) async {
    final hits = await myGeocoder.lookup(query, biasNear: near);
    return [
      for (final hit in hits)
        TripPlace(name: hit.name, subtitle: hit.address, lat: hit.lat, lon: hit.lon),
    ];
  }
}
```

- The search page debounces typing (300 ms) and passes the other endpoint as
  `near`.
- Throwing shows a search error. Return an empty list for "no matches".
- `currentLocation` should return a `TripPlace` with
  `isCurrentLocation: true`, or null when location is unavailable or denied.
  The view uses it to fill an empty origin on start, as OTPKit does, and
  offers it as "Use current location" in search.

### Configuring from an OBA region

OBA regions carry `otpBaseGraphqlUrl` and `otpBaseUrl`. `OtpClient.fromRegion`
ignores blank values and returns null when the region has no trip planner:

```dart
final otp = OtpClient.fromRegion(
  otpBaseGraphqlUrl: region.otpBaseGraphqlUrl,
  otpBaseUrl: region.otpBaseUrl,
);
if (otp == null) { /* hide trip planning */ }
```

## The OTP client

`OtpClient` implements `TripPlanService`, the interface the controller
depends on. You can supply your own implementation for a different backend
or for tests.

| | GraphQL (OTP 2.x) | REST (OTP 1.x) |
|---|---|---|
| Base URL | OTP root, e.g. `https://host/otp/` | OTP root or router URL |
| Request | `POST {root}/gtfs/v1` with `{query, variables}` | `GET {root}/routers/default/plan?...` |
| Normalization | Strips a trailing `routers/<id>`, then appends `gtfs/v1` | Appends `routers/default` unless a router segment is present |

Both flavours send the date as `MM-dd-yyyy` and the time as `h:mm AM`, in the
device's time zone, as OTPKit does. REST also sends `fromPlace`/`toPlace`
(`lat,lon` with four decimals), `mode`, `arriveBy`, `maxWalkDistance`,
`wheelchair` and `showIntermediateStops=true`. Pass extra headers, such as an
API key, with `headers:`. The default timeout is 30 s.

**Fallback.** When both URLs are set, a request goes to GraphQL first. It is
retried over REST only if GraphQL failed: a network error, a non-200 status,
a malformed body, or a GraphQL `errors` array (for example, a schema too old
for the query). A planner answer such as "no route" is returned as is. If
REST fails too, its error is the one thrown.

**Errors** are all subtypes of `sealed class OtpException`:

| Type | When | `triggersFallback` |
|---|---|---|
| `OtpNetworkException` | DNS, TLS, connection reset, timeout | yes |
| `OtpHttpException(statusCode)` | Any status other than 200 | yes |
| `OtpFormatException` | Not JSON, or not the expected shape | yes |
| `OtpGraphQLException(messages)` | GraphQL top-level `errors` | yes |
| `OtpPlannerException(code)` | REST `error` object, or GraphQL `routingErrors` with no itineraries | no |

`PlannerErrorCode` mirrors OTP 1.x message keys. GraphQL routing error codes
map onto them as in OTPKit (`NO_TRANSIT_CONNECTION` → `pathNotFound`, and so
on). `WALKING_BETTER_THAN_TRANSIT` is advisory and is ignored. An empty
itinerary list with no error is a valid plan, and the view shows "No trips
found".

Models: `Itinerary.relevantLegs` drops walks of a minute or less and merges
consecutive legs on the same route (OTPKit's summary rule).
`Leg.geometry` decodes the leg's Google-encoded polyline into `GeoPoint`
records. `Itinerary.fare` is filled from OTP 1.x `fare.fare.regular` and is
null for GraphQL.

## Configuration

### Map tiles

```dart
TripMapConfig(
  userAgentPackageName: 'edu.example.app', // required: identifies your app to the tile server
  tileUrlTemplate: 'https://tiles.example.com/{z}/{x}/{y}.png', // default: OpenStreetMap
  attribution: 'Example Maps, OpenStreetMap contributors',      // shown as "© …"
  onAttributionTap: () => launchUrl(copyrightUri),              // optional
)
```

The default uses OpenStreetMap's public tile servers. Their
[usage policy](https://operations.osmfoundation.org/policies/tiles/) asks for
an identifying User-Agent and allows only light use. Apps with real traffic
should use their own tile provider. `tileProvider:` replaces flutter_map's
network provider, for caching or for tests.

### Modes and options

- `enabledModes` defaults to OTPKit's `[transit, walk, bike, car]`.
- `bikeRental` and `transitBikeRental` are opt-in. They are shown only when
  the service reports `supportsVehicleRental`, which for `OtpClient` means a
  GraphQL URL is configured.
- The form also sets leave now, depart at, or arrive by (with a date and time
  picker), wheelchair accessibility, and the maximum walking distance
  (OTPKit's ¼, ½, 1 and 2 mile presets).
- Changing any input clears the results and drops any request in flight.
  Planning starts only when the rider taps **Plan trip**, as in OTPKit.

### Units, times and text

- Distances use miles and feet for the US and its territories, Liberia,
  Myanmar and the UK, and kilometres and metres elsewhere (the same policy
  as `obakit_core`'s `MeasurementSystem`). Pass `distanceUnits:` to force
  either.
- Clock times use `MaterialLocalizations` and honour the device's 24-hour
  setting.
- All user-facing text lives in `TripPlannerStrings`. Subclass it and pass
  `strings:` to localize or reword:

```dart
class SpanishTripStrings extends TripPlannerStrings {
  const SpanishTripStrings();
  @override
  String get planTrip => 'Planificar viaje';
  // …
}
```

## Theming

The widgets use the host `ColorScheme` and `TextTheme` and work in light and
dark themes. Mode and status colours come from the `TripPlannerTheme`
`ThemeExtension`. When the host doesn't register one, the package derives
one from the `ColorScheme`: transit from `primary`, walk from `outline`,
bike from `tertiary` and car from `secondary`. Status colours match
`ObaArrivalsTheme`. Transit legs use their GTFS route colour and route text
colour when the feed provides them.

```dart
ThemeData(
  colorScheme: scheme,
  extensions: [
    TripPlannerTheme.fromColorScheme(scheme).copyWith(
      walk: Colors.grey,
      polylineWidth: 6,
    ),
  ],
)
```

## Accessibility

The planner targets WCAG 2.1 AA, in light and dark themes, inside the
host's theme.

What the package guarantees:

- **Contrast.** The default status colours (shared with `oba_arrivals`:
  green-800 / violet-700 / red-700 in light, green-400 / violet-300 /
  red-300 in dark) are at least 4.5:1 on every Material 3 surface role,
  including the selected card's `secondaryContainer`. Widgets check status
  and secondary text against the surface they are drawn on and adjust them
  only if they fall short, and foreground roles of your `ColorScheme` used
  by chips and buttons are corrected the same way
  (`TripPlannerContrast.accessibleScheme`). Text on route colours is always
  at least 4.5:1: a feed `route_text_color` that fails is replaced with
  black or white, and `contrastingTextColor` now uses the WCAG ratio rather
  than estimated brightness. With the platform's high-contrast setting, the
  stronger palette (`fromColorScheme(highContrast: true)`) is used.
- **Text size.** Text comes from your `TextTheme` and follows the user's
  text size with no clamping or truncation of place names, route names or
  times. At 130% and above, the detail view folds its time column into the
  step text. The place search field sits in the page body, so it can grow.
- **Screen readers.** Itinerary cards read as one sentence: "9:04 AM to
  9:46 AM, 41 minutes. Walk 5 minutes, then Tram Blue, 35 minutes. Walk 0.3
  miles, 1 transfer. Departs 9:09 AM from …, real-time, 3 minutes late"
  (or "scheduled time"). Durations and distances are spoken in full words.
  Origin and destination read as "From: Geisel Library" buttons, and the
  search field has a visible label. "Suggested trips" and the itinerary
  summary are headings, the number of trips or places found is announced,
  and errors and "No trips found" are live regions. "Show 12 stops" exposes
  its expanded state. The map is a single labelled node ("Map of the trip.
  The directions below describe the same trip.") whose text alternative is
  the step list. Its tiles, lines and markers are excluded, and the
  attribution is a separate link.
- **Input.** All controls are at least 48x48dp, including the "Show stops"
  buttons and a tappable map attribution. Cards and place fields work with
  Tab and Enter/Space and show a 2dp focus ring. With reduced motion on,
  progress spinners become static.

What you must do as an embedder:

- If you register a `TripPlannerTheme`, pick status and mode colours with
  at least 4.5:1 (text) or 3:1 (map lines and chips) against your surfaces.
- Keep `ItineraryDetailView`'s step list visible whenever you show the map,
  because it is the map's text alternative. Don't use the map on its own.
- Give the planner a scrollable, unconstrained height so it can grow at
  200% text.
- Translate the spoken strings too if you subclass `TripPlannerStrings`
  (`durationSemantics`, `distanceSemantics`, `realTimeStatusSemantics`, …).

`test/accessibility_test.dart` runs Flutter's tap-target, label and text
contrast guidelines on the form, loading, results, empty and error states,
the itinerary detail and place search, in light and dark, at 100% and 200%
text.

## Development

```bash
cd packages/obakit_trip_planner
TZ=America/Los_Angeles mise exec -- flutter test
mise exec -- flutter analyze
mise exec -- dart format .
```

Tests assume Pacific time for formatted times. Fixtures in `test/fixtures/`
include real captures from SDMTS (OTP 1.x REST) and Sound Transit (OTP 2.x
GraphQL), plus OTPKit's own fixtures.

## Differences from OTPKit

- Planner errors are thrown as `OtpPlannerException` rather than returned
  inside an `OTPResponse`.
- `OtpClient` combines both flavours and falls back at runtime. The iOS app
  picks one flavour from the region's configuration.
- The GraphQL query also requests `route.longName`.
- `TripPlanRequest` takes one `dateTime` instead of separate date and time
  values.
- Not ported: vehicle rental browsing (`fetchVehicleRentals`), via-point UI
  (the request supports `viaPoint`), trip progress and live in-trip
  tracking, favourites and recent places, route preference, and persistence
  of options across launches. The host owns these.
