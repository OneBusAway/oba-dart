import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';

final trip = TripRef(
  tripId: '1_18196913',
  serviceDate: DateTime.fromMillisecondsSinceEpoch(1343631600000),
  stopId: '1_29930',
  stopSequence: 10,
  vehicleId: '1_4011',
);

Future<ObaTestEnv> makeEnv({bool withArrival = true}) => ObaTestEnv.create(
  responses: {
    'trip-details': fixture('trip_details_1_18196913.json'),
    if (withArrival)
      'arrival-and-departure-for-stop': fixture(
        'arrival_for_trip_1_18196913.json',
      ),
    'shape': fixture('shape_1_20010002.json'),
  },
);

void main() {
  late ObaTestEnv env;
  tearDown(() => env.dispose());

  testWidgets('summary, collapsed runs, vehicle and rider stop', (
    tester,
  ) async {
    env = await makeEnv();
    await env.pumpPage(
      tester,
      TripPage(trip: trip),
      surfaceSize: const Size(800, 2400),
    );
    expect(find.text('65 · LAKE CITY WEDGWOOD'), findsWidgets);
    expect(find.text('7 stops away · 1.4 mi'), findsNothing);
    expect(find.textContaining('7 stops away'), findsOneWidget);
    expect(find.text('At NE 45TH ST & 36TH AVE NE'), findsOneWidget);
    expect(find.textContaining('2 min late'), findsOneWidget);
    expect(find.textContaining('3 passed stops'), findsOneWidget);
    expect(find.textContaining('6 stops before your stop'), findsOneWidget);
    expect(find.text('Vehicle is here'), findsOneWidget);
    expect(find.text('Your stop'), findsOneWidget);

    const firstStop = 'ROOSEVELT WAY NE & NE 42ND ST';
    expect(find.text(firstStop), findsNothing);
    await tester.tap(find.textContaining('3 passed stops'));
    await tester.pumpAndSettle();
    expect(find.text(firstStop), findsOneWidget);
  });

  testWidgets('block trips, stops and actions navigate', (tester) async {
    env = await makeEnv();
    final pushed = <ObaRoute>[];
    await env.pumpPage(
      tester,
      TripPage(trip: trip),
      onNavigate: (_, r) {
        pushed.add(r);
        return true;
      },
    );
    await tester.tap(find.textContaining('Starts as 67'));
    expect((pushed.last as TripRoute).trip.tripId, '1_18196851');
    await tester.tap(find.textContaining('Continues as 65'));
    expect((pushed.last as TripRoute).trip.tripId, '1_18196555');

    await tester.tap(find.text('Report a problem with this trip'));
    final report = pushed.last as ReportTripProblemRoute;
    expect(report.arrival?.tripId, '1_18196913');

    await tester.tap(find.text('All stops on this route'));
    expect(pushed.last, const RouteStopsRoute('1_65'));

    await tester.tap(find.text('Bookmark this trip'));
    expect(pushed.last, isA<BookmarkEditorRoute>());

    await tester.scrollUntilVisible(find.text('Last stop'), 200);
    await tester.tap(find.text('Last stop'));
    expect(pushed.last, const StopRoute('1_76680'));
  });

  testWidgets('without an arrival: stop list only', (tester) async {
    env = await makeEnv(withArrival: false);
    await env.pumpPage(
      tester,
      TripPage(
        trip: TripRef(tripId: '1_18196913', serviceDate: trip.serviceDate),
      ),
    );
    expect(find.text('Stops'), findsOneWidget);
    expect(find.text('No real-time position for this vehicle'), findsOneWidget);
    expect(find.byType(TripStopTile), findsWidgets);
    await tester.scrollUntilVisible(find.text('Last stop'), 300);
    expect(find.text('Last stop'), findsOneWidget);
  });

  testWidgets('error and retry', (tester) async {
    env = await ObaTestEnv.create(responses: {'trip-details': '{bad'});
    await env.pumpPage(tester, TripPage(trip: trip));
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('map overlay: shape, stops and vehicle', (tester) async {
    env = await makeEnv();
    final map = ObaMapCoordinator();
    addTearDown(map.dispose);
    await env.pumpPage(tester, TripPage(trip: trip), coordinator: map);
    expect(map.overlay.stops.length, 53);
    expect(map.overlay.markers.single.kind, ObaMapMarkerKind.vehicle);
    expect(map.overlay.polylines, isNotEmpty);
    expect(env.requests.any((r) => r.url.path.contains('shape')), isTrue);
    // The camera fits the trip.
    final fit = map.overlay.fitBounds!;
    final first = map.overlay.polylines.first.points.first;
    expect(fit.contains(first.lat, first.lon), isTrue);
  });

  testWidgets('embedded', (tester) async {
    env = await makeEnv();
    await env.pumpPage(
      tester,
      TripPage(trip: trip),
      presentation: ObaPresentation.embedded,
    );
    expect(find.text('Stops'), findsOneWidget);
  });

  for (final mode in [ThemeMode.light, ThemeMode.dark]) {
    testWidgets('accessibility (${mode.name})', (tester) async {
      env = await makeEnv();
      await env.pumpPage(tester, TripPage(trip: trip), themeMode: mode);
      await expectObaAccessibility(tester);
    });
  }

  testWidgets('no overflow at 200% text', (tester) async {
    env = await makeEnv();
    await env.expectNoOverflowAtTextScale(tester, TripPage(trip: trip));
  });
}
