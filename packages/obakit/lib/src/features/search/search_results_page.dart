import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as core show Route;

import '../../widgets/heading.dart';
import '../../app/scope.dart';
import '../../features/map/map_coordinator.dart';
import '../../features/map/map_logic.dart';
import '../../l10n/l10n.dart';
import '../../l10n/strings_bridge.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'search_common.dart';

/// The outcome of a search that matched several things (iOS
/// `SearchResultsSheetView`): routes, stops, vehicles or places, each row
/// opening its page. Stops and places are drawn on the map when there is
/// one. When [result] is null the search runs here.
///
/// Embeddable: needs only an `ObaScope`.
class SearchResultsPage extends StatefulWidget {
  const SearchResultsPage({super.key, required this.request, this.result});

  final SearchRequest request;
  final SearchResult? result;

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  SearchResult? _result;
  Object? _error;
  bool _loading = false;
  String? _loadingVehicle;
  String? _message;
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _result = widget.result;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (_result == null) _load();
  }

  @override
  void didUpdateWidget(SearchResultsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.request != widget.request ||
        oldWidget.result != widget.result) {
      _result = widget.result;
      if (_result == null) _load();
    }
  }

  Future<void> _load() async {
    final app = ObaScope.of(context);
    final map = ObaMapCoordinator.maybeOf(context);
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final r = await app.core.search.search(
        widget.request,
        mapCenter: map?.center,
        visibleRect: map?.visibleBounds,
      );
      if (!mounted) return;
      setState(() => _result = r);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _selectVehicle(String vehicleId) async {
    final app = ObaScope.of(context);
    final l10n = context.obaL10n;
    setState(() {
      _loadingVehicle = vehicleId;
      _message = null;
    });
    try {
      final r = await app.core.search.vehicle(vehicleId);
      if (!mounted) return;
      final route = vehicleTripRoute(r.vehicle);
      if (route == null) {
        setState(() => _message = l10n.searchVehicleNoTrip(vehicleId));
        obaAnnounce(context, _message!);
      } else {
        ObaNavigator.of(context).push(route);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _message = searchErrorText(context, e));
      obaAnnounce(context, _message!);
    } finally {
      if (mounted) setState(() => _loadingVehicle = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final result = _result;
    final List<Widget> slivers;
    if (result == null) {
      slivers = [
        ObaLoadingOrErrorSliver(
          error: _loading ? null : _error,
          errorMessage: _error == null
              ? null
              : searchErrorText(context, _error!),
          onRetry: _load,
        ),
      ];
    } else if (result.isEmpty) {
      slivers = [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ObaEmptyState(
            icon: Icons.search_off,
            title: l10n.searchNoResultsTitle,
            message: l10n.searchNoResultsBody(widget.request.query),
          ),
        ),
      ];
    } else {
      slivers = [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: ObaHeading(
              l10n.searchResultsHeading(result.count, widget.request.query),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
        if (_message != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: Semantics(
                liveRegion: true,
                child: Text(
                  _message!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          ),
        ..._rows(context, result),
      ];
    }
    return ObaMapOverlays(
      overlay: _overlay(context, result),
      child: ObaSheetPage(title: l10n.titleSearchResults, slivers: slivers),
    );
  }

  ObaMapOverlay _overlay(BuildContext context, SearchResult? result) {
    final l10n = context.obaL10n;
    switch (result) {
      case StopSearchResult(:final stops) when stops.isNotEmpty:
        return ObaMapOverlay(
          stops: stops,
          hideStopPins: true,
          fitBounds: ObaMapLogic.boundsOf([
            for (final s in stops) s.coordinate,
          ]),
        );
      case PlaceSearchResult(:final places) when places.isNotEmpty:
        return ObaMapOverlay(
          markers: [
            for (final p in places)
              ObaMapMarker(
                coordinate: p.coordinate,
                label: l10n.searchPlaceMarkerLabel(p.name),
                kind: ObaMapMarkerKind.place,
                onTap: () => _openPlace(p),
              ),
          ],
          fitBounds: ObaMapLogic.boundsOf([
            for (final p in places) p.coordinate,
          ]),
        );
      case VehicleResult(:final vehicle) when vehicle.location != null:
        return ObaMapOverlay(
          markers: [
            ObaMapMarker(
              coordinate: vehicle.location!,
              label: l10n.searchVehicleTitle(vehicle.vehicleId),
              kind: ObaMapMarkerKind.vehicle,
            ),
          ],
        );
      default:
        return ObaMapOverlay.empty;
    }
  }

  void _openPlace(Place p) {
    rememberPlace(ObaScope.of(context), p);
    ObaNavigator.of(context).push(PlaceRoute(p));
  }

  List<Widget> _rows(BuildContext context, SearchResult result) {
    final l10n = context.obaL10n;
    Widget header(String t) =>
        SliverToBoxAdapter(child: ObaSectionHeader(title: t));
    switch (result) {
      case RouteSearchResult(:final routes, :final references):
        return [
          header(l10n.searchResultsRoutes),
          SliverList.list(
            children: [
              for (final r in routes)
                _RouteRow(route: r, references: references),
            ],
          ),
        ];
      case StopSearchResult(:final stops, :final references):
        return [
          header(l10n.searchResultsStops),
          SliverList.list(
            children: [
              for (final s in stops)
                ObaStopRow(
                  stop: s,
                  routes: [for (final id in s.routeIds) ?references.route(id)],
                  onTap: () => ObaNavigator.of(context).push(StopRoute(s.id)),
                ),
            ],
          ),
        ];
      case VehicleMatchesResult(:final vehicles):
        return [
          header(l10n.searchResultsVehicles),
          SliverList.list(
            children: [
              for (final v in vehicles)
                if (v.vehicleId != null)
                  ObaListRow(
                    leading: const Icon(Icons.directions_bus_outlined),
                    title: l10n.searchVehicleTitle(v.vehicleId!),
                    subtitle: v.agencyName,
                    trailing: _loadingVehicle == v.vehicleId
                        ? Semantics(
                            label: l10n.searchVehicleLoading(v.vehicleId!),
                            child: const ExcludeSemantics(
                              child: SizedBox.square(
                                dimension: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          )
                        : null,
                    onTap: _loadingVehicle != null
                        ? null
                        : () => _selectVehicle(v.vehicleId!),
                  ),
            ],
          ),
        ];
      case VehicleResult(:final vehicle):
        final route = vehicleTripRoute(vehicle);
        return [
          header(l10n.searchResultsVehicles),
          SliverList.list(
            children: [
              ObaListRow(
                leading: const Icon(Icons.directions_bus_outlined),
                title: l10n.searchVehicleTitle(vehicle.vehicleId),
                subtitle: route == null
                    ? l10n.searchVehicleNoTrip(vehicle.vehicleId)
                    : null,
                onTap: route == null
                    ? null
                    : () => ObaNavigator.of(context).push(route),
              ),
            ],
          ),
        ];
      case PlaceSearchResult(:final places):
        final here = ObaScope.of(context).core.currentLocation?.coordinate;
        return [
          header(l10n.searchResultsPlaces),
          SliverList.list(
            children: [
              for (final p in places)
                ObaListRow(
                  leading: const Icon(Icons.place_outlined),
                  title: p.name,
                  subtitle: [
                    ?p.subtitle,
                    if (here != null)
                      l10n.searchNearbyDistance(
                        context.obaFormatters.distance(
                          distanceBetween(here, p.coordinate),
                        ),
                      ),
                  ].join(' · ').ifEmptyNull,
                  onTap: () => _openPlace(p),
                ),
            ],
          ),
        ];
    }
  }
}

class _RouteRow extends StatelessWidget {
  const _RouteRow({required this.route, required this.references});

  final core.Route route;
  final References references;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final name = route.shortName ?? route.longName ?? route.id;
    final agency = references.agency(route.agencyId)?.name;
    final details = [
      if (route.shortName != null && route.longName != null) route.longName!,
      if (route.description != null &&
          route.description!.isNotEmpty &&
          route.description != route.longName)
        route.description!,
      ?agency,
    ].join(' · ');
    return ObaListRow(
      leading: ObaRouteBadge.forRoute(route),
      title: route.longName != null && route.shortName == null
          ? route.longName!
          : name,
      subtitle: details.isEmpty ? null : details,
      semanticLabel: l10n.searchRouteRowLabel(
        name,
        [
          routeTypeLabel(l10n, route.routeType),
          details,
        ].where((s) => s.isNotEmpty).join(', '),
      ),
      onTap: () => ObaNavigator.of(context).push(RouteStopsRoute(route.id)),
    );
  }
}

extension on String {
  String? get ifEmptyNull => isEmpty ? null : this;
}
