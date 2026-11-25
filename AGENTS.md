# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Flutter port of the OneBusAway iOS app, built as an SDK. Parts of it are meant to be embedded in other apps. The first consumer is the UCSD Student Life app, which will embed individual parts (a stop page, a nearby-stops card, the map, the trip planner, the arrivals panel), not the whole app. The iOS source for reference is at `../ios` (`OBAKit`, `OBAKitCore`, `OBAKitTests/fixtures`).

A pub workspace (root `pubspec.yaml`). Every package uses `resolution: workspace`, so one `flutter pub get` at the root resolves everything.

- `packages/onebusaway`: pure Dart. Full OBA REST client, Regions API client, Obaco (sidecar) client, polyline codec.
- `packages/obakit_core`: pure Dart app logic (counterpart of iOS `OBAKitCore`). Platform access goes through interfaces.
- `packages/oba_arrivals`: Flutter arrivals panel (`ObaArrivalsPanel`), released as 0.1.0. `example/` is the UCSD Student Life embedding demo (a workspace member).
- `packages/obakit`: Flutter UI SDK (counterpart of iOS `OBAKit`): `ObaApp`, `ObaScope`, theme, l10n, map, every screen.
- `packages/obakit_trip_planner`: OpenTripPlanner client and trip planner UI.
- `lib/`: thin app shim, `main.dart` and `app_config.dart` only. `integration_test/` is a live end-to-end walkthrough.
- `docs/superpowers/`: specs and plans. The plan for the full app is `plans/2026-11-24-full-app.md` (feature map, decisions, status).

Dependency direction: `lib → obakit → {obakit_core, oba_arrivals, obakit_trip_planner} → onebusaway`. `obakit_trip_planner` does not depend on the other repo packages. Don't add a dependency that points the other way.

## Commands

The toolchain is pinned with mise (Flutter 3.47.5 / Dart 3.13.4). Prefix commands with `mise exec --`.

```bash
mise install && mise exec -- flutter pub get

mise exec -- flutter run   # dart-defines: OBA_API_KEY, OBA_FIXED_REGION_NAME, OBA_FIXED_REGION_URL
mise exec -- flutter analyze            # whole workspace, run from the root
mise exec -- dart format <paths>        # CI checks `dart format --output=none --set-exit-if-changed .`

# Tests: run each from its own directory. Pure-Dart packages use `dart test`.
mise exec -- flutter test                                                       # root shim
(cd packages/onebusaway && mise exec -- dart test)
(cd packages/obakit_core && mise exec -- dart test)
(cd packages/oba_arrivals && TZ=America/Los_Angeles mise exec -- flutter test)
(cd packages/oba_arrivals/example && TZ=America/Los_Angeles mise exec -- flutter test)
(cd packages/obakit_trip_planner && TZ=America/Los_Angeles mise exec -- flutter test)
(cd packages/obakit && TZ=America/Los_Angeles mise exec -- flutter test)

# A single file or test name
(cd packages/onebusaway && mise exec -- dart test test/client_test.dart)
(cd packages/obakit && TZ=America/Los_Angeles mise exec -- flutter test test/app_test.dart --plain-name "<name>")

# Regenerate goldens (oba_arrivals; macOS only, Pacific time)
(cd packages/oba_arrivals && TZ=America/Los_Angeles mise exec -- flutter test --tags golden --update-goldens)

# After editing packages/obakit/lib/src/l10n/app_en.arb (config: packages/obakit/l10n.yaml)
(cd packages/obakit && mise exec -- flutter gen-l10n)   # commit lib/src/l10n/generated/

# Live end-to-end walkthrough (device or simulator; not run in CI)
mise exec -- flutter test integration_test/walkthrough_test.dart -d <device>
```

- Use `TZ=America/Los_Angeles` for every Flutter package test run, as CI does. Many tests format times in Pacific time. `oba_arrivals` goldens skip themselves unless on macOS in that zone.
- Test fixtures load by path relative to the package directory. `oba_arrivals` reads `../onebusaway/test/fixtures/arrivals_mts_24151.json`. `obakit` and `obakit_core` fall back to `../onebusaway/test/fixtures/`. Fixtures are real captured server responses (many copied from `../ios/OBAKitTests/fixtures`). Don't hand-write them.
- The walkthrough needs a fresh install and a device location in downtown Seattle. Read its header comment (`integration_test/walkthrough_test.dart`) before running. Run it with `tool/walkthrough.sh <ios|android> <device-id> <output-dir>`, which acts on the `SHOT:`, `SEM:`, `GRANT_LOCATION` and `SET:` lines the test prints.
- Releases: tags are unprefixed (`0.1.0`). Install snippets in READMEs must use a `ref:` that exists. Only `0.1.0` exists, and it predates `obakit`, `obakit_core` and `obakit_trip_planner`.

## Safety: no writes to production servers

Never send write requests to production OBA, Obaco or OTP servers from tests, the walkthrough or manual verification. That covers problem reports (`problemReports.reportStop/reportTrip`, ghost bus reports), alarm create and delete, push registration, survey answers, and anything else that mutates server state. Tests use `MockClient`. In the walkthrough, stop at local validation (the report step does). The app talks to live servers when run, so read-only checks are fine.

## `onebusaway` client

- `OneBusAwayClient` owns a `Transport` and exposes one `final` resource object per endpoint group: `arrivalsAndDepartures`, `agencies`, `config`, `currentTime`, `problemReports`, `routes`, `schedules`, `shapes`, `stops`, `trips`, `vehicles`. It closes the `http.Client` only if it created it.
- `core/transport.dart` is the only code that touches HTTP for `api/where`. It builds `api/where/<method>[/<id>].json?key=…`, decodes the shared OBA envelope, and returns an `ObaEnvelope`. Resources then call `envelope.toEntry(Model.fromJson)` or `envelope.toList(...)`.
- `RegionsClient` (`regions/`) fetches the regions list. `ObacoClient` (`obaco/`) talks to a region's sidecar (weather, alarms, vehicle search, ghost bus reports, push registration, surveys). `Polyline` encodes and decodes Google polylines.
- Every failure is an `ObaException` subtype (`ObaApiException` with kind `httpStatus`/`emptyResponse`/`envelope`, `ObaNetworkException`, `ObaFormatException`). Network errors redact the API key. SDMTS returns 200 with an empty body both for unknown IDs and for rejected keys. Java servers return a `null` body instead of a 404 (`isNullBody`); `arrivalsAndDepartures.forStop` handles it.
- Models parse with the helpers in `core/json.dart`. Use `readOptString` for fields that OBA may send as `""`. Related entities (stops, routes, trips, agencies, situations) come from the response's `References`, not inline.
- Parameter rules follow iOS (radius clamps, `stopSequence` only when above 0). They are listed in `packages/onebusaway/README.md`.
- To add an endpoint, follow the steps in `packages/onebusaway/README.md`: add models, add or extend a resource, expose it on the client, export it, and add a real captured fixture with a `MockClient` test.

## `obakit_core`

- No Flutter dependency. `ObaCoreApplication(ObaAppConfig)` must `await start()` before use. It owns regions, user data, settings, search, alarms, problem reports, surveys, alerts, deep links and formatters.
- Read `app.restClient` and `app.obacoClient` on every use. They are rebuilt when the region changes (`clientsListenable`). Never cache them.
- Platform access is behind interfaces: `KeyValueStore`, `LocationProvider`, `PushServiceProvider`, `ObaAnalytics`, `PlaceSearchProvider`. Each has an in-memory or no-op implementation for tests (`InMemoryKeyValueStore`, `FakeLocationProvider`, `FakePushServiceProvider`, `NoopAnalytics`). Persisted keys start with `oba.` and hold JSON strings. Persisted models parse tolerantly: skip a bad entry, don't fail the list.
- Change notification uses `ObaChangeNotifier` and `ObaValueListenable<T>`, pure-Dart twins of Flutter's. `obakit` adapts them with `ObaListenableAdapter`.
- Time comes from `package:clock` and logic takes `now` as a parameter.
- Feature availability is exposed as flags (`obacoStatus`, `pushStatus`, `tripPlanningStatus`, `alarmsAvailable`). UI hides features whose flag is off.
- ETA flooring in `ArrivalDepartureLogic.minutesUntil` follows iOS (uses departure time at a trip's first stop). `oba_arrivals` has its own copy with slightly different rules, because a pure-Dart package can't depend on it.

## `oba_arrivals` panel

- `lib/oba_arrivals.dart` re-exports `onebusaway` **with `Route` hidden**, because it clashes with Flutter's `Route`. Code that needs the model imports `package:onebusaway/onebusaway.dart` with a prefix (`as oba`).
- `ArrivalsController` (`ChangeNotifier`) fetches one stop and polls every 30 s by default. It exposes an immutable `ArrivalsState` (`loading` → `loaded`/`error`). The state never goes back to `loading`: retries keep `error` and set `isRefreshing`, and a failed refresh with existing data stays `loaded` with `error` set.
- `onError` (on the controller, passed through by the panel) reports each failed fetch that the controller applies, after `state` records it. A throwing callback goes to `FlutterError.reportError`. The panel's owned controller always calls the latest `widget.onError`, so changing the closure never reloads.
- Polling is reference-counted. `acquire()`/`release()` come from panels, and `resume()`/`pause()` are for manual callers. Polling continues while any holder remains, so a home card and a pushed full-page panel can share one controller.
- The panel acquires the controller while it is visible and the app is in the foreground. It releases it when a pushed route covers it, when the app is backgrounded, or when the panel is disposed. It never disposes a controller it did not create. A panel given a new `client` instance treats it as a new configuration and reloads, so hosts must not create the client inside `build()`.
- Time: the controller reads time from `package:clock`, not `DateTime.now`, so that `fake_async`/`testWidgets` can control it. It applies the server's `currentTime` offset from the latest request only. Use `controller.now()` for ETA math.
- `display/` contains the pure logic ported from Wayfinder (ETA flooring, status kind, departed filtering, layover collapsing). Widgets under `widgets/` render it. Test the logic in `display/` directly, without widgets.
- Theming: status colors and badge metrics come from the `ObaArrivalsTheme` `ThemeExtension`. When the host does not register one, the panel uses the light or dark default. Status colours are checked against the surface at runtime and adjusted if they fail 4.5:1. User-facing text lives in the overridable `ObaArrivalsStrings`.
- The package's public API is released (0.1.0). Don't break it. `example/` is the UCSD demo: `lib/main.dart` builds one `OneBusAwayClient` from its own `AppConfig` (`OBA_BASE_URL`, `OBA_API_KEY`) and passes it down; `ShuttleCard` owns an `ArrivalsController` shared by its panel and the pushed `AllArrivalsPage`.

## `obakit` UI SDK

The embedding contract is in `packages/obakit/README.md` ("Embedding single screens" and "Contributing a screen"). Read it before adding or changing a screen. The key rules:

- Every screen is a plain widget that needs only an `ObaScope` ancestor. Read the app with `ObaScope.of(context)`, never from a global.
- A page must work in the sheet, in the 400dp side panel, as a full-screen route on a host navigator, and (for sections) in a host's feed. Use `ObaSheetPage` as the scaffold. Home sections don't scroll and have no fixed height.
- The map is optional: use `ObaMapCoordinator.maybeOf(context)?.…` and `ObaMapOverlays`. Every `ObaMapMarker` needs a `label`.
- Navigate with `ObaNavigator.of(context).push(SomeRoute(...))`, never `Navigator.push` for an SDK destination. `ObaRoute` is a sealed class. Resolution order: `ObaScope.onNavigate`, nearest `ObaNavigatorScope` (the shell installs one), then `PageObaNavigator`. `ObaRouteBuilder` maps routes to pages.
- Controllers are `ChangeNotifier`s owned by a `State`. A controller a host passes in is never disposed by the SDK. Polling runs only while on screen and the app is in the foreground.
- Theme: screens read `Theme.of(context)`. SDK-specific colours come from the `ObaTheme` extension (with light, dark and high-contrast defaults).
- Strings: every user-facing string, including semantics labels and tooltips, is a key in `lib/src/l10n/app_en.arb` with an `@key` description. Run `flutter gen-l10n` and commit `lib/src/l10n/generated/`. Read with `context.obaL10n`. Other locales are translated from the iOS `.strings` tables.
- `lib/obakit.dart` is the public surface. Add each new public widget to the `show` list for its feature file. It re-exports `obakit_core` with `Route` and `Polyline` hidden (they clash with Flutter and flutter_map); a prefixed `onebusaway` import gives the models. `Place` here is the geocoded place, and `obakit_trip_planner` has another `Place`, so import the planner with a prefix when using both.
- `ObaApplication.create` builds the default adapters (shared_preferences, geolocator, optional Nominatim) and the core application. Creating one is cheap and must stay so: no location prompt at startup, no regions download when `regionsPath: null` with a `fixedRegion`, no onboarding outside `ObaApp`.
- Layout: `lib/src/app` (application, scope, `ObaApp`, deep links), `features/{stop,bookmarks,search,settings,map}`, `navigation`, `shell` (map plus draggable sheet), `platform` (adapters), `theme`, `widgets`, `l10n`.

## Accessibility (WCAG 2.1 AA, a hard requirement in every package)

- Text uses the theme's `textTheme` and scales to 200% with no clamping, no `fontSize:` literals, no fixed row heights. Layouts wrap or stack instead of truncating the ETA, route or headsign.
- Contrast: text 4.5:1, large text, icons and focus rings 3:1, in light, dark and high-contrast. Status is never conveyed by colour alone.
- Every control has a label. A row reads as one sentence. Headings are marked. Refreshed data uses a live region or `obaAnnounce`. Decorative icons are excluded from semantics.
- Tap targets are at least 48dp. Everything works by keyboard or switch, and no action needs a drag gesture only.
- Honour reduce-motion, bold-text and high-contrast. Use `EdgeInsetsDirectional` and friends for RTL.
- Tests: use the shared harness `packages/obakit/test/support/oba_test_harness.dart`. `ObaTestEnv.create(responses: {...})` boots a real application over an in-memory store, `FakeLocationProvider`, fake map tiles and a `MockClient` that answers from fixtures (URL substring to body). Then call `env.pumpPage(tester, page)`, `await expectObaAccessibility(tester)` and `await env.expectNoOverflowAtTextScale(tester, page)` on every screen, in light and dark. `env.requests` lists the HTTP calls made. Put time-dependent tests under `withClock`. `oba_arrivals` and `obakit_trip_planner` have their own `accessibility_test.dart`.
- `packages/obakit/test/theme_contrast_test.dart` checks every default colour pair. Keep it passing when you add colours.

## `obakit_trip_planner`

- `api/` is pure Dart: `OtpClient` prefers the OTP 2.x GraphQL API and falls back to OTP 1.x REST, decoding both into the same models (`TripPlan`, `Itinerary`, `Leg`, `Place`, `LegStep`).
- `TripPlannerController` (`ChangeNotifier`) holds an immutable `TripPlannerState`. `TripPlannerView` and `ItineraryDetailView` render it. A view never disposes a controller it didn't create.
- It depends only on `http`, `flutter_map`, `latlong2` and `clock`. `obakit` bridges its place search (`trip_place_search_bridge.dart`).

## Root shim

`lib/main.dart` calls `buildOneBusAwayApp`, which calls `ObaApplication.create` with `buildObaAppConfig` (`lib/app_config.dart`), and returns an `ObaApp`. The regions list is bundled in `packages/obakit/assets/regions.json`. `app_config.dart` is the Flutter equivalent of the iOS `OBAKitConfig` Info.plist map. Keep logic out of `lib/`; it belongs in a package.

## Known quirks

- A Flutter framework semantics null-check bug is mitigated in `packages/obakit/lib/src/shell/sheet_navigator.dart` (see the comment there) until a Flutter upgrade contains the fix. Don't remove the mitigation before upgrading.
- The macOS sandbox entitlements allow outbound network and location.
