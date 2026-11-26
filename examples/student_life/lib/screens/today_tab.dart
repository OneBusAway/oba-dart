import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import '../chosen_trip.dart';
import '../data/dining.dart';
import '../data/events.dart';
import '../data/schedule.dart';
import '../data/student.dart';
import '../theme.dart';
import '../widgets/embed_frame.dart';
import '../widgets/host_page.dart';
import '../widgets/section_title.dart';
import 'event_detail_page.dart';

/// The home feed: host cards with SDK cards mixed in.
class TodayTab extends StatelessWidget {
  const TodayTab({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Today')),
    body: ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const _Greeting(),
        const NextClassCard(meeting: nextClass),
        // When to leave, from the itinerary the student chose in the SDK
        // trip planner (onItinerarySelected), or a prompt to plan one.
        const ChosenTripCard(),
        // OBA embed: urgent unread service alerts. Renders nothing at all
        // when there are none, so it costs the feed no space.
        const EmbedFrame(
          sdkWidget: 'ServiceAlertsSection',
          child: ServiceAlertsSection(),
        ),
        const SectionTitle('Campus shuttle'),
        // OBA embed: live departures from the shuttle stop by Eighth
        // College, the obakit successor of the oba_arrivals example's
        // ShuttleCard. "See all" opens the stop page through onNavigate.
        const EmbedFrame(
          sdkWidget: 'ObaStopDeparturesCard',
          child: ObaStopDeparturesCard(
            stopId: 'MTS_24151',
            title: 'Eighth College / Theatre District',
            maxArrivals: 3,
          ),
        ),
        const SectionTitle('Dining'),
        const DiningCard(halls: diningHalls),
        const SectionTitle('Featured event'),
        FeaturedEventCard(event: featuredEvent),
      ],
    ),
  );
}

class _Greeting extends StatelessWidget {
  const _Greeting();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final part = now.hour < 12
        ? 'morning'
        : now.hour < 18
        ? 'afternoon'
        : 'evening';
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ObaHeading(
            'Good $part, ${currentStudent.firstName}',
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            MaterialLocalizations.of(context).formatFullDate(now),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// The student's next class, with a Directions button that opens the SDK
/// trip planner. When to leave comes from the trip the student picks
/// there (see [ChosenTripCard]).
class NextClassCard extends StatelessWidget {
  const NextClassCard({super.key, required this.meeting});

  final ClassMeeting meeting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = MaterialLocalizations.of(context);
    final start = loc.formatTimeOfDay(meeting.start);
    const onNavy = Colors.white;
    return Card(
      color: Brand.navy,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ObaHeading(
              'Next class',
              style: theme.textTheme.labelLarge?.copyWith(color: Brand.gold),
            ),
            const SizedBox(height: 8),
            Text(
              '${meeting.course} · ${meeting.building.name} '
              '${meeting.room} · $start',
              style: theme.textTheme.titleMedium?.copyWith(color: onNavy),
            ),
            Text(
              meeting.title,
              style: theme.textTheme.bodyMedium?.copyWith(color: onNavy),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Brand.gold,
                foregroundColor: Brand.navy,
                minimumSize: const Size(48, 48),
              ),
              onPressed: () => openTripPlanner(
                context,
                name: meeting.building.name,
                coordinate: meeting.building.coordinate,
              ),
              icon: const Icon(Icons.directions),
              label: Text('Directions to ${meeting.building.name}'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Today's dining hall hours. Open or closed is spelled out, not just
/// coloured.
class DiningCard extends StatelessWidget {
  const DiningCard({super.key, required this.halls});

  final List<DiningHall> halls;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Column(
        children: [
          for (final hall in halls)
            MergeSemantics(
              child: ListTile(
                leading: ExcludeSemantics(
                  child: Icon(
                    hall.isOpen ? Icons.restaurant : Icons.no_meals_outlined,
                  ),
                ),
                title: Text(hall.name),
                subtitle: Text(
                  '${hall.isOpen ? 'Open' : 'Closed'} · ${hall.hours}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// One event, tappable through to its detail page.
class FeaturedEventCard extends StatelessWidget {
  const FeaturedEventCard({super.key, required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      contentPadding: const EdgeInsetsDirectional.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: const ExcludeSemantics(child: Icon(Icons.event)),
      title: Text(event.title),
      subtitle: Text('${event.when} · ${event.venue.name}'),
      trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
      onTap: () => EventDetailPage.push(context, event),
    ),
  );
}

/// The trip the student chose in the SDK trip planner: when to leave, the
/// first route, and where it goes, with a way to clear it. With no trip
/// chosen, a prompt to plan one; never made-up times.
class ChosenTripCard extends StatelessWidget {
  const ChosenTripCard({super.key});

  @override
  Widget build(BuildContext context) {
    final trip = ChosenTripScope.of(context);
    final itinerary = trip.itinerary;
    final theme = Theme.of(context);
    if (itinerary == null) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ObaHeading('Your trip', style: theme.textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'No trip planned. Plan one and open the itinerary you want, '
                'and this card shows when to leave.',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(48, 48),
                ),
                onPressed: () => openTripPlanner(context),
                icon: const Icon(Icons.directions),
                label: const Text('Plan a trip'),
              ),
            ],
          ),
        ),
      );
    }
    final leaveAt = MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(itinerary.startTime.toLocal()));
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ObaHeading('Your trip', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            // A live region: screen readers hear the new time when the
            // student picks another itinerary.
            Semantics(
              liveRegion: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ExcludeSemantics(child: Icon(Icons.directions_walk)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Leave by $leaveAt · ${tripRouteLabel(itinerary)}',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'To ${trip.destination}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              style: TextButton.styleFrom(minimumSize: const Size(48, 48)),
              onPressed: trip.clear,
              icon: const Icon(Icons.close),
              label: const Text('Clear trip'),
            ),
          ],
        ),
      ),
    );
  }
}
