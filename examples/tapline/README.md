# Tapline: a fare app that embeds OneBusAway

Tapline is a sample Flutter app showing how a transit fare and payment app
can embed screens from the OneBusAway SDK (`package:obakit`). The fare
side (wallet, passes, checkout, tap history, reload stores) is the host's
own code. Everything about live transit (departures, alerts, the map, trip
planning, trip details) comes from the SDK.

**Tapline is a fictional brand.** The prices are sample values, not real
MTS fares, the reload stores are made up, and no payment is ever taken:
checkout shows "Demo purchase, no charge" and updates an in-memory wallet.
The transit data is real: the app uses the live OneBusAway San Diego
server, at a fixed point near UC San Diego.

## Run it

```bash
mise install && mise exec -- flutter pub get      # once, from the repo root
cd examples/tapline
mise exec -- flutter run --dart-define=OBA_API_KEY=your-key
```

Without `OBA_API_KEY` the app uses the public test key
`org.onebusaway.iphone`.

Turn on **Show OBA embeds** (the outline button in the Wallet tab's app
bar) to see every SDK widget outlined in green with its class name. In the
code, each embed is marked with an `// OBA embed:` comment.

## How it is wired

- `lib/main.dart` creates one `ObaApplication` with a
  `FixedLocationProvider` (32.8801, -117.2340), `regionsPath: null` and
  `fixedRegion: FixedRegionConfig(name: 'San Diego')`. That means no
  location prompt and no regions download.
- `lib/app.dart` puts one `ObaScope` (and Tapline's own `TaplineScope`)
  above the navigator with `MaterialApp(builder: ...)`, so every route and
  sheet is covered. Its `onNavigate` takes every `ObaRoute` and pushes a
  Tapline route built with `ObaRouteBuilder.build(context, route)`, so
  stops, trips, schedules, alerts and the trip planner all open under
  Tapline's app bar, never the SDK's.
- `lib/widgets/host_oba_page.dart`: `HostObaPage` (Tapline's app bar over
  one embedded SDK page) and `hostChromeFor`, which picks each route's
  title. Pages whose title is data (a stop's name, a trip) keep the SDK's
  compact header under a section title ("Transit"), so the name shows once.
  Pages with a fixed title (the trip planner, alerts) drop the SDK header
  and Tapline's app bar carries the title.
- Tabs live in an `IndexedStack`. SDK widgets in hidden tabs stop polling
  and release location on their own.
- `lib/data/` holds the mock wallet, products, taps and stores.
  `fareAdvice()` and `tripFareSuggestion()` there are host logic, not SDK
  logic.
- `lib/widgets/embed_frame.dart` is the "Show OBA embeds" overlay.

## Map tiles

Tapline shows the SDK's map with **vector tiles** (a prototype,
`lib/map_vector.dart`). The SDK has no vector dependency of its own: the
app passes `ObaTileSource.custom` a `VectorTileLayer` from
`vector_map_tiles` (pinned to 9.0.0-beta.13, the line that supports
flutter_map 8). The tiles and styles come from OpenFreeMap (free, no API
key). At startup the app loads the Positron and Dark styles and repaints
their background, land and water toward Tapline's palette. Roads, rail and
labels keep the base style.

- If the styles don't load within 5 seconds, the app falls back to CARTO's
  raster tiles (`lib/map_tiles.dart`). So does
  `--dart-define=TAPLINE_MAP=raster`, for comparing the two.
- The trip planner's itinerary map draws raster tiles only. It uses the
  same CARTO tiles, through the source's `rasterFallback`.
- Still to check on real devices: frame rate while panning on low-end
  Android, label quality, and web support.

## Embed points

| Screen | SDK widget | Why it's there for a fare-app rider |
|---|---|---|
| Wallet | `ServiceAlertsSection` | Disruptions show up where riders look before every trip. It renders nothing when there are no alerts, so it costs nothing on a normal day. |
| Wallet | `ObaNearbyStopsCard` | "Departures near you": after checking their balance, the rider's next question is when the bus comes. |
| Ride | `ObaStopDeparturesCard` (stop of the last tap, host title "Ride again from ...") | The ticket screen is open while the rider waits. Most trips repeat, so the last tap's stop is a good guess, but on a return trip it's the wrong end, hence "Ride again" rather than "Your next ride". Tapping a departure opens the SDK's `TripPage` under Tapline's app bar. |
| Ride (no stop known) | `ObaNearbyStopsCard` | When the last tap has no stop (see below), departures near the rider instead. |
| Buy | `TripPlannerPage`, pushed as `TripPlannerRoute(onItinerarySelected: ...)` and shown under Tapline's app bar | "Not sure which fare? Plan your trip". When the rider opens an itinerary, `onItinerarySelected` hands it to Tapline, and the Buy screen shows a sample suggestion such as "Suggested fare for your trip: $2.50 (stored value covers it)". It uses the itinerary's `fare` when the OTP server reports one, and otherwise Tapline's sample fare table (by agency, then mode), counting the transit legs with 2-hour transfers. |
| Activity, Ride details | `ObaStopDeparturesCard(stopId: tap.stopId)`, titled "Ride again from ..." | Turns a past tap into the next trip. The card's title is the only place the stop's name appears. |
| Map | `ObaMapView` with Tapline's reload-store markers added through `ObaMapCoordinator` and `ObaMapOverlays` | Riders find stops and the stores where they can reload with cash on one map. The map's "Stops on the map" button opens the SDK's `StopsOnMapPage` under Tapline's app bar. The floating Ride button is hidden on this tab so it doesn't cover the map; the app bar has a ticket button instead. |
| Map (stop tapped) | `ObaStopDeparturesCard` in a host bottom sheet | A quick look at a stop's departures without leaving the map. The `ObaScope` above the navigator covers the sheet, so no `ObaScope.rewrap` is needed. |

## Taps without a stop

The sample taps all carry an OneBusAway stop id, so the Ride screen and
ride details can show departures from that stop. Real fare systems often
don't know it: validators on board a bus record the route or the vehicle,
not where the rider got on. A production app may know the stop for only
some taps (rail platforms and station gates, say). `Tap.stopId` is
nullable for that reason, and when the last tap has no stop the Ride
screen falls back to the SDK's nearby-stops card. Matching a vehicle tap
to a stop would need the vehicle's position at tap time, which is outside
this sample.

## Tests

```bash
cd examples/tapline
TZ=America/Los_Angeles mise exec -- flutter test
```

The tests boot a real `ObaApplication` over an in-memory store, a fixed
location and a `MockClient` that answers from the captured fixtures in
`packages/onebusaway/test/fixtures` (see `test/support/test_env.dart`).
They check that no write request is ever sent. The Map tab isn't covered,
because a fake tile provider would need a direct `flutter_map` dependency.
