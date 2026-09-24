# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A pub workspace that lets UCSD embed OneBusAway real-time arrivals in its Flutter Student Life app:

- `packages/onebusaway`: pure-Dart OBA REST client (no Flutter dependency). It is meant to grow toward the full OBA API.
- `packages/oba_arrivals`: Flutter arrivals panel (`ObaArrivalsPanel`). It depends on `onebusaway`.
- `lib/`: demo host app that mimics the Student Life home feed. It depends on `oba_arrivals` alone.
- `docs/superpowers/`: design spec and implementation plan.

The root `pubspec.yaml` declares the workspace. Both packages use `resolution: workspace`, so a single `flutter pub get` at the root resolves everything.

## Commands

The toolchain is pinned with mise (Flutter 3.47.5 / Dart 3.13.4). Prefix commands with `mise exec --`.

```bash
mise install && mise exec -- flutter pub get

mise exec -- flutter run   # optional: --dart-define=OBA_BASE_URL=... --dart-define=OBA_API_KEY=...
mise exec -- flutter analyze
mise exec -- dart format <paths>

# Tests (the package tests must run from each package's own directory)
mise exec -- flutter test                                              # demo app
(cd packages/onebusaway && mise exec -- dart test)
(cd packages/oba_arrivals && TZ=America/Los_Angeles mise exec -- flutter test)

# A single test file or test name
(cd packages/onebusaway && mise exec -- dart test test/client_test.dart)
(cd packages/oba_arrivals && TZ=America/Los_Angeles mise exec -- flutter test test/controller_test.dart --plain-name "<name>")

# Regenerate goldens (macOS only, Pacific time)
(cd packages/oba_arrivals && TZ=America/Los_Angeles mise exec -- flutter test --tags golden --update-goldens)
```

- Test fixtures are loaded with paths relative to the package directory. `oba_arrivals` tests read `../onebusaway/test/fixtures/arrivals_mts_24151.json`.
- Golden tests skip themselves unless they run on macOS with `TZ=America/Los_Angeles`. Other `oba_arrivals` tests also assume Pacific time for formatted times.
- `OBA_BASE_URL` is the OBA *server root* (default `https://realtime.sdmts.com/api/`). Endpoints live at `{baseUrl}api/where/…`.

## Architecture

### `onebusaway` client

- `OneBusAwayClient` owns a `Transport` and exposes one `final` resource object per endpoint group (currently `arrivalsAndDepartures`). It closes the `http.Client` only if it created it.
- `core/transport.dart` is the only code that touches HTTP. It builds `api/where/<method>[/<id>].json?key=…`, decodes the shared OBA envelope, and returns an `ObaEnvelope`. Resources then call `envelope.toEntry(Model.fromJson)` or `envelope.toList(...)`.
- Every failure is an `ObaException` subtype (`ObaApiException` with kind `httpStatus`/`emptyResponse`/`envelope`, `ObaNetworkException`, `ObaFormatException`). Network errors redact the API key. SDMTS returns 200 with an empty body both for unknown IDs and for rejected keys.
- Models parse with the helpers in `core/json.dart`. Use `readOptString` for fields that OBA may send as `""`. Related entities (stops, routes, trips, agencies) come from the response's `References`, not inline.
- To add an endpoint, follow the steps in `packages/onebusaway/README.md`: add models, add or extend a resource, expose it on the client, export it, and add a real captured fixture with a `MockClient` test.

### `oba_arrivals` panel

- `lib/oba_arrivals.dart` re-exports `onebusaway` **with `Route` hidden**, because it clashes with Flutter's `Route`. Code that needs the model imports `package:onebusaway/onebusaway.dart` with a prefix (`as oba`).
- `ArrivalsController` (`ChangeNotifier`) fetches one stop and polls every 30 s by default. It exposes an immutable `ArrivalsState` (`loading` → `loaded`/`error`). The state never goes back to `loading`: retries keep `error` and set `isRefreshing`, and a failed refresh with existing data stays `loaded` with `error` set.
- Polling is reference-counted. `acquire()`/`release()` come from panels, and `resume()`/`pause()` are for manual callers. Polling continues while any holder remains, so the demo's home card and the pushed full-page panel share one controller.
- The panel acquires the controller while it is visible and the app is in the foreground. It releases it when a pushed route covers it, when the app is backgrounded, or when the panel is disposed. It never disposes a controller it did not create. A panel given a new `client` instance treats it as a new configuration and reloads, so hosts must not create the client inside `build()`.
- Time: the controller reads time from `package:clock`, not `DateTime.now`, so that `fake_async`/`testWidgets` can control it. It applies the server's `currentTime` offset from the latest request only. Use `controller.now()` for ETA math.
- `display/` contains the pure logic ported from Wayfinder (ETA flooring, status kind, departed filtering, layover collapsing). Widgets under `widgets/` render it. Test the logic in `display/` directly, without widgets.
- Theming: status colors and badge metrics come from the `ObaArrivalsTheme` `ThemeExtension`. When the host does not register one, the panel uses the light or dark default. User-facing text lives in the overridable `ObaArrivalsStrings`.

### Demo app

`lib/main.dart` builds one `OneBusAwayClient` from `AppConfig` (dart-defines) and passes it down. `HomePage` shows `ShuttleCard`, which owns an `ArrivalsController` and gives it both to its `maxArrivals: 3` panel and to the pushed `AllArrivalsPage`. The demo stops are in `demo_stops.dart`. The macOS sandbox entitlements allow outbound network.
