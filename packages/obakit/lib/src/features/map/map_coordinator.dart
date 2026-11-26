import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as core show Route;

import '../../widgets/frame.dart';
import 'map_logic.dart';

/// A line on the map (a route shape, a trip, an itinerary leg).
@immutable
class ObaMapPolyline {
  const ObaMapPolyline({
    required this.points,
    this.color,
    this.width,
    this.dashed = false,
  });

  /// From an encoded polyline (OBA shapes).
  factory ObaMapPolyline.encoded(
    String encoded, {
    Color? color,
    double? width,
    bool dashed = false,
  }) => ObaMapPolyline(
    points: Polyline.decode(encoded),
    color: color,
    width: width,
    dashed: dashed,
  );

  final List<Coordinate> points;

  /// Null uses `ObaTheme.routeLine`.
  final Color? color;
  final double? width;

  /// Dashed lines are for walking legs.
  final bool dashed;
}

enum ObaMapMarkerKind { place, origin, destination, vehicle, generic }

/// A point marker. Every marker has a screen reader [label].
@immutable
class ObaMapMarker {
  const ObaMapMarker({
    required this.coordinate,
    required this.label,
    this.kind = ObaMapMarkerKind.generic,
    this.heading,
    this.color,
    this.onTap,
  });

  final Coordinate coordinate;
  final String label;
  final ObaMapMarkerKind kind;

  /// Degrees clockwise from north (vehicles).
  final double? heading;
  final Color? color;
  final VoidCallback? onTap;
}

/// What a page draws on the map while it is the top page.
@immutable
class ObaMapOverlay {
  const ObaMapOverlay({
    this.polylines = const [],
    this.markers = const [],
    this.stops = const [],
    this.hideStopPins = false,
    this.fitBounds,
  });

  static const empty = ObaMapOverlay();

  final List<ObaMapPolyline> polylines;
  final List<ObaMapMarker> markers;

  /// Stops to show emphasised (always drawn, even when zoomed out).
  final List<Stop> stops;

  /// Hide the regular nearby-stop pins while this overlay shows.
  final bool hideStopPins;

  /// Where to move the camera when the overlay is applied.
  final RegionRect? fitBounds;

  bool get isEmpty =>
      polylines.isEmpty && markers.isEmpty && stops.isEmpty && !hideStopPins;
}

/// What the map view implements so the coordinator can move it.
abstract interface class ObaMapCameraDelegate {
  void moveTo(Coordinate center, {double? zoom});
  void fitBounds(RegionRect bounds);
}

/// Lets screens drive the map without owning it. The shell creates one and
/// shares it with the map and every sheet page; an `ObaMapView` a host
/// embeds can take one too.
///
/// Screens must treat it as optional: [maybeOf] returns null when the page
/// is shown without a map (a host navigator, a card), and every call then
/// simply does nothing.
///
/// ```dart
/// ObaMapCoordinator.maybeOf(context)?.focusStop(stop);
/// ```
///
/// For overlays tied to a page's lifetime, prefer the declarative
/// `ObaMapOverlays` widget: the overlay shows while that page is on top and
/// comes back when the rider pops back to it.
class ObaMapCoordinator extends ChangeNotifier {
  ObaMapCoordinator();

  /// The coordinator for [context], or null (no map on screen).
  static ObaMapCoordinator? maybeOf(BuildContext context) => context
      .getInheritedWidgetOfExactType<ObaMapCoordinatorScope>()
      ?.coordinator;

  ObaMapCameraDelegate? _delegate;
  void Function(ObaMapCameraDelegate)? _pending;

  // -- Camera state (written by the map view) ---------------------------------

  Coordinate? _center;
  double? _zoom;
  RegionRect? _visibleBounds;

  /// The camera centre, once the map has laid out.
  Coordinate? get center => _center;
  double? get zoom => _zoom;
  RegionRect? get visibleBounds => _visibleBounds;

  /// Called by the map view on camera changes. Does not notify (camera
  /// ticks are frequent); listen to [cameraIdle] for settled positions.
  void updateCamera({
    required Coordinate center,
    required double zoom,
    required RegionRect visibleBounds,
  }) {
    _center = center;
    _zoom = zoom;
    _visibleBounds = visibleBounds;
  }

  /// Notifies when the camera has settled (debounced by the map view).
  final ValueNotifier<RegionRect?> cameraIdle = ValueNotifier(null);

  // -- Commands ---------------------------------------------------------------

  /// Called by the map view.
  void attach(ObaMapCameraDelegate delegate) {
    _delegate = delegate;
    final pending = _pending;
    _pending = null;
    pending?.call(delegate);
  }

  void detach(ObaMapCameraDelegate delegate) {
    if (identical(_delegate, delegate)) _delegate = null;
  }

  bool get isAttached => _delegate != null;

  void _run(void Function(ObaMapCameraDelegate) command) {
    final d = _delegate;
    if (d == null) {
      _pending = command;
    } else {
      command(d);
    }
  }

  /// Centres the visible map area (above the sheet) on [center].
  void moveTo(Coordinate center, {double? zoom}) =>
      _run((d) => d.moveTo(center, zoom: zoom));

  void fitBounds(RegionRect bounds) => _run((d) => d.fitBounds(bounds));

  // -- Selection --------------------------------------------------------------

  String? _selectedStopId;

  /// The highlighted stop pin.
  String? get selectedStopId => _selectedStopId;

  void selectStop(String? stopId) {
    if (stopId == _selectedStopId) return;
    _selectedStopId = stopId;
    notifyListeners();
  }

  /// Selects [stop] and centres on it.
  void focusStop(Stop stop, {double zoom = ObaMapLogic.focusStopZoom}) {
    selectStop(stop.id);
    moveTo(stop.coordinate, zoom: zoom);
  }

  // -- Overlays ---------------------------------------------------------------

  final Map<Object, ObaMapOverlay> _overlays = {};
  final List<Object> _order = [];
  Object? _activeOwner;
  bool _tracksActiveOwner = false;

  /// The overlay the map draws: the active owner's when the shell tracks
  /// the top page, otherwise the most recently set one.
  ObaMapOverlay get overlay {
    if (_tracksActiveOwner) {
      return _overlays[_activeOwner] ?? ObaMapOverlay.empty;
    }
    return _order.isEmpty ? ObaMapOverlay.empty : _overlays[_order.last]!;
  }

  /// The shell calls this with the top sheet route whenever it changes, so
  /// only the top page's overlay shows. Re-shows (and re-fits) that page's
  /// overlay when the rider pops back to it.
  void setActiveOwner(Object? owner) {
    _tracksActiveOwner = true;
    if (identical(owner, _activeOwner)) return;
    _activeOwner = owner;
    final o = _overlays[owner];
    if (o?.fitBounds != null) fitBounds(o!.fitBounds!);
    notifyListeners();
  }

  /// The owner imperative calls use: the active page when tracked.
  Object get _imperativeOwner => _activeOwner ?? this;

  /// Sets [owner]'s overlay (usually a `ModalRoute`).
  ///
  /// The camera fits [ObaMapOverlay.fitBounds] only when it differs from
  /// the owner's previous overlay, so a page that refreshes its overlay
  /// (new vehicle positions every 30 s) doesn't keep pulling the camera
  /// back while the rider pans.
  void setOverlay(Object owner, ObaMapOverlay overlay, {bool fit = true}) {
    final previous = _overlays[owner]?.fitBounds;
    _overlays[owner] = overlay;
    _order
      ..remove(owner)
      ..add(owner);
    final visible = !_tracksActiveOwner || identical(owner, _activeOwner);
    final bounds = overlay.fitBounds;
    if (fit && visible && bounds != null && !_sameRect(previous, bounds)) {
      fitBounds(bounds);
    }
    notifyListeners();
  }

  static bool _sameRect(RegionRect? a, RegionRect b) =>
      a != null &&
      a.minLat == b.minLat &&
      a.maxLat == b.maxLat &&
      a.minLon == b.minLon &&
      a.maxLon == b.maxLon;

  void removeOverlay(Object owner) {
    if (_overlays.remove(owner) == null) return;
    _order.remove(owner);
    notifyListeners();
  }

  /// Removes the current page's overlay.
  void clearOverlays() => removeOverlay(_imperativeOwner);

  /// Draws a route's shapes and stops and fits them.
  void showRoute({
    required List<ObaMapPolyline> shapes,
    List<Stop> stops = const [],
  }) {
    setOverlay(
      _imperativeOwner,
      ObaMapOverlay(
        polylines: shapes,
        stops: stops,
        hideStopPins: true,
        fitBounds: ObaMapLogic.boundsOf([
          for (final s in shapes) ...s.points,
          for (final s in stops) s.coordinate,
        ]),
      ),
    );
  }

  /// Draws a trip's shape, its stops and the vehicle.
  void showTrip({
    required ObaMapPolyline shape,
    Coordinate? vehiclePosition,
    double? vehicleHeading,
    String? vehicleLabel,
    List<Stop> stops = const [],
  }) {
    setOverlay(
      _imperativeOwner,
      ObaMapOverlay(
        polylines: [shape],
        stops: stops,
        hideStopPins: true,
        markers: [
          if (vehiclePosition != null)
            ObaMapMarker(
              coordinate: vehiclePosition,
              // Empty: the marker reads the localized "Vehicle".
              label: vehicleLabel ?? '',
              kind: ObaMapMarkerKind.vehicle,
              heading: vehicleHeading,
            ),
        ],
        fitBounds: ObaMapLogic.boundsOf([...shape.points, ?vehiclePosition]),
      ),
    );
  }

  /// Draws a planned itinerary (legs plus origin/destination markers).
  void showItinerary({
    required List<ObaMapPolyline> legs,
    List<ObaMapMarker> markers = const [],
  }) {
    setOverlay(
      _imperativeOwner,
      ObaMapOverlay(
        polylines: legs,
        markers: markers,
        hideStopPins: true,
        fitBounds: ObaMapLogic.boundsOf([
          for (final l in legs) ...l.points,
          for (final m in markers) m.coordinate,
        ]),
      ),
    );
  }

  /// Drops a marker for a place and centres on it.
  void showPlace(ObaMapMarker marker) {
    setOverlay(_imperativeOwner, ObaMapOverlay(markers: [marker]), fit: false);
    moveTo(marker.coordinate, zoom: ObaMapLogic.focusStopZoom - 1);
  }

  // -- Visible stops (the accessible alternative to the pins) -------------------

  List<Stop> _visibleStops = const [];
  Map<String, core.Route> _routes = const {};

  /// The stops whose pins are on the map now.
  List<Stop> get visibleStops => _visibleStops;

  /// Routes referenced by [visibleStops], by id.
  Map<String, core.Route> get routes => _routes;

  /// Called by the map view.
  void updateVisibleStops(List<Stop> stops, Map<String, core.Route> routes) {
    _visibleStops = List.unmodifiable(stops);
    _routes = routes;
    notifyListeners();
  }

  bool _disposed = false;
  bool _notifyScheduled = false;

  /// Defers notifications raised while the tree is building or being torn
  /// down (a page's overlay removed in `dispose`) to the end of the frame.
  @override
  void notifyListeners() {
    if (_disposed) return;
    if (obaIsMidFrame) {
      if (_notifyScheduled) return;
      _notifyScheduled = true;
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _notifyScheduled = false;
        if (!_disposed) super.notifyListeners();
      });
      return;
    }
    super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    cameraIdle.dispose();
    super.dispose();
  }
}

/// Makes an [ObaMapCoordinator] available to the subtree.
class ObaMapCoordinatorScope extends InheritedWidget {
  const ObaMapCoordinatorScope({
    super.key,
    required this.coordinator,
    required super.child,
  });

  final ObaMapCoordinator coordinator;

  @override
  bool updateShouldNotify(ObaMapCoordinatorScope old) =>
      !identical(old.coordinator, coordinator);
}

/// Shows [overlay] on the map while the enclosing page is the top page.
/// Does nothing when there is no map (no coordinator), so pages can use it
/// unconditionally.
///
/// ```dart
/// ObaMapOverlays(
///   overlay: ObaMapOverlay(polylines: [shape], stops: stops, fitBounds: b),
///   child: ObaSheetPage(...),
/// )
/// ```
class ObaMapOverlays extends StatefulWidget {
  const ObaMapOverlays({super.key, required this.overlay, required this.child});

  final ObaMapOverlay overlay;
  final Widget child;

  @override
  State<ObaMapOverlays> createState() => _ObaMapOverlaysState();
}

class _ObaMapOverlaysState extends State<ObaMapOverlays> {
  ObaMapCoordinator? _coordinator;
  Object? _owner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final coordinator = ObaMapCoordinator.maybeOf(context);
    final owner = ModalRoute.of(context) ?? this;
    if (!identical(coordinator, _coordinator) || !identical(owner, _owner)) {
      if (_owner != null) _coordinator?.removeOverlay(_owner!);
      _coordinator = coordinator;
      _owner = owner;
      _apply();
    }
  }

  @override
  void didUpdateWidget(ObaMapOverlays oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.overlay, widget.overlay)) _apply();
  }

  void _apply() {
    final c = _coordinator;
    final o = _owner;
    if (c == null || o == null) return;
    c.setOverlay(o, widget.overlay);
  }

  @override
  void dispose() {
    final o = _owner;
    if (o != null) _coordinator?.removeOverlay(o);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
