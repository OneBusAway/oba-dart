# OBA Arrivals for Flutter — Design

Date: 2026-09-23
Status: Draft for review

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

Every package's pubspec sets `resolution: workspace`. The Dart SDK
constraint is `^3.13.0`.

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
  `{baseUrl}where/{method}/{id}.json?key={apiKey}&{params}`. The `id` part is
  optional and URL-encoded. The transport performs the GET with a timeout and
  decodes the JSON envelope.
- **Envelope** fields: `code`, `text`, `currentTime`, `version`, and `data`.
  `data` holds `entry` or `list`, plus `references`, `limitExceeded` and
  `outOfRange`.
- **Errors** (sealed `ObaException`):
  - `ObaApiException(code, text)`: the envelope `code` or HTTP status is not
    200. Examples are an invalid key or an unknown stop (404).
  - `ObaNetworkException`: socket or TLS failure, or timeout.
  - `ObaFormatException`: the body is not JSON or a required field is missing.
- **Responses:**
  - `ObaEntryResponse<T>` has `entry`, `references`, `currentTime` and
    `version`.
  - `ObaListResponse<T>` has `list`, `references`, `currentTime`,
    `limitExceeded` and `outOfRange`.
- **References** are parsed once into id-keyed maps: `agencies`, `routes`,
  `stops`, `trips` and `situations`. Lookups are `route(id)`, `stop(id)`,
  `trip(id)`, `agency(id)` and `situation(id)`, and each returns null when the
  id is missing.
- **Parsing helpers** (internal):
  - `readString`, `readInt`, `readBool` and `readList`, which report the
    offending field in `ObaFormatException`.
  - `readEpochMs`, which maps `0` or missing to `null`.

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

Models are hand-written immutable classes. Each has a `fromJson` factory and
value equality. The client ignores unknown fields. Times are `DateTime` (UTC)
or null.

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
  `predicted`, `scheduleDeviation`, `vehicleId` and `activeTripId`.
- `Stop`: `id`, `code`, `name`, `lat`, `lon`, `direction`, `routeIds`,
  `wheelchairBoarding`.
- `Route`: `id`, `agencyId`, `shortName`, `longName`, `description`, `type`,
  `color`, `textColor`, `url`.
- `Trip`: `id`, `routeId`, `tripHeadsign`, `directionId`, `serviceId`,
  `blockId`, `shapeId`.
- `Agency`: `id`, `name`, `url`, `timezone`, `phone`.
- `Situation`: `id`, `summary`, `description`, `severity`, `reason`. This
  subset is parsed for future use; the v1 UI does not display alerts.
- `Frequency`: `startTime`, `endTime`, `headway`.

### Tests

- Fixture JSON captured from `realtime.sdmts.com`: arrivals for a UCSD stop,
  plus an error envelope and a 404.
- `MockClient` checks the URL and query construction, envelope decoding,
  references lookup, error mapping and timeout handling.

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
     - the stop's route short names, sorted and joined with `, `.
   - A refresh icon button that spins while a request is in flight.
2. **Arrival rows**, separated by dividers:
   - `RouteBadge`: a rounded rectangle holding the short name. Wayfinder's
     font-size rule scales long names down.
   - The headsign, bold, at most 2 lines.
   - A subline: `hh:mm AM/PM · {status text}`. The status text uses the status
     color.
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
| Error, no data | Message and a Retry button. Invalid key and unknown stop get their own messages |
| Error, stale data | Keep the rows and show the footer notice |

### `ArrivalsController` (`ChangeNotifier`)

- Constructor: `(client, stopId, {minutesAfter, refreshInterval, clock})`.
- It exposes an immutable `ArrivalsState`:
  - `status` (`loading | loaded | error`);
  - `stop`, `arrivals` (already filtered and sorted), `references`;
  - `updatedAt`, `error`, `isRefreshing`.
- `refresh()` fetches now and restarts the poll timer.
- **Polling:** a `Timer.periodic` runs at `refreshInterval`. It pauses when the
  app goes to the background (`AppLifecycleListener`) and refreshes on resume.
- **Stale responses:** every request gets an incrementing token, and a response
  whose token isn't the latest is discarded.
- **Clock skew:** the controller stores `serverOffset = response.currentTime -
  clock.now()` and computes "now" as `clock.now() + serverOffset`.
- **ETA labels:** a 30-second tick in the widget recomputes the labels from
  the local clock between fetches.

### Display logic (pure Dart, ported from Wayfinder)

All functions take an explicit `now`.

- **Minutes until arrival:**
  - Floor the times and `now` to whole minutes.
  - `eta = predictedMins - nowMins` when `predicted` is true and
    `predictedArrivalTime` is present. Otherwise use `scheduledMins`.
  - The label is `now` when `eta == 0`, otherwise `{eta}m`.
- **Deviation:** `delay = predictedMins - scheduledMins`. It applies only when
  the row has a prediction.
- **Status kind and text:**
  - `canceled` (from `status == 'CANCELED'` or the trip status) shows the
    canceled string.
  - `frequency` trips show `every {headway} min`.
  - A prediction with `delay > 0` is `late`: `{delay} min late`.
  - A prediction with `delay < -1` is `early`: `{-delay} min early`.
  - Any other prediction is `onTime`: `on time`.
  - No prediction is `scheduled`: `scheduled`.
- **Filtering** runs in this order:
  - `filterDeparted`: drop rows whose ETA is negative.
  - `collapseLayovers`: drop an arrival row when all of these hold:
    - it is at the trip's final stop (`stopSequence == totalStopsInTrip - 1`);
    - it has a `vehicleId`;
    - another row has `stopSequence == 0`, the same `vehicleId` and
      `serviceDate`, and `blockTripSequence + 1`.
  - Sort by ETA ascending.

### Theming

`ObaArrivalsTheme extends ThemeExtension<ObaArrivalsTheme>`:

- `onTime`, `late`, `early`, `scheduled` and `canceled` colors;
- `badgeSize`, `badgeRadius`, and `badgeFallbackPalette` (8 background colors).

`ObaArrivalsTheme.light()` and `.dark()` defaults use the colors below. The
panel picks one based on `Theme.of(context).brightness` unless the host
registers the extension.

| Status | Light | Dark |
|---|---|---|
| On time | green-600 | green-400 |
| Late | violet-600 | violet-400 |
| Early | red-600 | red-400 |
| Scheduled | `colorScheme.onSurfaceVariant` | same |

Surfaces, text styles and fonts come from the host `Theme`.

Badge colors:

- **Background:** the GTFS `route.color`. When it is missing, a palette entry
  chosen by a stable hash of the route id.
- **Text:** the GTFS `route.textColor`. When it is missing, black or white,
  whichever has the higher WCAG contrast against the background.

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
- Controller tests with a fake client and `fake_async`: polling, stale-response
  drop, error-keeps-data, lifecycle pause and resume, and clock skew.
- Widget tests for each state in the States table, `maxArrivals`, the tap
  callback, and the semantics labels.
- Golden tests for a loaded panel in light and dark themes.

## Demo app: `oba_dart`

- A shell modeled on the Student Life app: a navy app bar titled
  "UC San Diego" (text only, no UCSD logo or artwork), a gold accent, and a
  scrolling feed of cards.
- A "Shuttle" card embeds `ObaArrivalsPanel(maxArrivals: 3)` and has a
  "See all arrivals" button. The button pushes a full-screen page with the
  uncapped panel.
- A stop picker (a menu on the card) switches between a few hardcoded UCSD
  stops, for example Eighth College / Theatre District. Their stop IDs are
  confirmed against the live API during implementation.
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
- The web build may hit CORS limits when calling SDMTS directly. The README
  documents this, and v1 does not work around it.

## Documentation

- `packages/onebusaway/README.md`: installation, usage, error handling, and
  how to add an endpoint.
- `packages/oba_arrivals/README.md`: installation as a git dependency,
  embedding, theming, strings, and the controller.
- The root `README.md`: running the demo, configuration, and the repo layout.

## Out of scope (v1)

- Row expansion and trip details.
- Map, search, favorites, and stop discovery.
- Displaying service alerts. Situations are parsed but not rendered.
- Loading more arrivals beyond `minutesAfter`.
- Publishing to pub.dev. UCSD depends on the packages by git path.
- CI configuration.
- Translations beyond English.
