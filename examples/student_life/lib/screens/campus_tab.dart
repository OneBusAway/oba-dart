import 'package:flutter/material.dart';

import '../data/events.dart';
import 'event_detail_page.dart';

/// The host's own events list. No SDK widgets here; each event's detail
/// page embeds the transit parts.
class CampusTab extends StatelessWidget {
  const CampusTab({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Campus')),
    body: ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: campusEvents.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, i) {
        final event = campusEvents[i];
        return ListTile(
          contentPadding: const EdgeInsetsDirectional.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: const ExcludeSemantics(child: Icon(Icons.event)),
          title: Text(event.title),
          subtitle: Text(
            '${event.category} · ${event.when} · ${event.venue.name}',
          ),
          trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
          onTap: () => EventDetailPage.push(context, event),
        );
      },
    ),
  );
}
