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
  covers every route. Its `onNavigate` takes `StopRoute` and pushes a host
  route: the host's app bar over an embedded `StopPage`
  (`ObaPresentationScope.embedded(showsHeader: true, ...)`). Every other SDK
  destination returns false, and the SDK pushes its own page.
- `lib/widgets/host_page.dart`: `HostObaPage`, the host app bar over one
  embedded SDK page, used for stops, the trip planner, bookmarks and alerts.
- `lib/widgets/embed_frame.dart`: `EmbedFrame` wraps every embedded SDK
  widget. Turn on **Me → Show OBA embeds** to outline each one with a label
  naming its SDK widget. Each embed is also marked `// OBA embed:` in the
  code.
- `lib/data/`: the host's mock data (schedule, dining, events, student,
  campus places and stops).
- Tabs live in an `IndexedStack`. SDK widgets in a hidden tab stop polling
  by themselves; the host does nothing.

## Embed points

| Screen | SDK widget | Why it's there for a student |
|---|---|---|
| Today | `ObaStopDeparturesCard(stopId: 'MTS_24151', maxArrivals: 3)` | The campus shuttle's next departures from Eighth College, on the home feed. "See all" opens the stop page in a host route. |
| Today | `ServiceAlertsSection()` | Urgent detours or delays on the stops the student uses. Takes no space when there are none. |
| Today → Directions | `TripPlannerPage(destination: Center Hall)` | Directions to the next class, under the host's app bar. |
| Transit | `ObaMapView` (240dp preview, plus a full-screen page) | Find stops around campus. Tapping a pin opens the stop through the host's `onNavigate`. |
| Transit | `NearbyStopsSection(maxStops: 3)` | Departures from the three closest stops. |
| Transit | `ObaBookmarksCard(limit: 3)` | The student's saved stops with live departures. |
| Transit → Campus stops | `StopPage` (via `ObaNavigator.push(StopRoute(id))` and the host's `onNavigate`) | Full departures for the host's curated campus stops (Eighth College, UCSD Central Campus trolley, Gilman Transit Center). |
| Campus → event | `ObaNearbyStopsCard(around: venue)` | Departures near the event venue (Price Center, RIMAC Arena, Geisel Library), not near the student. |
| Campus → event → Plan a trip | `TripPlannerPage(destination: venue)` | Directions to the event. |
| Me → Saved stops | `BookmarksPage()` | All saved stops, managed in one place. |
| Me → Service alerts | `AlertsListPage()` | Every current alert for the student's stops. |

## Accessibility

The app follows the repo's WCAG 2.1 AA rules (see `AGENTS.md`): theme text
styles only (no font sizes), text that reflows at 200%, 48dp targets, a
label on every control, headings marked, decorative icons excluded, and
open or closed spelled out rather than shown by colour. The ID card's
barcode is an image with a label. The embed overlay's label chips are
hidden from screen readers.
