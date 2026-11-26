import 'package:flutter/foundation.dart';

import 'package:flutter_map/flutter_map.dart' show TileProvider;
import 'package:obakit_core/obakit_core.dart' show MapType;

/// One raster tile source.
@immutable
class ObaTileSource {
  const ObaTileSource({
    required this.urlTemplate,
    required this.attribution,
    this.attributionUrl,
    this.maxNativeZoom = 19,
    this.subdomains = const [],
  });

  /// OpenStreetMap's public tiles. Their usage policy
  /// (https://operations.osmfoundation.org/policies/tiles/) allows light use
  /// only, with an identifying User-Agent; production apps should use their
  /// own provider.
  static const openStreetMap = ObaTileSource(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    attribution: 'OpenStreetMap contributors',
    attributionUrl: 'https://www.openstreetmap.org/copyright',
  );

  /// `{z}/{x}/{y}` template (`{s}` for [subdomains], `{r}` for retina).
  final String urlTemplate;

  /// Shown on the map as "© [attribution]". Required by most providers.
  final String attribution;

  /// Opened when the attribution is tapped.
  final String? attributionUrl;
  final int maxNativeZoom;
  final List<String> subdomains;
}

/// Map configuration for the SDK's map ([ObaMapView] and the shell).
@immutable
class ObaMapConfig {
  const ObaMapConfig({
    required this.userAgentPackageName,
    this.standard = ObaTileSource.openStreetMap,
    this.standardDark,
    this.satellite,
    this.hybridLabels,
    this.tileProvider,
    this.maxZoom = 19,
    this.minZoom = 3,
    this.maxStopMarkers = 300,
  });

  /// The host's application id (e.g. `edu.ucsd.studentlife`), sent in the
  /// tile request User-Agent.
  final String userAgentPackageName;

  /// The street map. Always available.
  final ObaTileSource standard;

  /// The street map in a dark theme (`Theme.of(context).brightness` is
  /// dark), with its own attribution. When null, [standard] is used in
  /// both themes.
  final ObaTileSource? standardDark;

  /// Imagery. When null, the satellite and hybrid map types are hidden.
  final ObaTileSource? satellite;

  /// Transparent labels drawn over [satellite] for the hybrid map type.
  /// When null (and [satellite] is set), hybrid is hidden.
  final ObaTileSource? hybridLabels;

  /// Replaces flutter_map's network tile provider (caching, or a fake in
  /// tests so no network is touched).
  final TileProvider? tileProvider;
  final double maxZoom;
  final double minZoom;

  /// The most stop pins drawn at once (the ones nearest the centre win).
  final int maxStopMarkers;

  bool get supportsSatellite => satellite != null;
  bool get supportsHybrid => satellite != null && hybridLabels != null;

  /// The street tiles for a theme brightness: [standardDark] in a dark
  /// theme when it is set, else [standard].
  ObaTileSource standardFor(Brightness brightness) =>
      brightness == Brightness.dark ? standardDark ?? standard : standard;

  /// The base tile source the map shows for [type] in a theme of
  /// [brightness] (its attribution is the one displayed). Map types that
  /// aren't configured fall back to the street tiles.
  ObaTileSource sourceFor(MapType type, Brightness brightness) =>
      switch (type) {
        MapType.satellite when satellite != null => satellite!,
        MapType.hybrid when supportsHybrid => satellite!,
        _ => standardFor(brightness),
      };

  /// Whether the street tiles shown for [type] and [brightness] are the
  /// dark ones (so the status bar over the map needs light icons).
  bool showsDarkStreetTiles(MapType type, Brightness brightness) =>
      standardDark != null &&
      brightness == Brightness.dark &&
      identical(sourceFor(type, brightness), standardDark);

  ObaMapConfig copyWith({TileProvider? tileProvider}) => ObaMapConfig(
    userAgentPackageName: userAgentPackageName,
    standard: standard,
    standardDark: standardDark,
    satellite: satellite,
    hybridLabels: hybridLabels,
    tileProvider: tileProvider ?? this.tileProvider,
    maxZoom: maxZoom,
    minZoom: minZoom,
    maxStopMarkers: maxStopMarkers,
  );
}
