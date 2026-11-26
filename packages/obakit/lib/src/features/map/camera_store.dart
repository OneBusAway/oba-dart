import 'package:obakit_core/obakit_core.dart';

/// A saved camera position.
class SavedCamera {
  const SavedCamera({required this.center, required this.zoom, this.regionId});

  final Coordinate center;
  final double zoom;

  /// The region it was saved in; a camera from another region is ignored.
  final int? regionId;
}

/// Persists the map camera so the app reopens where the rider left it.
class MapCameraStore {
  const MapCameraStore(this.store);

  final KeyValueStore store;
  static const key = 'oba.map.lastCamera';

  SavedCamera? read() {
    final m = store.readMap(key);
    final lat = m['lat'], lon = m['lon'], zoom = m['zoom'];
    if (lat is! num || lon is! num || zoom is! num) return null;
    final region = m['regionId'];
    return SavedCamera(
      center: Coordinate(lat.toDouble(), lon.toDouble()),
      zoom: zoom.toDouble(),
      regionId: region is num ? region.toInt() : null,
    );
  }

  void write(SavedCamera camera) => store.writeJson(key, {
    'lat': camera.center.lat,
    'lon': camera.center.lon,
    'zoom': camera.zoom,
    'regionId': ?camera.regionId,
  });
}
