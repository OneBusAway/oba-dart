import 'package:flutter_test/flutter_test.dart';
import 'package:tapline_example/map_vector.dart';

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
      {
        'id': 'landcover_wood',
        'type': 'fill',
        'paint': {'fill-color': '#ddd'},
      },
      {'id': 'landuse_park', 'type': 'fill'},
      {
        'id': 'landuse_residential',
        'type': 'fill',
        'paint': {'fill-color': '#eee'},
      },
      {
        'id': 'building',
        'type': 'fill',
        'paint': {'fill-color': '#eee'},
      },
      {
        'id': 'waterway',
        'type': 'line',
        'paint': {'line-color': '#abc'},
      },
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

  test('repaints background, land and water fills from the palette', () {
    final out = recolorStyle(style(), taplineLightPalette);
    expect(paint(out, 'background', 'background-color'), '#F4F1EA');
    expect(paint(out, 'water', 'fill-color'), taplineLightPalette.water);
    expect(
      paint(out, 'landcover_wood', 'fill-color'),
      taplineLightPalette.park,
    );
    expect(paint(out, 'landuse_park', 'fill-color'), taplineLightPalette.park);
    expect(
      paint(out, 'landuse_residential', 'fill-color'),
      taplineLightPalette.residential,
    );
    expect(paint(out, 'building', 'fill-color'), taplineLightPalette.building);
  });

  test('leaves lines alone and does not change its input', () {
    final input = style();
    final out = recolorStyle(input, taplineDarkPalette);
    expect(paint(out, 'waterway', 'line-color'), '#abc');
    expect(paint(out, 'highway_major_inner', 'line-color'), '#fff');
    expect(paint(input, 'water', 'fill-color'), '#ccc');
  });

  test('gives each palette its own theme id', () {
    // vector_map_tiles caches tiles by theme id; the styles have none.
    expect(recolorStyle(style(), taplineLightPalette)['id'], 'tapline-light');
    expect(recolorStyle(style(), taplineDarkPalette)['id'], 'tapline-dark');
  });
}
