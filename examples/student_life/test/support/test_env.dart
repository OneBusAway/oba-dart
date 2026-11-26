// A small stand-in for packages/obakit/test/support/oba_test_harness.dart
// (another package's test code can't be imported): a real ObaApplication
// over an in-memory store, the fixed campus location, and a MockClient
// that answers from the onebusaway package's captured fixtures. Nothing
// reaches the network, and nothing is ever written to a server.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;
import 'package:student_life_example/app.dart';
import 'package:student_life_example/data/campus.dart';
import 'package:student_life_example/oba_setup.dart';
import 'package:student_life_example/settings.dart';
import 'package:student_life_example/theme.dart';

/// Reads a captured server response from packages/onebusaway. Tests run
/// from examples/student_life.
String fixture(String name) =>
    File('../../packages/onebusaway/test/fixtures/$name').readAsStringSync();

class TestEnv {
  TestEnv._(this.oba, this.requests, this.settings);

  final ObaApplication oba;

  /// Every HTTP request the SDK made, in order.
  final List<http.Request> requests;
  final StudentLifeSettings settings;

  /// [responses] maps a URL substring to a fixture body; anything else
  /// gets a 404.
  static Future<TestEnv> create({
    Map<String, String> responses = const {},
    bool showObaEmbeds = false,
    ThemeMode themeMode = ThemeMode.light,
  }) async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      for (final e in responses.entries) {
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
    final oba = await createObaApplication(
      services: ObaPlatformServices(
        keyValueStore: InMemoryKeyValueStore(),
        locationProvider: FixedLocationProvider(CampusPlaces.campusCenter),
      ),
      bundledRegionsJson: fixture('regions-v3.json'),
      httpClient: client,
    );
    return TestEnv._(
      oba,
      requests,
      StudentLifeSettings(showObaEmbeds: showObaEmbeds, themeMode: themeMode),
    );
  }

  /// The app, optionally starting at [home] instead of the tabs.
  Widget app({Widget? home}) => home == null
      ? StudentLifeApp(oba: oba, settings: settings)
      : StudentLifeApp(oba: oba, settings: settings, home: home);

  /// Requests that would change server state. Must stay empty.
  Iterable<http.Request> get writes => requests.where((r) => r.method != 'GET');

  /// Settles animations and pending (mock) HTTP futures.
  static Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 3; i++) {
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    }
    await tester.pumpAndSettle();
  }

  void dispose() {
    oba.dispose();
    settings.dispose();
  }
}

/// 48dp targets, labelled targets and (optionally) WCAG AA text contrast.
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

/// Pumps a host-only [widget] in the host theme (with a [SettingsScope])
/// at [textScale] on a phone-sized surface.
Future<void> pumpHost(
  WidgetTester tester,
  Widget widget, {
  StudentLifeSettings? settings,
  double textScale = 1,
  Brightness brightness = Brightness.light,
}) async {
  await tester.binding.setSurfaceSize(const Size(390, 844));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  final s = settings ?? StudentLifeSettings(themeMode: ThemeMode.light);
  await tester.pumpWidget(
    SettingsScope(
      settings: s,
      child: MaterialApp(
        theme: buildStudentLifeTheme(brightness),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: widget,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Lets `ObaMapView` build with the default tile provider in a test.
///
/// flutter_map's tile cache asks `path_provider` for a cache directory,
/// which has no plugin in widget tests; this answers with a temporary
/// directory. Tile downloads themselves never leave the machine: the test
/// binding answers every `HttpClient` request with a 400, and the map
/// shows blank tiles. (obakit's own tests pass a fake `TileProvider`
/// instead, but that type lives in flutter_map, which this app doesn't
/// depend on directly.)
void mockMapTileCache() {
  final dir = Directory.systemTemp.createTempSync('student_life_tiles');
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
