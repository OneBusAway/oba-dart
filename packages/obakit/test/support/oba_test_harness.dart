// Shared test harness for obakit screens. Every screen test should use it:
//
//   final env = await ObaTestEnv.create(responses: {
//     'stops-for-location': fixture('stops_for_location_query.json'),
//   });
//   await env.pumpPage(tester, const StopPage(stopId: '1_75403'));
//   await expectObaAccessibility(tester);
//   await env.expectNoOverflowAtTextScale(tester, const StopPage(...));
//
// It boots a real ObaApplication over an in-memory store, a fake location
// provider and a MockClient that answers from fixture files, with the
// Puget Sound region selected and no network, tiles or timers left over.

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:obakit/obakit.dart';

/// Reads a fixture: `test/fixtures/<name>` in this package, then the
/// onebusaway package's fixtures. Tests run from the package directory.
String fixture(String name) {
  final local = File('test/fixtures/$name');
  if (local.existsSync()) return local.readAsStringSync();
  return File('../onebusaway/test/fixtures/$name').readAsStringSync();
}

/// A 1x1 transparent PNG.
final Uint8List kTransparentPng = Uint8List.fromList(const [
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, //
  0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
  0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
  0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
  0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
  0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
]);

/// Serves blank tiles without touching the network.
class FakeTileProvider extends fm.TileProvider {
  FakeTileProvider();

  int requests = 0;

  @override
  ImageProvider getImage(fm.TileCoordinates coordinates, fm.TileLayer options) {
    requests++;
    return MemoryImage(kTransparentPng);
  }
}

/// A booted application plus its fakes.
class ObaTestEnv {
  ObaTestEnv._({
    required this.app,
    required this.store,
    required this.location,
    required this.requests,
    required this.tiles,
  });

  /// Creates and starts an application.
  ///
  /// [responses] maps a URL substring (e.g. `stops-for-location`) to a
  /// response body (use [fixture]); unmatched requests get a 404.
  /// [region] picks the selected region by name from `regions-v3.json`.
  /// [onboardingDone] marks every onboarding step seen.
  /// [locationProvider] replaces the fake one ([location] is then unused);
  /// [darkTiles] sets `ObaMapConfig.standardDark`.
  static Future<ObaTestEnv> create({
    Map<String, String> responses = const {},
    String region = 'Puget Sound',
    LocationPermissionStatus permission =
        LocationPermissionStatus.notDetermined,
    ObaLocation? location,
    Map<String, String> storeValues = const {},
    bool onboardingDone = true,
    PlaceSearchProvider? placeSearch,
    LocationProvider? locationProvider,
    ObaTileSource? darkTiles,
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
    final store = InMemoryKeyValueStore({
      if (onboardingDone) 'oba.settings.onboardingSeenVersions': '{"onboarding.welcome":1,"onboarding.location":1,"onboarding.region":1}',
      ...storeValues,
    });
    final fakeLocation = FakeLocationProvider(
      location: location,
      permission: permission,
    );
    final tiles = FakeTileProvider();
    final app = ObaApplication(
      core: ObaCoreApplication(
        ObaAppConfig(
          appName: 'OneBusAway',
          apiKey: 'test',
          appVersion: '1.0.0',
          bundledRegionsJson: fixture('regions-v3.json'),
          regionsPath: null,
          fixedRegion: FixedRegionConfig(name: region),
          keyValueStore: store,
          locationProvider: locationProvider ?? fakeLocation,
          placeSearchProvider: placeSearch,
          httpClient: client,
        ),
      ),
      map: ObaMapConfig(
        userAgentPackageName: 'org.onebusaway.test',
        standardDark: darkTiles,
        tileProvider: tiles,
      ),
    );
    await app.start();
    return ObaTestEnv._(
      app: app,
      store: store,
      location: fakeLocation,
      requests: requests,
      tiles: tiles,
    );
  }

  final ObaApplication app;
  final InMemoryKeyValueStore store;
  final FakeLocationProvider location;

  /// Every HTTP request made, in order.
  final List<http.Request> requests;
  final FakeTileProvider tiles;

  /// Wraps [child] like a host would: `MaterialApp` with the SDK's
  /// delegates, an [ObaScope], and (optionally) a presentation and a map
  /// coordinator.
  Widget wrap(
    Widget child, {
    ThemeData? theme,
    ThemeMode themeMode = ThemeMode.light,
    double textScale = 1,
    ObaNavigateCallback? onNavigate,
    ObaMapCoordinator? coordinator,
    ObaPresentation presentation = ObaPresentation.page,
    Locale? locale,
    List<LocalizationsDelegate<Object?>> localizationsDelegates =
        obaLocalizationsDelegates,
  }) {
    Widget page = child;
    if (presentation == ObaPresentation.embedded) {
      page = ObaPresentationScope.embedded(child: Material(child: page));
    } else if (presentation != ObaPresentation.page) {
      page = ObaPresentationScope(
        presentation: presentation,
        child: Material(child: page),
      );
    }
    if (coordinator != null) {
      page = ObaMapCoordinatorScope(coordinator: coordinator, child: page);
    }
    return ObaScope(
      application: app,
      onNavigate: onNavigate,
      child: MaterialApp(
        theme: theme ?? ObaTheme.buildThemeData(),
        darkTheme: ObaTheme.buildThemeData(brightness: Brightness.dark),
        themeMode: themeMode,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
        supportedLocales: [...obaSupportedLocales, ?locale],
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: page,
      ),
    );
  }

  /// Pumps [page] as a full-screen route (the default), or with another
  /// [presentation], and settles.
  Future<void> pumpPage(
    WidgetTester tester,
    Widget page, {
    ThemeData? theme,
    ThemeMode themeMode = ThemeMode.light,
    double textScale = 1,
    ObaNavigateCallback? onNavigate,
    ObaMapCoordinator? coordinator,
    ObaPresentation presentation = ObaPresentation.page,
    Size? surfaceSize,
    Locale? locale,
    List<LocalizationsDelegate<Object?>> localizationsDelegates =
        obaLocalizationsDelegates,
  }) async {
    if (surfaceSize != null) {
      await tester.binding.setSurfaceSize(surfaceSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));
    }
    await tester.pumpWidget(
      wrap(
        page,
        theme: theme,
        themeMode: themeMode,
        textScale: textScale,
        onNavigate: onNavigate,
        coordinator: coordinator,
        presentation: presentation,
        locale: locale,
        localizationsDelegates: localizationsDelegates,
      ),
    );
    await settle(tester);
  }

  /// Pumps the full app ([ObaApp]) with the fake tiles.
  Future<void> pumpApp(
    WidgetTester tester, {
    Uri? initialLink,
    Stream<Uri>? links,
    Set<OnboardingStep> onboardingSteps = const {
      OnboardingStep.welcome,
      OnboardingStep.location,
      OnboardingStep.region,
    },
    Size? surfaceSize,
  }) async {
    if (surfaceSize != null) {
      await tester.binding.setSurfaceSize(surfaceSize);
      addTearDown(() => tester.binding.setSurfaceSize(null));
    }
    await tester.pumpWidget(
      ObaApp(
        application: app,
        initialLink: initialLink,
        links: links,
        themeMode: ThemeMode.light,
        onboardingSteps: onboardingSteps,
      ),
    );
    await settle(tester);
  }

  /// Settles animations, the map's 250 ms stop debounce and pending HTTP
  /// futures.
  static Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 3; i++) {
      await tester.pumpAndSettle();
      await tester.pump(const Duration(milliseconds: 300));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    }
    await tester.pumpAndSettle();
  }

  /// Pumps [page] at 200% text size (the WCAG reflow bar) in a phone-sized
  /// surface and fails on any overflow or other exception.
  Future<void> expectNoOverflowAtTextScale(
    WidgetTester tester,
    Widget page, {
    double textScale = 2,
    ObaPresentation presentation = ObaPresentation.page,
    Size surfaceSize = const Size(390, 844),
  }) async {
    await pumpPage(
      tester,
      page,
      textScale: textScale,
      presentation: presentation,
      surfaceSize: surfaceSize,
    );
    expect(tester.takeException(), isNull);
  }

  void dispose() => app.dispose();
}

/// Runs the accessibility guidelines every screen must meet: 48dp tap
/// targets (Android and iOS rules), labelled tap targets, and text
/// contrast (WCAG AA). Call after pumping a screen.
Future<void> expectObaAccessibility(
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
