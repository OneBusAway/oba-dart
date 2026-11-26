import 'package:http/http.dart' as http;
import 'package:obakit/obakit.dart';

import 'data/campus.dart';

/// The OneBusAway API key. Pass your own with
/// `--dart-define=OBA_API_KEY=...`.
const obaApiKey = String.fromEnvironment(
  'OBA_API_KEY',
  defaultValue: 'org.onebusaway.iphone',
);

/// The bundled-regions entry this campus app is pinned to.
const obaRegionName = 'San Diego';

/// Builds the app's one [ObaApplication].
///
/// - `regionsPath: null` plus a fixed region: no regions download, and the
///   rider never picks a region.
/// - [FixedLocationProvider] at the middle of campus: no location
///   permission prompt; "nearby" always means "near campus". A real app
///   would pass its own provider (or the SDK's default geolocator one).
///
/// [services] and [httpClient] let tests swap in an in-memory store and a
/// `MockClient`.
Future<ObaApplication> createObaApplication({
  ObaPlatformServices? services,
  ObaMapConfig? map,
  String? bundledRegionsJson,
  http.Client? httpClient,
}) async {
  final platform =
      services ??
      await ObaPlatformServices.defaults(
        locationProvider: FixedLocationProvider(CampusPlaces.campusCenter),
      );
  return ObaApplication.create(
    services: platform,
    map:
        map ??
        const ObaMapConfig(
          userAgentPackageName: 'org.onebusaway.examples.studentlife',
        ),
    config: (s) => ObaAppConfig(
      appName: 'Student Life',
      apiKey: obaApiKey,
      appVersion: '0.1.0',
      keyValueStore: s.keyValueStore,
      locationProvider: s.locationProvider,
      placeSearchProvider: s.placeSearchProvider,
      bundledRegionsJson: bundledRegionsJson,
      regionsPath: null,
      fixedRegion: const FixedRegionConfig(name: obaRegionName),
      httpClient: httpClient,
    ),
  );
}
