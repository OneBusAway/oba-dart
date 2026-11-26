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
  above the navigator with `MaterialApp(builder: ...)`, so every route,
  sheet and SDK-pushed page is covered.
- Tabs live in an `IndexedStack`. SDK widgets in hidden tabs stop polling
  and release location on their own.
- `lib/data/` holds the mock wallet, products, taps and stores.
  `fareAdvice()` there is host logic, not SDK logic.
- `lib/widgets/embed_frame.dart` is the "Show OBA embeds" overlay.

## Embed points

| Screen | SDK widget | Why it's there for a fare-app rider |
|---|---|---|
| Wallet | `ServiceAlertsSection` | Disruptions show up where riders look before every trip. It renders nothing when there are no alerts, so it costs nothing on a normal day. |
| Wallet | `ObaNearbyStopsCard` | "Departures near you": after checking their balance, the rider's next question is when the bus comes. |
| Wallet | `ObaStopDeparturesCard` (stop of the last tap, `maxArrivals: 2`) | "From your last ride": most trips repeat, so the last boarding stop is a good guess for the next one. |
| Ride | `ObaStopDeparturesCard` (boarding stop, host title "Your next ride from ...") | The ticket screen is open while the rider waits at the stop. Tapping a departure opens the SDK's `TripPage` (default navigation). |
| Buy | `TripPlannerPage` in `ObaPresentationScope.embedded`, under Tapline's app bar | "Not sure which fare? Plan your trip": seeing the legs and transfers helps the rider pick a fare. |
| Activity, Ride details | `ObaStopDeparturesCard(stopId: tap.stopId)` | "Ride again from ...": turns a past tap into the next trip. |
| Map | `ObaMapView` with Tapline's reload-store markers added through `ObaMapCoordinator` and `ObaMapOverlays` | Riders find stops and the stores where they can reload with cash on one map. The map's "Stops on the map" button opens the SDK's `StopsOnMapPage`. |
| Map (stop tapped) | `ObaStopDeparturesCard` in a host bottom sheet, via `ObaScope.rewrap` | A quick look at a stop's departures without leaving the map. |

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
