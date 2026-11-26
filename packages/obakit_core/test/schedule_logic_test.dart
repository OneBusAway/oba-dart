import 'dart:convert';

import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

(Map<String, dynamic>, References) load(String name) {
  final data = jsonDecode(fixture(name))['data'] as Map<String, dynamic>;
  return (
    data['entry'] as Map<String, dynamic>,
    References.fromJson(data['references']),
  );
}

void main() {
  test('stop schedule: routes in natural order, departures sorted', () {
    final (entry, refs) = load('schedule-for-stop_1_75403.json');
    final routes = stopScheduleRoutes(ScheduleForStop.fromJson(entry), refs);
    expect(routes, isNotEmpty);
    final names = routes.map((r) => r.displayName).toList();
    expect(names, [...names]..sort(naturalCompare));
    for (final r in routes) {
      for (final d in r.directions) {
        for (var i = 1; i < d.departures.length; i++) {
          expect(
            d.departures[i].time.isBefore(d.departures[i - 1].time),
            isFalse,
          );
        }
      }
    }
    expect(routes.first.departureCount, greaterThan(0));
  });

  test('groupByHour buckets consecutive times', () {
    final t = [
      DateTime(2024, 1, 1, 6, 5),
      DateTime(2024, 1, 1, 6, 45),
      DateTime(2024, 1, 1, 7, 10),
      DateTime(2024, 1, 2, 0, 15),
    ];
    final g = groupByHour(t, (d) => d, local: (d) => d);
    expect(g.map((e) => e.$1), [6, 7, 0]);
    expect(g.first.$2.length, 2);
  });

  test('route timetable: trips by start, null where skipped', () {
    final (entry, refs) = load('schedule-for-route_1_100223.json');
    final schedule = ScheduleForRoute.fromJson(entry);
    final dirs = routeTimetable(schedule, refs);
    expect(dirs.length, 2);
    final d = dirs.first;
    expect(d.stops, isNotEmpty);
    expect(d.stops.first.$2, isNotNull);
    expect(d.times.length, d.tripIds.length);
    for (final row in d.times) {
      expect(row.length, d.stops.length);
    }
    final firstStop = d.timesAtStop(0);
    for (var i = 1; i < firstStop.length; i++) {
      expect(firstStop[i].isBefore(firstStop[i - 1]), isFalse);
    }
    expect(firstStop.first.isAfter(schedule.scheduleDate), isTrue);
    expect(d.indexOfStop(d.stops.last.$1), d.stops.length - 1);
    expect(d.indexOfStop('nope'), isNull);
  });
}
