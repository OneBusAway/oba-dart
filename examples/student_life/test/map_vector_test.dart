import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:student_life_example/map_vector.dart';
import 'package:student_life_example/oba_setup.dart';

void main() {
  Map<String, dynamic> style() => {
    'version': 8,
    'layers': [
      {
        'id': 'background',
        'type': 'background',
        'paint': {'background-color': '#fff'},
      },
      {
        'id': 'water',
        'type': 'fill',
        'paint': {'fill-color': '#ccc'},
      },
      {'id': 'landuse_park', 'type': 'fill'},
      {
        'id': 'highway_major_inner',
        'type': 'line',
        'paint': {'line-color': '#fff'},
      },
    ],
  };

  Object? paint(Map<String, dynamic> s, String id, String key) =>
      ((s['layers'] as List).firstWhere((l) => l['id'] == id)
          as Map)['paint']?[key];

  test('repaints fills from the Student Life palettes, not lines', () {
    final light = recolorStyle(style(), studentLifeLightPalette);
    expect(
      paint(light, 'background', 'background-color'),
      studentLifeLightPalette.background,
    );
    expect(paint(light, 'water', 'fill-color'), studentLifeLightPalette.water);
    expect(
      paint(light, 'landuse_park', 'fill-color'),
      studentLifeLightPalette.park,
    );
    expect(paint(light, 'highway_major_inner', 'line-color'), '#fff');
    // Each palette caches its tiles under its own theme id.
    expect(light['id'], 'student-life-light');
    expect(
      recolorStyle(style(), studentLifeDarkPalette)['id'],
      'student-life-dark',
    );
  });

  group('studentLifeMapConfig', () {
    final vector = ObaTileSource.custom(
      layerBuilder: (_) => throw UnimplementedError(),
      attribution: 'test',
      attributionUrl: 'https://example.com',
      rasterFallback: ObaTileSource.openStreetMap,
    );

    test('uses OpenFreeMap vector tiles, light and dark', () async {
      final urls = <String>[];
      final config = await studentLifeMapConfig(
        loadVector: (url, palette) async {
          urls.add(url);
          return vector;
        },
      );
      expect(urls, [openFreeMapPositron, openFreeMapDark]);
      expect(config.standard, same(vector));
      expect(config.standardDark, same(vector));
      expect(
        config.userAgentPackageName,
        'org.onebusaway.examples.studentlife',
      );
    });

    test('falls back to the SDK raster tiles when the styles fail', () async {
      final config = await studentLifeMapConfig(
        loadVector: (_, _) async => throw Exception('offline'),
      );
      expect(config.standard, same(ObaTileSource.openStreetMap));
      expect(config.standardDark, isNull);
    });

    test('falls back when the styles take too long', () async {
      final config = await studentLifeMapConfig(
        loadVector: (_, _) => Completer<ObaTileSource>().future,
        timeout: Duration.zero,
      );
      expect(config.standard, same(ObaTileSource.openStreetMap));
    });

    test('raster mode skips the vector styles', () async {
      final config = await studentLifeMapConfig(
        mode: 'raster',
        loadVector: (_, _) => fail('should not load vector styles'),
      );
      expect(config.standard, same(ObaTileSource.openStreetMap));
      expect(config.standardDark, isNull);
    });
  });
}
