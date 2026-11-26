import 'campus.dart';

/// A campus event (mock data).
class CampusEvent {
  const CampusEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.when,
    required this.venue,
    required this.description,
  });

  final String id;
  final String title;
  final String category;

  /// Display text; real data would carry a start and end time.
  final String when;
  final CampusPlace venue;
  final String description;
}

const campusEvents = [
  CampusEvent(
    id: 'career-fair',
    title: 'Winter Career Fair',
    category: 'Careers',
    when: 'Thursday, 10 AM – 2 PM',
    venue: CampusPlaces.priceCenter,
    description:
        'Meet more than 120 employers hiring for internships and full-time '
        'roles. Bring copies of your résumé; professional dress is '
        'recommended.',
  ),
  CampusEvent(
    id: 'basketball',
    title: 'Tritons Basketball vs. UC Irvine',
    category: 'Athletics',
    when: 'Saturday, 7 PM',
    venue: CampusPlaces.rimacArena,
    description:
        'Cheer on the Tritons in a Big West rivalry game. Free entry with '
        'your student ID; doors open at 6 PM.',
  ),
  CampusEvent(
    id: 'study-jam',
    title: 'Finals Study Jam',
    category: 'Academics',
    when: 'Sunday, 6 PM – midnight',
    venue: CampusPlaces.geiselLibrary,
    description:
        'Late-night study space with tutors, snacks and quiet rooms on '
        'floors 2 and 8.',
  ),
];

/// The event shown on the Today feed.
CampusEvent get featuredEvent => campusEvents.first;
