import 'dart:convert';

import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

List<TripStopEntry> entries(int n, {List<String>? ids}) => [
  for (var i = 0; i < n; i++)
    TripStopEntry(
      stopId: ids?[i] ?? 's$i',
      name: 'Stop $i',
      scheduledArrival: DateTime.utc(2024, 1, 1, 8, i),
    ),
];

void main() {
  test('no vehicle: nothing passed, no groups', () {
    final list = TripStopList.build(entries(5), userStopId: 's2');
    expect(list.vehicleIndex, isNull);
    expect(list.userIndex, 2);
    expect(list.groups, isEmpty);
    expect(list.rows.where((r) => r.isPassed), isEmpty);
    expect(list.rows.last.isTerminal, isTrue);
    expect(list.items().length, 5);
  });

  test('passed stops collapse; far approaching stops collapse', () {
    final list = TripStopList.build(
      entries(15),
      userStopId: 's12',
      closestStopId: 's4',
    );
    expect(list.vehicleIndex, 4);
    expect(list.rows[3].isPassed, isTrue);
    expect(list.rows[4].isVehicleHere, isTrue);
    final groups = list.groups;
    expect(groups.map((g) => g.id), ['passed', 'approaching']);
    expect((groups[0].start, groups[0].end), (0, 4));
    expect((groups[1].start, groups[1].end), (5, 12));
    expect(groups[0].firstDate, DateTime.utc(2024, 1, 1, 8, 0));
    expect(groups[0].lastDate, DateTime.utc(2024, 1, 1, 8, 3));

    final collapsed = list.items();
    // group, vehicle stop, group, user stop, 2 more stops.
    expect(collapsed.length, 6);
    expect(collapsed.first, isA<TripStopItemGroup>());
    final expanded = list.items(expanded: {'passed'});
    expect(expanded.length, 10);
  });

  test('a one-stop passed run stays expanded', () {
    final list = TripStopList.build(entries(5), closestStopId: 's1');
    expect(list.groups, isEmpty);
  });

  test('the user stop splits the passed run', () {
    final list = TripStopList.build(
      entries(10),
      userStopId: 's3',
      closestStopId: 's8',
    );
    expect(list.groups.map((g) => g.id), ['passed-before-your-stop', 'passed']);
    expect(list.items().whereType<TripStopItemStop>().map((s) => s.row.index), [
      3,
      8,
      9,
    ]);
  });

  test('stop sequence picks the right visit of a loop trip', () {
    final list = TripStopList.build(
      entries(5, ids: ['a', 'b', 'c', 'b', 'd']),
      userStopId: 'b',
      userStopSequence: 3,
    );
    expect(list.userIndex, 3);
  });

  test('vehicle index prefers the visit before the user stop', () {
    final list = TripStopList.build(
      entries(5, ids: ['a', 'b', 'c', 'b', 'd']),
      userStopId: 'c',
      closestStopId: 'b',
    );
    expect(list.vehicleIndex, 1);
  });

  test('shared destination marks the boarding stop and the ride', () {
    final list = TripStopList.build(
      entries(8),
      userStopId: 's2',
      destinationStopId: 's5',
    );
    expect(list.userIndex, 5);
    expect(list.boardingIndex, 2);
    expect(list.rows[2].isBoardingStop, isTrue);
    expect(list.rows[1].isOutsideRide, isTrue);
    expect(list.rows[3].isOutsideRide, isFalse);
    expect(list.rows[6].isOutsideRide, isTrue);
  });

  test('entries from a trip-details fixture', () {
    final data = jsonDecode(fixture('trip_details_1_18196913.json'))['data'];
    final e = TripStopEntry.fromTripDetails(
      TripDetails.fromJson(data['entry']),
      References.fromJson(data['references']),
    );
    expect(e, isNotEmpty);
    expect(e.first.name, isNot(e.first.stopId));
    expect(e.first.scheduledArrival, isNotNull);
  });
}
