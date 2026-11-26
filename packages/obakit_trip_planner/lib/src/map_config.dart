import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart' show TileProvider;

/// Map tile configuration for the itinerary map.
///
/// The default uses OpenStreetMap's public tile server, which requires an
/// identifying User-Agent ([userAgentPackageName]) and is meant for light
/// use only; see https://operations.osmfoundation.org/policies/tiles/. Apps
/// with real traffic should point [tileUrlTemplate] at their own provider.
@immutable
class TripMapConfig {
  const TripMapConfig({
    required this.userAgentPackageName,
    this.tileUrlTemplate = openStreetMapTemplate,
    this.attribution = openStreetMapAttribution,
    this.onAttributionTap,
    this.maxZoom = 19,
    this.tileProvider,
    this.subdomains = const [],
    this.retinaMode = false,
  });

  static const openStreetMapTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const openStreetMapAttribution = 'OpenStreetMap contributors';

  /// The host's application id (e.g. `edu.ucsd.studentlife`), sent in the
  /// tile request User-Agent.
  final String userAgentPackageName;
  final String tileUrlTemplate;

  /// Shown on the map as "© [attribution]".
  final String attribution;

  /// E.g. open https://www.openstreetmap.org/copyright. Null makes the
  /// attribution non-interactive.
  final VoidCallback? onAttributionTap;
  final double maxZoom;

  /// Overrides flutter_map's network tile provider (caching, tests).
  final TileProvider? tileProvider;

  /// Values for the `{s}` placeholder in [tileUrlTemplate].
  final List<String> subdomains;

  /// Request high-density (`{r}` = `@2x`) tiles. The host decides, from
  /// the screen density and whether its provider serves them.
  final bool retinaMode;
}
