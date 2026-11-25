import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';
import 'bookmarks_support.dart';

const _alertStop = 'MTS_11670';

/// Fixture time for `..._mts_11670_route_alerts.json`.
final _alertsNow = DateTime.fromMillisecondsSinceEpoch(1474553212655);

Future<T> atAlertsTime<T>(Future<T> Function() body) =>
    withClock(Clock.fixed(_alertsNow), body);

String alertsFixture() =>
    fixture('arrivals_and_departures_for_stop_mts_11670_route_alerts.json');

/// The alerts fixture with every situation set to [severity].
String alertsWithSeverity(String severity) {
  final json = jsonDecode(alertsFixture()) as Map<String, dynamic>;
  for (final s in json['data']['references']['situations'] as List) {
    (s as Map<String, dynamic>)['severity'] = severity;
  }
  return jsonEncode(json);
}

Situation firstSituation({String severity = ''}) {
  final json = jsonDecode(alertsFixture()) as Map<String, dynamic>;
  final s =
      (json['data']['references']['situations'] as List).first
          as Map<String, dynamic>;
  s['severity'] = severity;
  return Situation.fromJson(s);
}

void main() {
  late ObaTestEnv env;

  tearDown(() => env.dispose());

  group('alerts list', () {
    testWidgets('lists a stop\'s alerts with unread markers and detail links', (
      tester,
    ) async {
      await atAlertsTime(() async {
        env = await ObaTestEnv.create(
          responses: {'arrivals-and-departures-for-stop': alertsFixture()},
        );
        final nav = RecordingNavigator();
        await env.pumpPage(
          tester,
          withNavigator(nav, const AlertsListPage(stopId: _alertStop)),
        );
        expect(find.textContaining('Concrete Pour'), findsWidgets);
        expect(find.textContaining('unread alerts'), findsOneWidget);
        expect(find.text('Unread · Service alert'), findsWidgets);
        await expectObaAccessibility(tester);

        await tester.tap(find.textContaining('Concrete Pour').first);
        expect(nav.pushed.single, isA<AlertDetailRoute>());

        await tester.tap(find.byTooltip('Mark all as read'));
        await tester.pump();
        expect(find.textContaining('0 unread alerts'), findsOneWidget);
        expect(find.text('Unread · Service alert'), findsNothing);
      });
    });

    testWidgets('a route scope keeps only alerts naming the route', (
      tester,
    ) async {
      await atAlertsTime(() async {
        env = await ObaTestEnv.create(
          responses: {
            'arrivals-and-departures-for-stop': alertsFixture(),
            'stops-for-route': fixture('stops_for_route_1_44.json'),
          },
        );
        await env.pumpPage(tester, const AlertsListPage(routeId: 'MTS_11'));
        expect(find.textContaining('Concrete Pour'), findsWidgets);
        await env.pumpPage(tester, const AlertsListPage(routeId: 'MTS_999'));
        expect(find.text('No service alerts'), findsOneWidget);
      });
    });

    testWidgets('region-wide gathers from bookmarked stops and explains', (
      tester,
    ) async {
      await atAlertsTime(() async {
        env = await ObaTestEnv.create(
          responses: {'arrivals-and-departures-for-stop': alertsFixture()},
        );
        env.app.core.userData.addBookmark(
          stopBookmark('Work', stopId: _alertStop),
        );
        await env.pumpPage(tester, const AlertsListPage());
        expect(find.textContaining('Concrete Pour'), findsWidgets);
        expect(
          find.textContaining('bookmarked, recent and nearby'),
          findsOneWidget,
        );
      });
    });

    testWidgets('empty and error states', (tester) async {
      await atFixtureTime(() async {
        env = await arrivalsEnv();
        await env.pumpPage(tester, const AlertsListPage(stopId: kStopId));
        expect(find.text('No service alerts'), findsOneWidget);
        await expectObaAccessibility(tester);
      });
      await unmount(tester);
      env.dispose();
      env = await ObaTestEnv.create();
      await env.pumpPage(tester, const AlertsListPage(stopId: _alertStop));
      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('accessible and reflowing everywhere', (tester) async {
      await atAlertsTime(() async {
        env = await ObaTestEnv.create(
          responses: {'arrivals-and-departures-for-stop': alertsFixture()},
        );
        const page = AlertsListPage(stopId: _alertStop);
        for (final p in ObaPresentation.values) {
          for (final mode in [ThemeMode.light, ThemeMode.dark]) {
            await env.pumpPage(tester, page, presentation: p, themeMode: mode);
            await expectObaAccessibility(tester);
          }
        }
        await env.expectNoOverflowAtTextScale(tester, page);
      });
    });
  });

  group('alert detail', () {
    testWidgets('shows the alert, marks it read and opens its link', (
      tester,
    ) async {
      env = await ObaTestEnv.create();
      final alert = firstSituation(severity: 'SEVERE');
      final opened = <Uri>[];
      final nav = RecordingNavigator();
      await env.pumpPage(
        tester,
        withNavigator(
          nav,
          AlertDetailPage(
            route: AlertDetailRoute(alert),
            urlOpener: (uri) async {
              opened.add(uri);
              return true;
            },
          ),
        ),
      );
      expect(
        find.text('Concrete Pour Impacting N/B RTS 11, 901 & 929'),
        findsWidgets,
      );
      expect(find.text('Severe'), findsOneWidget);
      expect(find.textContaining('three day concrete pour'), findsOneWidget);
      expect(find.text('Active period'), findsOneWidget);
      expect(env.app.core.userData.isAlertUnread(alert.id), isFalse);
      await expectObaAccessibility(tester);

      await tester.scrollUntilVisible(find.text('Learn more'), 200);
      await tester.tap(find.text('Learn more'));
      expect(opened.single.host, 'www.sdmts.com');

      await tester.scrollUntilVisible(
        find.widgetWithText(ActionChip, '901'),
        200,
      );
      await tester.tap(find.widgetWithText(ActionChip, '901'));
      expect(nav.pushed.single, const RouteStopsRoute('MTS_901'));
    });

    testWidgets('a failed launch says so; non-web links are not offered', (
      tester,
    ) async {
      env = await ObaTestEnv.create();
      final alert = firstSituation();
      await env.pumpPage(
        tester,
        AlertDetailPage(
          route: AlertDetailRoute(alert),
          urlOpener: (_) async => false,
        ),
      );
      await tester.scrollUntilVisible(find.text('Learn more'), 200);
      await tester.tap(find.text('Learn more'));
      await tester.pump();
      expect(find.text("Couldn't open that link."), findsOneWidget);

      await env.pumpPage(
        tester,
        AlertDetailPage(
          route: AlertDetailRoute(
            Situation(
              id: 'js',
              url: const TranslatedString(value: 'javascript:alert(1)'),
            ),
          ),
        ),
      );
      expect(find.text('Learn more'), findsNothing);
      expect(find.text('No additional details available.'), findsOneWidget);
    });

    testWidgets('accessible and reflowing everywhere', (tester) async {
      env = await ObaTestEnv.create();
      final page = AlertDetailPage(
        route: AlertDetailRoute(firstSituation(severity: 'WARNING')),
      );
      for (final p in ObaPresentation.values) {
        for (final mode in [ThemeMode.light, ThemeMode.dark]) {
          await env.pumpPage(tester, page, presentation: p, themeMode: mode);
          await expectObaAccessibility(tester);
        }
      }
      await env.expectNoOverflowAtTextScale(tester, page);
    });
  });

  testWidgets('the warning icon stays readable on a host gold tertiary', (
    tester,
  ) async {
    env = await ObaTestEnv.create();
    // A host theme whose tertiary is UCSD gold: 1.5:1 on white.
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF182B49))
          .copyWith(tertiary: const Color(0xFFFFCD00), surface: Colors.white),
    );
    await env.pumpPage(
      tester,
      AlertDetailPage(
        route: AlertDetailRoute(firstSituation(severity: 'WARNING')),
      ),
      theme: theme,
    );
    final icon = tester.widget<Icon>(find.byIcon(Icons.warning_amber_outlined));
    expect(
      ObaContrast.ratio(icon.color!, Colors.white),
      greaterThanOrEqualTo(3),
    );
  });

  group('alerts section', () {
    testWidgets('shows urgent unread alerts and links to the list', (
      tester,
    ) async {
      await atAlertsTime(() async {
        env = await ObaTestEnv.create(
          responses: {
            'arrivals-and-departures-for-stop': alertsWithSeverity('SEVERE'),
          },
        );
        env.app.core.userData.addBookmark(
          stopBookmark('Work', stopId: _alertStop),
        );
        final nav = RecordingNavigator();
        await env.pumpPage(
          tester,
          withNavigator(
            nav,
            const SingleChildScrollView(child: ServiceAlertsSection()),
          ),
          presentation: ObaPresentation.embedded,
        );
        expect(find.text('Alerts'), findsOneWidget);
        expect(find.textContaining('more alert'), findsOneWidget);
        await expectObaAccessibility(tester);
        await tester.tap(find.text('See all'));
        expect(nav.pushed.single, const AlertsListRoute());
        await unmount(tester);
      });
    });

    testWidgets('renders nothing without high-severity alerts', (tester) async {
      await atAlertsTime(() async {
        env = await ObaTestEnv.create(
          responses: {'arrivals-and-departures-for-stop': alertsFixture()},
        );
        env.app.core.userData.addBookmark(
          stopBookmark('Work', stopId: _alertStop),
        );
        await env.pumpPage(
          tester,
          const ServiceAlertsSection(),
          presentation: ObaPresentation.embedded,
        );
        expect(find.text('Alerts'), findsNothing);
        await unmount(tester);
      });
    });
  });

  group('agencies', () {
    String agenciesJson() {
      final json = jsonDecode(
        fixture('2_agencies_with_coverage.json'),
      ) as Map<String, dynamic>;
      final agencies = json['data']['references']['agencies'] as List;
      final metro = agencies.firstWhere(
        (a) => (a as Map)['id'] == '1',
      ) as Map<String, dynamic>;
      metro['email'] = 'info@metro.example';
      metro['fareUrl'] = 'https://metro.example/fares';
      metro['disclaimer'] = 'Times are estimates.';
      return jsonEncode(json);
    }

    testWidgets('lists agencies with contact links', (tester) async {
      env = await ObaTestEnv.create(
        responses: {'agencies-with-coverage': agenciesJson()},
      );
      final opened = <Uri>[];
      await env.pumpPage(
        tester,
        AgenciesPage(
          urlOpener: (uri) async {
            opened.add(uri);
            return true;
          },
        ),
      );
      expect(find.text('Metro Transit'), findsOneWidget);
      expect(find.text("Seattle Children's Hospital"), findsOneWidget);
      expect(find.text('Times are estimates.'), findsOneWidget);
      await expectObaAccessibility(tester);

      await tester.tap(find.text('Call 206-553-3000'));
      await tester.tap(find.text('Email info@metro.example'));
      await tester.tap(find.text('Fare information'));
      expect(opened.map((u) => u.scheme), ['tel', 'mailto', 'https']);
      expect(opened.first.path, '2065533000');
    });

    testWidgets('centres the map on the coverage when a map exists', (
      tester,
    ) async {
      env = await ObaTestEnv.create(
        responses: {'agencies-with-coverage': agenciesJson()},
      );
      final delegate = _FakeCamera();
      final coordinator = ObaMapCoordinator()..attach(delegate);
      await env.pumpPage(
        tester,
        const AgenciesPage(),
        coordinator: coordinator,
      );
      await tester.tap(find.text('Show coverage on the map').last);
      expect(
        delegate.bounds.single.minLat,
        closeTo(47.6470785 - 0.0316525, 0.001),
      );
    });

    testWidgets('no map button without a coordinator; error state', (
      tester,
    ) async {
      env = await ObaTestEnv.create(
        responses: {'agencies-with-coverage': agenciesJson()},
      );
      await env.pumpPage(tester, const AgenciesPage());
      expect(find.text('Show coverage on the map'), findsNothing);
      await unmount(tester);
      env.dispose();
      env = await ObaTestEnv.create();
      await env.pumpPage(tester, const AgenciesPage());
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('accessible and reflowing everywhere', (tester) async {
      env = await ObaTestEnv.create(
        responses: {'agencies-with-coverage': agenciesJson()},
      );
      for (final p in ObaPresentation.values) {
        for (final mode in [ThemeMode.light, ThemeMode.dark]) {
          await env.pumpPage(
            tester,
            const AgenciesPage(),
            presentation: p,
            themeMode: mode,
          );
          await expectObaAccessibility(tester);
        }
      }
      await env.expectNoOverflowAtTextScale(tester, const AgenciesPage());
    });
  });
}

class _FakeCamera implements ObaMapCameraDelegate {
  final bounds = <RegionRect>[];

  @override
  void fitBounds(RegionRect rect) => bounds.add(rect);

  @override
  void moveTo(Coordinate center, {double? zoom}) {}
}
