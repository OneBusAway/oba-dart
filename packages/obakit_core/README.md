# obakit_core

The app-level, non-UI logic of a OneBusAway app, in pure Dart. It is the
counterpart of iOS `OBAKitCore` (minus networking, which lives in
[`onebusaway`](../onebusaway)). The Flutter UI package (`obakit`) is built on
top of it and contains only widgets.

It has no Flutter dependency. Platform access (storage, location, push,
analytics, geocoding) goes through small interfaces that the host app
implements. Each interface ships with an in-memory or no-op implementation
for tests.

`package:obakit_core/obakit_core.dart` re-exports `package:onebusaway`.

## Install

Unreleased: the `0.1.0` tag predates this package. Pin a commit or a branch.

```yaml
dependencies:
  obakit_core:
    git:
      url: https://github.com/onebusaway/oba-dart.git
      path: packages/obakit_core
      ref: <commit SHA or branch>
```

Requires Dart 3.13.4 or later.

## What's inside

| Area | Main types | iOS source |
|---|---|---|
| Configuration | `ObaAppConfig`, `FixedRegionConfig`, `MoreTabConfig`, `DonationsConfig` | `CoreAppConfig`, `AppConfig`, `OBAKitConfig` Info.plist keys |
| Application | `ObaCoreApplication`, `RegionClients`, `FeatureStatus` | `CoreApplication`, `Application+FeatureAvailability` |
| Regions | `RegionsService` | `RegionsService` |
| User data | `UserDataStore`, `Bookmark`, `BookmarkGroup`, `TripBookmarkKey`, `StoredStop`, `StoredRoute`, `RecentStop`, `RecentPlace`, `StopPreferences`, `StoredAlarm` | `UserDataStore`, `Bookmark*`, `StopPreferences` |
| Settings | `ObaSettings`, `WalkingSpeedPreset`, `MapType`, `WalkingDirectionsProvider` | `UserDataStore` settings, `FeatureFlags`, map settings |
| Arrivals | `cleanArrivals`, `filterTerminalDuplicates`, `groupArrivalsByRoute`, `filterByArrivalDepartureFilter`, `ArrivalDepartureLogic` extension, `WalkTime`, `walkTimeDividerIndex` | `ArrivalDeparture+Deduplication`, `GroupedArrivalDeparture`, `WalkTimeInfo`, `StopPageListBuilder` |
| Geometry | `distanceBetween`, `nearestStops`, `nearest` | `Stop+Distance` |
| Formatting | `ObaFormatters`, `ObaCoreStrings`, `alarmLeadTimeChoices` | `Formatters`, `AlarmTimePickerManager` |
| Deep links | `DeepLinkRouter`, sealed `DeepLink`, `TripDeepLink` | `URLSchemeRouter`, `AppLinksRouter`, `ArrivalDepartureDeepLink` |
| Search | `SearchService`, `SearchRequest`, sealed `SearchResult` | `SearchManager`, `SearchRequest`, `Searchable` |
| Service alerts | `ServiceAlertTracker`, `AlertSeverity`, `alertsForStop`, `sortAlertsBySeverity` | `ServiceAlert`, `AgencyAlert.isHighSeverity` |
| Surveys | `SurveyService`, `ExternalSurveyUrlBuilder` | `SurveyService`, `ExternalSurveyURLBuilder` |
| Alarms and reports | `AlarmService`, `ProblemReportService` | `AlarmBuilder`, `AlarmRemover`, problem reporting |

## Wiring it up

```dart
final store = MySharedPreferencesStore();   // implements KeyValueStore
final app = ObaCoreApplication(
  ObaAppConfig(
    appName: 'OneBusAway',
    apiKey: 'org.onebusaway.iphone',
    appVersion: '1.0.0',
    bundledRegionsJson: myRegionsJson,          // an OBA envelope with data.list
    keyValueStore: store,
    locationProvider: MyGeolocatorProvider(),   // implements LocationProvider
    pushServiceProvider: null,                  // no alarms without one
    analytics: null,                            // NoopAnalytics is used
    placeSearchProvider: MyGeocoder(),          // address search; optional
  ),
);
await app.start();   // must finish before any service is used
```

`bundledRegionsJson` is the list used until a downloaded one is cached. In
Flutter, `obakit`'s `ObaApplication.create` supplies the SDK's bundled list
when you leave it out. Without obakit, pass the list, or pass
`ObaCoreApplication(config, bundledRegionsLoader: () async => ...)`, which
is called only when the config has none and nothing is cached.

A white-label app can instead build the config from an iOS-style
`OBAKitConfig` map with `ObaAppConfig.fromOBAKitConfig(map, ...)`. The keys
are the same as in the iOS `project.yml`: `RESTServerAPIKey`,
`RegionsServerBaseAddress`, `FixedRegionName`, `MoreTab`, and so on.

After `start()`:

- `app.regions`: the region list and the current region. If
  `needsRegionSelection` is true, show the picker.
- `app.restClient` / `app.obacoClient`: clients for the current region. They
  are rebuilt when the region changes; listen to `app.clientsListenable`.
  Read them on every use instead of caching them.
- `app.userData`, `app.settings`: persisted state.
- `app.search`, `app.alarms`, `app.problemReports`, `app.surveys`,
  `app.alerts`, `app.deepLinks`. `ObaFormatters` formats times, distances
  and labels (English by default; pass an `ObaCoreStrings` subclass to
  localise).
- Location is demand-driven (`app.locationService`). `start()` never
  subscribes to the provider's position stream. A consumer that needs live
  location calls `app.acquireLocation()` and gets a `LocationLease`; the
  stream is subscribed while at least one lease is held (and permission is
  granted) and cancelled when the last one is released. `app.currentLocation`
  (the last known fix) is readable without a lease.
  `app.requestLocationPermission()` asks once and takes one fix (which also
  drives automatic region selection). With automatic region selection on
  and no cached fix, `start()` takes one fix too; a fixed region takes none.
- Feature flags for the UI: `obacoStatus`, `pushStatus`, `deepLinkingStatus`,
  `tripPlanningStatus`, `alarmsAvailable`.

Call `app.dispose()` when you are done. It closes the HTTP client only if the
app created it.

### Change notification

There is one pattern throughout. Stateful objects extend `ObaChangeNotifier`,
a pure-Dart `ChangeNotifier`. Values that change on their own are exposed as
`ObaValueListenable<T>`. Their `addListener`/`removeListener` signatures
match Flutter's `Listenable`, so a Flutter adapter takes three lines:

```dart
class ObaListenableAdapter implements Listenable {
  ObaListenableAdapter(this.source);
  final ObaListenable source;
  @override void addListener(VoidCallback l) => source.addListener(l);
  @override void removeListener(VoidCallback l) => source.removeListener(l);
}
```

## Interfaces a host implements

| Interface | Purpose | In-memory implementation |
|---|---|---|
| `KeyValueStore` | String storage (`shared_preferences`). `load()` is awaited once, after which reads are synchronous. obakit_core writes JSON strings under keys that start with `oba.` | `InMemoryKeyValueStore` |
| `LocationProvider` | Permission, current position, position stream, last known fix | `FakeLocationProvider` (tests; counts `activeSubscriptions`). For hosts: `FixedLocationProvider(coordinate)` (always reports one point, permission granted, no prompt) and `NoLocationProvider` (no location at all; `app.isLocationAvailable` is false and screens say location isn't used) |
| `PushServiceProvider` (optional) | Push availability, permission, token | `FakePushServiceProvider` |
| `ObaAnalytics` (optional) | Events, search queries, stop views, region, user properties, errors | `NoopAnalytics` |
| `PlaceSearchProvider` (optional) | Address and point-of-interest search | none |

## Notes

- Time-dependent logic reads `package:clock` and takes `now` as a parameter,
  so tests can control time with `withClock` or `fake_async`. Pass the arrivals
  controller's server-corrected time where you have it.
- ETA flooring in `ArrivalDepartureLogic.minutesUntil` duplicates a few lines
  of `oba_arrivals`, because this pure-Dart package cannot depend on a Flutter
  package. Unlike `oba_arrivals`, it follows iOS: at a trip's first stop it
  uses the departure time.
- Regions, bookmarks and the other persisted models read their JSON
  tolerantly. A malformed entry is skipped instead of failing the whole list.

## Development

```bash
mise exec -- dart test
mise exec -- dart analyze
mise exec -- dart format .
```

Tests read fixtures from `test/fixtures/` (copied from
`../../ios/OBAKitTests/fixtures`). When a file isn't there, they fall back to
`../onebusaway/test/fixtures/`.
