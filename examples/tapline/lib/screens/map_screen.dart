import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme.dart';
import '../widgets/embed_frame.dart';

/// The SDK map with Tapline's own "Reload locations" markers on it.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // The host owns the coordinator, so it can add overlays and move the map.
  final _coordinator = ObaMapCoordinator();
  late final ObaMapOverlay _reloadOverlay = ObaMapOverlay(
    markers: [
      for (final store in reloadLocations)
        ObaMapMarker(
          coordinate: store.coordinate,
          // Every marker needs a label: screen readers announce it.
          label: 'Reload location: ${store.name}',
          kind: ObaMapMarkerKind.place,
          color: TaplineColors.teal,
          onTap: () => _showStore(store),
        ),
    ],
  );

  @override
  void dispose() {
    _coordinator.dispose();
    super.dispose();
  }

  void _showStore(ReloadLocation store) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => ReloadLocationSheet(store: store),
    );
  }

  void _showStoreList() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
              child: Semantics(
                header: true,
                child: Text(
                  'Reload locations',
                  style: Theme.of(sheetContext).textTheme.titleLarge,
                ),
              ),
            ),
            for (final store in reloadLocations)
              ListTile(
                leading: const ExcludeSemantics(child: Icon(Icons.store)),
                title: Text(store.name),
                subtitle: Text('${store.address}\n${store.hours}'),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _coordinator.moveTo(store.coordinate, zoom: 17);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showStopsList(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        // A new route sits above the map: hand it the coordinator so the
        // SDK's list can read the visible stops.
        builder: (_) => ObaMapCoordinatorScope(
          coordinator: _coordinator,
          child: const StopsOnMapPage(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.storefront_outlined),
            tooltip: 'List reload locations',
            onPressed: _showStoreList,
          ),
        ],
      ),
      // The SDK's overlay mechanism: ObaMapOverlays registers the host's
      // markers with the coordinator the map draws from.
      body: ObaMapCoordinatorScope(
        coordinator: _coordinator,
        child: ObaMapOverlays(
          overlay: _reloadOverlay,
          // OBA embed: ObaMapView — tiles, stop pins, the rider's location
          // and the host's reload-location markers. A tapped stop opens in
          // Tapline's own bottom sheet.
          child: Builder(
            builder: (context) => EmbedFrame(
              sdkWidget: 'ObaMapView',
              child: ObaMapView(
                coordinator: _coordinator,
                dropsPinOnLongPress: false,
                onShowStopsList: () => _showStopsList(context),
                onStopSelected: (stop) => showModalBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  isScrollControlled: true,
                  // The sheet's route sits above the map's ObaScope, so
                  // re-wrap it. (Tapline's scope is above the navigator,
                  // so this is belt and braces, but it is what a host with
                  // a deeper scope must do.)
                  builder: (_) => SafeArea(
                    child: SingleChildScrollView(
                      // OBA embed: ObaStopDeparturesCard — the tapped
                      // stop's next departures.
                      child: ObaScope.rewrap(
                        context,
                        EmbedFrame(
                          sdkWidget: 'ObaStopDeparturesCard',
                          child: ObaStopDeparturesCard(stopId: stop.id),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ReloadLocationSheet extends StatelessWidget {
  const ReloadLocationSheet({super.key, required this.store});

  final ReloadLocation store;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              header: true,
              child: Text(store.name, style: text.headlineSmall),
            ),
            const SizedBox(height: 8),
            Text(store.address),
            Text(store.hours),
            const SizedBox(height: 16),
            const Text(
              'Reload your Tapline card with cash at the register. '
              'Stored value appears in the app within a few minutes.',
            ),
          ],
        ),
      ),
    );
  }
}
