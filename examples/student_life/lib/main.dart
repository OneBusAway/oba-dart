import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import 'app.dart';
import 'map_vector.dart';
import 'oba_setup.dart';
import 'settings.dart';

/// `--dart-define=STUDENT_LIFE_MAP=raster` keeps the SDK's default raster
/// tiles (OpenStreetMap). The default tries vector tiles and falls back
/// to those raster tiles when the styles can't be loaded.
const _mapStyle = String.fromEnvironment(
  'STUDENT_LIFE_MAP',
  defaultValue: 'vector',
);

Future<ObaMapConfig> _mapConfig() async {
  var standard = ObaTileSource.openStreetMap;
  ObaTileSource? standardDark;
  if (_mapStyle == 'vector') {
    try {
      final loaded = await Future.wait([
        loadVectorTiles(
          styleUrl: openFreeMapPositron,
          palette: studentLifeLightPalette,
          rasterFallback: ObaTileSource.openStreetMap,
        ),
        loadVectorTiles(
          styleUrl: openFreeMapDark,
          palette: studentLifeDarkPalette,
          rasterFallback: ObaTileSource.openStreetMap,
        ),
      ]).timeout(const Duration(seconds: 5));
      standard = loaded[0];
      standardDark = loaded[1];
    } on Object catch (error) {
      debugPrint('Vector tiles unavailable ($error); using raster tiles.');
    }
  }
  return ObaMapConfig(
    userAgentPackageName: 'org.onebusaway.examples.studentlife',
    standard: standard,
    standardDark: standardDark,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final oba = await createObaApplication(map: await _mapConfig());
  runApp(StudentLifeApp(oba: oba, settings: StudentLifeSettings()));
}
