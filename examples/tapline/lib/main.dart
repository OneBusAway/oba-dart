import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import 'app.dart';
import 'data/wallet.dart';
import 'map_tiles.dart';

/// `--dart-define=OBA_API_KEY=...`; defaults to the public test key.
const _apiKey = String.fromEnvironment(
  'OBA_API_KEY',
  defaultValue: 'org.onebusaway.iphone',
);

/// Near UC San Diego, so the live departures are interesting.
const _riderLocation = Coordinate(32.8801, -117.2340);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // One OneBusAway application for the whole app. A fixed location and a
  // fixed region: no location prompt and no regions download.
  final oba = await ObaApplication.create(
    map: const ObaMapConfig(
      userAgentPackageName: 'org.onebusaway.examples.tapline',
      standard: cartoVoyager,
      standardDark: cartoDarkMatter,
    ),
    services: ObaPlatformServices(
      keyValueStore: await SharedPreferencesKeyValueStore.create(),
      locationProvider: FixedLocationProvider(_riderLocation),
      // Address search for the trip planner (read-only geocoding).
      placeSearchProvider: NominatimPlaceSearch(
        userAgent: 'Tapline/0.1 (org.onebusaway.examples.tapline)',
      ),
    ),
    config: (services) => ObaAppConfig(
      appName: 'Tapline',
      apiKey: _apiKey,
      appVersion: '0.1.0',
      keyValueStore: services.keyValueStore,
      locationProvider: services.locationProvider,
      placeSearchProvider: services.placeSearchProvider,
      regionsPath: null,
      fixedRegion: const FixedRegionConfig(name: 'San Diego'),
    ),
  );

  runApp(TaplineApp(application: oba, wallet: Wallet.sample()));
}
