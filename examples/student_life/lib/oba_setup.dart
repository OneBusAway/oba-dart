import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:obakit/obakit.dart';

import 'data/campus.dart';
import 'map_vector.dart';

/// The OneBusAway API key. Pass your own with
/// `--dart-define=OBA_API_KEY=...`.
const obaApiKey = String.fromEnvironment(
  'OBA_API_KEY',
  defaultValue: 'org.onebusaway.iphone',
);

/// The bundled-regions entry this campus app is pinned to.
const obaRegionName = 'San Diego';

/// `--dart-define=STUDENT_LIFE_MAP=raster` keeps the SDK's default raster
/// tiles (OpenStreetMap). The default tries vector tiles and falls back to
/// those raster tiles when the styles can't be loaded.
const studentLifeMapMode = String.fromEnvironment(
  'STUDENT_LIFE_MAP',
  defaultValue: 'vector',
);

const _userAgentPackageName = 'org.onebusaway.examples.studentlife';

/// The map's street tiles: OpenFreeMap vector tiles (free, no API key) in
/// Student Life's light and dark palettes, or the SDK's default raster
/// tiles in `raster` [mode] or when the styles don't load within
/// [timeout]. [loadVector] lets tests stand in for the network.
Future<ObaMapConfig> studentLifeMapConfig({
  String mode = studentLifeMapMode,
  Duration timeout = const Duration(seconds: 5),
  Future<ObaTileSource> Function(String styleUrl, VectorPalette palette)?
  loadVector,
}) async {
  var standard = ObaTileSource.openStreetMap;
  ObaTileSource? standardDark;
  if (mode == 'vector') {
    final load =
        loadVector ??
        (url, palette) => loadVectorTiles(
          styleUrl: url,
          palette: palette,
          rasterFallback: ObaTileSource.openStreetMap,
        );
    try {
      final loaded = await Future.wait([
        load(openFreeMapPositron, studentLifeLightPalette),
        load(openFreeMapDark, studentLifeDarkPalette),
      ]).timeout(timeout);
      standard = loaded[0];
      standardDark = loaded[1];
    } on Object catch (error) {
      debugPrint('Vector tiles unavailable ($error); using raster tiles.');
    }
  }
  return ObaMapConfig(
    userAgentPackageName: _userAgentPackageName,
    standard: standard,
    standardDark: standardDark,
  );
}

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
    map: map ?? const ObaMapConfig(userAgentPackageName: _userAgentPackageName),
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
