# Student Life (sample app)

A sample university "Student Life" app that embeds OneBusAway screens from
the `obakit` SDK next to its own content: class schedule, dining hours,
campus events and a student ID. The campus is UC San Diego and the transit
data is live San Diego MTS data. The brand ("Student Life", navy and gold)
is generic.

It shows how a host app embeds individual SDK parts (a stop departures
card, nearby stops, bookmarks, the map, the trip planner, full SDK pages)
without the OneBusAway shell, and how it takes over SDK navigation where it
wants its own presentation.

## Relation to `packages/oba_arrivals/example`

`packages/oba_arrivals/example` is the first, minimal UCSD demo: a home
feed with one shuttle card built on the standalone `oba_arrivals` panel,
which needs its own `OneBusAwayClient` and knows nothing of the rest of the
SDK. It stays as the example for hosts that embed arrivals without `obakit`.

This app is its fuller successor, built on `obakit`. The shuttle card is now
`ObaStopDeparturesCard`, which needs only an `ObaScope` and shares the
SDK's settings, navigation, bookmarks and alerts with every other embedded
part.

## Running it

```bash
cd examples/student_life
mise exec -- flutter run --dart-define=OBA_API_KEY=<your key>
```

`OBA_API_KEY` defaults to `org.onebusaway.iphone`. The app needs no
location permission: it uses a `FixedLocationProvider` in the middle of
campus (32.8801, -117.2340), so "nearby" always means "near campus".

Tests (from this directory) and the checks CI runs (from the repo root):

```bash
TZ=America/Los_Angeles mise exec -- flutter test
(cd ../.. && mise exec -- flutter analyze)
(cd ../.. && mise exec -- dart format examples/student_life)
```

The tests boot a real `ObaApplication` over an in-memory store and a
`MockClient` that answers from the captured fixtures in
`packages/onebusaway/test/fixtures`. They never reach a server.

## How it's put together

- `lib/oba_setup.dart`: the one `ObaApplication.create(...)`. The region is
  fixed to San Diego with `regionsPath: null`, so there is no regions
  download and no region picker.
- `lib/app.dart`: one `ObaScope` above the navigator (`MaterialApp.builder`)
  covers every route. Its `onNavigate` takes every `ObaRoute` and pushes a
  host route built with `ObaRouteBuilder.build(context, route)`: the host's
  app bar over the embedded SDK page. So stops, trips, schedules, alerts and
  the trip planner all open under the host's app bar, never the SDK's.
- `lib/widgets/host_page.dart`: `HostObaPage`, the host app bar over one
  embedded SDK page, and `hostChromeFor`, which picks each route's app bar
  title. Pages whose title is data (a stop's name, a trip) keep the SDK's
  compact header (`showsHeader: true`) under a generic host title such as
  "Transit", so the stop name shows once. Pages with a fixed title (saved
  stops, alerts, the trip planner) drop the SDK header, and the host app bar
  carries the title.
- `lib/widgets/embed_frame.dart`: `EmbedFrame` wraps every embedded SDK
  widget. Turn on **Me → Show OBA embeds** to outline each one with a label
  naming its SDK widget. Each embed is also marked `// OBA embed:` in the
  code.
- `lib/data/`: the host's mock data (schedule, dining, events, student,
  campus places and stops).
- Tabs live in an `IndexedStack`. SDK widgets in a hidden tab stop polling
  by themselves; the host does nothing.

## Map tiles

The map uses **vector tiles** from OpenFreeMap (free, no API key), as
Tapline does: `lib/map_vector.dart` loads the Positron and Dark styles and
repaints their background, land and water toward Student Life's palette,
and `studentLifeMapConfig` (`lib/oba_setup.dart`) passes them to the SDK as
`ObaMapConfig`'s `standard` and `standardDark`. The SDK has no vector
dependency of its own: the app hands `ObaTileSource.custom` a
`VectorTileLayer` from `vector_map_tiles` (pinned to 9.0.0-beta.13, the
line that supports flutter_map 8).

- If the styles don't load within 5 seconds, the app falls back to the
  SDK's default raster tiles (OpenStreetMap's public server, which allows
  light use only and has no dark style). So does
  `--dart-define=STUDENT_LIFE_MAP=raster`.
- The trip planner's itinerary map draws raster tiles only, through the
  source's `rasterFallback`.
- A production app should still choose a tile provider and plan, or host
  its own tiles.

## Embed points

| Screen | SDK widget | Why it's there for a student |
|---|---|---|
| Today | `ObaStopDeparturesCard(stopId: 'MTS_24151', maxArrivals: 3)` | The campus shuttle's next departures from Eighth College, on the home feed. "See all" opens the stop page in a host route. |
| Today | `ServiceAlertsSection()` | Urgent detours or delays on the stops the student uses. Takes no space when there are none. |
| Today → Directions | `TripPlannerRoute(destination: Center Hall, onItinerarySelected: ...)` | Directions to the next class, pushed through `ObaNavigator` and opened under the host's app bar. |
| Today → Your trip | the `tp.Itinerary` from `onItinerarySelected` | When the student opens an itinerary in the planner, the app keeps it (`lib/chosen_trip.dart`, provided above the navigator) and Today shows "Leave by <start time> · <first route>" and the destination, with a Clear button. With no trip chosen it shows a prompt to plan one. |
| Transit | `ObaMapView` (240dp preview, plus a full-screen page) | Find stops around campus. Tapping a pin opens the stop through the host's `onNavigate`. |
| Transit | `NearbyStopsSection(maxStops: 3, title: 'Near campus')` | Departures from the three closest stops. The section's own heading is the only one. |
| Transit | `ObaBookmarksCard(limit: 3)` | The student's saved stops with live departures. |
| Transit → Campus stops | `StopPage` (via `ObaNavigator.push(StopRoute(id))` and the host's `onNavigate`) | Full departures for the host's curated campus stops (Eighth College, UCSD Central Campus trolley, Gilman Transit Center). |
| Campus → event | `ObaNearbyStopsCard(around: venue)` | Departures near the event venue (Price Center, RIMAC Arena, Geisel Library), not near the student. |
| Campus → event → Plan a trip | `TripPlannerRoute(destination: venue, onItinerarySelected: ...)` | Directions to the event venue, as its own route. The itinerary the student opens shows on Today. |
| Me → Saved stops | `BookmarksPage()` (via `BookmarksRoute`) | All saved stops, managed in one place. |
| Me → Service alerts | `AlertsListPage()` (via `AlertsListRoute`) | Every current alert for the student's stops. |

## Accessibility

The app follows the repo's WCAG 2.1 AA rules (see `AGENTS.md`): theme text
styles only (no font sizes), text that reflows at 200%, 48dp targets, a
label on every control, headings marked, decorative icons excluded, and
open or closed spelled out rather than shown by colour. The ID card's
barcode is an image with a label. The embed overlay's label chips are
hidden from screen readers.
