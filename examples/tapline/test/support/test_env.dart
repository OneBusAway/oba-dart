// A small equivalent of obakit's test harness (which can't be imported from
// another package): a real ObaApplication over an in-memory store, a fixed
// location, and a MockClient that answers from the onebusaway package's
// captured fixtures. Nothing touches the network.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;
import 'package:tapline_example/app.dart';
import 'package:tapline_example/data/wallet.dart';

/// Reads a captured server response from packages/onebusaway/test/fixtures.
/// Tests run from examples/tapline.
String fixture(String name) =>
    File('../../packages/onebusaway/test/fixtures/$name').readAsStringSync();

/// Default responses: URL substring to body.
Map<String, String> defaultResponses() => {
  'stops-for-location': fixture('stops_for_location_query.json'),
  'arrivals-and-departures-for-stop': fixture('arrivals_mts_24151.json'),
};

class TestEnv {
  TestEnv._(this.app, this.requests);

  static Future<TestEnv> create({Map<String, String>? responses}) async {
    final bodies = responses ?? defaultResponses();
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      for (final e in bodies.entries) {
        if (request.url.toString().contains(e.key)) {
          return http.Response(
            e.value,
            200,
            headers: {'content-type': 'application/json'},
          );
        }
      }
      return http.Response('', 404);
    });
    final store = InMemoryKeyValueStore();
    final location = FixedLocationProvider(
      const Coordinate(32.8801, -117.2340),
    );
    final app = ObaApplication(
      core: ObaCoreApplication(
        ObaAppConfig(
          appName: 'Tapline',
          apiKey: 'test',
          appVersion: '0.1.0',
          bundledRegionsJson: fixture('regions-v3.json'),
          regionsPath: null,
          fixedRegion: const FixedRegionConfig(name: 'San Diego'),
          keyValueStore: store,
          locationProvider: location,
          httpClient: client,
        ),
      ),
      // No tile provider: a hidden ObaMapView loads no tiles, and a test
      // that shows the map calls mockMapTileCache(). (A fake TileProvider
      // would need a direct flutter_map dependency; obakit doesn't
      // re-export it.)
      map: const ObaMapConfig(
        userAgentPackageName: 'org.onebusaway.examples.tapline.test',
      ),
    );
    await app.start();
    return TestEnv._(app, requests);
  }

  final ObaApplication app;

  /// Every HTTP request the SDK made.
  final List<http.Request> requests;

  /// Pumps the app with [wallet], at [textScale], with animations off
  /// unless [animations].
  Future<void> pumpApp(
    WidgetTester tester, {
    Wallet? wallet,
    Widget? home,
    double textScale = 1,
    bool animations = false,
    Size? surfaceSize,
    bool settleAll = true,
    Brightness brightness = Brightness.light,
  }) async {
    if (surfaceSize != null) {
      await tester.binding.setSurfaceSize(surfaceSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));
    }
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(
          size: surfaceSize ?? const Size(800, 600),
          textScaler: TextScaler.linear(textScale),
          disableAnimations: !animations,
          platformBrightness: brightness,
        ),
        child: TaplineApp(
          application: app,
          wallet: wallet ?? Wallet.sample(),
          home: home,
        ),
      ),
    );
    if (settleAll) await settle(tester);
  }

  /// Settles animations and pending HTTP futures.
  static Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 3; i++) {
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    }
    await tester.pumpAndSettle();
  }

  /// Unmounts the tree (cancelling polling timers) and disposes the app.
  Future<void> tearDown(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    app.dispose();
  }

  /// Safety: the SDK must never write to a server from these tests.
  void expectReadOnly() {
    expect(
      requests.where((r) => r.method != 'GET'),
      isEmpty,
      reason: 'tests must not send write requests',
    );
  }
}

/// 48dp targets, labelled targets and text contrast (WCAG AA).
Future<void> expectAccessible(
  WidgetTester tester, {
  bool checkContrast = true,
}) async {
  final handle = tester.ensureSemantics();
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
  if (checkContrast) {
    await expectLater(tester, meetsGuideline(textContrastGuideline));
  }
  handle.dispose();
}

/// Lets `ObaMapView` build with the default tile provider in a test.
///
/// flutter_map's tile cache asks `path_provider` for a cache directory,
/// which has no plugin in widget tests; this answers with a temporary
/// directory. Tile downloads never leave the machine: the test binding
/// answers every `HttpClient` request with a 400, and the map shows blank
/// tiles.
void mockMapTileCache() {
  final dir = Directory.systemTemp.createTempSync('tapline_tiles');
  addTearDown(() => dir.deleteSync(recursive: true));
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(channel, (call) async => dir.path);
  addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
}

/// A real itinerary: the first one in obakit_trip_planner's captured OTP
/// GraphQL response (Westlake to U District on Sound Transit's 1 Line,
/// leaving 9:00 AM Pacific on Nov 25, 2026; the response reports no fare).
tp.Itinerary westlakeItinerary() => tp
    .parseGraphQLPlanResponse(
      jsonDecode(
        File(
          '../../packages/obakit_trip_planner/test/fixtures/graphql/'
          'soundtransit_westlake_to_udistrict.json',
        ).readAsStringSync(),
      ) as Map<String, dynamic>,
    )
    .itineraries
    .first;

/// Opens [itinerary] in the trip planner on screen, the way a tap on its
/// row does. The region's OTP server isn't mocked, so this calls the
/// planner's tap callback directly instead of planning a trip (as obakit's
/// own tests do). The SDK then calls `onItinerarySelected`.
Future<void> openItinerary(WidgetTester tester, tp.Itinerary itinerary) async {
  final finder = find.byType(tp.TripPlannerView);
  tester.widget<tp.TripPlannerView>(finder).onItineraryTap!(
    tester.element(finder),
    itinerary,
  );
  await tester.pump();
}
