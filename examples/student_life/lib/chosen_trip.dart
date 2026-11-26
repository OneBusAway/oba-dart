import 'package:flutter/widgets.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

/// The trip the student last chose in the SDK trip planner, and where it
/// goes.
///
/// Set from `TripPlannerRoute.onItinerarySelected` (see `openTripPlanner`)
/// and shown on Today. In memory only: a real app might persist it and
/// drop it once its start time has passed.
class ChosenTrip extends ChangeNotifier {
  tp.Itinerary? _itinerary;
  String? _destination;

  tp.Itinerary? get itinerary => _itinerary;

  /// The destination's name.
  String? get destination => _destination;

  void choose(tp.Itinerary itinerary, {required String destination}) {
    _itinerary = itinerary;
    _destination = destination;
    notifyListeners();
  }

  void clear() {
    if (_itinerary == null) return;
    _itinerary = null;
    _destination = null;
    notifyListeners();
  }
}

/// Provides the app's [ChosenTrip]. Sits above the navigator, so pushed
/// routes (the trip planner among them) can set it.
class ChosenTripScope extends InheritedNotifier<ChosenTrip> {
  const ChosenTripScope({
    super.key,
    required ChosenTrip trip,
    required super.child,
  }) : super(notifier: trip);

  /// Rebuilds the caller when the trip changes.
  static ChosenTrip of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ChosenTripScope>()!.notifier!;

  /// Reads the trip without depending on it (for callbacks).
  static ChosenTrip? read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ChosenTripScope>()?.notifier;
}

/// What Today shows for a chosen trip: the first transit leg's route short
/// name, or its mode, or "Walk" for a walking-only trip.
String tripRouteLabel(tp.Itinerary itinerary) {
  for (final leg in itinerary.legs) {
    if (leg.transitLeg) {
      final name = leg.routeShortName;
      if (name != null && name.isNotEmpty) return name;
      return _modeLabel(leg.mode);
    }
  }
  return 'Walk';
}

String _modeLabel(String mode) => switch (mode.toUpperCase()) {
  'BUS' => 'Bus',
  'TRAM' => 'Light rail',
  'RAIL' => 'Train',
  'SUBWAY' => 'Subway',
  'FERRY' => 'Ferry',
  _ => mode.isEmpty ? 'Transit' : mode[0] + mode.substring(1).toLowerCase(),
};
