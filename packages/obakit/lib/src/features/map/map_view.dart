import 'dart:async';

import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show OrdinalSortKey;
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../widgets/link_opener.dart';
import '../../widgets/frame.dart';
import '../../widgets/visibility.dart';
import '../../app/application.dart';
import '../../app/location_holder.dart';
import '../../app/map_config.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/rows.dart';
import '../../widgets/states.dart';
import 'camera_store.dart';
import 'map_coordinator.dart';
import 'map_logic.dart';
import 'map_markers.dart';
import 'stops_loader.dart';

LatLng _ll(Coordinate c) => LatLng(c.lat, c.lon);
Coordinate _co(LatLng l) => Coordinate(l.latitude, l.longitude);
RegionRect _rect(fm.LatLngBounds b) => RegionRect(
  minLat: b.south,
  maxLat: b.north,
  minLon: b.west,
  maxLon: b.east,
);
fm.LatLngBounds _bounds(RegionRect r) =>
    fm.LatLngBounds(LatLng(r.minLat, r.minLon), LatLng(r.maxLat, r.maxLon));

/// The OneBusAway map as a standalone widget: tiles from `ObaMapConfig`,
/// stop pins for the visible area (when zoomed in far enough), the user's
/// location, overlays from an [ObaMapCoordinator], a status pill and the
/// tile attribution. Needs only an `ObaScope` ancestor.
///
/// ```dart
/// ObaMapView(onStopSelected: (stop) => openMyStopPage(stop.id))
/// ```
///
/// Without [onStopSelected], tapping a pin pushes `StopRoute` through
/// `ObaNavigator` (so a host's `ObaScope.onNavigate` sees it).
///
/// Nothing is loaded until the map is first visible: in a hidden
/// `IndexedStack` child (a host's off-screen tab) it builds no tiles and
/// requests no stops. Live location (for the location dot and the first
/// centring) is held only while the map is visible and the app is in the
/// foreground, and not at all when [showsUserLocation] is false.
class ObaMapView extends StatefulWidget {
  const ObaMapView({
    super.key,
    this.coordinator,
    this.onStopSelected,
    this.onLongPress,
    this.dropsPinOnLongPress = true,
    this.padding = EdgeInsets.zero,
    this.paddingListenable,
    this.showsUserLocation = true,
    this.showsControls = true,
    this.onOpenMapSettings,
    this.onShowStopsList,
    this.topStartAccessory,
    this.persistsCamera = true,
  });

  /// Shares camera, selection and overlays with screens. When null the view
  /// creates its own.
  final ObaMapCoordinator? coordinator;
  final ValueChanged<Stop>? onStopSelected;

  /// Long press handler. When null and [dropsPinOnLongPress], a long press
  /// pushes `PlaceRoute` for a dropped pin.
  final ValueChanged<Coordinate>? onLongPress;
  final bool dropsPinOnLongPress;

  /// The part of the map covered by other UI (the sheet): controls stay
  /// clear of it and camera moves centre on the uncovered area. Ignored when
  /// [paddingListenable] is given.
  final EdgeInsets padding;

  /// A [padding] that changes often (a draggable sheet's height). Only the
  /// floating controls rebuild when it changes, never the map itself, and
  /// camera moves always use its latest value.
  final ValueListenable<EdgeInsets>? paddingListenable;
  final bool showsUserLocation;

  /// Shows the recentre button (and the optional buttons below).
  final bool showsControls;

  /// Adds a map-settings button.
  final VoidCallback? onOpenMapSettings;

  /// Adds a "Stops on the map" button (the accessible list of pins).
  final VoidCallback? onShowStopsList;

  /// Shown at the top start corner (the shell's weather slot).
  final Widget? topStartAccessory;

  /// Saves and restores the last camera position.
  final bool persistsCamera;

  @override
  State<ObaMapView> createState() => _ObaMapViewState();
}

class _ObaMapViewState extends State<ObaMapView>
    with SingleTickerProviderStateMixin, ObaVisibilityAware<ObaMapView>
    implements ObaMapCameraDelegate {
  final fm.MapController _map = fm.MapController();
  late ObaApplication _app;
  late ObaMapCoordinator _coordinator;
  ObaMapCoordinator? _ownedCoordinator;
  late StopsLoader _loader;
  final StopMarkerCache<fm.Marker> _markerCache = StopMarkerCache();
  late final AnimationController _camAnim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );
  Timer? _idleTimer;
  bool _ready = false;
  fm.MapOptions? _mapOptions;
  bool _initialized = false;
  Region? _region;

  /// Whether the map has ever been visible ([ObaVisibilityAware]). Until
  /// then no tiles or stops load (a host's hidden tab).
  bool _everShown = false;

  @override
  void onVisibilityChanged(bool visible) {
    if (visible && !_everShown) setState(() => _everShown = true);
  }

  /// True until the camera has been placed on the rider's first fix (or
  /// someone moved it): with no saved camera the map opens on the region,
  /// then centres on the rider once a location arrives, as iOS does.
  bool _awaitingFirstFix = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final app = ObaScope.of(context);
    if (!_initialized) {
      _initialized = true;
      _app = app;
      _bindCoordinator();
      _loader = StopsLoader(
        client: () => _app.core.restClient,
        maxMarkers: _app.map.maxStopMarkers,
      )..addListener(_onStopsChanged);
      _region = _app.core.currentRegion;
      _app.core.regions.currentRegionListenable.addListener(_onRegionChanged);
      _app.core.locationListenable.addListener(_onLocationChanged);
    }
  }

  void _bindCoordinator() {
    _coordinator =
        widget.coordinator ?? (_ownedCoordinator ??= ObaMapCoordinator());
  }

  @override
  void didUpdateWidget(ObaMapView old) {
    super.didUpdateWidget(old);
    if (!identical(old.coordinator, widget.coordinator)) {
      _coordinator.detach(this);
      _bindCoordinator();
      if (_ready) _coordinator.attach(this);
    }
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _camAnim.dispose();
    _coordinator.detach(this);
    _ownedCoordinator?.dispose();
    _loader.dispose();
    _app.core.regions.currentRegionListenable.removeListener(_onRegionChanged);
    _app.core.locationListenable.removeListener(_onLocationChanged);
    _map.dispose();
    super.dispose();
  }

  // -- Camera -----------------------------------------------------------------

  fm.MapOptions _options(BuildContext context) {
    final theme = ObaTheme.of(context);
    final region = _app.core.currentRegion;
    final saved = widget.persistsCamera
        ? MapCameraStore(_app.core.store).read()
        : null;
    final useSaved =
        saved != null && (region == null || saved.regionId == region.id);
    final user = useSaved ? null : _userLocationInRegion();
    _awaitingFirstFix = !useSaved && user == null;
    return fm.MapOptions(
      initialCenter: useSaved
          ? _ll(saved.center)
          : user != null
          ? _ll(user)
          : _ll(region?.centerCoordinate ?? const Coordinate(20, 0)),
      initialZoom: useSaved
          ? saved.zoom
          : user != null
          ? ObaMapLogic.userLocationZoom
          : (region == null ? 2 : 11),
      initialCameraFit: !useSaved && user == null && region != null
          ? fm.CameraFit.bounds(
              bounds: _bounds(region.serviceRect),
              padding: const EdgeInsets.all(24),
            )
          : null,
      minZoom: _app.map.minZoom,
      maxZoom: _app.map.maxZoom,
      backgroundColor: theme.mapBackground,
      interactionOptions: const fm.InteractionOptions(
        flags: fm.InteractiveFlag.all & ~fm.InteractiveFlag.rotate,
      ),
      onMapReady: _onMapReady,
      onPositionChanged: _onPositionChanged,
      onLongPress: (_, latLng) => _onLongPress(_co(latLng)),
    );
  }

  /// The rider's location when permitted and inside the current region
  /// (or anywhere when there is no region).
  Coordinate? _userLocationInRegion() {
    final core = _app.core;
    final location = core.currentLocation;
    if (location == null || !core.locationPermission.isGranted) return null;
    final region = core.currentRegion;
    if (region != null &&
        !region.serviceRect.contains(location.lat, location.lon)) {
      return null;
    }
    return location.coordinate;
  }

  void _onLocationChanged() {
    if (!_awaitingFirstFix || !_ready) return;
    final user = _userLocationInRegion();
    if (user == null) return;
    _awaitingFirstFix = false;
    moveTo(user, zoom: ObaMapLogic.userLocationZoom);
  }

  void _onMapReady() {
    _ready = true;
    _coordinator.attach(this);
    _onPositionChanged(_map.camera, false);
    _onLocationChanged();
  }

  void _onPositionChanged(fm.MapCamera camera, bool hasGesture) {
    if (hasGesture) _awaitingFirstFix = false;
    final bounds = _rect(camera.visibleBounds);
    _coordinator.updateCamera(
      center: _co(camera.center),
      zoom: camera.zoom,
      visibleBounds: bounds,
    );
    _idleTimer?.cancel();
    _idleTimer = Timer(ObaMapLogic.stopsRequestDebounce, () => _onIdle(camera));
  }

  void _onIdle(fm.MapCamera camera) {
    if (!mounted) return;
    final bounds = _rect(camera.visibleBounds);
    _loader.onCameraIdle(bounds);
    _coordinator.cameraIdle.value = bounds;
    if (widget.persistsCamera) {
      MapCameraStore(_app.core.store).write(
        SavedCamera(
          center: _co(camera.center),
          zoom: camera.zoom,
          regionId: _app.core.currentRegion?.id,
        ),
      );
    }
  }

  /// The covered part of the map, as of now.
  EdgeInsets get _padding => widget.paddingListenable?.value ?? widget.padding;

  /// Offset from the widget centre to the centre of the uncovered area.
  Offset get _visibleCenterShift {
    final padding = _padding;
    return Offset(
      (padding.left - padding.right) / 2,
      (padding.top - padding.bottom) / 2,
    );
  }

  void _whenSafe(VoidCallback fn) => obaRunWhenSafe(() {
    if (mounted) fn();
  });

  @override
  void moveTo(Coordinate center, {double? zoom}) => _whenSafe(() {
    _awaitingFirstFix = false;
    final camera = _map.camera;
    final z = zoom ?? camera.zoom;
    final projected = camera.projectAtZoom(_ll(center), z);
    final target = camera.unprojectAtZoom(projected - _visibleCenterShift, z);
    _animateCamera(target, z);
  });

  @override
  void fitBounds(RegionRect bounds) => _whenSafe(() {
    _awaitingFirstFix = false;
    final fitted = fm.CameraFit.bounds(
      bounds: _bounds(bounds),
      // Extra room at the bottom for the attribution chip, which would
      // otherwise cover whatever is fitted to the edge.
      padding: const EdgeInsets.fromLTRB(48, 48, 48, 88) + _padding,
      maxZoom: 18,
    ).fit(_map.camera);
    _animateCamera(fitted.center, fitted.zoom);
  });

  void _animateCamera(LatLng target, double zoom) {
    if (!mounted) return;
    final reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final start = _map.camera;
    if (reduceMotion) {
      _map.move(target, zoom);
      return;
    }
    final lat = Tween(begin: start.center.latitude, end: target.latitude);
    final lon = Tween(begin: start.center.longitude, end: target.longitude);
    final z = Tween(begin: start.zoom, end: zoom);
    final curve = CurvedAnimation(parent: _camAnim, curve: Curves.easeInOut);
    void tick() => _map.move(
      LatLng(lat.evaluate(curve), lon.evaluate(curve)),
      z.evaluate(curve),
    );
    _camAnim
      ..stop()
      ..reset();
    _camAnim.addListener(tick);
    _camAnim.forward().whenCompleteOrCancel(
      () => _camAnim.removeListener(tick),
    );
  }

  void _onRegionChanged() {
    final region = _app.core.currentRegion;
    if (identical(region, _region)) return;
    final previous = _region;
    _region = region;
    if (region == null) return;
    if (previous?.id != region.id) _loader.reset();
    if (_ready && previous?.id != region.id) fitBounds(region.serviceRect);
  }

  // -- Interaction ----------------------------------------------------------------

  void _onStopTap(Stop stop) {
    _coordinator.selectStop(stop.id);
    _app.core.analytics.reportEvent(
      pageUrl: 'app://localhost/map',
      label: AnalyticsLabels.mapStopAnnotationTapped,
    );
    final handler = widget.onStopSelected;
    if (handler != null) {
      handler(stop);
    } else {
      ObaNavigator.of(context).push(StopRoute(stop.id));
    }
  }

  void _onLongPress(Coordinate c) {
    final handler = widget.onLongPress;
    if (handler != null) {
      handler(c);
      return;
    }
    if (!widget.dropsPinOnLongPress) return;
    final l10n = context.obaL10n;
    final place = Place(
      name: l10n.mapDroppedPin,
      coordinate: c,
      id: 'dropped-${c.lat.toStringAsFixed(5)},${c.lon.toStringAsFixed(5)}',
    );
    // The place page draws the pin as its own overlay, so the page below
    // keeps its overlay (a stop's route shapes) and gets it back on pop.
    ObaNavigator.of(context).push(PlaceRoute(place, isDroppedPin: true));
  }

  Future<void> _recenter() async {
    _app.core.analytics.reportEvent(
      pageUrl: 'app://localhost/map',
      label: AnalyticsLabels.mapShowUserLocationButtonTapped,
    );
    var location = _app.core.currentLocation;
    if (!_app.core.locationPermission.isGranted) {
      final status = await _app.core.requestLocationPermission();
      if (!status.isGranted) return;
      location = _app.core.currentLocation;
    }
    if (location != null) {
      moveTo(location.coordinate, zoom: ObaMapLogic.userLocationZoom);
    }
  }

  void _onStopsChanged() {
    _coordinator.updateVisibleStops(_loader.stops, _loader.routes);
  }

  // -- Build --------------------------------------------------------------------

  List<fm.TileLayer> _tileLayers(MapType type, Brightness brightness) {
    final cfg = _app.map;
    fm.TileLayer layer(ObaTileSource s) => fm.TileLayer(
      key: ValueKey(s.urlTemplate),
      urlTemplate: s.urlTemplate,
      subdomains: s.subdomains,
      userAgentPackageName: cfg.userAgentPackageName,
      maxNativeZoom: s.maxNativeZoom,
      tileProvider: cfg.tileProvider,
    );
    return switch (type) {
      MapType.satellite when cfg.satellite != null => [layer(cfg.satellite!)],
      MapType.hybrid when cfg.supportsHybrid => [
        layer(cfg.satellite!),
        layer(cfg.hybridLabels!),
      ],
      _ => [layer(cfg.standardFor(brightness))],
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final settings = _app.core.settings;
    return ListenableBuilder(
      listenable: settings.listenable,
      builder: (context, _) {
        final mapType = settings.mapType;
        final brightness = Theme.of(context).brightness;
        final source = _app.map.sourceFor(mapType, brightness);
        if (!_everShown) {
          // A hidden tab: no tiles, no stops request, no location.
          return ColoredBox(
            color: ObaTheme.of(context).mapBackground,
            child: const SizedBox.expand(),
          );
        }
        // The floating controls read before the (many) stop pins.
        return ObaLocationHolder(
          enabled: widget.showsUserLocation,
          child: Semantics(
            container: true,
            explicitChildNodes: true,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Semantics(
                    sortKey: const OrdinalSortKey(1),
                    label: l10n.mapLabel,
                    container: true,
                    child: fm.FlutterMap(
                      mapController: _map,
                      // Built once: only the initial camera and callbacks matter after
                      // the first frame, and camera ticks never rebuild this.
                      options: _mapOptions ??= _options(context),
                      children: [
                        ..._tileLayers(mapType, brightness),
                        _OverlayLinesLayer(coordinator: _coordinator),
                        if (widget.showsUserLocation)
                          _UserLocationLayer(
                            app: _app,
                            showsHeading: settings.mapShowsHeading,
                          ),
                        _StopMarkersLayer(
                          app: _app,
                          loader: _loader,
                          coordinator: _coordinator,
                          cache: _markerCache,
                          onTap: _onStopTap,
                        ),
                        _OverlayMarkersLayer(coordinator: _coordinator),
                      ],
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Semantics(
                    sortKey: const OrdinalSortKey(0),
                    container: true,
                    explicitChildNodes: true,
                    child: _ChromePadding(
                      padding: widget.padding,
                      paddingListenable: widget.paddingListenable,
                      child: SafeArea(
                        child: _MapChrome(
                          app: _app,
                          loader: _loader,
                          source: source,
                          showsControls: widget.showsControls,
                          onRecenter: _recenter,
                          onOpenMapSettings: widget.onOpenMapSettings,
                          onShowStopsList: widget.onShowStopsList,
                          topStartAccessory: widget.topStartAccessory,
                          coordinator: _coordinator,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Pads the map chrome by a fixed [padding], or by [paddingListenable]
/// (rebuilding only this subtree when it changes).
class _ChromePadding extends StatelessWidget {
  const _ChromePadding({
    required this.padding,
    required this.paddingListenable,
    required this.child,
  });

  final EdgeInsets padding;
  final ValueListenable<EdgeInsets>? paddingListenable;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final listenable = paddingListenable;
    if (listenable == null) return Padding(padding: padding, child: child);
    return ValueListenableBuilder<EdgeInsets>(
      valueListenable: listenable,
      builder: (context, value, child) => Padding(padding: value, child: child),
      child: child,
    );
  }
}

class _StopMarkersLayer extends StatefulWidget {
  const _StopMarkersLayer({
    required this.app,
    required this.loader,
    required this.coordinator,
    required this.cache,
    required this.onTap,
  });

  final ObaApplication app;
  final StopsLoader loader;
  final ObaMapCoordinator coordinator;
  final StopMarkerCache<fm.Marker> cache;
  final ValueChanged<Stop> onTap;

  @override
  State<_StopMarkersLayer> createState() => _StopMarkersLayerState();
}

class _StopMarkersLayerState extends State<_StopMarkersLayer> {
  late Listenable _listenable = _merge();

  Listenable _merge() => Listenable.merge([
    widget.loader,
    widget.coordinator,
    widget.coordinator.cameraIdle,
    widget.app.core.userData.listenable,
  ]);

  @override
  void didUpdateWidget(_StopMarkersLayer old) {
    super.didUpdateWidget(old);
    if (!identical(old.loader, widget.loader) ||
        !identical(old.coordinator, widget.coordinator) ||
        !identical(old.app, widget.app)) {
      _listenable = _merge();
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    final loader = widget.loader;
    final coordinator = widget.coordinator;
    final cache = widget.cache;
    final onTap = widget.onTap;
    return ListenableBuilder(
      listenable: _listenable,
      builder: (context, _) {
        final overlay = coordinator.overlay;
        final zoom = coordinator.zoom;
        final compactOverlay =
            overlay.stops.length > 1 &&
            zoom != null &&
            zoom < ObaMapLogic.compactOverlayStopsBelowZoom;
        final selected = coordinator.selectedStopId;
        final regionId = app.core.currentRegion?.id;
        final bookmarkedIds = <String>{};
        final specs = <StopMarkerSpec>[];
        for (final b in app.core.userData.bookmarksInRegion(regionId)) {
          bookmarkedIds.add(b.stopId);
        }
        void add(Stop stop, RouteType type, {bool compact = false}) {
          final bookmarked = bookmarkedIds.contains(stop.id);
          final isSelected = stop.id == selected;
          specs.add(
            StopMarkerSpec(
              stop: stop,
              routeType: type,
              isBookmarked: bookmarked,
              isSelected: isSelected,
              compact: compact && !bookmarked && !isSelected,
            ),
          );
        }

        final ids = <String>{};
        for (final s in overlay.stops) {
          if (ids.add(s.id)) {
            add(
              s,
              prioritizedRouteType(loader.routeTypesFor(s)),
              compact: compactOverlay,
            );
          }
        }
        if (!overlay.hideStopPins) {
          for (final s in loader.stops) {
            if (ids.add(s.id)) {
              add(s, prioritizedRouteType(loader.routeTypesFor(s)));
            }
          }
          // Bookmarked stops stay visible when zoomed out.
          for (final b in app.core.userData.bookmarksInRegion(regionId)) {
            if (ids.add(b.stopId)) {
              add(
                b.stop.toStop(),
                prioritizedRouteType(b.stop.routes.map((r) => r.routeType)),
              );
            }
          }
        }
        // The selected pin draws last (on top).
        specs.sort((a, b) => (a.isSelected ? 1 : 0) - (b.isSelected ? 1 : 0));
        final markers = cache.update(
          specs,
          (spec) => fm.Marker(
            key: ValueKey('stop-${spec.id}'),
            point: LatLng(spec.stop.lat, spec.stop.lon),
            width: kObaMarkerTarget,
            height: kObaMarkerTarget,
            child: ObaStopPin(spec: spec, onTap: () => onTap(spec.stop)),
          ),
        );
        return fm.MarkerLayer(markers: markers);
      },
    );
  }
}

class _UserLocationLayer extends StatelessWidget {
  const _UserLocationLayer({required this.app, required this.showsHeading});

  final ObaApplication app;
  final bool showsHeading;

  @override
  Widget build(BuildContext context) {
    final theme = ObaTheme.of(context);
    return ValueListenableBuilder<ObaLocation?>(
      valueListenable: app.core.locationListenable.valueListenable,
      builder: (context, location, _) {
        if (location == null || !app.core.locationPermission.isGranted) {
          return const SizedBox.shrink();
        }
        final point = LatLng(location.lat, location.lon);
        return Stack(
          children: [
            if (location.accuracy > 0)
              fm.CircleLayer(
                circles: [
                  fm.CircleMarker(
                    point: point,
                    radius: location.accuracy,
                    useRadiusInMeter: true,
                    color: theme.userLocation.withValues(alpha: 0.12),
                    borderColor: theme.userLocation.withValues(alpha: 0.5),
                    borderStrokeWidth: 1,
                  ),
                ],
              ),
            fm.MarkerLayer(
              markers: [
                fm.Marker(
                  point: point,
                  width: kObaMarkerTarget,
                  height: kObaMarkerTarget,
                  child: ObaUserLocationDot(
                    heading: showsHeading ? location.heading : null,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _OverlayLinesLayer extends StatelessWidget {
  const _OverlayLinesLayer({required this.coordinator});

  final ObaMapCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    final theme = ObaTheme.of(context);
    final surface = Theme.of(context).colorScheme.surface;
    return ListenableBuilder(
      listenable: coordinator,
      builder: (context, _) {
        final lines = coordinator.overlay.polylines;
        if (lines.isEmpty) return const SizedBox.shrink();
        return fm.PolylineLayer(
          polylines: [
            for (final l in lines)
              fm.Polyline(
                points: [for (final p in l.points) _ll(p)],
                color: l.color ?? theme.routeLine,
                strokeWidth: l.width ?? theme.routeLineWidth,
                borderColor: surface,
                borderStrokeWidth: 1.5,
                pattern: l.dashed
                    ? const fm.StrokePattern.dotted()
                    : const fm.StrokePattern.solid(),
              ),
          ],
        );
      },
    );
  }
}

class _OverlayMarkersLayer extends StatelessWidget {
  const _OverlayMarkersLayer({required this.coordinator});

  final ObaMapCoordinator coordinator;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: coordinator,
      builder: (context, _) {
        final markers = coordinator.overlay.markers;
        if (markers.isEmpty) return const SizedBox.shrink();
        return fm.MarkerLayer(
          markers: [
            for (final m in markers)
              fm.Marker(
                point: _ll(m.coordinate),
                width: kObaMarkerTarget,
                height: kObaMarkerTarget,
                child: ObaOverlayMarker(marker: m),
              ),
          ],
        );
      },
    );
  }
}

/// Floating controls, status pill and attribution over the map.
class _MapChrome extends StatelessWidget {
  const _MapChrome({
    required this.app,
    required this.loader,
    required this.source,
    required this.showsControls,
    required this.onRecenter,
    required this.onOpenMapSettings,
    required this.onShowStopsList,
    required this.topStartAccessory,
    required this.coordinator,
  });

  final ObaMapCoordinator coordinator;
  final ObaApplication app;
  final StopsLoader loader;
  final ObaTileSource source;
  final bool showsControls;
  final VoidCallback onRecenter;
  final VoidCallback? onOpenMapSettings;
  final VoidCallback? onShowStopsList;
  final Widget? topStartAccessory;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    return Stack(
      children: [
        // Focus order: accessory, pill, controls, attribution.
        PositionedDirectional(
          top: 8,
          start: 8,
          end: 72,
          child: FocusTraversalGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ?topStartAccessory,
                const SizedBox(height: 8),
                Center(
                  child: ObaMapStatusPill(
                    app: app,
                    loader: loader,
                    coordinator: coordinator,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showsControls)
          PositionedDirectional(
            top: 8,
            end: 8,
            child: FocusTraversalGroup(
              child: _ControlColumn(
                children: [
                  if (app.core.isLocationAvailable)
                    ObaMapControlButton(
                      icon: Icons.my_location,
                      tooltip: l10n.mapRecenter,
                      onPressed: onRecenter,
                    ),
                  if (onOpenMapSettings != null)
                    ObaMapControlButton(
                      icon: Icons.layers_outlined,
                      tooltip: l10n.mapSettingsButton,
                      onPressed: onOpenMapSettings!,
                    ),
                  if (onShowStopsList != null)
                    ObaMapControlButton(
                      icon: Icons.list,
                      tooltip: l10n.mapStopsListButton,
                      onPressed: onShowStopsList!,
                    ),
                ],
              ),
            ),
          ),
        PositionedDirectional(
          start: 4,
          bottom: 4,
          end: 4,
          child: Align(
            alignment: AlignmentDirectional.bottomStart,
            child: _Attribution(source: source),
          ),
        ),
      ],
    );
  }
}

class _ControlColumn extends StatelessWidget {
  const _ControlColumn({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerHigh,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

/// A 48dp map control with a tooltip (its semantics label) and a visible
/// focus ring.
class ObaMapControlButton extends StatelessWidget {
  const ObaMapControlButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      tooltip: tooltip,
      onPressed: onPressed,
      constraints: const BoxConstraints.tightFor(width: 48, height: 48),
    );
  }
}

/// "Zoom in to see stops", a failed stops request (tap to retry), or a
/// location-permission prompt.
class ObaMapStatusPill extends StatefulWidget {
  const ObaMapStatusPill({
    super.key,
    required this.app,
    required this.loader,
    this.coordinator,
  });

  final ObaApplication app;
  final StopsLoader loader;

  /// When its overlay hides the regular pins (a route or trip page draws
  /// its own stops), "Zoom in to see stops" would be wrong and is hidden.
  final ObaMapCoordinator? coordinator;

  @override
  State<ObaMapStatusPill> createState() => _ObaMapStatusPillState();
}

class _ObaMapStatusPillState extends State<ObaMapStatusPill> {
  late Listenable _listenable = _merge();

  Listenable _merge() => Listenable.merge([
    widget.loader,
    widget.app.core.listenable,
    widget.coordinator,
  ]);

  @override
  void didUpdateWidget(ObaMapStatusPill old) {
    super.didUpdateWidget(old);
    if (!identical(old.loader, widget.loader) ||
        !identical(old.app, widget.app) ||
        !identical(old.coordinator, widget.coordinator)) {
      _listenable = _merge();
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    final loader = widget.loader;
    final coordinator = widget.coordinator;
    return ListenableBuilder(
      listenable: _listenable,
      builder: (context, _) {
        final l10n = context.obaL10n;
        final permission = app.core.locationPermission;
        final ownStops = coordinator?.overlay.hideStopPins ?? false;
        String? text;
        VoidCallback? onTap;
        IconData icon = Icons.zoom_in;
        if (loader.error != null && !loader.isZoomedOut && !ownStops) {
          // Without this an unreachable server leaves a map with no pins
          // and no explanation.
          text = ObaErrorState.messageFor(context, loader.error);
          icon = Icons.cloud_off;
          onTap = loader.reload;
        } else if (!app.core.isLocationAvailable) {
          // The host gives the SDK no location: nothing to ask for.
          if (loader.isZoomedOut && !ownStops) text = l10n.mapZoomInForStops;
        } else if (permission == LocationPermissionStatus.serviceDisabled) {
          text = l10n.mapLocationServicesOff;
          icon = Icons.location_disabled;
        } else if (permission == LocationPermissionStatus.denied ||
            permission == LocationPermissionStatus.deniedForever) {
          text = l10n.mapLocationDenied;
          icon = Icons.location_disabled;
          onTap = app.core.requestLocationPermission;
        } else if (loader.isZoomedOut && !ownStops) {
          text = l10n.mapZoomInForStops;
        }
        if (text == null) return const SizedBox.shrink();
        final scheme = Theme.of(context).colorScheme;
        final content = Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(icon, size: 20, color: scheme.onInverseSurface),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(color: scheme.onInverseSurface),
                ),
              ),
            ],
          ),
        );
        return Semantics(
          liveRegion: true,
          button: onTap != null,
          child: Material(
            color: scheme.inverseSurface,
            shape: const StadiumBorder(),
            clipBehavior: Clip.antiAlias,
            child: onTap == null
                ? content
                : InkWell(
                    onTap: onTap,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(minHeight: 48),
                      child: content,
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class _Attribution extends StatelessWidget {
  const _Attribution({required this.source});
  final ObaTileSource source;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final url = source.attributionUrl;
    final label = context.obaL10n.mapAttribution(source.attribution);
    final text = Text(
      '© ${source.attribution}',
      semanticsLabel: label,
      style: Theme.of(context).textTheme.labelSmall
          ?.copyWith(color: scheme.onSurface),
    );
    return Material(
      color: scheme.surface.withValues(alpha: 0.9),
      borderRadius: BorderRadius.circular(6),
      clipBehavior: Clip.antiAlias,
      child: url == null
          ? Padding(padding: const EdgeInsets.all(6), child: text)
          : InkWell(
              onTap: () => obaOpenLink(context, Uri.parse(url)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Align(widthFactor: 1, child: text),
                ),
              ),
            ),
    );
  }
}
