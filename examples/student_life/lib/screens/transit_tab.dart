import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import '../data/campus.dart';
import '../widgets/embed_frame.dart';
import '../widgets/section_title.dart';

/// The transit hub: a map preview, departures near campus, the student's
/// bookmarks, and the host's own list of campus stops.
class TransitTab extends StatelessWidget {
  const TransitTab({super.key});

  /// Map preview height. Fixed: the map has no intrinsic size.
  static const mapHeight = 240.0;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Transit')),
    body: ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        SizedBox(
          height: mapHeight,
          // OBA embed: the stop map. Tapping a pin pushes StopRoute, which
          // the host's onNavigate opens under its own app bar.
          child: const EmbedFrame(
            sdkWidget: 'ObaMapView',
            fills: true,
            child: ObaMapView(dropsPinOnLongPress: false),
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const FullMapPage()),
              ),
              icon: const Icon(Icons.fullscreen),
              label: const Text('Open full map'),
            ),
          ),
        ),
        const SectionTitle('Near campus'),
        // OBA embed: departures at the three closest stops to the
        // student (here, the fixed campus location).
        const EmbedFrame(
          sdkWidget: 'NearbyStopsSection',
          child: NearbyStopsSection(maxStops: 3),
        ),
        // OBA embed: the student's saved stops with live departures.
        const EmbedFrame(
          sdkWidget: 'ObaBookmarksCard',
          child: ObaBookmarksCard(limit: 3),
        ),
        const SectionTitle('Campus stops'),
        const CampusStopsList(stops: campusStops),
      ],
    ),
  );
}

/// The host's curated campus stops. A tap pushes the SDK's [StopRoute]
/// through [ObaNavigator], so it reaches the host's `onNavigate` like a
/// tap inside any SDK widget would.
class CampusStopsList extends StatelessWidget {
  const CampusStopsList({super.key, required this.stops});

  final List<CampusStop> stops;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: Column(
      children: [
        for (final stop in stops)
          ListTile(
            leading: const ExcludeSemantics(child: Icon(Icons.signpost)),
            title: Text(stop.name),
            subtitle: Text(stop.description),
            trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
            onTap: () => ObaNavigator.of(context).push(StopRoute(stop.id)),
          ),
      ],
    ),
  );
}

/// The map on its own, full screen, under a host app bar.
class FullMapPage extends StatelessWidget {
  const FullMapPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Campus map')),
    // OBA embed: the same map widget, given the whole screen.
    body: const EmbedFrame(
      sdkWidget: 'ObaMapView',
      fills: true,
      child: ObaMapView(dropsPinOnLongPress: false),
    ),
  );
}
