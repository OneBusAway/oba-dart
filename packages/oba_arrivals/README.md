# oba_arrivals

A Wayfinder-style OneBusAway arrivals and departures panel for Flutter apps.

## Install

`oba_arrivals` re-exports `onebusaway` (except its `Route` model, see
below), so depend on this one package:

```yaml
dependencies:
  oba_arrivals:
    git:
      url: <this repository>
      path: packages/oba_arrivals
      ref: main # or a tag/commit; pin one for reproducible builds
```

## Embed

```dart
import 'package:oba_arrivals/oba_arrivals.dart';

final client = OneBusAwayClient(
  baseUrl: Uri.parse('https://realtime.sdmts.com/api/'), // OBA server root
  apiKey: '<your key>',
);

ObaArrivalsPanel(
  client: client,
  stopId: 'MTS_24151',
  maxArrivals: 3,                    // optional; good for home-feed cards
  onArrivalTap: (arrival) { /* … */ }, // optional; rows are static without it
)
```

Create the `OneBusAwayClient` once (e.g. in `main` or a `State`), reuse it
for every panel, and `close()` it when you're done. Don't build it inside
`build()`: the panel treats a new client instance as a new configuration and
reloads.

The panel is a non-scrolling `Column`. Wrap it in a scroll view for
full-screen use.

- It polls every 30 s (set `refreshInterval:` to change this) while it is
  visible and the app is in the foreground.
- It pauses when a pushed route covers it.
- It corrects the device's clock using the server's time.

The re-export hides the `onebusaway` `Route` model, which would clash with
Flutter's `Route`. If you need the model, import the client with a prefix:

```dart
import 'package:onebusaway/onebusaway.dart' as oba;

oba.Route? route = response.references.route(arrival.routeId);
```

## Theming

Surfaces, text and fonts come from your `Theme`. Status colors and badge
metrics come from `ObaArrivalsTheme`. If you don't register one, the panel
picks the light or dark default from the theme's brightness.

```dart
ThemeData(extensions: [
  ObaArrivalsTheme.light().copyWith(late: Colors.deepOrange),
]);
```

## Strings

Subclass `ObaArrivalsStrings` and pass it as `strings:` to translate or
reword any text.

## Controller

To share state or trigger refreshes, create the controller yourself:

```dart
final controller = ArrivalsController(client: client, stopId: 'MTS_24151');
ObaArrivalsPanel(controller: controller);
// …
controller.refresh();
controller.dispose(); // you own it
```

A panel given a host controller calls `acquire()` while it is visible and
the app is in the foreground, and `release()` when it is hidden or disposed.
The controller polls while any holder remains, so a card and a pushed
full-page panel can share one controller. The panel never disposes a
controller it doesn't own. Outside a panel, use `resume()` and `pause()`.

## Goldens

```bash
TZ=America/Los_Angeles flutter test --tags golden --update-goldens
```

Goldens are skipped unless the tests run on macOS in US Pacific time.
