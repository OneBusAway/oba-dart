# obakit

The OneBusAway app as an embeddable Flutter SDK: the counterpart of iOS
`OBAKit`. It contains the application object and scope, theme,
localization, the map-panel shell (full-screen map plus a draggable sheet),
the map, and every screen.

The main use case is **embedding parts of it in another app** (UCSD Student
Life: a host with its own navigation, theme and home feed). Running the
whole app is the second use case. Every screen is a plain widget that needs
only an `ObaScope` ancestor.

```
lib → obakit → { obakit_core, oba_arrivals, obakit_trip_planner } → onebusaway
```

`package:obakit/obakit.dart` re-exports `obakit_core` (and through it the
`onebusaway` client). It hides two names that clash:

- `Route`: Flutter's navigator `Route`. Import
  `package:onebusaway/onebusaway.dart` with a prefix (`as oba`) for the
  model.
- `Polyline`: the encoded-polyline codec, which clashes with flutter_map's
  `Polyline` widget. Use `ObaMapPolyline.encoded(...)`, or import
  `onebusaway` with a prefix.

`Place` (a geocoded place) is exported. `obakit_trip_planner` also has a
`Place` model, so import the trip planner with a prefix if you use both.

## Install

Unreleased: the `0.1.0` tag predates this package. Pin a commit or a branch.
Pub resolves the sibling packages (`obakit_core`, `onebusaway`,
`oba_arrivals`, `obakit_trip_planner`) from the same repository and the
same commit. The packages declare `resolution: workspace`, which pub ignores
when they are dependencies of an app outside this repository.

```yaml
dependencies:
  obakit:
    git:
      url: https://github.com/onebusaway/oba-dart.git
      path: packages/obakit
      ref: <commit SHA or branch>
```

If you also import a sibling package directly (for example
`package:oba_arrivals` for `ObaArrivalsPanel`, or
`package:obakit_trip_planner`), list it too, with the same `url` and the
same **full 40-character commit SHA** as `ref` in every entry. Pub
compares the refs as written: a branch, a tag or a short SHA in the direct
entry doesn't match the commit that `obakit`'s sibling resolved to, and
version solving fails. So does `oba_arrivals` at the `0.1.0` tag next to
`obakit` at a commit.

```yaml
  obakit:
    git:
      url: https://github.com/onebusaway/oba-dart.git
      path: packages/obakit
      ref: 0123456789abcdef0123456789abcdef01234567   # full SHA
  oba_arrivals:
    git:
      url: https://github.com/onebusaway/oba-dart.git
      path: packages/oba_arrivals
      ref: 0123456789abcdef0123456789abcdef01234567   # the same full SHA
```

For local development against a checkout, `path:` dependencies on
`<checkout>/packages/obakit` (and siblings) work the same way.

The SDK bundles the regions list (`assets/regions.json` in this package),
so a host needs no asset of its own. To use your own list instead, pass
`bundledRegionsJson:` (an OBA envelope with `data.list`) to `ObaAppConfig`.

Requires Flutter 3.47 or later (Dart 3.13.4 or later).

### Plugins and permissions

Depending on `obakit` links these Flutter plugins into your app:
`geolocator` (location), `shared_preferences` (storage), `url_launcher`
(links) and `share_plus` (sharing). They are linked even when you replace
the adapters that use them. `geolocator` asks for nothing by itself: the
location permission keys (see [Platform setup](#platform-setup-a-host-needs))
are needed only when you use the default location provider. A host that
passes `FixedLocationProvider` or `NoLocationProvider` declares none.

## Creating the application

Create one `ObaApplication` and dispose of it when you're done.

```dart
final app = await ObaApplication.create(
  map: const ObaMapConfig(userAgentPackageName: 'edu.ucsd.studentlife'),
  nominatimUserAgent: 'StudentLife/1.0 (edu.ucsd.studentlife)', // address search; optional
  config: (services) => ObaAppConfig(
    appName: 'OneBusAway',
    apiKey: 'org.onebusaway.iphone',
    appVersion: '1.0.0',
    keyValueStore: services.keyValueStore,         // shared_preferences, keys under "oba."
    locationProvider: services.locationProvider,   // geolocator; never prompts by itself
    placeSearchProvider: services.placeSearchProvider,
  ),
);
```

`create` builds the default adapters, the core application (with the
SDK's bundled regions list unless you pass `bundledRegionsJson:`), and calls
`start()`. To replace an adapter, pass
`services: await ObaPlatformServices.defaults(keyValueStore: myStore)` or
build `ObaPlatformServices` yourself. For full control, construct
`ObaApplication(core: ObaCoreApplication(config, bundledRegionsLoader:
ObaApplication.loadBundledRegionsJson), map: ...)` and call
`await app.start()`.

**Creating one is cheap**, which matters for a host that shows a single
card:

- Location: `GeolocatorLocationProvider` never prompts at startup, and the
  GPS runs only while a visible SDK widget needs it. Location is
  demand-driven and reference-counted (`app.core.locationService`): the map
  (for its location dot), a visible nearby section or page, a visible stop
  page (walk times) and the bookmarks page sorted by distance each hold a
  lease while on screen and the app is in the foreground. The position
  stream is subscribed while at least one lease is held and dropped when
  the last one goes away: under a pushed route, in a hidden `IndexedStack`
  tab, in the background, or on dispose. Even with permission granted,
  nothing runs while no such widget is on screen. The last known fix
  (`app.core.currentLocation`) stays readable without a lease. With
  automatic region selection on and no cached fix, startup takes one fix
  (never with a fixed region). `warmUp()` reads the platform's cached fix,
  and only when permission was already granted. In a host that declares no
  location permission, it reads as denied rather than failing.
- A fixed point instead of the device: pass `FixedLocationProvider` (it
  always reports one point, permission granted, no prompt). Screens then
  behave as if the rider stood there. To anchor one widget only, pass
  `around:` to it instead (see [Nearby departures](#nearby-departures-search-places-and-weather)).
- No location at all: pass `NoLocationProvider`. Screens that need a
  location say "This app doesn't use your location…" rather than "Location
  access is off", the map hides its location button, and `ObaApp` skips
  the location onboarding step.
- With either of those the SDK never touches the platform location APIs,
  and you need no location permission or `Info.plist` key.
- Regions: set `regionsPath: null` and `fixedRegion:` in `ObaAppConfig`, and
  no regions download happens. The region comes from the SDK's bundled
  list (or your `bundledRegionsJson:`, which may hold only your region).
- Onboarding: only `ObaApp` shows the onboarding gate. Embedded screens
  never do.

```dart
final app = await ObaApplication.create(
  map: const ObaMapConfig(userAgentPackageName: 'edu.ucsd.studentlife'),
  services: ObaPlatformServices(
    keyValueStore: await SharedPreferencesKeyValueStore.create(),
    locationProvider: FixedLocationProvider(const Coordinate(32.8801, -117.2340)), // or const NoLocationProvider()
  ),
  config: (services) => ObaAppConfig(
    appName: 'Student Life',
    apiKey: 'org.onebusaway.iphone',
    appVersion: '1.0.0',
    keyValueStore: services.keyValueStore,
    locationProvider: services.locationProvider,
    regionsPath: null,                                  // no regions server
    fixedRegion: const FixedRegionConfig(name: 'San Diego'),
  ),
);
```

#### Refreshing the bundled regions list

`assets/regions.json` in this package is a copy of the regions server's
list. Refresh it when regions change, then run the tests (`test/host_embedding_test.dart`
checks that it parses):

```bash
curl -fsSL https://regions.onebusaway.org/regions-v3.json -o packages/obakit/assets/regions.json
```

Apps also download the list at runtime (once a day) unless `regionsPath`
is null, so the bundled copy matters for first launch and fixed-region
hosts.

### Configuration reference

| Setting | Where | Notes |
|---|---|---|
| API key, app name and version, URL scheme, fixed region, More tab, donations | `ObaAppConfig` (obakit_core) | See the obakit_core README. `ObaAppConfig.fromOBAKitConfig` reads an iOS-style map |
| Tile server | `ObaMapConfig.standard` (`ObaTileSource`) | Defaults to OpenStreetMap, which allows light use only. Production apps should use their own provider. The attribution is always shown |
| High-density tiles | `ObaTileSource.retinaMode` | Automatic when the URL template has `{r}` and the screen is high-density (the provider serves `@2x` tiles). Without `{r}` it stays off unless you pass `true` |
| Vector tiles or another custom base layer | `ObaTileSource.custom(layerBuilder:, attribution:, rasterFallback:)` | Return any flutter_map layer (for example `VectorTileLayer` from `vector_map_tiles`, which the SDK doesn't depend on). The trip planner's itinerary map draws raster tiles only and uses `rasterFallback` (OpenStreetMap by default). `examples/tapline` has a working setup |
| Dark street tiles | `ObaMapConfig.standardDark` | Used when the theme is dark; null (default) uses `standard` in both. Its own attribution is shown. The shell's status-bar icons turn light over them |
| Regions list | `ObaAppConfig.bundledRegionsJson` | Defaults to the list bundled with the SDK |
| Location | `ObaPlatformServices.locationProvider` | `GeolocatorLocationProvider` (default), `FixedLocationProvider`, `NoLocationProvider`, or your own |
| Satellite and hybrid | `ObaMapConfig.satellite`, `hybridLabels` | When null, the map-type options are hidden |
| Tile User-Agent | `ObaMapConfig.userAgentPackageName` | Required by OSM |
| Test tiles | `ObaMapConfig.tileProvider` | Inject a fake in tests (see `test/support`) |
| Most pins drawn at once | `ObaMapConfig.maxStopMarkers` (300) | The stops nearest the centre win |
| Address search | `ObaAppConfig.placeSearchProvider` | `NominatimPlaceSearch`, or your own `PlaceSearchProvider` |
| Theme | Host `ThemeData` plus optional `ObaTheme` extension | See [Theming](#theming) |
| Host navigation | `ObaScope(onNavigate:)` or `ObaNavigatorScope` | See [Navigation](#navigation) |

## Running the whole app (a shim)

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final app = await ObaApplication.create(...);
  final links = AppLinks();                     // any app-links plugin; the SDK doesn't own link plumbing
  runApp(ObaApp(
    application: app,
    initialLink: await links.getInitialLink(),
    links: links.uriLinkStream,
  ));
}
```

`ObaApp` builds the `MaterialApp`, with light, dark and high-contrast
brand themes (unless you pass `theme`/`darkTheme`) and the SDK's
localizations. It then shows the onboarding gate (welcome, location, and
region when none could be chosen) and the `ObaHomeShell`. Links go through
`ObaDeepLinkHandler`:

- `onebusaway://stop?id=` and `view-stop` open the stop page.
- Sidecar `/regions/{id}/stops/{stop}[/trips]` links open the stop page or
  the trip page, switching region first if needed.
- `add-region` opens the custom-region form.

## Embedding single screens

Wrap the part of your tree that shows SDK widgets in an `ObaScope`. It can
sit inside your `MaterialApp`, and it adds the SDK's localization delegate
if yours doesn't register it. Screens read your `Theme`. You don't need the
shell or the map.

An `ObaScope` covers only its subtree. A route or modal sheet that your
code pushes sits above it, so wrap that content in an `ObaScope` again
(`ObaScope.rewrap(context, child)` copies the nearest one). Routes the SDK
pushes itself carry the scope over for you. The simplest way to cover every
route, yours and the SDK's, is one scope above your navigator:

```dart
MaterialApp(
  builder: (context, child) => ObaScope(application: app, child: child!),
  home: const MyHome(),
)
```

A scope deeper in the tree can still set its own `onNavigate`. Writing
`onNavigate` as an inline closure is fine: a new closure doesn't rebuild
the SDK widgets below, and navigation always calls the latest one.

Sections and cards poll, and hold location, only while they are visible:
not under a pushed route, not in a hidden `IndexedStack` child (the usual
bottom-navigation tabs), and not while the app is in the background.

#### Pages inside your own screens

A page (`StopPage`, `TripPage`, `TripPlannerPage`, ...) on its own is a
full-screen route: it brings a `Scaffold` and an `AppBar`. Inside a screen
that already has your app bar, such as a tab body, mark it embedded, or you
get two app bars:

```dart
Scaffold(
  appBar: AppBar(title: const Text('Transit')),
  body: ObaScope(
    application: app,
    child: const ObaPresentationScope.embedded(
      showsHeader: true,   // the stop's name as a heading, and its actions
      child: StopPage(stopId: 'MTS_24151'),
    ),
  ),
);
```

Embedded pages have no header by default: the page's title is left to
your app bar, and its header actions (refresh, bookmark, the overflow menu)
and any pinned controls lead the list instead. Pass `showsHeader: true`
when your screen has no title of its own for the page; the title and
actions then sit in a compact header, once. The header has no back button;
your app bar handles back.

### 1. A stop page pushed from host code

```dart
ObaScope(
  application: app,
  child: MyHostScreen(),
);

// Anywhere below it:
ObaNavigator.of(context).push(const StopRoute('MTS_11589'));
// or, as a plain widget in your own route:
Navigator.of(context).push(MaterialPageRoute(
  builder: (_) => ObaScope(application: app, child: const StopPage(stopId: 'MTS_11589')),
));
```

Outside the shell, `ObaNavigator` pushes SDK pages as ordinary full-screen
routes on your nearest `Navigator`. It copies the `ObaScope` onto the new
route, so the page works even when your scope sits below the navigator.
Pages render as a `Scaffold` with an `AppBar`.

### 2. A nearby-stops card in a host feed

To present SDK destinations your way, return true from `onNavigate`. For
example, push the trip page under your own app bar:

```dart
bool openInHost(BuildContext context, ObaRoute route) {
  if (route is! TripRoute) return false;
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('Trip')),
      body: ObaScope(               // a new route: re-wrap the scope
        application: app,
        onNavigate: openInHost,
        child: ObaPresentationScope.embedded(child: TripPage(trip: route.trip)),
      ),
    ),
  ));
  return true;
}
```

```dart
ObaScope(
  application: app,
  onNavigate: (context, route) {
    if (route is StopRoute) {
      myRouter.openStop(route.stopId);   // open it your way...
      return true;
    }
    return false;                        // ...or let the SDK push its page
  },
  child: ListView(children: [
    const MyWeatherCard(),
    const NearbyStopsSection(),          // a plain Column: no scrolling, no fixed height
    const BookmarksSection(),
  ]),
);
```

Home sections (`NearbyStopsSection`, `BookmarksSection`,
`RecentStopsSection`, `ServiceAlertsSection`) are non-scrolling widgets, so
they drop into a feed.

### 3. The map in a host tab

```dart
ObaScope(
  application: app,
  child: ObaMapView(
    onStopSelected: (stop) => myRouter.openStop(stop.id), // default: push StopRoute
    onLongPress: null,                // default: drop a pin and push PlaceRoute
    dropsPinOnLongPress: false,       // or switch that off
  ),
);
```

To show a stop in your own bottom sheet instead, re-wrap the scope (the
sheet's route sits above it). `rewrap` needs a context below the
`ObaScope`, hence the `Builder`:

```dart
ObaScope(
  application: app,
  child: Builder(
    builder: (context) => ObaMapView(
      onStopSelected: (stop) => showModalBottomSheet<void>(
        context: context,
        builder: (_) => ObaScope.rewrap(
          context,
          ObaStopDeparturesCard(stopId: stop.id),
        ),
      ),
    ),
  ),
);
```

`ObaMapView` loads stop pins for the visible area when zoomed in far
enough, and shows a "Zoom in to see stops" pill otherwise. In a hidden tab
it loads nothing (no tiles, no stops request, no location) until it is
first shown. It also shows
your location, the recentre button, and the tile attribution. Pass an
`ObaMapCoordinator` to drive it from your code (`moveTo`, `focusStop`,
overlays). `onShowStopsList` adds the accessible list of visible stops.

For a dark theme, give the map dark street tiles (and their attribution).
Without them the default tiles show in both themes:

```dart
const ObaMapConfig(
  userAgentPackageName: 'edu.ucsd.studentlife',
  standardDark: ObaTileSource(
    urlTemplate: 'https://tiles.example.com/dark/{z}/{x}/{y}.png',
    attribution: 'Example Maps',
  ),
);
```

### 4. The trip planner

```dart
ObaScope(
  application: app,
  child: const TripPlannerPage(destination: Place(name: 'Geisel Library', coordinate: Coordinate(32.8811, -117.2376))),
);
```

In a tab under your own app bar, wrap it in `ObaPresentationScope.embedded`
(see [Pages inside your own screens](#pages-inside-your-own-screens)).

To learn which trip the rider chose, pass `onItinerarySelected`. It runs
when the rider opens an itinerary, just before the SDK pushes that
itinerary's details (the push still happens). The itinerary is an
`obakit_trip_planner` `Itinerary`. Import that package with a prefix,
because its `Place` clashes with the `Place` that `obakit` exports:

```dart
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

TripPlannerPage(
  destination: geisel,
  onItinerarySelected: (context, tp.Itinerary itinerary) {
    final routes = itinerary.legs
        .where((leg) => leg.transitLeg)
        .map((leg) => leg.routeShortName ?? leg.mode);
    myTripStore.remember(
      leaveAt: itinerary.startTime,   // "Leave by 9:12"
      routes: routes.toList(),        // "route 201"
      fare: itinerary.fare,           // Money?, when the server reports one
    );
  },
);

// The same through the navigator:
ObaNavigator.of(context).push(TripPlannerRoute(
  destination: geisel,
  onItinerarySelected: (context, itinerary) => myTripStore.remember(...),
));
```

An `Itinerary` has `startTime`, `endTime`, `duration` (seconds),
`transfers`, `fare` and `legs`. Each `Leg` has `mode` (`BUS`, `WALK`, ...),
`transitLeg`, `routeShortName`, `routeLongName`, `headsign`, `agencyName`,
`startTime`, `endTime`, and `from`/`to` places. The callback is not part
of `TripPlannerRoute`'s identity, so routes that differ only in it are
equal.

`TripPlannerPage` builds the region's `OtpClient` (`app.otpClient()`). It
wires up the app's place search, location and tiles, and shows an empty
state when the region has no trip planner. To use the lower-level widget,
use `obakit_trip_planner` directly with `app.tripPlaceSearch` and
`app.otpClient()`.

### Bookmarks, recent stops and alerts

```dart
ObaScope(
  application: app,
  child: ListView(children: const [
    ObaBookmarksCard(limit: 3),     // a Card like ObaNearbyStopsCard: pinned + newest bookmarks, live departures, "See all"
    RecentStopsSection(limit: 3),
    ServiceAlertsSection(),         // urgent unread alerts; renders nothing when there are none
    AlarmsSection(),                // alarms still to come; renders nothing when there are none
  ]),
);

// Full pages, as widgets in your own routes (all need only an ObaScope):
const BookmarksPage();              // grouped or by distance, pinned first, sort persisted
const AlertsListPage(stopId: '1_75403');   // or routeId:, or neither for the region
const AgenciesPage();               // phone / email / fares open through ObaLinkOpener
```

Bookmark departures are fetched once per stop, at most three requests at a
time, and refreshed every 30 seconds only while the widget is on screen and
the app is in the foreground. Links open through the `ObaLinkOpenerScope`
opener (see below); pass `urlOpener:` to `AlertDetailPage` or
`AgenciesPage` to override it for that page. Region-wide alerts come from the
arrivals of the rider's bookmarked, recent and nearby stops, because the
GTFS-realtime alerts feed is not ported.

### Settings, More, regions and prompt cards

```dart
ObaScope(
  application: app,
  child: Column(children: [
    const SettingsAndMoreSection(),   // Customize map, Settings, More
    const ObaSurveyCard(),            // map survey; pass stop: for a stop page
    const ObaDonationCard(),          // only when ObaAppConfig.donations.enabled
    const ObaFeedbackPrompt(),        // "Enjoying the app?"
  ]),
);

// Whole screens, in your own route or pushed through the navigator:
ObaNavigator.of(context).push(const SettingsRoute());
ObaNavigator.of(context).push(const MoreRoute());
ObaNavigator.of(context).push(const RegionPickerRoute());
```

- The cards show nothing unless their rules say so (surveys:
  `SurveyService.shouldShowSurvey` plus a survey for the stop or map;
  donations: enabled, three launches, not dismissed; feedback: five
  recorded successes, ask limits and back-offs). Call
  `app.core.reviewPrompt.recordSuccess()` after something good happens
  (a stop loaded, a bookmark saved) for the feedback prompt to ever appear.
  `app.core.prompts` keeps cards from piling up (one review prompt per
  session, a 14-day quiet period after any inline card).
- Every link the SDK opens (donate, privacy, store, mail, phone, fare
  payment app, alert and agency links, directions, maps, map attribution)
  goes through an `ObaLinkOpener`. The default uses `url_launcher`. Install
  your own (in-app browser, test fake) with
  `ObaLinkOpenerScope(opener: ..., child: ...)`. When a link can't be
  opened the rider is told (snack bar and screen-reader announcement).
  When no mail app exists, "Contact us" offers to copy the address and the
  debug info.
- Settings are `app.core.settings` (`ObaSettings`). Onboarding steps are
  versioned (`OnboardingStep.version`): raise a version to show that step
  again. Only `ObaApp` shows onboarding.

### Nearby departures, search, places and weather

```dart
ObaScope(
  application: app,
  child: ListView(children: const [
    ObaNearbyStopsCard(),           // "Departures near you": NearbyStopsSection in a Card
    NearbyStopsSection(maxStops: 3, maxRows: 4, showSeeAll: false),  // or the bare section
    ExploreSection(),               // Plan a trip (where available), Weather, Agencies
  ]),
);

// Near a fixed point instead of the rider: no location used at all.
const ObaNearbyStopsCard(around: Coordinate(32.8801, -117.2340));
const NearbyStopsSection(around: Coordinate(32.8801, -117.2340));
const NearbyStopsPage(coordinate: Coordinate(32.8801, -117.2340)); // the page's around:

// Full pages, as widgets in your own routes (all need only an ObaScope):
const SearchPage();                                    // field + scope chips; embeds inline too
const NearbyStopsPage(coordinate: Coordinate(32.8801, -117.2340));  // or null: near the rider
PlacePage(place: myPlace);                             // directions, nearby stops, share, open in maps
const WeatherPage();                                   // forecast in the locale's units
const ObaWeatherButton();                              // compact temperature chip; hides itself without data
```

- `NearbyStopsSection` finds stops around the rider's location, or the map
  centre when there is a map and no location; with neither it shows a
  "Use my location" button (the only place it asks for permission). With
  `around:` it uses that point only: no permission message, no location
  lease, and "See all" opens the list around the same point. With
  `NoLocationProvider` (and no `around:`) it says the app doesn't use
  location.
- `ObaNearbyStopsCard` and `ObaBookmarksCard` are the same kind of card:
  a `Card` styled by your `CardTheme` (colour, shape, elevation, margin,
  overridable with `margin:`), a heading, and the same padding. Inside
  `ObaBookmarksCard`, bookmarks are separated by dividers. The bare
  `NearbyStopsSection` and `BookmarksSection` have no outer card. It
  fetches departures for the closest `maxStops` stops one request at a
  time, refreshes every 30 seconds while on screen and the app is in the
  foreground, and refetches stops only after a move of 150 m.
- Search opens unambiguous results directly (one stop, one route, one
  vehicle's trip, one place) and pushes `SearchResultsRoute` otherwise. In
  the shell it replaces itself with the result; anywhere else it pushes, so
  your page is never replaced. Address search needs a
  `PlaceSearchProvider`; without one the Places scope explains that.
- The weather forecast is cached per application for 15 minutes (a failed
  fetch is retried after 5), so the button and the page share one request.
  Temperatures are °F and wind mph for US locales, °C and km/h elsewhere
  (mph in the UK), and the page names the unit.

### Stop departures, trips, schedules and reports

```dart
ObaScope(
  application: app,
  child: ListView(children: const [
    // Next departures at one stop, for a feed: a Card with no fixed height.
    // "See all" pushes StopRoute; a row pushes TripRoute (both through
    // ObaNavigator, so onNavigate can take over).
    ObaStopDeparturesCard(stopId: 'MTS_11589', maxArrivals: 3),
  ]),
);

// Full pages, as widgets in your own routes (all need only an ObaScope):
const StopPage(stopId: 'MTS_11589');                   // the full stop page
TripPage(trip: TripRef.fromArrival(arrival));          // vehicle progress and stop list
const RouteStopsPage(routeId: 'MTS_10');               // stops by direction
const StopSchedulePage(stopId: 'MTS_11589');           // full-day schedule
const RouteSchedulePage(routeId: 'MTS_10', stopId: 'MTS_11589');
const ReportStopProblemPage(stopId: 'MTS_11589');

// One controller shared by a card and the page it opens (the host owns
// and disposes it; the SDK never does):
final departures = StopArrivalsController(
  stopId: 'MTS_11589',
  client: () => app.core.restClient,
);
ObaStopDeparturesCard(stopId: 'MTS_11589', controller: departures);
StopPage(stopId: 'MTS_11589', controller: departures);
```

- The stop page and the card poll every 30 seconds while on screen and the
  app is in the foreground, keep the last data (with a "Couldn't refresh"
  banner) when a refresh fails, and use the server's clock for countdowns.
  Both honour the rider's departure-type filter and the stop's hidden
  routes. The stop page also records the stop in recent stops and reports
  `reportStopViewed`.
- Use the card rather than `oba_arrivals`' `ObaArrivalsPanel` inside an
  `ObaScope`: the panel needs its own client and knows nothing of the
  SDK's settings, navigation or alarms. The panel remains the choice for a
  host that embeds arrivals without `obakit`.
- `ObaDepartureRow` is the row on its own (route badge, headsign, clock
  time, status icon and text, real-time indicator, occupancy, countdown;
  read as one sentence, with its actions as screen-reader custom actions)
  for hosts that build their own lists.
- With a map, the stop page draws the routes serving the stop and live
  vehicles, the trip page the trip's shape, stops and vehicle, and the
  route stops page the route. Without one, nothing is fetched for the map.
- Alarm actions appear only when `ObaAppConfig.pushServiceProvider` is set
  and the region has an Obaco server. Trip and stop sharing need the
  region's sidecar. The route timetable entry points hide themselves when
  the region's server lacks `schedule-for-route`.

## Navigation

- `ObaRoute` is a sealed class with one variant per destination (listed
  under the contract below). A route is a value: routes with the same `id`
  are the same page.
- `ObaNavigator.of(context)` provides `push`, `replace`, `pop`,
  `popToRoot` and `canPop`. It resolves in this order: the host's
  `ObaScope.onNavigate`, the nearest `ObaNavigatorScope` (the shell installs
  one that pushes into its sheet; a host can install its own), then
  `PageObaNavigator` on the nearest `Navigator`.
- `ObaRouteBuilder.build(context, route)` maps any route to its page widget.
- In the shell, pages push into the sheet's nested navigator, and the map
  stays visible and interactive. Each route has sheet `detents`, which
  mirror iOS `SheetDetentConfiguration`. For example, the stop page opens at
  medium, search opens full, and home starts collapsed to the search field
  and tabs. Popping restores the previous page's detent. Pushing a route
  that is already open goes back to it. At 840dp and wider, the sheet
  becomes a 400dp side panel.

## Theming

Screens use your `Theme.of(context)`: text styles, colour scheme and
surfaces. They never assume the brand theme. OneBusAway-specific colours,
such as status, pins, the user location and route lines, come from the
`ObaTheme` `ThemeExtension`. When you don't register one, `ObaTheme.of`
picks light, dark or high-contrast defaults. Every default pair meets WCAG
AA, and `test/theme_contrast_test.dart` checks this.

```dart
ThemeData(
  colorScheme: myScheme,
  extensions: [ObaTheme.light().copyWith(brand: myGreen), ObaTheme.light().toArrivalsTheme()],
)
```

`ObaTheme.buildThemeData(brightness:, highContrast:)` builds the
standalone app's full theme. `ObaContrast` provides readable foregrounds
for route colours (`readableOn`, `ensureReadable`).

## Localization

All strings live in `lib/src/l10n/app_en.arb`. The generated
`ObaLocalizations` class is committed under `lib/src/l10n/generated/`.
Read strings with `context.obaL10n`, which is never null and falls back to
English. If you build your own `MaterialApp` and want SDK strings in your
locale, register the delegates:

```dart
MaterialApp(
  localizationsDelegates: [...obaLocalizationsDelegates, ...myDelegates],
  supportedLocales: [...obaSupportedLocales, ...],
)
```

If you skip this, `ObaScope` adds `ObaLocalizations.delegate` itself.

## Platform setup a host needs

| Platform | What |
|---|---|
| iOS | `Info.plist`: `NSLocationWhenInUseUsageDescription` ("Shows stops near you and picks your region"). For deep links, `CFBundleURLTypes` with your scheme (`onebusaway`), plus Associated Domains for sidecar universal links |
| macOS | In both entitlements files `com.apple.security.network.client`. For location, the same `Info.plist` key and `com.apple.security.personal-information.location` |
| Android | `AndroidManifest.xml`: `INTERNET` (Flutter's template adds it only to the debug and profile manifests). For location, `ACCESS_COARSE_LOCATION` and `ACCESS_FINE_LOCATION`. For deep links, an `intent-filter` for your scheme (and `autoVerify` https links) |
| Web | Location needs HTTPS. Nominatim and OSM tiles need CORS-friendly endpoints |

The location entries are needed only with the default
`GeolocatorLocationProvider`. A host that passes its own `LocationProvider`
(`FixedLocationProvider`, `NoLocationProvider`, or one over its own
location code) needs network access alone; the `geolocator` plugin is
still linked but never called. Without the declarations the default
provider reads as denied (the nearby section then offers "Use my
location", which can't succeed), so a host without location should pass
`NoLocationProvider` instead.

`url_launcher` (attribution links) and `share_plus` (sharing, used by
screens) need no extra setup beyond the defaults above.

## Contributing a screen

This section is the contract for anyone adding or changing a screen. Follow
it exactly. The shell, the registry, the barrel exports and the tests depend
on it.

### Where files go

| Feature area | Owns these routes | Entry file | Folder |
|---|---|---|---|
| Stop | `StopRoute`, `StopScheduleRoute`, `RouteScheduleRoute`, `TripRoute`, `ReportStopProblemRoute`, `ReportTripProblemRoute`, `RouteStopsRoute` | `lib/src/features/stop/stop_routes.dart` | `lib/src/features/stop/` |
| Bookmarks | `BookmarksRoute`, `BookmarkEditorRoute`, `ManageBookmarksRoute`, `RecentStopsRoute`, `AlertsListRoute`, `AlertDetailRoute`, `AgenciesRoute`, plus the bookmarks, recent and alerts home sections | `lib/src/features/bookmarks/bookmarks_routes.dart` | `lib/src/features/bookmarks/` |
| Settings | `SettingsRoute`, `MoreRoute`, `RegionPickerRoute`, `CustomRegionRoute`, `CreditsRoute`, `OnboardingRoute`, `buildOnboardingStep`, plus the "Settings and more" section | `lib/src/features/settings/settings_routes.dart` | `lib/src/features/settings/` |
| Search | `HomeRoute` (keep `ObaHomeSheet`), `SearchRoute`, `SearchResultsRoute`, `NearbyStopsRoute`, `PlaceRoute`, `TripPlannerRoute`, `WeatherRoute`, `buildWeatherAccessory`, plus the nearby and explore sections | `lib/src/features/search/search_routes.dart` | `lib/src/features/search/` |
| Shared infrastructure (change with care) | `MapSettingsRoute`, `StopsOnMapRoute`, the shell, map, navigation, theme, widgets | `lib/src/features/map/`, `lib/src/shell/`, `lib/src/navigation/`, `lib/src/widgets/` | |

**Keep the `build…Route` function names and the public page
and section class names** (`StopPage`, `NearbyStopsSection`, …). The
registry, the barrel exports and the embedding recipes above use them. Add
new public widgets to the `show` list for your file in `lib/obakit.dart`.

### Registering routes

- Every route is already mapped in `ObaRouteBuilder`
  (`lib/src/navigation/route_builder.dart`) to a function in your file. You
  don't edit the registry.
- A route nobody else uses goes in your own file:
  `class MyRoute extends ObaCustomRoute` with `id`, `detents` and
  `build(context)`.
- To change a shared route's parameters or detents, edit `oba_route.dart`,
  but only that route's class. Detents mirror iOS `SheetRoute.swift`.
- To navigate, call `ObaNavigator.of(context).push(SomeRoute(...))`. Never
  call `Navigator.push` for an SDK destination. Pop with
  `ObaNavigator.of(context).pop()`.

### Rules every screen follows (embedding first)

1. **Plain widget, `ObaScope` only.** A page must work in four places:
   inside the sheet, in the side panel, as a full-screen route on a host
   navigator, and (for sections) inside a host's feed. Read the app from
   `ObaScope.of(context)`, never from a global or singleton.
2. **Use `ObaSheetPage`** as the page scaffold. Give it a `title`,
   `actions` (`IconButton` with a `tooltip`) and `slivers`. It adapts by
   itself: a compact draggable header in the sheet, an `AppBar` as a page,
   and, embedded, either the compact header or (with no header) the
   actions at the top of the list. Don't add them to the list yourself. If you pass `body:` instead of
   `slivers:`, the scrollable must use the primary controller (`primary:
   true`, or no `controller:`), so that dragging the content drags the sheet.
3. **The map is optional.** Use `ObaMapCoordinator.maybeOf(context)?.…` and
   the `ObaMapOverlays` widget. Both do nothing without a map.
   **Live location is demand-driven.** Read `app.core.currentLocation` (the
   last known fix) freely. If the screen needs updates, wrap it in
   `ObaLocationHolder` (pass `enabled: false` when it was given a fixed
   point). Never listen to the provider's `positionStream` yourself.
4. **Sections don't scroll.** A home section is a `Column` with no fixed
   height. List it in your `…HomeSections` getter with its `order` slot.
5. **State.** Controllers are `ChangeNotifier`s owned by a `State` and
   disposed there. Listen to obakit_core objects with
   `ObaListenableAdapter` / `.listenable` / `.valueListenable`. Read the
   REST client on every use (`app.core.restClient`). Time comes from
   `package:clock`, and arrivals ETA uses the server-corrected time.
6. **Errors.** Use `ObaLoadingState`, `ObaErrorState(error:, onRetry:)` and
   `ObaEmptyState`. Never show a raw exception.

### Driving the map

```dart
// Imperative (applies to the current top page; restored when the rider pops back):
final map = ObaMapCoordinator.maybeOf(context);
map?.focusStop(stop);                                   // select and centre (zoom 17)
map?.showRoute(shapes: [ObaMapPolyline.encoded(shape.points, color: c)], stops: stops);
map?.showTrip(shape: line, vehiclePosition: pos, vehicleHeading: deg, vehicleLabel: label, stops: stops);
map?.showItinerary(legs: legs, markers: [origin, destination]);
map?.showPlace(ObaMapMarker(coordinate: c, label: place.name, kind: ObaMapMarkerKind.place));
map?.moveTo(coordinate, zoom: 16);  map?.fitBounds(rect);  map?.clearOverlays();
map?.center; map?.zoom; map?.visibleBounds; map?.cameraIdle /* ValueNotifier<RegionRect?> */;

// Declarative (preferred; tied to the page's lifetime):
ObaMapOverlays(
  overlay: ObaMapOverlay(polylines: [...], stops: [...], markers: [...], hideStopPins: true, fitBounds: rect),
  child: ObaSheetPage(...),
)
```

Every `ObaMapMarker` needs a `label`, because screen readers announce it.

### Shared widgets

| Widget | Use |
|---|---|
| `ObaSheetPage`, `ObaSheetHeader` | Page scaffold, or the header alone for custom layouts |
| `ObaSectionHeader(title:, actionLabel:, onAction:)` | Section titles, marked as headings, with an optional "See all" link |
| `ObaListRow(title:, subtitle:, leading:, trailing:, onTap:, semanticLabel:)` | Any tappable row, read as one sentence. Text wraps, and the row is at least 48dp tall |
| `ObaStopRow(stop:, routes:)` | A stop with its route-type icon, code, direction and routes. Tapping it pushes `StopRoute` |
| `ObaRouteBadge` / `ObaRouteBadge.forRoute(route)` | Route short-name badge that grows with the text size and picks a readable text colour |
| `ObaRouteTypeIcon`, `routeTypeIconData`, `routeTypeLabel`, `stopDirectionLabel`, `prioritizedRouteType` | Mode icons and labels |
| `ObaLoadingState`, `ObaErrorState`, `ObaEmptyState` | States |
| `obaAnnounce(context, message)` | Polite screen-reader announcement, for example after a refresh |
| `oba_arrivals`: `ArrivalsController`, `ObaArrivalsPanel` | Reuse them for departures. Its `RouteBadge` also grows with the text size, but takes its colours from `ObaArrivalsTheme`; inside obakit screens use `ObaRouteBadge`, which reads `ObaTheme` and the reduced-colours setting |

### Adding strings

1. Append keys to `lib/src/l10n/app_en.arb`, prefixed with your area
   (`stop…`, `bookmarks…`, `settings…`, `search…`). Every key needs an
   `@key` entry with a `description`. Placeholders are typed, and counts use
   ICU plurals:
   ```json
   "stopDeparturesCount": "{count, plural, =0{No departures} =1{1 departure} other{{count} departures}}",
   "@stopDeparturesCount": {"description": "...", "placeholders": {"count": {"type": "int"}}}
   ```
2. Run `mise exec -- flutter gen-l10n` in `packages/obakit`, and commit
   `lib/src/l10n/generated/`.
3. Read strings with `context.obaL10n.stopDeparturesCount(n)`. No literal
   user-facing strings, including semantics labels and tooltips.

### Accessibility checklist (WCAG 2.1 AA, required)

- [ ] **Text:** every style comes from `Theme.of(context).textTheme`, with
  no `fontSize:` literals and no `MediaQuery.withNoTextScaling` or clamped
  text scalers. Rows have no fixed heights. At 200% text, layouts wrap or
  stack instead of truncating critical information such as the ETA, route
  or headsign.
- [ ] **Contrast:** text is at least 4.5:1, and large text, icons, outlines
  and focus rings are at least 3:1. Use `ObaTheme` and colour-scheme pairs.
  Use `ObaContrast.ensureReadable` for feed colours. Never convey status by
  colour alone: pair it with text or an icon ("3 min late").
- [ ] **Screen readers:** every control has a label (tooltips count).
  Custom-painted or icon-only elements have `Semantics`, and decorative
  icons are wrapped in `ExcludeSemantics`. A row reads as one sentence
  (`MergeSemantics`, or `ObaListRow(semanticLabel:)`), for example "Route
  10, Capitol Hill, 4 minutes, on time". Headings use
  `Semantics(header: true)` (`ObaSectionHeader` does this). Refreshed or
  changed data uses `Semantics(liveRegion: true)` or `obaAnnounce`. Focus
  order follows the visual order.
- [ ] **Targets and input:** tap targets are at least 48×48dp. Keyboard
  focus is visible (use Material buttons, `InkWell` or `FocusableActionDetector`).
  Everything works by keyboard or switch. No action needs a drag gesture
  only, so provide a button or semantic action as well.
- [ ] **Motion and display:** honour `MediaQuery.disableAnimationsOf`,
  `boldTextOf` and `highContrastOf` (`ObaTheme.of` already switches to
  high-contrast colours).
- [ ] **RTL:** use `EdgeInsetsDirectional`, `AlignmentDirectional` and
  `PositionedDirectional`.
- [ ] **Tests:** run `expectObaAccessibility(tester)` on every screen and
  `env.expectNoOverflowAtTextScale(tester, page)` (2× text) on every page.
  Test in light and dark.

### Writing a widget test

`test/support/oba_test_harness.dart` boots a real application over an
in-memory store, a `FakeLocationProvider` and a `MockClient` that answers
from fixtures. It selects Puget Sound and uses fake map tiles.

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'support/oba_test_harness.dart';

void main() {
  late ObaTestEnv env;
  setUp(() async => env = await ObaTestEnv.create(responses: {
    'arrivals-and-departures-for-stop': fixture('arrivals_live.json'),  // URL substring -> body
  }));
  tearDown(() => env.dispose());

  testWidgets('stop page', (tester) async {
    await env.pumpPage(tester, const StopPage(stopId: '1_75403'));   // full-screen page
    // presentation: ObaPresentation.sheet / .panel / .embedded to test other layouts
    // coordinator: ObaMapCoordinator() to assert map calls
    // onNavigate: (ctx, route) { pushed.add(route); return true; } to capture navigation
    expect(find.text('...'), findsOneWidget);
    await expectObaAccessibility(tester);
    await env.expectNoOverflowAtTextScale(tester, const StopPage(stopId: '1_75403'));
  });
}
```

Useful pieces: `fixture(name)` reads `test/fixtures/` in this package, then
`../onebusaway/test/fixtures/`. `env.requests` lists the HTTP calls made.
`env.location.setLocation(...)` moves the fake location, and
`env.location.activeSubscriptions` counts open position-stream
subscriptions (assert it drops to 0 when your widget is hidden).
`ObaTestEnv.create(permission:, location:, region:, storeValues:,
locationProvider:, darkTiles:)` sets up the starting state. `env.pumpApp(tester)` boots the whole `ObaApp`.
`ObaTestEnv.settle(tester)` settles animations, the map's 250 ms debounce
and HTTP. Put time-dependent tests under `withClock`.

## Development

```bash
cd packages/obakit
TZ=America/Los_Angeles mise exec -- flutter test
mise exec -- flutter analyze
mise exec -- dart format .
mise exec -- flutter gen-l10n   # after editing app_en.arb
```

## Differences from iOS

- The sheet is a custom Flutter widget with detents. The collapsed detent
  is measured from the top page's header, so it fits any text size. It is
  one sheet with a nested navigator, rather than iOS's base and stacked
  sheet layers.
- Map: flutter_map raster tiles instead of MapKit. The zoom threshold and
  the 250 ms debounce use the iOS values (map-rect height of 40,000 MapKit
  points). Stop clustering, under-pin labels and the scale bar are not
  drawn yet.
- Address search uses Nominatim by default instead of MapKit local search.
