# oba_arrivals

A Wayfinder-style OneBusAway arrivals and departures panel for Flutter apps.

## Install

```yaml
dependencies:
  oba_arrivals:
    git:
      url: <this repository>
      path: packages/oba_arrivals
  onebusaway:
    git:
      url: <this repository>
      path: packages/onebusaway
```

## Embed

```dart
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

The panel is a non-scrolling `Column`. Wrap it in a scroll view for
full-screen use.

- It polls every 30 s while it is visible and the app is in the foreground.
- It pauses when a pushed route covers it.
- It corrects the device's clock using the server's time.

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

A panel given a host controller resumes and pauses it along with its own
visibility, and pauses it when the panel is disposed; it never disposes a
controller it doesn't own.

## Goldens

```bash
TZ=America/Los_Angeles flutter test --tags golden --update-goldens
```

Goldens are skipped unless the tests run on macOS in US Pacific time.
