import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit/src/features/bookmarks/departure_line.dart';

import '../support/oba_test_harness.dart';

void main() {
  final now = DateTime.utc(2026, 11, 25, 12);
  ArrivalAndDeparture departure({String? status}) => ArrivalAndDeparture(
    routeId: '1_100479',
    tripId: 't',
    serviceDate: DateTime.utc(2026, 11, 25),
    stopId: '1_75403',
    stopSequence: 3,
    routeShortName: '49',
    tripHeadsign: 'Broadway',
    scheduledDepartureTime: now.add(const Duration(minutes: 5)),
    scheduledArrivalTime: now.add(const Duration(minutes: 5)),
    tripStatus: TripStatus(status: status),
  );

  // Bookmarks, nearby and the stop page share one status implementation, so
  // a canceled trip reads "canceled" in every list.
  for (final (name, build) in <(String, Widget Function(ArrivalAndDeparture))>[
    ('bookmarks', (a) => DepartureLine(arrival: a, now: now)),
    (
      'nearby',
      (a) => NearbyDepartureTile(
        stop: const Stop(id: '1_75403', name: 'Pine St', lat: 0, lon: 0),
        arrival: a,
        now: now,
      ),
    ),
  ]) {
    testWidgets('$name rows show canceled trips as canceled', (tester) async {
      final env = await ObaTestEnv.create();
      addTearDown(env.dispose);
      await env.pumpPage(
        tester,
        Scaffold(body: build(departure(status: 'CANCELED'))),
      );
      expect(find.text('canceled'), findsOneWidget);
      await env.pumpPage(tester, Scaffold(body: build(departure())));
      expect(find.text('canceled'), findsNothing);
      expect(find.text('scheduled'), findsOneWidget);
      expect(find.text('5 min'), findsOneWidget);
    });
  }
}
