import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:onebusaway/onebusaway.dart';

final serviceDate = DateTime.utc(2026, 9, 24);
final now = DateTime.utc(2026, 9, 24, 14, 0);

ArrivalAndDeparture a(
  String trip, {
  required int minutesFromNow,
  int stopSequence = 3,
  int? totalStopsInTrip = 10,
  int? blockTripSequence,
  String? vehicleId,
}) =>
    ArrivalAndDeparture(
      routeId: 'R',
      tripId: trip,
      serviceDate: serviceDate,
      stopId: 'S',
      stopSequence: stopSequence,
      totalStopsInTrip: totalStopsInTrip,
      blockTripSequence: blockTripSequence,
      vehicleId: vehicleId,
      scheduledArrivalTime: now.add(Duration(minutes: minutesFromNow)),
    );

void main() {
  test('filterDeparted drops negative ETAs and rows without times', () {
    final rows = [
      a('past', minutesFromNow: -1),
      a('now', minutesFromNow: 0),
      a('soon', minutesFromNow: 5),
      ArrivalAndDeparture(
          routeId: 'R', tripId: 'none', serviceDate: serviceDate, stopId: 'S', stopSequence: 1),
    ];
    expect(filterDeparted(rows, now).map((r) => r.tripId), ['now', 'soon']);
  });

  group('collapseLayovers', () {
    final arrivalAtEnd = a('t1',
        minutesFromNow: 2, stopSequence: 9, blockTripSequence: 4, vehicleId: 'V1');
    final departureNext = a('t2',
        minutesFromNow: 6, stopSequence: 0, blockTripSequence: 5, vehicleId: 'V1');

    test('drops the final-stop arrival when the same vehicle departs next', () {
      expect(collapseLayovers([arrivalAtEnd, departureNext]).map((r) => r.tripId), ['t2']);
    });

    test('keeps it when vehicle differs', () {
      final other = a('t2',
          minutesFromNow: 6, stopSequence: 0, blockTripSequence: 5, vehicleId: 'V2');
      expect(collapseLayovers([arrivalAtEnd, other]), hasLength(2));
    });

    test('keeps it when block sequence is not +1', () {
      final later = a('t2',
          minutesFromNow: 6, stopSequence: 0, blockTripSequence: 6, vehicleId: 'V1');
      expect(collapseLayovers([arrivalAtEnd, later]), hasLength(2));
    });

    test('keeps it without a vehicle id', () {
      final noVehicle =
          a('t1', minutesFromNow: 2, stopSequence: 9, blockTripSequence: 4);
      expect(collapseLayovers([noVehicle, departureNext]), hasLength(2));
    });
  });

  test('visibleArrivals filters then collapses and keeps server order', () {
    final rows = [
      a('late-in-list', minutesFromNow: 9),
      a('gone', minutesFromNow: -2),
      a('early-in-list', minutesFromNow: 1),
    ];
    expect(visibleArrivals(rows, now).map((r) => r.tripId),
        ['late-in-list', 'early-in-list']);
  });
}
