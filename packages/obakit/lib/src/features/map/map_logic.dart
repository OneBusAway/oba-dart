import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:obakit_core/obakit_core.dart';

/// Pure map rules shared by the map view, the shell and tests.
abstract final class ObaMapLogic {
  /// MapKit's world size in map points (`MKMapSize.world`), so thresholds
  /// can be copied from iOS unchanged.
  static const double mapKitWorldSize = 268435456; // 2^28

  /// Above this visible height (MapKit map points) stops are not loaded and
  /// the "Zoom in to see stops" pill shows (iOS
  /// `MapRegionManager.requiredHeightToShowStops`).
  static const double requiredHeightToShowStops = 40000;

  /// Above this visible height pins lose their labels (iOS
  /// `requiredHeightToShowExtraStopData`).
  static const double requiredHeightToShowStopLabels = 5000;

  /// How long the camera must rest before stops load (iOS
  /// `stopsRequestDebounceInterval`).
  static const Duration stopsRequestDebounce = Duration(milliseconds: 250);

  /// Zoom used to focus one stop (iOS centres stops at zoom level 18; a
  /// little less leaves room for its neighbours over a half-height sheet).
  static const double focusStopZoom = 17;

  /// Zoom used by "Show my location" (iOS uses 16).
  static const double userLocationZoom = 16;

  /// Below this zoom, a page's own stops (route, trip) draw as dots.
  static const double compactOverlayStopsBelowZoom = 15;

  /// Web Mercator y of [lat], 0 at the top of the world and 1 at the
  /// bottom.
  static double mercatorY(double lat) {
    final clamped = lat.clamp(-85.05112878, 85.05112878);
    final rad = clamped * math.pi / 180;
    return 0.5 - math.log(math.tan(math.pi / 4 + rad / 2)) / (2 * math.pi);
  }

  /// The height of [bounds] in MapKit map points (`MKMapRect.height`).
  static double visibleMapRectHeight(RegionRect bounds) =>
      (mercatorY(bounds.minLat) - mercatorY(bounds.maxLat)).abs() *
      mapKitWorldSize;

  /// Whether stops load for a camera showing [bounds].
  static bool shouldLoadStops(RegionRect bounds) =>
      visibleMapRectHeight(bounds) <= requiredHeightToShowStops;

  static bool shouldShowStopLabels(RegionRect bounds) =>
      visibleMapRectHeight(bounds) <= requiredHeightToShowStopLabels;

  /// The `stops-for-location` request for [bounds], or null when zoomed out
  /// too far.
  static StopsRequest? stopsRequestFor(RegionRect bounds) {
    if (!shouldLoadStops(bounds)) return null;
    return StopsRequest(
      center: bounds.center,
      latSpan: (bounds.maxLat - bounds.minLat).abs(),
      lonSpan: (bounds.maxLon - bounds.minLon).abs(),
    );
  }

  /// Whether [previous] already covers [bounds] well enough to skip a new
  /// request: the new area lies inside the old one and is not much smaller
  /// (zooming in a lot asks again, because the server caps results).
  static bool requestCovers(StopsRequest previous, RegionRect bounds) {
    final p = previous.rect;
    final inside =
        bounds.minLat >= p.minLat &&
        bounds.maxLat <= p.maxLat &&
        bounds.minLon >= p.minLon &&
        bounds.maxLon <= p.maxLon;
    final latSpan = (bounds.maxLat - bounds.minLat).abs();
    return inside && latSpan >= previous.latSpan * 0.5;
  }

  /// At most [max] stops, nearest to [center] first, restricted to
  /// [within] when given.
  static List<Stop> capStops(
    Iterable<Stop> stops, {
    required Coordinate center,
    required int max,
    RegionRect? within,
  }) {
    final candidates = [
      for (final s in stops)
        if (within == null || within.contains(s.lat, s.lon)) s,
    ];
    double d(Stop s) {
      final dy = s.lat - center.lat;
      final dx = (s.lon - center.lon) * math.cos(center.lat * math.pi / 180);
      return dx * dx + dy * dy;
    }

    // Always nearest first: the accessible "Stops on the map" list reads
    // in this order.
    candidates.sort((a, b) => d(a).compareTo(d(b)));
    return candidates.length <= max ? candidates : candidates.sublist(0, max);
  }

  /// Grows [r] by [factor] of its size on every side.
  static RegionRect inflate(RegionRect r, double factor) {
    final dLat = (r.maxLat - r.minLat) * factor;
    final dLon = (r.maxLon - r.minLon) * factor;
    return RegionRect(
      minLat: r.minLat - dLat,
      maxLat: r.maxLat + dLat,
      minLon: r.minLon - dLon,
      maxLon: r.maxLon + dLon,
    );
  }

  /// The smallest rect containing [points], or null when empty.
  static RegionRect? boundsOf(Iterable<Coordinate> points) {
    double? minLat, maxLat, minLon, maxLon;
    for (final p in points) {
      minLat = minLat == null ? p.lat : math.min(minLat, p.lat);
      maxLat = maxLat == null ? p.lat : math.max(maxLat, p.lat);
      minLon = minLon == null ? p.lon : math.min(minLon, p.lon);
      maxLon = maxLon == null ? p.lon : math.max(maxLon, p.lon);
    }
    if (minLat == null) return null;
    return RegionRect(
      minLat: minLat,
      maxLat: maxLat!,
      minLon: minLon!,
      maxLon: maxLon!,
    );
  }

  /// Compares two id sets.
  static StopDiff diff(Iterable<String> previous, Iterable<String> next) {
    final before = previous.toSet();
    final after = next.toSet();
    return StopDiff(
      added: after.difference(before),
      removed: before.difference(after),
      kept: after.intersection(before),
    );
  }
}

/// A `stops-for-location` query.
@immutable
class StopsRequest {
  const StopsRequest({
    required this.center,
    required this.latSpan,
    required this.lonSpan,
  });

  final Coordinate center;
  final double latSpan;
  final double lonSpan;

  RegionRect get rect => RegionRect(
    minLat: center.lat - latSpan / 2,
    maxLat: center.lat + latSpan / 2,
    minLon: center.lon - lonSpan / 2,
    maxLon: center.lon + lonSpan / 2,
  );

  @override
  bool operator ==(Object other) =>
      other is StopsRequest &&
      other.center == center &&
      other.latSpan == latSpan &&
      other.lonSpan == lonSpan;

  @override
  int get hashCode => Object.hash(center, latSpan, lonSpan);
}

@immutable
class StopDiff {
  const StopDiff({
    required this.added,
    required this.removed,
    required this.kept,
  });

  final Set<String> added;
  final Set<String> removed;
  final Set<String> kept;

  bool get isEmpty => added.isEmpty && removed.isEmpty;
}

/// What a stop pin looks like. Two equal specs draw the same pin, so the
/// marker can be reused.
@immutable
class StopMarkerSpec {
  const StopMarkerSpec({
    required this.stop,
    required this.routeType,
    this.isBookmarked = false,
    this.isSelected = false,
    this.showsLabel = false,
    this.compact = false,
  });

  final Stop stop;

  /// Drawn as a small dot: a route or trip's own stops when zoomed out,
  /// so dozens of them don't pile up over the line. Still a full-size,
  /// labelled tap target.
  final bool compact;
  final RouteType routeType;
  final bool isBookmarked;
  final bool isSelected;
  final bool showsLabel;

  String get id => stop.id;

  @override
  bool operator ==(Object other) =>
      other is StopMarkerSpec &&
      other.stop.id == stop.id &&
      other.stop.lat == stop.lat &&
      other.stop.lon == stop.lon &&
      other.stop.name == stop.name &&
      other.stop.direction == stop.direction &&
      other.routeType == routeType &&
      other.isBookmarked == isBookmarked &&
      other.isSelected == isSelected &&
      other.showsLabel == showsLabel &&
      other.compact == compact;

  @override
  int get hashCode => Object.hash(
    stop.id,
    stop.lat,
    stop.lon,
    stop.direction,
    routeType,
    isBookmarked,
    isSelected,
    showsLabel,
    compact,
  );
}

/// Builds markers only for stops whose [StopMarkerSpec] changed, reusing
/// the rest. The map rebuilds its pins when stops, bookmarks or the
/// selection change, never on camera movement.
class StopMarkerCache<T> {
  final Map<String, (StopMarkerSpec, T)> _entries = {};

  /// How many markers [update] has built in total (for tests).
  int buildCount = 0;

  /// Markers for [specs], in order.
  List<T> update(
    Iterable<StopMarkerSpec> specs,
    T Function(StopMarkerSpec) build,
  ) {
    final out = <T>[];
    final seen = <String>{};
    for (final spec in specs) {
      if (!seen.add(spec.id)) continue;
      final existing = _entries[spec.id];
      if (existing != null && existing.$1 == spec) {
        out.add(existing.$2);
        continue;
      }
      final built = build(spec);
      buildCount++;
      _entries[spec.id] = (spec, built);
      out.add(built);
    }
    _entries.removeWhere((id, _) => !seen.contains(id));
    return out;
  }

  void clear() => _entries.clear();
}
