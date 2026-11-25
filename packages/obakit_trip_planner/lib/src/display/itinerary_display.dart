import '../api/api.dart';

/// How a leg is travelled, for icons, colours and instructions.
enum LegKind {
  walk,
  bike,
  rentalBike,
  car,
  transit;

  static LegKind of(Leg leg) {
    if (leg.rentedBike) return rentalBike;
    return switch (leg.legMode) {
      LegMode.walk => walk,
      LegMode.bicycle => bike,
      LegMode.car => car,
      null => leg.transitLeg ? transit : walk,
      _ => transit,
    };
  }
}

/// One chip in an itinerary's leg summary.
class LegSummaryItem {
  const LegSummaryItem({required this.kind, required this.leg, this.routeName});

  final LegKind kind;
  final Leg leg;

  /// The route's short name for transit legs; null otherwise.
  final String? routeName;

  LegMode? get legMode => leg.legMode;
  int get durationSeconds => leg.duration;
}

/// The chips summarizing [itinerary]: one per relevant leg (short walks
/// dropped, same-route legs merged). An itinerary that is nothing but short
/// walks still gets one walk chip.
List<LegSummaryItem> legSummary(Itinerary itinerary) {
  var legs = itinerary.relevantLegs;
  if (legs.isEmpty && itinerary.legs.isNotEmpty) legs = [itinerary.legs.first];
  return [
    for (final leg in legs)
      LegSummaryItem(
        kind: LegKind.of(leg),
        leg: leg,
        routeName: LegKind.of(leg) == LegKind.transit ? leg.routeName : null,
      ),
  ];
}

/// The first transit leg, whose departure is the time that matters most.
Leg? firstTransitLeg(Itinerary itinerary) {
  for (final leg in itinerary.legs) {
    if (LegKind.of(leg) == LegKind.transit) return leg;
  }
  return null;
}

/// True when the trip involves transit and any transit leg has real-time
/// data.
bool hasRealTimeData(Itinerary itinerary) => itinerary.legs.any(
  (leg) => LegKind.of(leg) == LegKind.transit && leg.realTime,
);

/// The turn a walking [LegStep] asks for (OTPKit `RelativeDirection`).
enum RelativeDirection {
  depart('DEPART'),
  hardLeft('HARD_LEFT'),
  left('LEFT'),
  slightlyLeft('SLIGHTLY_LEFT'),
  continueStraight('CONTINUE'),
  slightlyRight('SLIGHTLY_RIGHT'),
  right('RIGHT'),
  hardRight('HARD_RIGHT'),
  circleClockwise('CIRCLE_CLOCKWISE'),
  circleCounterclockwise('CIRCLE_COUNTERCLOCKWISE'),
  elevator('ELEVATOR'),
  uturnLeft('UTURN_LEFT'),
  uturnRight('UTURN_RIGHT'),
  enterStation('ENTER_STATION'),
  exitStation('EXIT_STATION'),
  followSigns('FOLLOW_SIGNS');

  const RelativeDirection(this.wireValue);

  final String wireValue;

  static RelativeDirection? fromOtp(String? token) {
    if (token == null) return null;
    final normalized = token.trim().toUpperCase().replaceAll(' ', '_');
    for (final direction in values) {
      if (direction.wireValue == normalized) return direction;
    }
    return null;
  }
}

/// `SPIN_AROUND` → `Spin Around`: the last-resort rendering of a token this
/// client doesn't know.
String humanizeOtpToken(String token) => token
    .split(RegExp(r'[_\s]+'))
    .where((word) => word.isNotEmpty)
    .map((w) => w[0].toUpperCase() + w.substring(1).toLowerCase())
    .join(' ');

/// Rental feeds name free-floating vehicles "Default vehicle type"; that
/// placeholder must never reach the UI.
bool isPlaceholderPlaceName(Place place) {
  final name = place.name.trim();
  return name.isEmpty || name.toLowerCase() == 'default vehicle type';
}
