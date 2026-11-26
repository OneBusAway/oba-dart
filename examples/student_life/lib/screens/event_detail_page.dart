import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import '../data/events.dart';
import '../widgets/embed_frame.dart';
import '../widgets/host_page.dart';
import '../widgets/section_title.dart';

/// One event: the host's details, then "Getting there" with departures
/// near the venue and a trip planner button.
class EventDetailPage extends StatelessWidget {
  const EventDetailPage({super.key, required this.event});

  final CampusEvent event;

  static Future<void> push(BuildContext context, CampusEvent event) =>
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (_) => EventDetailPage(event: event)),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Event')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.category.toUpperCase(),
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                ObaHeading(event.title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                _Fact(icon: Icons.schedule, label: 'When', text: event.when),
                _Fact(
                  icon: Icons.place_outlined,
                  label: 'Where',
                  text: event.venue.name,
                ),
                const SizedBox(height: 12),
                Text(event.description, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
          const SectionTitle('Getting there'),
          // OBA embed: departures around the venue, not around the
          // student: `around:` uses that point only, with no location.
          EmbedFrame(
            sdkWidget: 'ObaNearbyStopsCard',
            child: ObaNearbyStopsCard(
              around: event.venue.coordinate,
              title: 'Departures near ${event.venue.name}',
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: () => openTripPlanner(
                context,
                name: event.venue.name,
                coordinate: event.venue.coordinate,
              ),
              icon: const Icon(Icons.directions),
              label: Text('Plan a trip to ${event.venue.name}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact({required this.icon, required this.label, required this.text});

  final IconData icon;
  final String label;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Semantics(
      container: true,
      label: '$label: $text',
      excludeSemantics: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    ),
  );
}
