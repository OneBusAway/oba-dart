import 'dart:convert';

import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  final json = jsonDecode(
    fixture('arrivals_and_departures_for_stop_1_10020.json'),
  );
  final data = json['data'] as Map<String, dynamic>;
  final entry = StopWithArrivalsAndDepartures.fromJson(data['entry']);
  final refs = References.fromJson(data['references']);
  final now = DateTime.fromMillisecondsSinceEpoch(json['currentTime'] as int);

  StopDepartures build({
    StopPreferences prefs = const StopPreferences(),
    ArrivalDepartureFilter filter = ArrivalDepartureFilter.all,
    bool showHidden = false,
    int? walk,
  }) => StopDepartures.build(
    entry.arrivalsAndDepartures,
    references: refs,
    now: now,
    preferences: prefs,
    filter: filter,
    showHiddenRoutes: showHidden,
    walkMinutes: walk,
  );

  test('splits past and upcoming, sorted', () {
    final d = build();
    expect(d.all.length, 4);
    expect(d.past.length, 2);
    expect(d.upcoming.length, 2);
    expect(d.walkDividerIndex, isNull);
    expect(d.groups.length, 2);
  });

  test('walk divider index within upcoming', () {
    // Upcoming rows are ~21 and ~22 minutes away.
    expect(build(walk: 22).walkDividerIndex, 1);
    expect(build(walk: 5).walkDividerIndex, isNull);
    expect(build(walk: 60).walkDividerIndex, 2);
  });

  test('hidden routes, and the reason for an empty list', () {
    final routes = entry.arrivalsAndDepartures.map((a) => a.routeId).toSet();
    final prefs = StopPreferences(hiddenRoutes: routes.toList());
    final d = build(prefs: prefs);
    expect(d.isEmpty, isTrue);
    expect(d.isEmptyBecauseOfHiddenRoutes, isTrue);
    expect(build(prefs: prefs, showHidden: true).all.length, 4);
  });

  test('departure-type filter', () {
    final d = build(filter: ArrivalDepartureFilter.scheduledOnly);
    expect(d.isEmpty, isTrue);
    expect(d.isEmptyBecauseOfFilter, isTrue);
    expect(d.hiddenByFilter, 4);
  });
}
