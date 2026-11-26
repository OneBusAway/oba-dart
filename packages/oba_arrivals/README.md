# oba_arrivals

A Wayfinder-style OneBusAway arrivals and departures panel for Flutter apps.

## Install

`oba_arrivals` re-exports `onebusaway` (except its `Route` model, see
below), so depend on this one package:

```yaml
dependencies:
  oba_arrivals:
    git:
      url: https://github.com/onebusaway/oba-dart.git
      path: packages/oba_arrivals
      ref: 0.1.0 # pin a release tag
```

Requires Flutter 3.47 or later (Dart 3.13.4 or later). Pub resolves the
`onebusaway` package from the same repository automatically.

## Example app

`example/` is a runnable demo that mimics the UCSD Student Life home feed and
embeds the panel on a card, with a full-page view that shares the card's
controller. Run it from the repository root:

```bash
cd packages/oba_arrivals/example
mise exec -- flutter run   # optional: --dart-define=OBA_BASE_URL=... --dart-define=OBA_API_KEY=...
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

## Errors

The panel shows failures to the user but doesn't log them. Pass `onError`
to report each failed fetch to your crash or analytics tool:

```dart
ObaArrivalsPanel(
  client: client,
  stopId: 'MTS_24151',
  onError: (error, stackTrace) =>
      Sentry.captureException(error, stackTrace: stackTrace),
)
```

Errors are normally `ObaException` subtypes. SDMTS answers a rejected API
key the same way as an unknown stop (`ObaApiException` with kind
`emptyResponse`), so watch for a spike of those after changing keys. When
you pass your own controller, give `onError` to the `ArrivalsController`
instead.

## Theming

Surfaces, text and fonts come from your `Theme`. Status colors and badge
metrics come from `ObaArrivalsTheme`. If you don't register one, the panel
picks the light or dark default from the theme's brightness.

```dart
ThemeData(extensions: [
  ObaArrivalsTheme.light().copyWith(late: Colors.deepOrange),
]);
```

## Accessibility

The panel targets WCAG 2.1 AA, in light and dark themes, inside whatever
theme the host app uses.

What the package guarantees:

- **Contrast.** The default status colours are at least 4.5:1 on every
  Material 3 surface role (`ObaArrivalsTheme.light()` uses green-800,
  violet-700 and red-700; the older green-600/red-600 measured 3.1:1 and
  4.6:1 on white). Every status colour, including one you register, is
  checked at runtime against the surface the panel sits on (the nearest
  `Material`: your `Card`, sheet or `Scaffold`) and darkened or lightened
  only if it falls short. Foreground roles of your `ColorScheme`
  (`onSurfaceVariant`, `primary`, `error`, …) get the same treatment inside
  the panel. Route badges always get a label of at least 4.5:1: a GTFS
  `route_text_color` that fails on its `route_color` is replaced with black
  or white.
- **High contrast.** With the platform's high-contrast setting on, the
  defaults switch to `ObaArrivalsTheme.highContrastLight()` /
  `highContrastDark()` (7:1 / 6.4:1).
- **Text size.** Text comes from your `TextTheme` and follows the user's
  text size with no clamping. Badges grow with it, nothing essential (route,
  headsign, ETA, status) is truncated, and at 130% and above each row stacks
  the badge and ETA above the headsign. Bold-text settings apply.
- **Screen readers.** Each row reads as one sentence: "Route IL, Inside
  Loop, arriving in 5 minutes, at 10:47 PM, 2 minutes late, real-time".
  Status is always written out, never shown by colour alone. The stop name
  is a heading. Loading, empty, error and "couldn't update" messages are
  live regions, and the result of a refresh the rider asked for (refresh
  button or Retry) is announced. Background polls are silent.
- **Input.** Tappable rows, the refresh button and Retry are at least
  48x48dp, work with Tab and Enter/Space, and rows show a 2dp focus ring in
  `colorScheme.primary`. With reduced motion on, the refresh spinner is
  replaced by a static icon.

What you must do as an embedder:

- If you override `ObaArrivalsTheme` colours, choose ones with at least
  4.5:1 against your surfaces. The runtime adjustment is a safety net that
  can shift your hue, not a substitute.
- Place the panel on an opaque `Material` (a `Card`, `Scaffold` or sheet),
  so that it can find the background it is drawn on.
- Translate the spoken strings too if you subclass `ObaArrivalsStrings`
  (`routeSemantics`, `atTime`, `minutesLateSemantics`, …).
- Don't wrap the panel in a fixed-height box. It must be free to grow at
  large text sizes.

`test/accessibility_test.dart` runs Flutter's tap-target, label and text
contrast guidelines on every state (loading, loaded, empty, error, stale)
in light and dark, at 100% and 200% text.

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

## License

Licensed under the [Apache License, Version 2.0](LICENSE).
