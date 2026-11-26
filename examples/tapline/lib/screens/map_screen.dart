import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import '../data/mock_data.dart';
import '../data/models.dart';
import '../theme.dart';
import '../widgets/embed_frame.dart';
import '../widgets/host_oba_page.dart';
import 'wallet_screen.dart';

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
        // SDK's list can read the visible stops. Under Tapline's app bar,
        // like every other SDK page.
        builder: (_) => ObaMapCoordinatorScope(
          coordinator: _coordinator,
          child: const HostObaPage(
            title: 'Stops on the map',
            sdkWidget: 'StopsOnMapPage',
            child: StopsOnMapPage(),
          ),
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
          // The shell's floating Ride button is hidden on this tab (it
          // would cover the map), so the ticket is here instead.
          IconButton(
            icon: const Icon(Icons.qr_code_2),
            tooltip: 'Show your ticket',
            onPressed: () => openRide(context),
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
                  // Tapline's ObaScope sits above the navigator, so it
                  // covers the sheet's route too; no ObaScope.rewrap. (A
                  // host whose scope is below its navigator would need it.)
                  builder: (_) => SafeArea(
                    child: SingleChildScrollView(
                      // OBA embed: ObaStopDeparturesCard — the tapped
                      // stop's next departures.
                      child: EmbedFrame(
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
