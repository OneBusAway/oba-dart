import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';

void main() {
  late ObaTestEnv env;
  setUp(() async {
    env = await ObaTestEnv.create(
      responses: {
        'schedule-for-stop': fixture('schedule-for-stop_1_75403.json'),
        'schedule-for-route': fixture('schedule-for-route_1_100223.json'),
      },
    );
  });
  tearDown(() => env.dispose());

  final date = DateTime(2025, 12, 6);

  group('stop schedule', () {
    testWidgets('routes, directions and hours', (tester) async {
      await env.pumpPage(
        tester,
        StopSchedulePage(stopId: '1_75403', date: date),
      );
      expect(
        find.textContaining('East Stevens Way NE & Benton Ln'),
        findsWidgets,
      );
      expect(find.widgetWithText(ChoiceChip, '45'), findsOneWidget);
      expect(find.widgetWithText(ChoiceChip, '372'), findsOneWidget);
      expect(find.textContaining('To Loyal Heights Greenwood'), findsOneWidget);
      expect(find.byType(ScheduleHourRow), findsWidgets);
      expect(env.requests.last.url.queryParameters['date'], '2025-12-06');
      await tester.tap(find.widgetWithText(ChoiceChip, '67'));
      await tester.pumpAndSettle();
      expect(
        find.textContaining('To Northgate Station Roosevelt Station'),
        findsOneWidget,
      );
    });

    testWidgets('next day refetches', (tester) async {
      await env.pumpPage(
        tester,
        StopSchedulePage(stopId: '1_75403', date: date),
      );
      await tester.tap(find.byTooltip('Next day'));
      await ObaTestEnv.settle(tester);
      expect(env.requests.last.url.queryParameters['date'], '2025-12-07');
    });

    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets('accessibility (${mode.name})', (tester) async {
        await env.pumpPage(
          tester,
          StopSchedulePage(stopId: '1_75403', date: date),
          themeMode: mode,
        );
        await expectObaAccessibility(tester);
      });
    }

    testWidgets('no overflow at 200% text', (tester) async {
      await env.expectNoOverflowAtTextScale(
        tester,
        StopSchedulePage(stopId: '1_75403', date: date),
      );
    });
  });

  group('route schedule', () {
    testWidgets('list by stop, direction switch, grid', (tester) async {
      await env.pumpPage(
        tester,
        RouteSchedulePage(routeId: '1_100223', date: date, stopId: '1_41904'),
      );
      expect(find.textContaining('43'), findsWidgets);
      expect(find.textContaining('(your stop)'), findsOneWidget);
      expect(find.byType(ScheduleHourRow), findsWidgets);
      await tester.tap(
        find.text('To Capitol Hill University Of Washington Medical Center'),
      );
      await tester.pumpAndSettle();
      expect(find.byType(ScheduleHourRow), findsWidgets);
      await tester.tap(find.text('Grid'));
      await tester.pumpAndSettle();
      expect(find.byType(Table), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('stop picker', (tester) async {
      await env.pumpPage(
        tester,
        RouteSchedulePage(routeId: '1_100223', date: date),
      );
      await tester.tap(find.text('Stop'));
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsWidgets);
    });

    testWidgets('embedded', (tester) async {
      await env.pumpPage(
        tester,
        RouteSchedulePage(routeId: '1_100223', date: date),
        presentation: ObaPresentation.embedded,
      );
      expect(find.byType(ScheduleHourRow), findsWidgets);
    });

    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      testWidgets('accessibility (${mode.name})', (tester) async {
        await env.pumpPage(
          tester,
          RouteSchedulePage(routeId: '1_100223', date: date),
          themeMode: mode,
        );
        await expectObaAccessibility(tester);
      });
    }

    testWidgets('no overflow at 200% text (list and grid)', (tester) async {
      await env.expectNoOverflowAtTextScale(
        tester,
        RouteSchedulePage(routeId: '1_100223', date: date),
      );
      await tester.tap(find.text('Grid'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}
