import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';

void main() {
  late ObaTestEnv env;
  tearDown(() => env.dispose());

  final trip = TripRef(
    tripId: '1_18196913',
    serviceDate: DateTime.utc(2012, 7, 30, 7),
    stopId: '1_29930',
    vehicleId: '1_4011',
  );

  Future<void> scrollTap(WidgetTester tester, Finder f) async {
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await ObaTestEnv.settle(tester);
  }

  group('stop problem', () {
    testWidgets('validates, sends code, comment and no location', (
      tester,
    ) async {
      env = await ObaTestEnv.create(
        responses: {'report-problem': fixture('report_stop_problem.json')},
        location: ObaLocation(
          lat: 47.6,
          lon: -122.3,
          timestamp: DateTime(2024),
        ),
        permission: LocationPermissionStatus.whileInUse,
      );
      await env.pumpPage(tester, const ReportStopProblemPage(stopId: '1_1'));
      await scrollTap(tester, find.text('Send report'));
      expect(find.text('Choose a problem first.'), findsOneWidget);
      expect(env.requests, isEmpty);

      await tester.tap(find.text('The stop name is wrong'));
      await tester.enterText(find.byType(TextField), 'Wrong name');
      await scrollTap(tester, find.text('Share my location'));
      await scrollTap(tester, find.text('Send report'));
      final q = env.requests.single.url.queryParameters;
      expect(q['code'], 'stop_name_wrong');
      expect(q['userComment'], 'Wrong name');
      expect(q.containsKey('userLat'), isFalse);
      expect(find.text('Thanks! Your report was sent.'), findsOneWidget);
    });

    testWidgets('failure is shown', (tester) async {
      env = await ObaTestEnv.create(responses: {'report-problem': '{bad'});
      await env.pumpPage(tester, const ReportStopProblemPage(stopId: '1_1'));
      await tester.tap(find.text('Something else'));
      await scrollTap(tester, find.text('Send report'));
      expect(
        find.text("Couldn't send the report. Please try again."),
        findsOneWidget,
      );
    });

    testWidgets('a report is not sent after the region changes', (
      tester,
    ) async {
      env = await ObaTestEnv.create(
        responses: {'report-problem': fixture('report_stop_problem.json')},
      );
      await env.pumpPage(tester, const ReportStopProblemPage(stopId: '1_1'));
      await tester.tap(find.text('Something else'));
      final regions = env.app.core.regions;
      regions.automaticallySelectRegion = false;
      regions.setCurrentRegion(
        regions.regions.firstWhere((r) => r.id != regions.currentRegion!.id),
      );
      await ObaTestEnv.settle(tester);
      await scrollTap(tester, find.text('Send report'));
      expect(
        env.requests.where((r) => r.url.path.contains('report-problem')),
        isEmpty,
      );
      expect(
        find.text("Couldn't send the report. Please try again."),
        findsOneWidget,
      );
    });

    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets('accessibility (${mode.name})', (tester) async {
        env = await ObaTestEnv.create();
        await env.pumpPage(
          tester,
          const ReportStopProblemPage(stopId: '1_1'),
          themeMode: mode,
        );
        await expectObaAccessibility(tester);
      });
    }

    testWidgets('no overflow at 200% text', (tester) async {
      env = await ObaTestEnv.create();
      await env.expectNoOverflowAtTextScale(
        tester,
        const ReportStopProblemPage(stopId: '1_1'),
      );
    });
  });

  group('trip problem', () {
    testWidgets('without an arrival: by trip id, with vehicle number', (
      tester,
    ) async {
      env = await ObaTestEnv.create(
        responses: {'report-problem': fixture('report_trip_problem.json')},
      );
      await env.pumpPage(tester, ReportTripProblemPage(trip: trip));
      await tester.tap(find.text('It came late'));
      await scrollTap(tester, find.text("I'm on this vehicle"));
      await tester.enterText(
        find.widgetWithText(TextField, 'Vehicle number (optional)'),
        '4011',
      );
      await scrollTap(tester, find.text('Send report'));
      final q = env.requests.single.url.queryParameters;
      expect(q['tripId'], '1_18196913');
      expect(q['code'], 'vehicle_came_late');
      expect(q['userOnVehicle'], 'true');
      expect(q['vehicleId'], '4011');
      expect(q['stopId'], '1_29930');
    });

    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets('accessibility (${mode.name})', (tester) async {
        env = await ObaTestEnv.create();
        await env.pumpPage(
          tester,
          ReportTripProblemPage(trip: trip),
          themeMode: mode,
        );
        await expectObaAccessibility(tester);
      });
    }

    testWidgets('no overflow at 200% text', (tester) async {
      env = await ObaTestEnv.create();
      await env.expectNoOverflowAtTextScale(
        tester,
        ReportTripProblemPage(trip: trip),
      );
    });
  });
}
