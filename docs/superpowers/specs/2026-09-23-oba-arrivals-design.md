# OBA Arrivals for Flutter — Design

Date: 2026-09-23
Status: Revised after review (live SDMTS API checked 2026-09-23)

## Goal

UC San Diego wants to embed a real-time arrivals & departures panel in its
Flutter "Student Life" app. The panel should look and behave like the stop
panel in Wayfinder (`../wayfinder`), the OneBusAway web app, while fitting the
host app's visual style.

We deliver it as reusable Flutter packages plus a demo host app. The API layer
must be structured so it can grow, endpoint by endpoint, to cover the full
OneBusAway REST API.

### Success criteria

- UCSD can add a git dependency and embed arrivals for a stop with a few lines
  of code, passing their own OBA base URL and API key.
- The panel shows the same information as Wayfinder's stop panel (route badge,
  headsign, time, schedule deviation, minutes until arrival, real-time
  indicator) and uses the same status rules and colors.
- It adopts the host's Material theme (light or dark) and does not look
  foreign inside the Student Life app.
- Adding a new OBA endpoint to the client means adding models and one method,
  with no changes to the core.

## Decisions

| Topic | Decision |
|---|---|
| Delivery | Two packages in a pub workspace, plus the `oba_dart` demo app |
| v1 UI scope | Single-stop arrivals panel; no expansion, map, search, favorites |
| Row tap | Static rows; optional `onArrivalTap` callback for the host |
| Theming | Inherit the host `Theme`; `ThemeExtension` for OBA-specific colors |
| API access | Direct HTTPS to OBA; host supplies base URL + key; injectable `http.Client` |
| Extensibility | Pure-Dart client, resource-per-group, shared envelope/references core |
| Toolchain | Flutter 3.47.5 / Dart 3.13.4, pinned in `mise.toml` |

## Repository layout

```
flutter-example/                 # workspace root; also the oba_dart demo app
├── pubspec.yaml                 # workspace: [packages/onebusaway, packages/oba_arrivals]
├── lib/                         # demo app
├── test/
└── packages/
    ├── onebusaway/              # pure Dart; depends only on package:http
    └── oba_arrivals/            # Flutter; depends on onebusaway
```

- The root `pubspec.yaml` (the `oba_dart` app) declares `workspace:`.
- Only the member packages set `resolution: workspace`.
- Every pubspec uses the same SDK constraint, `^3.13.4`.
- `oba_arrivals` depends on `onebusaway` with `path: ../onebusaway`, never a
  version constraint. That lets a git consumer resolve it without pub.dev.
- `onebusaway` keeps its `test` dev-dependency constraint loose, so the
  shared lockfile can still resolve it against the `test_api`/`matcher`
  versions that `flutter_test` pins.

## Package 1: `onebusaway` (pure Dart API client)

Has no Flutter dependency, so it also works in Dart servers, CLIs and tests.

### Client

```dart
final client = OneBusAwayClient(
  baseUrl: Uri.parse('https://realtime.sdmts.com/api/'),
  apiKey: 'org.onebusaway.iphone',
  httpClient: http.Client(),          // optional; injectable for tests/proxies
  timeout: const Duration(seconds: 15), // optional
);
// baseUrl is the OBA *server root*, the same value as Wayfinder's
// PUBLIC_OBA_SERVER_URL. For SDMTS it is https://realtime.sdmts.com/api/,
// and endpoints live under .../api/api/where/.

final response = await client.arrivalsAndDepartures.forStop(
  'MTS_24151',
  minutesBefore: 5,   // optional; server default 5
  minutesAfter: 35,   // optional; server default 35
  time: null,         // optional DateTime; server default "now"
);
```

`close()` closes the HTTP client only if the client created it.

### Core layer (shared by all endpoints)

- **Transport** builds the request URL,
  `{baseUrl}api/where/{method}[/{id}].json?key={apiKey}&{params}`.
  - It adds a trailing slash to `baseUrl` if one is missing.
  - The `id` part is optional and URL-encoded.
  - It performs the GET under `Future.timeout`. That timeout does not abort
    the underlying request; this is accepted for v1.
  - It then decodes the response in the order below.
- **Decoding order:**
  1. A non-2xx HTTP status becomes `ObaApiException(kind: httpStatus,
     code: status)`, and the body is not parsed. For example, a wrong path
     gives an HTML 404.
  2. A 2xx status with an empty body becomes `ObaApiException(kind:
     emptyResponse)`. SDMTS does this for an unknown stop *and* for a
     rejected key, so the two can't be distinguished.
  3. A body that isn't JSON becomes `ObaFormatException`.
  4. An envelope `code` other than 200 becomes `ObaApiException(kind:
     envelope, code, text)`.
- **Envelope** fields: `code`, `text`, `currentTime`, `version`, and `data`.
  `data` holds `entry` or `list`, plus `references`, `limitExceeded` and
  `outOfRange`.
- **Errors** (sealed `ObaException`):
  - `ObaApiException(kind, code?, text?)`, where `kind` is `httpStatus`,
    `emptyResponse` or `envelope`.
  - `ObaNetworkException`: socket or TLS failure, or timeout.
  - `ObaFormatException`: the body is not JSON or a required field is
    missing or has the wrong type.
- **Responses:**
  - `ObaEntryResponse<T>` has `entry`, `references`, `currentTime` and
    `version`.
  - `ObaListResponse<T>` has `list`, `references`, `currentTime`,
    `limitExceeded` and `outOfRange`.
- **References** are parsed once into id-keyed maps: `agencies`, `routes`,
  `stops` and `trips`.
  - Lookups are `route(id)`, `stop(id)`, `trip(id)` and `agency(id)`. Each
    returns null when the id is missing.
  - Situations are deferred. Their `summary` and `description` are
    `{value, lang}` objects that need their own model.
  - `references.routes` can include routes that don't serve the stop. For
    example, `MTS_201` appears at `MTS_24151`. Callers filter by
    `stop.routeIds`.
- **Parsing helpers** (internal):
  - `readString`, `readInt`, `readBool` and `readList`, which report the
    offending field in `ObaFormatException`.
  - `readEpochMs`, which maps `0` or missing to `null`.
  - `readString` maps `""` to null for optional fields. SDMTS sends `""` for
    `textColor` on UCSD routes and for `direction` on some stops.

### Resources

Endpoints are grouped by OBA resource. Each group is a class that the client
exposes as a property:

- `ArrivalsAndDeparturesResource.forStop(stopId, {minutesBefore, minutesAfter, time})`
  → `ObaEntryResponse<StopWithArrivalsAndDepartures>`

Future endpoints follow the same pattern: a new file under `src/resources/`,
new models under `src/models/`, and a property on the client. Examples are
`stops.get`, `stops.forLocation`, `trips.details` and `routes.forAgency`. The
README documents this recipe.

### Models (v1)

Models are hand-written immutable classes with a `fromJson` factory. Value
equality is added only where tests need it. The client ignores unknown
fields. Times are `DateTime` (UTC) or null, and `currentTime` is epoch
milliseconds.

- `StopWithArrivalsAndDepartures`: `stopId`, `arrivalsAndDepartures`,
  `nearbyStopIds`, `situationIds`.
- `ArrivalAndDeparture` has these fields:
  - `routeId`, `tripId`, `serviceDate`, `stopId`, `stopSequence`,
    `totalStopsInTrip`, `blockTripSequence`;
  - `routeShortName`, `routeLongName`, `tripHeadsign`;
  - `scheduledArrivalTime`, `predictedArrivalTime`, `scheduledDepartureTime`,
    `predictedDepartureTime`;
  - `predicted`, `arrivalEnabled`, `departureEnabled`;
  - `vehicleId`, `numberOfStopsAway`, `distanceFromStop`, `status`;
  - `frequency`, `tripStatus`.
- `TripStatus`: the subset needed now, which is `status`, `phase`,
  `predicted`, `scheduleDeviation` (seconds), `vehicleId`, `activeTripId` and
  `serviceDate`.
- `Stop`: `id`, `code`, `name`, `lat`, `lon`, `direction`, `routeIds`,
  `wheelchairBoarding`.
- `Route`: `id`, `agencyId`, `shortName`, `longName`, `description`, `type`,
  `color`, `textColor`, `url`.
- `Trip`: `id`, `routeId`, `tripHeadsign`, `directionId`, `serviceId`,
  `blockId`, `shapeId`.
- `Agency`: `id`, `name`, `url`, `timezone`, `phone`.
- `Frequency`: `startTime`, `endTime`, `headway` (**seconds**).

### Tests

- Fixtures:
  - arrivals JSON for `MTS_24151`, captured from `realtime.sdmts.com` during
    service hours so it has predicted and scheduled rows;
  - a hand-made non-200 envelope;
  - an empty 200 body;
  - an HTML 404.
- `MockClient` tests cover:
  - URL construction using the real SDMTS root, which must yield
    `https://realtime.sdmts.com/api/api/where/arrivals-and-departures-for-stop/MTS_24151.json?key=...`;
  - envelope decoding and references lookup;
  - each branch of the decoding order;
  - timeout handling.

## Package 2: `oba_arrivals` (Flutter UI)

### Public widget

```dart
ObaArrivalsPanel(
  client: obaClient,
  stopId: 'MTS_24151',
  onArrivalTap: (ArrivalAndDeparture a) { ... },  // optional
  minutesAfter: 35,                               // optional
  maxArrivals: 5,                                 // optional; null = all
  refreshInterval: const Duration(seconds: 30),   // optional
  controller: myController,                       // optional
  strings: const ObaArrivalsStrings(),            // optional overrides
)
```

The panel lays out as a `Column` and does not scroll, so it works inside a
home-feed card. A host that wants a full-screen view wraps it in a scroll
view. The panel creates and disposes its own controller unless the host passes
one. If `stopId` changes, the panel reloads.

### Layout

1. **Header**
   - The stop name in a title style, truncated with an ellipsis.
   - A subtitle joined with ` · `, with empty parts dropped:
     - `Stop #{stop.code}`, falling back to the id without its agency prefix;
     - the direction bound, e.g. `Southwest bound`, taken from `stop.direction`
       (N, NE, … → words);
     - the stop's route short names, sorted and joined with `, `. Only routes
    in `stop.routeIds` count.
  - An unknown direction code is shown as the code itself. An empty
    direction is omitted.
   - A refresh icon button that spins while a request is in flight.
2. **Arrival rows**, separated by dividers:
   - `RouteBadge`: a 56×64 rounded rectangle holding the short name.
     - Font size uses Wayfinder's rule: `max(8, min(24, round(90 /
       longestWordLength), round(42 / wordCount)))`.
     - Badge text ignores `textScaler`, so large text settings can't
       overflow the fixed box.
   - The headsign, bold, at most 2 lines.
   - A subline: `{time} · {status text}`. The status text uses the status
     color.
     - `{time}` is the predicted arrival when the row is predicted,
       otherwise the scheduled arrival.
     - It is formatted in device local time with
       `MaterialLocalizations.formatTimeOfDay(..., alwaysUse24HourFormat:
       MediaQuery.alwaysUse24HourFormatOf(context))`. That needs no `intl`.
   - A right column with the ETA label (`now` or `{n}m`) in large bold status
     color, followed by a real-time icon (`Icons.rss_feed`) or a clock icon
     for schedule-only rows.
   - When `onArrivalTap` is set, the row is an `InkWell` with a chevron
     affordance. Otherwise there is no chevron.
3. **Footer** (conditional):
   - "Couldn't update. Showing results from {h:mm}", shown when the latest
     refresh failed but data exists.

### States

| State | UI |
|---|---|
| Initial load | Header placeholder and 3 skeleton rows |
| Loaded, no rows | "No arrivals in the next {minutesAfter} minutes" |
| Loaded | Rows, capped at `maxArrivals` |
| Error, no data | Message and a Retry button. `emptyResponse` shows "Stop not found or service unavailable" |
| Error, stale data | Keep the rows and show the footer notice |

### `ArrivalsController` (`ChangeNotifier`)

- Constructor: `(client, stopId, {minutesAfter, refreshInterval, clock})`.
- It exposes an immutable `ArrivalsState`:
  - `status` (`loading | loaded | error`);
  - `stop`, `rawArrivals` (unfiltered, in server order), `references`;
  - `updatedAt`, `error`, `isRefreshing`.
- `now()` returns `clock.now() + serverOffset`.
- `refresh()` fetches now and restarts the poll timer.
- **Polling:** a one-shot `Timer` is scheduled for `refreshInterval` after
  each response completes, so slow requests never pile up.
- `pause()` cancels the timer. `resume()` refreshes immediately and restarts
  polling.
- The controller has no dependency on `WidgetsBinding`.
- **Stale responses:** every request gets an incrementing token, and a response
  whose token isn't the latest is discarded.
- **Clock skew:** the controller stores `serverOffset = response.currentTime -
  clock.now()` and computes "now" as `clock.now() + serverOffset`.
- **Filtering and ETA labels live in the widget.** The panel computes
  `visibleArrivals(state.rawArrivals, controller.now())` on every fetch and on
  a 30-second tick between fetches, so departed rows disappear on time.
- **Lifecycle:** the panel's `State` owns the lifecycle handling.
  - An `AppLifecycleListener` calls `pause()` when the app is hidden or
    paused and `resume()` when it is resumed.
  - The panel also pauses while `TickerMode.of(context)` is false, which
    happens when a pushed route covers it. So the demo's feed card stops
    polling under the full-screen page.

### Display logic (pure Dart, ported from Wayfinder)

All functions take an explicit `now`.

- **Minutes until arrival:**
  - Floor the times and `now` to whole minutes.
  - `eta = predictedMins - nowMins` when `predicted` is true and
    `predictedArrivalTime` is present. Otherwise use `scheduledMins`.
  - The label is `now` when `eta == 0`, otherwise `{eta}m`.
- **Deviation:** `delay = predictedMins - scheduledMins`. It applies only when
  the row has a prediction.
- **Status text** is a separate function from **status color**, matching
  Wayfinder:
  - Canceled (`tripStatus?.status == 'CANCELED'`): `canceled` text, canceled
    color.
  - Frequency-based trips (`frequency != null`), with
    `headwayMin = floor(headway / 60)`:
    - `every {headwayMin} min from {startTime}` when `now < startTime`;
    - `every {headwayMin} min until {endTime}` otherwise.
  - With a prediction, the text is `{delay} min late` when `delay > 0`,
    `{-delay} min early` when `delay < 0`, and `on time` otherwise.
  - With a prediction, the color is late when `delay > 0`, early when
    `delay < -1`, and on-time otherwise. This deliberately matches Wayfinder:
    at 1 minute early the text says "1 min early" but the color stays green.
  - With no prediction, the text is `scheduled` and the color is scheduled.
- **Filtering** runs in this order:
  - `filterDeparted`: drop rows whose ETA is negative.
  - `collapseLayovers`: drop an arrival row when all of these hold:
    - it is at the trip's final stop (`stopSequence == totalStopsInTrip - 1`);
    - it has a `vehicleId`;
    - another row has `stopSequence == 0`, the same `vehicleId` and
      `serviceDate`, and `blockTripSequence + 1`.
  - Keep the server's order, as Wayfinder does. There is no client-side
    sort.

### Theming

`ObaArrivalsTheme extends ThemeExtension<ObaArrivalsTheme>`:

- `onTime`, `late`, `early` and `canceled` colors;
- `scheduled`, which is nullable and resolves to
  `colorScheme.onSurfaceVariant` at build time;
- `badgeSize`, `badgeRadius`, and `badgeFallbackColor` (default `#374151`,
  Wayfinder's fallback);
- `copyWith` and `lerp`.

`ObaArrivalsTheme.light()` and `.dark()` defaults use the colors below. The
panel picks one based on `Theme.of(context).brightness` unless the host
registers the extension.

| Status | Light | Dark |
|---|---|---|
| On time | green-600 | green-400 |
| Late | violet-600 | violet-400 |
| Early | red-600 | red-400 |
| Scheduled | `colorScheme.onSurfaceVariant` | same |
| Canceled | `colorScheme.error` | same |

Surfaces, text styles and fonts come from the host `Theme`.

Badge colors:

- **Background:** the GTFS `route.color`, which arrives as hex without `#`
  and may be lowercase. When it is missing, `badgeFallbackColor`.
- **Text:** the GTFS `route.textColor`. When it is missing or empty, black or
  white, whichever has the higher WCAG contrast against the background.
  UCSD routes send `textColor: ""` on light backgrounds, such as IL on
  `ffcd00`, so this rule matters.

### Strings

`ObaArrivalsStrings` is a const class with English defaults for every
user-facing string. Parameterized strings are functions, e.g.
`minLate(int n)`. The host can subclass it or pass overrides. There is no
dependency on `gen_l10n`.

### Accessibility

- Each row merges into one semantics node with a label like
  "IL, Inside Loop, arriving in 3 minutes, on time, real-time". When the row is
  tappable it also gets a tap hint.
- The refresh button has a tooltip and semantics label.
- The layout wraps and truncates cleanly at 200% text scale.

### Tests

- Unit tests for the display logic (ETA, deviation, status, layover collapse,
  departed filter) with fixed times.
- Controller tests with a fake client and `fake_async`: polling reschedules
  after completion, stale-response drop, error-keeps-data, pause and resume,
  and clock skew.
- Widget tests for each state in the States table, `maxArrivals`, the tap
  callback, and the semantics labels.
- Golden tests for a loaded panel in light and dark themes.
  - They use a fixed clock, load real fonts rather than Ahem, and are
    generated on macOS.
  - They are tagged `golden` so they can be skipped on other operating
    systems.

## Demo app: `oba_dart`

- A shell modeled on the Student Life app: a navy app bar titled
  "UC San Diego" (text only, no UCSD logo or artwork), a gold accent, and a
  scrolling feed of cards.
- A "Shuttle" card embeds `ObaArrivalsPanel(maxArrivals: 3)` and has a
  "See all arrivals" button. The button pushes a full-screen page with the
  uncapped panel.
- A stop picker (a menu on the card) switches between hardcoded UCSD stops,
  all verified live:
  - `MTS_24151`, Eighth College / Theatre District (North);
  - `MTS_88986`, UCSD Central Campus Trolley;
  - `MTS_11902`, Gilman Transit Center (South).
- A light/dark toggle in the app bar.
- `onArrivalTap` shows a snackbar with the route and headsign.
- Configuration comes from `--dart-define=OBA_BASE_URL` and
  `--dart-define=OBA_API_KEY`. They default to `https://realtime.sdmts.com/api/`
  and `org.onebusaway.iphone`, matching Wayfinder's UCSD config. The packages
  have no defaults.
- The default widget test is replaced with a smoke test that uses a fake
  client.

## Platforms

- iOS and Android are the primary targets. macOS is supported for quick
  desktop runs.
- Web: SDMTS returned CORS headers for a localhost origin, so the web build
  should work against SDMTS. Other OBA servers may not send those headers.

## Verification of git consumption

A throwaway app outside the repo adds `oba_arrivals` as a dependency using
`git: {url: <local repo path>, path: packages/oba_arrivals}` and must pass
`flutter pub get` and `flutter build` for one platform. This proves UCSD
can consume the package.

## Verified live API facts (SDMTS, 2026-09-23)

- The server root is `https://realtime.sdmts.com/api/`, and endpoints live at
  `/api/api/where/...`.
- The envelope has `code: 200`, `text: "OK"`, `version: 2`, and
  `currentTime` in epoch ms.
- Stop ids are `MTS_<code>`, even for UCSD shuttle stops, and `stop.code` is
  populated.
- UCSD routes belong to the `UCSD_` agency:
  - `UCSD_1040` is IL, `ffcd00`;
  - `UCSD_1030` is OL, `20183d`;
  - `UCSD_1010` is R, `6e963b`;
  - `UCSD_1020` is S, `90a7d3`.
- UCSD routes have `textColor: ""`. MTS routes have `FFFFFF`.
- `tripStatus.scheduleDeviation` is in seconds, and `frequency` is usually
  `null`.
- An unknown stop and a bad key both return HTTP 200 with an empty body. A
  wrong path returns an HTML 404.

## Documentation

- `packages/onebusaway/README.md`: installation, usage, error handling, and
  how to add an endpoint.
- `packages/oba_arrivals/README.md`: installation as a git dependency,
  embedding, theming, strings, and the controller.
- The root `README.md`: running the demo, configuration, and the repo layout.

## Out of scope (v1)

- Row expansion and trip details.
- Map, search, favorites, and stop discovery.
- Service alerts, including the Situation model.
- Showing times in the agency's timezone; v1 uses device local time.
- Loading more arrivals beyond `minutesAfter`.
- Publishing to pub.dev. UCSD depends on the packages by git path.
- CI configuration.
- Translations beyond English.
