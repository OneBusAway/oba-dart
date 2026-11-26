import 'package:flutter/material.dart';
import 'package:oba_arrivals/oba_arrivals.dart' show parseHexColor;
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as oba show Route;

import '../../app/polling.dart';
import '../../widgets/loader.dart';
import '../../widgets/heading.dart';
import '../../app/application.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/memo.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import '../map/map_coordinator.dart';
import '../map/map_logic.dart';

/// A route's stops by direction, with a direction switcher; the route's
/// shape and stops show on the map (iOS route stops / `StopRouteFocus`).
/// Tapping a stop opens it. Embeddable: needs only an `ObaScope`.
class RouteStopsPage extends StatefulWidget {
  const RouteStopsPage({super.key, required this.routeId});

  final String routeId;

  @override
  State<RouteStopsPage> createState() => _RouteStopsPageState();
}

class _RouteStopsPageState extends State<RouteStopsPage> {
  late ObaLoader<ObaEntryResponse<StopsForRoute>> _loader;
  ObaApplication? _app;
  bool _started = false;
  int _direction = 0;

  /// The selected direction's decoded shapes and the overlay drawn from
  /// them, recomputed only when the response, direction or colour change.
  final ObaMemo<List<List<Coordinate>>> _decoded = ObaMemo();
  final ObaMemo<ObaMapOverlay> _overlay = ObaMemo();

  @override
  void initState() {
    super.initState();
    _loader = _make();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _app = ObaScope.of(context);
    if (!_started) {
      _started = true;
      _loader.load();
    }
  }

  ObaLoader<ObaEntryResponse<StopsForRoute>> _make() => ObaLoader(() {
    final core = _app?.core;
    final client = core?.restClient;
    if (core == null || client == null) throw const ObaNoRegionException();
    // Shared, cached per region (the stop page fetched it for its shapes).
    return core.stopsForRoute.get(client, widget.routeId);
  });

  @override
  void didUpdateWidget(RouteStopsPage old) {
    super.didUpdateWidget(old);
    if (old.routeId != widget.routeId) {
      _loader.dispose();
      _loader = _make()..load();
      _direction = 0;
    }
  }

  @override
  void dispose() {
    _loader.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ListenableBuilder(listenable: _loader, builder: _build);

  Widget _build(BuildContext context, Widget? _) {
    final l10n = context.obaL10n;
    final core = ObaScope.of(context).core;
    final r = _loader.value;
    final route = r?.references.route(widget.routeId);
    final name = route?.shortName ?? route?.longName;
    final groups = [
      for (final g in r?.entry.stopGroupings ?? const <StopGrouping>[])
        ...g.stopGroups,
    ];
    final dir = groups.isEmpty ? 0 : _direction.clamp(0, groups.length - 1);
    final group = groups.isEmpty ? null : groups[dir];
    final stopIds = group?.stopIds ?? r?.entry.stopIds ?? const <String>[];
    final stops = r == null
        ? const <Stop>[]
        : r.references.stopsWithIds(stopIds);
    final polylines = group != null && group.polylines.isNotEmpty
        ? group.polylines
        : (r?.entry.polylines ?? const <String>[]);

    final slivers = <Widget>[];
    if (r == null) {
      slivers.add(
        ObaLoadingOrErrorSliver(error: _loader.error, onRetry: _loader.load),
      );
    } else if (stops.isEmpty) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: ObaEmptyState(
            icon: Icons.route_outlined,
            title: l10n.stopRouteStopsEmpty,
          ),
        ),
      );
    } else {
      if (groups.length > 1) {
        slivers.add(
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ObaHeading(
                    l10n.stopRouteStopsDirection,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (var i = 0; i < groups.length; i++)
                        ChoiceChip(
                          label: Text(
                            l10n.stopRouteStopsToward(
                              groups[i].name ?? groups[i].id,
                            ),
                          ),
                          selected: i == dir,
                          onSelected: (_) => setState(() => _direction = i),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
      slivers.addAll([
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 4),
            child: Text(
              l10n.stopRouteStopsCount(stops.length),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        SliverList.list(
          children: [
            for (final s in stops)
              ObaStopRow(
                stop: s,
                routes: [for (final id in s.routeIds) ?r.references.route(id)],
              ),
          ],
        ),
      ]);
    }

    final color = _routeColor(context, route);
    final supportsSchedule =
        core.currentRegion?.supportsScheduleForRoute ?? false;
    final overlay = _overlay([r, dir, color], () {
      if (r == null) return ObaMapOverlay.empty;
      // Each shape decoded once (it used to be decoded for the lines and
      // again for the bounds).
      final lines = _decoded([
        r,
        dir,
      ], () => [for (final p in polylines) Polyline.decode(p)]);
      return ObaMapOverlay(
        polylines: [
          for (final points in lines)
            ObaMapPolyline(points: points, color: color),
        ],
        stops: stops,
        hideStopPins: true,
        fitBounds: ObaMapLogic.boundsOf([
          for (final points in lines) ...points,
          for (final s in stops) s.coordinate,
        ]),
      );
    });
    return ObaMapOverlays(
      overlay: overlay,
      child: ObaSheetPage(
        title: name == null
            ? l10n.titleRouteStops
            : l10n.stopRouteStopsTitle(name),
        actions: [
          if (supportsSchedule)
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              tooltip: l10n.stopRowRouteSchedule,
              onPressed: () =>
                  ObaNavigator.of(context)
                      .push(RouteScheduleRoute(widget.routeId)),
            ),
        ],
        slivers: slivers,
      ),
    );
  }

  Color _routeColor(BuildContext context, oba.Route? route) =>
      parseHexColor(route?.color) ?? ObaTheme.of(context).routeLine;
}
