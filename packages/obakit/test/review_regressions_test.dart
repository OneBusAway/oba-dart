// Regression tests for bugs found in code review: region changes, late
// async results, and work started mid-build. Each test names the bug it
// pins.

import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit/src/features/bookmarks/bookmark_card.dart';
import 'package:obakit/src/features/bookmarks/departure_line.dart';
import 'package:obakit/src/features/bookmarks/departures_loader.dart';
import 'package:obakit/src/features/map/stops_loader.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import 'support/oba_test_harness.dart';

/// An application like the harness's, but answering through [handler], so
/// a test can hold a response back.
Future<ObaApplication> _appWith(
  Future<http.Response> Function(http.Request request) handler,
) async {
  final app = ObaApplication(
    core: ObaCoreApplication(
      ObaAppConfig(
        appName: 'OneBusAway',
        apiKey: 'test',
        appVersion: '1.0.0',
        bundledRegionsJson: fixture('regions-v3.json'),
        regionsPath: null,
        fixedRegion: const FixedRegionConfig(name: 'Puget Sound'),
        keyValueStore: InMemoryKeyValueStore(),
        locationProvider: FakeLocationProvider(),
        httpClient: MockClient(handler),
      ),
    ),
    map: ObaMapConfig(
      userAgentPackageName: 'org.onebusaway.test',
      tileProvider: FakeTileProvider(),
    ),
  );
  await app.start();
  return app;
}

/// A 200 with a JSON body (UTF-8: some fixtures have non-Latin-1 text).
http.Response _json(String body) => http.Response(
  body,
  200,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

Region _sanDiego(ObaApplication app) => app.core.regions.find(11)!;

final _seattle = ObaLocation(
  lat: 47.6097,
  lon: -122.3331,
  timestamp: DateTime.utc(2026),
);

RegionRect _box(double lat, double lon, double span) => RegionRect(
  minLat: lat - span / 2,
  maxLat: lat + span / 2,
  minLon: lon - span / 2,
  maxLon: lon + span / 2,
);

const _stopBookmark = StoredStop(
  id: '1_10914',
  name: '15th Ave NE & NE Campus Pkwy',
  lat: 47.656422,
  lon: -122.312164,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('region changes', () {
    testWidgets(
      'a deep link into another region turns automatic selection off',
      (tester) async {
        final env = await ObaTestEnv.create();
        addTearDown(env.dispose);
        final regions = env.app.core.regions;
        regions.automaticallySelectRegion = true;
        final links = StreamController<Uri>();
        addTearDown(links.close);
        await env.pumpApp(
          tester,
          surfaceSize: const Size(390, 844),
          links: links.stream,
        );
        links.add(Uri.parse('onebusaway://view-stop?stopID=99&regionID=11'));
        await ObaTestEnv.settle(tester);
        expect(regions.currentRegion?.regionName, 'San Diego');
        expect(regions.automaticallySelectRegion, isFalse);

        // The next location fix (the rider is in Seattle) must not switch
        // back under the page the link opened.
        regions.updateLocation(_seattle);
        await ObaTestEnv.settle(tester);
        expect(regions.currentRegion?.regionName, 'San Diego');
        final shell = tester.state<ObaHomeShellState>(
          find.byType(ObaHomeShell),
        );
        expect(shell.routeStack.last, const StopRoute('99'));
      },
    );

    test('NearbyDeparturesController.reset forgets the old region', () async {
      final calls = <String>[];
      OneBusAwayClient client(String host, String stops) => OneBusAwayClient(
        baseUrl: Uri.parse('https://$host/'),
        apiKey: 'k',
        httpClient: MockClient((r) async {
          calls.add('${r.url.host}${r.url.path}');
          return http.Response(
            fixture(
              r.url.path.contains('stops-for-location')
                  ? stops
                  : 'arrivals_and_departures_empty.json',
            ),
            200,
          );
        }),
      );
      final a = client('a.example.org', 'stops_for_location_seattle.json');
      final b = client('b.example.org', 'stops_for_location_query.json');
      var current = a;
      final c = NearbyDeparturesController(client: () => current);
      addTearDown(c.dispose);
      c.setCenter(const Coordinate(47.6495, -122.3038));
      await pumpEventQueue();
      final oldIds = {for (final s in c.stops) s.id};
      expect(oldIds, isNotEmpty);

      // The centre has not moved, so setCenter alone would keep the stops.
      current = b;
      c.setCenter(const Coordinate(47.6495, -122.3038));
      await pumpEventQueue();
      expect({for (final s in c.stops) s.id}, oldIds);

      c.reset();
      expect(c.stops, isEmpty);
      expect(c.routes, isEmpty);
      expect(c.hasLoadedStops, isFalse);
      await pumpEventQueue();
      expect(calls.last, startsWith('b.example.org'));
      expect(c.hasLoadedStops, isTrue);
      expect(c.stops.single.name, '108th / Bridgeport');
      expect(oldIds.contains(c.stops.single.id), isFalse);
    });

    test(
      'NearbyDeparturesController.reset: departures in flight are dropped',
      () async {
        final gate = Completer<void>();
        var arrivals = 0;
        final client = OneBusAwayClient(
          baseUrl: Uri.parse('https://a.example.org/'),
          apiKey: 'k',
          httpClient: MockClient((r) async {
            if (r.url.path.contains('stops-for-location')) {
              return http.Response(
                fixture('stops_for_location_query.json'),
                200,
              );
            }
            arrivals++;
            if (arrivals == 1) {
              // The old region's server, slow and then failing.
              await gate.future;
              return http.Response('boom', 500);
            }
            return http.Response(
              fixture('arrivals_and_departures_empty.json'),
              200,
            );
          }),
        );
        final c = NearbyDeparturesController(client: () => client);
        addTearDown(c.dispose);
        c.visible = true;
        c.setCenter(const Coordinate(47.159439, -122.505051));
        await pumpEventQueue();
        expect(arrivals, 1, reason: 'the first departures request is held');
        final stopId = c.stops.single.id;

        c.reset();
        await pumpEventQueue();
        gate.complete();
        await pumpEventQueue();
        // The failure belonged to the request from before the reset: the
        // round goes on for the stops listed now instead of stopping.
        expect(arrivals, 2);
        expect(c.hasArrivalsFor(stopId), isTrue);
      },
    );

    testWidgets('NearbyStopsSection asks the new region for its stops', (
      tester,
    ) async {
      final env = await ObaTestEnv.create(
        responses: {
          'stops-for-location': fixture('stops_for_location_query.json'),
          'arrivals-and-departures-for-stop': fixture(
            'arrivals_and_departures_empty.json',
          ),
        },
      );
      addTearDown(env.dispose);
      Iterable<String> stopsHosts() => env.requests
          .where((r) => r.url.path.contains('stops-for-location'))
          .map((r) => r.url.host);
      await env.pumpPage(
        tester,
        const Material(
          child: NearbyStopsSection(around: Coordinate(47.159439, -122.505051)),
        ),
      );
      expect(stopsHosts(), hasLength(1));
      final first = stopsHosts().single;

      env.app.core.regions.setCurrentRegion(_sanDiego(env.app));
      await ObaTestEnv.settle(tester);
      expect(stopsHosts(), hasLength(2));
      expect(stopsHosts().last, isNot(first));
      expect(tester.takeException(), isNull);
    });

    test('SurveyService drops another region\'s surveys', () async {
      final env = await ObaTestEnv.create(
        responses: {
          'surveys.json': fixture('surveys_always_visible_one_time.json'),
        },
      );
      addTearDown(env.dispose);
      final surveys = env.app.core.surveys;
      int requests() =>
          env.requests.where((r) => r.url.path.contains('surveys')).length;
      await surveys.fetchSurveys(force: true);
      expect(surveys.allSurveys, isNotEmpty);
      expect(requests(), 1);

      env.app.core.regions.setCurrentRegion(_sanDiego(env.app));
      // Before any fetch for the new region (a card builds, and picks its
      // survey, before its deferred fetch runs): nothing is offered.
      expect(surveys.allSurveys, isEmpty);
      expect(surveys.visibleSurveys, isEmpty);
      expect(surveys.surveyForMap(), isNull);
      expect(surveys.surveyForStop('STOP_1', const []), isNull);

      // The fetch ignores the cooldown: the cache was the old region's.
      await surveys.fetchSurveys();
      expect(requests(), 2);
      expect(env.requests.last.url.path, contains('/11/'));
      expect(surveys.allSurveys, isNotEmpty);
    });

    testWidgets('ObaSurveyCard: a card that stays on screen drops the old '
        'region\'s survey and asks the new region', (tester) async {
      final none = jsonEncode({
        ...jsonDecode(fixture('surveys_always_visible_one_time.json'))
            as Map<String, Object?>,
        'surveys': <Object?>[],
      });
      final env = await ObaTestEnv.create(
        responses: {
          'regions/1/surveys.json': fixture(
            'surveys_always_visible_one_time.json',
          ),
          'regions/11/surveys.json': none,
        },
      );
      addTearDown(env.dispose);
      env.app.core.userData.alwaysShowSurveysOnStops = true;
      Iterable<String> surveyPaths() => env.requests
          .where((r) => r.url.path.contains('surveys'))
          .map((r) => r.url.path);
      await env.pumpPage(
        tester,
        Material(child: ListView(children: const [ObaSurveyCard()])),
      );
      expect(find.text('Do you like OBA IOS App ?'), findsOneWidget);
      expect(surveyPaths().single, contains('/regions/1/'));

      env.app.core.regions.setCurrentRegion(_sanDiego(env.app));
      await ObaTestEnv.settle(tester);
      expect(
        find.text('Do you like OBA IOS App ?'),
        findsNothing,
        reason: 'the card still offers Puget Sound\'s survey in San Diego',
      );
      expect(surveyPaths().last, contains('/regions/11/'));
      expect(tester.takeException(), isNull);
    });

    test('SurveyService: a fetch overtaken by a region change', () async {
      final gate = Completer<void>();
      final paths = <String>[];
      final app = await _appWith((r) async {
        if (!r.url.path.contains('surveys')) return http.Response('', 404);
        paths.add(r.url.path);
        if (paths.length == 1) await gate.future;
        return _json(fixture('surveys_always_visible_one_time.json'));
      });
      addTearDown(app.dispose);
      final surveys = app.core.surveys;
      final first = surveys.fetchSurveys(force: true);
      await pumpEventQueue();
      expect(paths, hasLength(1));

      app.core.regions.setCurrentRegion(_sanDiego(app));
      // Turned away: the old region's fetch is still running.
      await surveys.fetchSurveys();
      expect(paths, hasLength(1));

      gate.complete();
      await first;
      await pumpEventQueue();
      // The old answer was dropped and the new region asked.
      expect(paths, hasLength(2));
      expect(paths.last, contains('/11/'));
      expect(surveys.allSurveys, isNotEmpty);
      expect(surveys.lastError, isNull);
    });

    test('StopDeparturesLoader: a request from before a region change '
        'leaves the new one tracked', () async {
      final gates = [Completer<void>(), Completer<void>()];
      var requests = 0;
      final app = await _appWith((r) async {
        if (!r.url.path.contains('arrivals-and-departures-for-stop')) {
          return http.Response('', 404);
        }
        final n = requests++;
        if (n < gates.length) await gates[n].future;
        return _json(fixture('arrivals-and-departures-for-stop-1_10914.json'));
      });
      addTearDown(app.dispose);
      final loader = StopDeparturesLoader(app);
      addTearDown(loader.dispose);
      loader.setStops({'1_10914'});
      await pumpEventQueue();
      expect(requests, 1);

      app.core.regions.setCurrentRegion(_sanDiego(app));
      await pumpEventQueue();
      expect(requests, 2, reason: 'asked again for the new region');

      // The old region's answer arrives. It is not shown, and it must not
      // mark the stop as idle: the new request is still in flight.
      gates[0].complete();
      await pumpEventQueue();
      expect(loader.stateFor('1_10914').isLoading, isTrue);
      final refreshed = loader.refresh();
      await pumpEventQueue();
      expect(requests, 2, reason: 'no second request for a stop in flight');

      gates[1].complete();
      await refreshed;
      expect(loader.stateFor('1_10914').hasData, isTrue);
    });

    test(
      'AlertsLoader drops and reloads alerts for the new region',
      () => withClock(
        // When the fixture's alerts were active.
        Clock.fixed(DateTime.fromMillisecondsSinceEpoch(1474553212655)),
        () async {
          final env = await ObaTestEnv.create(
            responses: {
              'arrivals-and-departures-for-stop': fixture(
                'arrivals_and_departures_for_stop_mts_11670_route_alerts.json',
              ),
            },
          );
          addTearDown(env.dispose);
          // A bookmark in Puget Sound: the region-wide loader asks its stop.
          env.app.core.userData.addBookmark(
            Bookmark.forStop(name: 'Home', regionId: 1, stop: _stopBookmark),
          );
          final loader = AlertsLoader(env.app);
          addTearDown(loader.dispose);
          await loader.load();
          expect(loader.alerts, isNotEmpty);
          expect(loader.loadedAt, isNotNull);

          // San Diego has no bookmarks, recents or location: nothing to ask,
          // and nothing of Puget Sound's left to show.
          env.app.core.regions.setCurrentRegion(_sanDiego(env.app));
          expect(loader.alerts, isEmpty);
          await pumpEventQueue();
          expect(loader.alerts, isEmpty);
          expect(loader.isLoading, isFalse);
          expect(loader.error, isNull);
        },
      ),
    );
  });

  group('late results and work started mid-build', () {
    testWidgets('a host-pushed page keeps working after the widget that '
        'pushed it is removed', (tester) async {
      final env = await ObaTestEnv.create();
      addTearDown(env.dispose);
      final navigated = <ObaRoute>[];
      // The navigator sits above the ObaScope (a host tab holds the scope),
      // so the pushed page gets its scope from the pushing context.
      Widget host({required bool showButton}) => MaterialApp(
        theme: ObaTheme.buildThemeData(),
        localizationsDelegates: obaLocalizationsDelegates,
        supportedLocales: obaSupportedLocales,
        home: ObaScope(
          application: env.app,
          onNavigate: (context, route) {
            if (route is! RegionPickerRoute) return false;
            navigated.add(route);
            return true;
          },
          child: Scaffold(
            body: showButton
                ? Builder(
                    builder: (context) => TextButton(
                      onPressed: () =>
                          ObaNavigator.of(context).push(const MoreRoute()),
                      child: const Text('go'),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      );
      await tester.pumpWidget(host(showButton: true));
      await ObaTestEnv.settle(tester);
      await tester.tap(find.text('go'));
      await ObaTestEnv.settle(tester);
      expect(find.byType(MorePage), findsOneWidget);

      // The button is gone (a departure row leaves its list, say), and the
      // app rebuilds: every route's builder runs again.
      await tester.pumpWidget(host(showButton: false));
      await ObaTestEnv.settle(tester);
      expect(tester.takeException(), isNull);
      expect(find.byType(MorePage), findsOneWidget);

      // The page still reaches the application and the host's callback.
      final region = find.text('Region');
      await tester.ensureVisible(region);
      await ObaTestEnv.settle(tester);
      await tester.tap(region);
      await ObaTestEnv.settle(tester);
      expect(navigated, [const RegionPickerRoute()]);
    });

    test('StopsLoader: a request that finishes after dispose', () async {
      final gate = Completer<void>();
      final client = OneBusAwayClient(
        baseUrl: Uri.parse('https://api.example.org/'),
        apiKey: 'k',
        httpClient: MockClient((r) async {
          await gate.future;
          return http.Response(fixture('stops_for_location_query.json'), 200);
        }),
      );
      final loader = StopsLoader(client: () => client);
      var notified = 0;
      loader.addListener(() => notified++);
      final pending = loader.onCameraIdle(_box(47.159439, -122.505051, 0.01));
      await pumpEventQueue();
      loader.dispose();
      final before = notified;
      gate.complete();
      // Used to throw "A StopsLoader was used after being disposed".
      await pending;
      expect(notified, before);
    });

    test('DeepLinkRouter.parse: malformed percent-encoding is not a link', () {
      const router = DeepLinkRouter(scheme: 'onebusaway');
      for (final link in [
        'onebusaway://stop?id=%FF',
        'onebusaway://view-stop?stopID=%E0%A4%A&regionID=1',
        'onebusaway://add-region?name=%FF&oba-url=https%3A%2F%2Fx.org',
        'https://onebusaway.co/regions/1/stops/%FF',
        'https://onebusaway.co/regions/1/stops/1_75403/trips?trip_id=%FF',
      ]) {
        final Uri uri;
        try {
          uri = Uri.parse(link);
        } on FormatException {
          continue; // Never reaches the router.
        }
        expect(router.parse(uri), isNull, reason: link);
      }
      // Well-formed links still parse.
      expect(
        router.parse(Uri.parse('onebusaway://stop?id=1_75403')),
        isA<ViewStopDeepLink>(),
      );
    });

    testWidgets('ObaSurveyCard starts its fetch after the build', (
      tester,
    ) async {
      // No surveys: every card that appears fetches again (nothing is
      // cached), and the fetch notifies the cards already listening.
      final empty = jsonEncode({
        ...jsonDecode(fixture('surveys_always_visible_one_time.json'))
            as Map<String, Object?>,
        'surveys': <Object?>[],
      });
      final env = await ObaTestEnv.create(responses: {'surveys.json': empty});
      addTearDown(env.dispose);
      int requests() =>
          env.requests.where((r) => r.url.path.contains('surveys')).length;
      Widget cards(int count) => Material(
        child: ListView(
          children: [
            for (var i = 0; i < count; i++) ObaSurveyCard(key: ValueKey(i)),
          ],
        ),
      );
      await env.pumpPage(tester, cards(1));
      expect(requests(), 1);

      // A second card mounts while the first listens to the service.
      await tester.pumpWidget(env.wrap(cards(2)));
      expect(
        tester.takeException(),
        isNull,
        reason: 'setState() called during build',
      );
      await ObaTestEnv.settle(tester);
      expect(tester.takeException(), isNull);
      expect(requests(), 2);
    });

    testWidgets('the weather page loads without notifying the map button '
        'mid-build', (tester) async {
      // No weather fixture: the forecast fails, the button hides itself
      // (still listening) and the failure is remembered for 5 minutes.
      final env = await ObaTestEnv.create();
      addTearDown(env.dispose);
      int requests() =>
          env.requests.where((r) => r.url.path.contains('weather')).length;
      // The button sits under a covered route (tickers off), so it makes
      // no periodic check of its own, but it still listens.
      Widget tree({required bool page}) => env.wrap(
        Material(
          child: Column(
            children: [
              const TickerMode(enabled: false, child: ObaWeatherButton()),
              if (page) const Expanded(child: WeatherPage()),
            ],
          ),
        ),
      );
      await tester.pumpWidget(tree(page: false));
      await ObaTestEnv.settle(tester);
      expect(requests(), 1);

      // Past the back-off: opening the page is what starts the next fetch.
      await tester.pump(const Duration(minutes: 6));
      final before = requests();
      expect(before, 1);
      await tester.pumpWidget(tree(page: true));
      expect(
        tester.takeException(),
        isNull,
        reason: 'setState() called during build',
      );
      await ObaTestEnv.settle(tester);
      expect(tester.takeException(), isNull);
      expect(requests(), greaterThan(before));
    });
  });

  group('the sheet', () {
    late ObaTestEnv env;
    setUp(() async => env = await ObaTestEnv.create());
    tearDown(() => env.dispose());

    Future<ObaHomeShellState> pumpShell(WidgetTester tester) async {
      await env.pumpPage(
        tester,
        const ObaHomeShell(),
        surfaceSize: const Size(390, 844),
      );
      return tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
    }

    testWidgets('a menu over a page is not a page: the overlay, the selected '
        'stop and the camera stay', (tester) async {
      final shell = await pumpShell(tester);
      final camera = _RecordingCamera();
      shell.navigator.push(const _MenuRoute());
      await ObaTestEnv.settle(tester);
      shell.coordinator.selectStop('1_75403');
      expect(shell.coordinator.overlay.markers.single.label, 'Here');
      // Count only what happens from here on.
      shell.coordinator
        ..detach(_currentDelegate(tester))
        ..attach(camera);
      addTearDown(() => shell.coordinator.detach(camera));

      await tester.tap(find.byTooltip('More'));
      await ObaTestEnv.settle(tester);
      expect(find.text('Item 0'), findsOneWidget);
      expect(shell.routeStack.last, const _MenuRoute());
      expect(shell.coordinator.overlay.markers.single.label, 'Here');
      expect(shell.coordinator.selectedStopId, '1_75403');

      await tester.tap(find.text('Item 0'));
      await ObaTestEnv.settle(tester);
      expect(shell.coordinator.overlay.markers.single.label, 'Here');
      expect(shell.coordinator.selectedStopId, '1_75403');
      expect(
        camera.fits,
        isEmpty,
        reason: 'closing a menu must not pull the map back to the overlay',
      );
    });

    testWidgets('a menu opened from a collapsed sheet gets room', (
      tester,
    ) async {
      final shell = await pumpShell(tester);
      shell.navigator.push(const _MenuRoute());
      await ObaTestEnv.settle(tester);
      shell.sheet.animateTo(shell.sheet.minHeight);
      await ObaTestEnv.settle(tester);
      expect(shell.sheet.isCollapsed, isTrue);

      await tester.tap(find.byTooltip('More'));
      await ObaTestEnv.settle(tester);
      expect(shell.sheet.isCollapsed, isFalse);
      // Every item is on screen and can be tapped.
      final screen = tester.getRect(find.byType(ObaHomeShell));
      for (final label in ['Item 0', 'Item 3']) {
        final rect = tester.getRect(find.text(label));
        expect(screen.contains(rect.topLeft), isTrue, reason: label);
        expect(screen.contains(rect.bottomRight), isTrue, reason: label);
      }
      await tester.tap(find.text('Item 3'));
      await ObaTestEnv.settle(tester);
      expect(find.text('Item 3'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });

  group('the sheet: pages and pickers over it', () {
    late ObaTestEnv env;
    setUp(() async => env = await ObaTestEnv.create());
    tearDown(() => env.dispose());

    Future<ObaHomeShellState> pumpShell(WidgetTester tester) async {
      await env.pumpPage(
        tester,
        const ObaHomeShell(),
        surfaceSize: const Size(390, 844),
      );
      return tester.state<ObaHomeShellState>(find.byType(ObaHomeShell));
    }

    testWidgets('the trip planner\'s place picker covers the screen: in the '
        'half-height sheet the keyboard would hide its field', (tester) async {
      final shell = await pumpShell(tester);
      shell.navigator.push(const TripPlannerRoute());
      await ObaTestEnv.settle(tester);
      // The planner opens at half height.
      expect(shell.sheet.height, lessThan(shell.sheet.maxHeight * 0.6));

      // A keyboard 336dp tall (the test view is 3 physical pixels per dp).
      tester.view.viewInsets = const FakeViewPadding(bottom: 336 * 3);
      addTearDown(tester.view.reset);
      await tester.tap(find.bySemanticsLabel(RegExp('^From: ')));
      await ObaTestEnv.settle(tester);
      expect(
        tester.getRect(find.byType(tp.TripPlaceSearchPage)),
        const Rect.fromLTWH(0, 0, 390, 844),
      );
      expect(
        tester.getRect(find.byType(TextField)).bottom,
        lessThan(844 - 336),
        reason: 'the search field is under the keyboard',
      );
      // Still a sheet page underneath: the picker is not one of its pages.
      expect(shell.routeStack.last, const TripPlannerRoute());
      expect(tester.takeException(), isNull);
    });

    testWidgets('a page pushed while a menu is open: the page under the menu '
        'keeps the height to come back to', (tester) async {
      final shell = await pumpShell(tester);
      shell.navigator.push(const _MenuRoute());
      await ObaTestEnv.settle(tester);
      shell.sheet.expandFully();
      await ObaTestEnv.settle(tester);
      expect(shell.sheet.restingDetent, ObaSheetDetent.large);

      await tester.tap(find.byTooltip('More'));
      await ObaTestEnv.settle(tester);
      expect(find.text('Item 0'), findsOneWidget);
      // A deep link, say: a page arrives while the menu is still open.
      shell.navigator.push(const SettingsRoute());
      await ObaTestEnv.settle(tester);
      expect(shell.routeStack.last, const SettingsRoute());
      shell.sheet.animateTo(shell.sheet.minHeight);
      await ObaTestEnv.settle(tester);

      shell.navigator.pop();
      await ObaTestEnv.settle(tester);
      expect(shell.routeStack.last, const _MenuRoute());
      expect(
        shell.sheet.restingDetent,
        ObaSheetDetent.large,
        reason: 'the menu page reopened at its initial height',
      );
      expect(tester.takeException(), isNull);
    });
  });

  group('bookmarks', () {
    test('StopDeparturesLoader: a stop added while hidden is fetched on '
        'return, not at the next interval', () async {
      final env = await ObaTestEnv.create(
        responses: {
          'arrivals-and-departures-for-stop': fixture(
            'arrivals-and-departures-for-stop-1_10914.json',
          ),
        },
      );
      addTearDown(env.dispose);
      final loader = StopDeparturesLoader(env.app);
      addTearDown(loader.dispose);
      loader.setStops({'1_10914'});
      loader.setActive(true);
      await pumpEventQueue();
      expect(loader.stateFor('1_10914').hasData, isTrue);
      final before = env.requests.length;

      // The rider leaves (the list is covered), bookmarks another stop and
      // comes back within the 30-second refresh interval.
      loader.setActive(false);
      loader.setStops({'1_10914', '1_75403'}, fetchNew: false);
      expect(loader.stateFor('1_75403').isLoading, isTrue);
      loader.setActive(true);
      await pumpEventQueue();
      expect(loader.stateFor('1_75403').hasData, isTrue);
      expect(
        env.requests.length,
        before + 1,
        reason: 'only the new stop: the other is still fresh',
      );
      loader.setActive(false);
    });

    testWidgets('a loop trip that serves the stop twice gets two rows', (
      tester,
    ) async {
      final env = await ObaTestEnv.create();
      addTearDown(env.dispose);
      final now = DateTime.utc(2026, 11, 25, 20);
      final serviceDate = DateTime.utc(2026, 11, 25, 8);
      ArrivalAndDeparture visit(int sequence, int minutes) =>
          ArrivalAndDeparture(
            routeId: '1_100',
            tripId: '1_loop',
            serviceDate: serviceDate,
            stopId: _stopBookmark.id,
            stopSequence: sequence,
            routeShortName: '100',
            tripHeadsign: 'Campus Loop',
            scheduledArrivalTime: now.add(Duration(minutes: minutes)),
            scheduledDepartureTime: now.add(Duration(minutes: minutes)),
          );
      await env.pumpPage(
        tester,
        Material(
          child: SingleChildScrollView(
            child: BookmarkCard(
              bookmark: Bookmark.forStop(
                name: 'Loop terminal',
                regionId: 1,
                stop: _stopBookmark,
              ),
              // Leaves the terminal in 5 minutes and is back in 35.
              departures: BookmarkStopDepartures(
                arrivals: [visit(0, 5), visit(30, 35)],
                hasData: true,
              ),
              now: now,
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull, reason: 'Duplicate keys found');
      expect(find.byType(DepartureLine), findsNWidgets(2));
    });

    testWidgets('editor: cancelling "New group…" puts the group field back', (
      tester,
    ) async {
      final env = await ObaTestEnv.create();
      addTearDown(env.dispose);
      final store = env.app.core.userData;
      final group = store.addGroup('Work');
      store.addBookmark(
        Bookmark.forStop(name: 'Office', regionId: 1, stop: _stopBookmark),
        groupId: group.id,
      );
      final bookmark = store.bookmarks.single;
      await env.pumpPage(
        tester,
        BookmarkEditorPage(route: BookmarkEditorRoute(bookmark: bookmark)),
      );
      final field = find.byType(DropdownButtonFormField<String>);
      expect(
        find.descendant(of: field, matching: find.text('Work')),
        findsOneWidget,
      );

      await tester.tap(field);
      await ObaTestEnv.settle(tester);
      await tester.tap(find.text('New group…').last);
      await ObaTestEnv.settle(tester);
      await tester.tap(find.text('Cancel').last);
      await ObaTestEnv.settle(tester);

      // The field shows the group the bookmark will be saved in.
      expect(
        find.descendant(of: field, matching: find.text('Work')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: field, matching: find.text('New group…')),
        findsNothing,
      );
    });
  });

  group('schedule dates', () {
    DateTime? changed;
    Future<void> pumpBar(WidgetTester tester, DateTime date) =>
        tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: obaLocalizationsDelegates,
            supportedLocales: obaSupportedLocales,
            home: Material(
              child: ScheduleDateBar(date: date, onChanged: (d) => changed = d),
            ),
          ),
        );

    testWidgets('previous and next day follow the calendar when the clocks '
        'change', (tester) async {
      // Every day of two years, so both clock changes of any time zone the
      // tests run in are covered (a day is then 23 or 25 hours long).
      for (
        var day = DateTime(2026);
        day.year < 2028;
        day = DateTime(day.year, day.month, day.day + 1)
      ) {
        await pumpBar(tester, day);
        await tester.tap(find.byTooltip('Next day'));
        expect(
          changed,
          DateTime(day.year, day.month, day.day + 1),
          reason: 'next after $day',
        );
        await tester.tap(find.byTooltip('Previous day'));
        expect(
          changed,
          DateTime(day.year, day.month, day.day - 1),
          reason: 'previous before $day',
        );
      }
    });

    testWidgets('the picker opens on a date outside its usual range', (
      tester,
    ) async {
      final today = DateTime.now();
      // 40 days back with the day buttons: before the picker's first day.
      final old = DateTime(today.year, today.month, today.day - 40);
      await pumpBar(tester, old);
      await tester.tap(find.byIcon(Icons.calendar_today_outlined));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.byType(DatePickerDialog), findsOneWidget);
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(changed, old);
    });
  });
}

/// The camera delegate the map view attached (the coordinator has one at a
/// time), so a test can swap in a recording one.
ObaMapCameraDelegate _currentDelegate(WidgetTester tester) =>
    tester.state(find.byType(ObaMapView)) as ObaMapCameraDelegate;

class _RecordingCamera implements ObaMapCameraDelegate {
  final fits = <RegionRect>[];

  @override
  void fitBounds(RegionRect bounds) => fits.add(bounds);

  @override
  void moveTo(Coordinate center, {double? zoom}) {}
}

/// A page with a map overlay (that fits the camera) and an overflow menu.
class _MenuRoute extends ObaCustomRoute {
  const _MenuRoute();

  @override
  String get id => 'test-menu';

  @override
  ObaSheetDetents get detents => ObaSheetDetents.stop;

  @override
  Widget build(BuildContext context) => ObaMapOverlays(
    overlay: _overlay,
    child: ObaSheetPage(
      title: 'Menu',
      actions: [
        PopupMenuButton<int>(
          tooltip: 'More',
          itemBuilder: (_) => [
            for (var i = 0; i < 4; i++)
              PopupMenuItem(value: i, child: Text('Item $i')),
          ],
        ),
      ],
      slivers: const [],
    ),
  );

  static const _overlay = ObaMapOverlay(
    markers: [
      ObaMapMarker(coordinate: Coordinate(47.6, -122.3), label: 'Here'),
    ],
    fitBounds: RegionRect(minLat: 47, maxLat: 48, minLon: -123, maxLon: -122),
  );
}
