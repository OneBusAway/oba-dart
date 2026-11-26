# oba_dart

A Flutter port of the OneBusAway iOS app, built as an SDK. Each part of the
app lives in a package that another app can embed. The app in `lib/` is a
thin shim over those packages, in the same way the iOS `Apps/OneBusAway`
target is a shim over `OBAKit`.

The main use case is embedding individual parts (a stop page, a nearby-stops
card, the map, the trip planner, the arrivals panel) in a host app such as
the UCSD Student Life app. Running the whole app is the second use case.

| Path | What | Flutter? |
|---|---|---|
| `packages/onebusaway` | OneBusAway REST client, Regions API client, Obaco (sidecar) client, polyline codec | No (pure Dart) |
| `packages/obakit_core` | App logic: `ObaAppConfig`, `ObaCoreApplication`, regions, user data, settings, deep links, search, formatters, alarms, surveys. Platform access goes through interfaces | No (pure Dart) |
| `packages/oba_arrivals` | Arrivals panel (`ObaArrivalsPanel`). Released as 0.1.0. `example/` is the UCSD Student Life embedding demo | Yes |
| `packages/obakit` | UI SDK: `ObaApp`, `ObaScope`, theme, localization, map, and every screen, each exported for standalone embedding | Yes |
| `packages/obakit_trip_planner` | OpenTripPlanner client (GraphQL, falling back to REST) and trip planner UI | Yes |
| `lib/` | The app shim: `main.dart` and `app_config.dart` only (the regions list comes from `obakit`) | Yes |
| `integration_test/` | Live end-to-end walkthrough of the app | Yes |
| `docs/superpowers/` | Design spec and implementation plans | |

Dependencies point one way:
`lib → obakit → { obakit_core, oba_arrivals, obakit_trip_planner } → onebusaway`.

## Embed a part in your app

Every screen is a plain widget that needs only an `ObaScope` ancestor. Create
one `ObaApplication`, wrap the part of your tree that shows SDK widgets in an
`ObaScope`, and place the widget you want. This example puts a stop page and a
nearby-stops section in a host app:

```dart
final app = await ObaApplication.create(
  map: const ObaMapConfig(userAgentPackageName: 'edu.example.app'),
  nominatimUserAgent: 'MyApp/1.0 (edu.example.app)', // address search; optional
  config: (services) => ObaAppConfig(
    appName: 'MyApp',
    apiKey: '<your OBA API key>',
    appVersion: '1.0.0',
    keyValueStore: services.keyValueStore,
    locationProvider: services.locationProvider,
    placeSearchProvider: services.placeSearchProvider,
  ),
);

ObaScope(
  application: app,
  child: ListView(children: const [
    NearbyStopsSection(),                  // non-scrolling, drops into a feed
    // Or push a full page from your own routes:
    //   StopPage(stopId: 'MTS_11589')
  ]),
);
```

The regions list ships with the SDK (no asset to copy). Location is used
only while a visible part needs it (the map, a nearby section, a stop
page's walk times), never just because permission was granted. To show
stops near a fixed point (a campus) without the device's location, pass
`around:`; to anchor every part there, or to give the SDK no location at
all, pass a location provider:

```dart
const ObaNearbyStopsCard(around: Coordinate(32.8801, -117.2340)); // no location used

final campusApp = await ObaApplication.create(
  map: const ObaMapConfig(userAgentPackageName: 'edu.example.app'),
  services: ObaPlatformServices(
    keyValueStore: await SharedPreferencesKeyValueStore.create(),
    locationProvider: FixedLocationProvider(const Coordinate(32.8801, -117.2340)),
    // or: const NoLocationProvider() (parts then say location isn't used)
  ),
  config: (services) => ObaAppConfig(
    appName: 'MyApp',
    apiKey: '<your OBA API key>',
    appVersion: '1.0.0',
    keyValueStore: services.keyValueStore,
    locationProvider: services.locationProvider,
    regionsPath: null,                                      // no regions download
    fixedRegion: const FixedRegionConfig(name: 'San Diego'),
  ),
);
```

`obakit` links the `geolocator`, `shared_preferences`, `url_launcher` and
`share_plus` plugins. The location permission keys (`Info.plist`,
`AndroidManifest.xml`) are needed only with the default location provider,
not with `FixedLocationProvider` or `NoLocationProvider`. See
[Platform setup](packages/obakit/README.md#platform-setup-a-host-needs).

Recipes for the other parts are in the package READMEs:

- [`packages/obakit/README.md`](packages/obakit/README.md): creating the
  application, location (demand-driven, fixed or none), the stop page,
  nearby stops, the map (including dark tiles), bookmarks, alerts,
  settings, search, weather, host navigation, theming, localization, the
  platform setup a host needs, and refreshing the bundled regions list.
- [`packages/oba_arrivals/README.md`](packages/oba_arrivals/README.md): the
  arrivals panel on its own, without `obakit`.
- [`packages/obakit_trip_planner/README.md`](packages/obakit_trip_planner/README.md):
  the trip planner on its own.
- [`packages/obakit_core/README.md`](packages/obakit_core/README.md) and
  [`packages/onebusaway/README.md`](packages/onebusaway/README.md): the
  pure-Dart layers.

### Install

Add the packages as git dependencies on this repository. Pub resolves the
sibling packages from the same repository.

```yaml
dependencies:
  oba_arrivals:
    git:
      url: https://github.com/onebusaway/oba-dart.git
      path: packages/oba_arrivals
      ref: 0.1.0 # pin a release tag
```

Release tags are unprefixed (`0.1.0`). Only `0.1.0` exists. It contains
`onebusaway` and `oba_arrivals`, and `onebusaway` at that tag has only the
arrivals endpoints. `obakit`, `obakit_core` and `obakit_trip_planner` are
unreleased: until the next tag, pin a commit SHA or a branch in `ref:` for
them (and for the newer `onebusaway` endpoints). When you list more
than one package, give every entry the same full 40-character commit SHA as
`ref`: pub resolves the siblings from that one commit, and a branch, tag or
short SHA in a second entry fails to resolve (see
[`packages/obakit/README.md`](packages/obakit/README.md#install)).

## Set up

The toolchain is pinned with [mise](https://mise.jdx.dev): Flutter 3.47.5 /
Dart 3.13.4. A single `flutter pub get` at the root resolves the whole pub
workspace.

```bash
mise install
mise exec -- flutter pub get
```

## Run the full app

```bash
mise exec -- flutter run
# Optional dart-defines:
mise exec -- flutter run \
  --dart-define=OBA_API_KEY=<key> \
  --dart-define=OBA_FIXED_REGION_NAME=<region name> \
  --dart-define=OBA_FIXED_REGION_URL=<OBA server root>
```

- `OBA_API_KEY` defaults to `org.onebusaway.iphone`.
- `OBA_FIXED_REGION_NAME` and `OBA_FIXED_REGION_URL` pin the app to one
  region, as a white-label build does. Leave them unset to use the regions
  server and pick a region by location.

Run the UCSD embedding demo from `packages/oba_arrivals/example` (see
[`packages/oba_arrivals/README.md`](packages/oba_arrivals/README.md)).

iOS and Android are the primary targets, and macOS works for desktop runs.

## Test

```bash
mise exec -- flutter test                                                  # root shim
(cd packages/onebusaway && mise exec -- dart test)
(cd packages/obakit_core && mise exec -- dart test)
(cd packages/oba_arrivals && TZ=America/Los_Angeles mise exec -- flutter test)
(cd packages/oba_arrivals/example && TZ=America/Los_Angeles mise exec -- flutter test)
(cd packages/obakit_trip_planner && TZ=America/Los_Angeles mise exec -- flutter test)
(cd packages/obakit && TZ=America/Los_Angeles mise exec -- flutter test)
mise exec -- flutter analyze
mise exec -- dart format .
```

Package tests must run from each package's own directory. Golden tests in
`oba_arrivals` run only on macOS with `TZ=America/Los_Angeles`.

### Walkthrough

`integration_test/walkthrough_test.dart` boots the real app against live
servers (real network and plugins) and walks onboarding, the map, the home
sheet, a stop, bookmarks, a trip, schedules, search, the trip planner and
more. It asserts structure only, never specific arrival values. Start from a
fresh install with the device location in downtown Seattle:

```bash
tool/walkthrough.sh <ios|android> <device-id> <output-dir>
```

`tool/walkthrough.sh` runs the test and acts on the markers it prints:
`SHOT:<name>` (take a device screenshot), `SEM:` (save the semantics
outline), `GRANT_LOCATION`, and `SET:<setting>` (`dark`, `light`, `bigtext`,
`normaltext`: change the system appearance or text size). Screenshots and
the log land in the output directory. It is not part of CI. It only
reads: the report step checks local validation and never sends a problem
report. Keep it that way, because it runs against live servers.

## What is ported

Ported:

- Regions (fetch, cache, bundled fallback, auto-select, picker, custom regions).
- Map: stop pins, user location, route shapes and vehicles, dropped pin, weather.
- Home sheet: nearby stops, recent stops, bookmarks, alarms, alerts, explore, settings, more.
- Search: routes, stop numbers, vehicle IDs, addresses, bookmarks.
- Stop page, trip page, and stop and route schedules.
- Bookmarks (stops and trips, groups, reorder, pin), recent stops, alerts, agencies.
- Settings, More, onboarding, deep links (`onebusaway://` and sidecar universal links).
- Trip planning through OpenTripPlanner.
- Weather, vehicle search, surveys, and problem reports.

Interface only (the host supplies the implementation):

- Push notifications, through `PushServiceProvider`. The alarm UI appears only when one is configured.
- Address search, through `PlaceSearchProvider`. A Nominatim default ships in `obakit`.

Not ported (Apple-platform features with no equivalent inside an SDK): Live
Activities, home-screen widgets, the watch app, App Intents, Siri, Spotlight,
Visual Intelligence, HealthKit speed sync, voice search, TipKit, Look Around.
The classic tab-bar UI is also not ported; the map-panel UI is the target.

Deferred: on-demand and GTFS-Flex, the bikes and scooters layer, vehicle
position estimation, trip suggestions, proximity (geofence) alerts, the
legacy-app data migration, and the SQLite stop cache.

See [`docs/superpowers/plans/2026-11-24-full-app.md`](docs/superpowers/plans/2026-11-24-full-app.md)
for the plan and its status, including known partial behaviours.

## Accessibility

Accessibility is a requirement in every package, to WCAG 2.1 AA:

- Text scales to 200% without losing content.
- Colour pairs meet contrast minimums in light, dark and high-contrast modes.
  Status is never shown by colour alone.
- Every control has screen-reader semantics, and the map has a non-visual
  alternative (a list of visible stops).
- Tap targets are at least 48dp. Everything works by keyboard or switch.
- Reduce-motion, bold-text and high-contrast settings are honoured.
- Widget tests run Flutter's accessibility guidelines through a shared harness.

The per-package checklists are in `packages/obakit/README.md` and
`packages/oba_arrivals/README.md`.

## License

Licensed under the [Apache License, Version 2.0](LICENSE).
