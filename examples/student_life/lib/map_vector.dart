// Vector street tiles for the map (prototype). The SDK draws raster tiles
// by default; a host plugs in any flutter_map layer through
// ObaTileSource.custom. Here that layer is vector_map_tiles' VectorTileLayer
// over OpenFreeMap's styles, recoloured toward Student Life's palette.
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:obakit/obakit.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart'
    show ThemeReader;

/// OpenFreeMap's hosted styles: free, no API key, OpenMapTiles schema.
const openFreeMapPositron = 'https://tiles.openfreemap.org/styles/positron';
const openFreeMapDark = 'https://tiles.openfreemap.org/styles/dark';

/// The fills a [VectorPalette] repaints. Roads, rail, labels and
/// boundaries keep the base style's colours.
@immutable
class VectorPalette {
  const VectorPalette({
    required this.id,
    required this.background,
    required this.residential,
    required this.park,
    required this.water,
    required this.building,
  });

  /// Names the recoloured theme. vector_map_tiles caches rendered tiles by
  /// theme id, and OpenFreeMap's styles have none, so each palette must
  /// bring its own or the light and dark maps share cached tiles.
  final String id;
  final String background;
  final String residential;
  final String park;
  final String water;
  final String building;
}

/// Tapline's warm ground with teal-tinted water.
const studentLifeLightPalette = VectorPalette(
  id: 'studentlife-light',
  background: '#F4F1EA',
  residential: '#EEEAE1',
  park: '#DCE6D2',
  water: '#BCD9DD',
  building: '#E6E0D4',
);

/// A teal-black night map.
const studentLifeDarkPalette = VectorPalette(
  id: 'studentlife-dark',
  background: '#0F1A1D',
  residential: '#132226',
  park: '#14282A',
  water: '#0A3640',
  building: '#16221F',
);

/// [style] (a MapLibre style document) with its background and land and
/// water fills repainted from [palette]. Returns a new map; [style] is not
/// changed.
Map<String, dynamic> recolorStyle(
  Map<String, dynamic> style,
  VectorPalette palette,
) {
  String? colorFor(String id, String type) {
    if (type == 'background') return palette.background;
    if (type != 'fill') return null;
    if (id.contains('water')) return palette.water;
    if (id.contains('park') || id.contains('wood') || id.contains('grass')) {
      return palette.park;
    }
    if (id.contains('residential')) return palette.residential;
    if (id.contains('building')) return palette.building;
    if (id.contains('pier')) return palette.background;
    return null;
  }

  final copy = jsonDecode(jsonEncode(style)) as Map<String, dynamic>;
  copy['id'] = palette.id;
  for (final layer in (copy['layers'] as List).cast<Map<String, dynamic>>()) {
    final type = layer['type'] as String? ?? '';
    final color = colorFor(layer['id'] as String? ?? '', type);
    if (color == null) continue;
    final paint = (layer['paint'] as Map?)?.cast<String, dynamic>() ?? {};
    paint[type == 'background' ? 'background-color' : 'fill-color'] = color;
    layer['paint'] = paint;
  }
  return copy;
}

/// Loads the style at [styleUrl], recolours it with [palette], and returns
/// a base layer for the SDK's map. Throws when the style can't be loaded;
/// the caller falls back to raster tiles.
Future<ObaTileSource> loadVectorTiles({
  required String styleUrl,
  required VectorPalette palette,
  required ObaTileSource rasterFallback,
}) async {
  // StyleReader resolves the style's sources (TileJSON) and sprites.
  final style = await StyleReader(uri: styleUrl).read();
  // It doesn't expose the document itself, so read it again to recolour.
  final response = await http.get(Uri.parse(styleUrl));
  if (response.statusCode != 200) {
    throw http.ClientException(
      'style ${response.statusCode}',
      response.request?.url,
    );
  }
  final json = jsonDecode(response.body) as Map<String, dynamic>;
  final theme = ThemeReader().read(recolorStyle(json, palette));
  return ObaTileSource.custom(
    layerBuilder: (_) => VectorTileLayer(
      tileProviders: style.providers,
      theme: theme,
      sprites: style.sprites,
    ),
    attribution: 'OpenFreeMap, OpenMapTiles, OpenStreetMap contributors',
    attributionUrl: 'https://openfreemap.org',
    rasterFallback: rasterFallback,
  );
}
