// Map-owned routes (scaffold): map settings and the accessible list of the
// stops on the map.

import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;
import 'package:obakit_core/obakit_core.dart' as core show Route;

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'map_coordinator.dart';

Widget buildMapSettingsRoute(BuildContext context, MapSettingsRoute route) =>
    const MapSettingsPage();

Widget buildStopsOnMapRoute(BuildContext context, StopsOnMapRoute route) =>
    const StopsOnMapPage();

/// Map type and display toggles. Satellite and hybrid appear only when the
/// host configured their tiles.
class MapSettingsPage extends StatelessWidget {
  const MapSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = ObaScope.of(context);
    final settings = app.core.settings;
    final l10n = context.obaL10n;
    final types = [
      MapType.standard,
      if (app.map.supportsSatellite) MapType.satellite,
      if (app.map.supportsHybrid) MapType.hybrid,
    ];
    String label(MapType t) => switch (t) {
      MapType.standard => l10n.mapTypeStandard,
      MapType.satellite => l10n.mapTypeSatellite,
      MapType.hybrid => l10n.mapTypeHybrid,
    };
    return ListenableBuilder(
      listenable: settings.listenable,
      builder: (context, _) => ObaSheetPage(
        title: l10n.titleMapSettings,
        slivers: [
          SliverList.list(
            children: [
              if (types.length > 1) ...[
                ObaSectionHeader(title: l10n.mapTypeTitle),
                RadioGroup<MapType>(
                  groupValue: settings.mapType,
                  onChanged: (v) {
                    if (v != null) settings.mapType = v;
                  },
                  child: Column(
                    children: [
                      for (final t in types)
                        RadioListTile<MapType>(value: t, title: Text(label(t))),
                    ],
                  ),
                ),
              ],
              SwitchListTile(
                title: Text(l10n.mapShowHeading),
                value: settings.mapShowsHeading,
                onChanged: (v) => settings.mapShowsHeading = v,
              ),
              // No "Show stop labels" switch: the map doesn't draw labels
              // under pins yet, so the setting would do nothing.
            ],
          ),
        ],
      ),
    );
  }
}

/// The stops currently drawn on the map, as a list: the screen-reader and
/// keyboard alternative to the pins.
class StopsOnMapPage extends StatelessWidget {
  const StopsOnMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final coordinator = ObaMapCoordinator.maybeOf(context);
    if (coordinator == null) {
      return ObaSheetPage(
        title: l10n.titleStopsOnMap,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: ObaEmptyState(title: l10n.mapVisibleStopsCount(0)),
          ),
        ],
      );
    }
    return ListenableBuilder(
      listenable: coordinator,
      builder: (context, _) {
        final stops = coordinator.visibleStops;
        return ObaSheetPage(
          title: l10n.titleStopsOnMap,
          slivers: [
            SliverToBoxAdapter(
              child: Semantics(
                liveRegion: true,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 8),
                  child: Text(l10n.mapVisibleStopsCount(stops.length)),
                ),
              ),
            ),
            SliverList.builder(
              itemCount: stops.length,
              itemBuilder: (context, i) {
                final stop = stops[i];
                return ObaStopRow(
                  stop: stop,
                  routes: <core.Route>[
                    for (final id in stop.routeIds) ?coordinator.routes[id],
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
