// Test helpers for the settings area: an application whose config can vary
// (donations, More tab, store ids, analytics, regions server) and a link
// opener that records instead of launching.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';

class FakeLinkOpener extends ObaLinkOpener {
  FakeLinkOpener({this.accept = _always});

  /// Decides whether a URL "opens".
  bool Function(Uri uri) accept;
  final List<Uri> opened = [];
  final List<Uri> attempted = [];

  static bool _always(Uri _) => true;

  @override
  Future<bool> open(Uri uri) async {
    attempted.add(uri);
    final ok = accept(uri);
    if (ok) opened.add(uri);
    return ok;
  }
}

class RecordingAnalytics extends NoopAnalytics {
  final List<({String page, String label, Object? value})> events = [];

  @override
  void reportEvent({
    required String pageUrl,
    required String label,
    Object? value,
  }) => events.add((page: pageUrl, label: label, value: value));

  bool has(String label, [Object? value]) => events.any(
    (e) => e.label == label && (value == null || e.value == value),
  );
}

class SettingsEnv {
  SettingsEnv._(
    this.app,
    this.store,
    this.location,
    this.requests,
    this.opener,
    this.analytics,
  );

  static Future<SettingsEnv> create({
    Map<String, String> responses = const {},
    Map<String, int> statuses = const {},
    String region = 'Puget Sound',
    LocationPermissionStatus permission =
        LocationPermissionStatus.notDetermined,
    ObaLocation? location,
    Map<String, String> storeValues = const {},
    bool onboardingDone = true,
    DonationsConfig donations = DonationsConfig.disabled,
    MoreTabConfig? moreTab,
    String? developerEmail,
    Uri? privacyPolicyUrl,
    String? appStoreId,
    String? playStoreId,
    String operatingSystem = 'android',
    bool withAnalytics = false,
    String? regionsPath,
    bool feedbackPromptEnabled = true,
    FakeLinkOpener? opener,
  }) async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      for (final e in responses.entries) {
        if (request.url.toString().contains(e.key)) {
          return http.Response(
            e.value,
            statuses[e.key] ?? 200,
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
    final analytics = RecordingAnalytics();
    final app = ObaApplication(
      core: ObaCoreApplication(
        ObaAppConfig(
          appName: 'OneBusAway',
          apiKey: 'test',
          appVersion: '1.2.3',
          bundledRegionsJson: fixture('regions-v3.json'),
          regionsPath: regionsPath,
          fixedRegion: FixedRegionConfig(name: region),
          keyValueStore: store,
          locationProvider: fakeLocation,
          httpClient: client,
          donations: donations,
          moreTab: moreTab,
          developerEmail: developerEmail,
          privacyPolicyUrl: privacyPolicyUrl,
          appStoreId: appStoreId,
          playStoreId: playStoreId,
          operatingSystem: operatingSystem,
          analytics: withAnalytics ? analytics : null,
          feedbackPromptEnabled: feedbackPromptEnabled,
        ),
      ),
      map: ObaMapConfig(
        userAgentPackageName: 'org.onebusaway.test',
        tileProvider: FakeTileProvider(),
      ),
    );
    await app.start();
    return SettingsEnv._(
      app,
      store,
      fakeLocation,
      requests,
      opener ?? FakeLinkOpener(),
      analytics,
    );
  }

  final ObaApplication app;
  final InMemoryKeyValueStore store;
  final FakeLocationProvider location;
  final List<http.Request> requests;
  final FakeLinkOpener opener;
  final RecordingAnalytics analytics;

  ObaCoreApplication get core => app.core;

  final List<ObaRoute> pushed = [];

  Widget wrap(
    Widget child, {
    ThemeMode themeMode = ThemeMode.light,
    double textScale = 1,
    ObaMapCoordinator? coordinator,
    ObaPresentation presentation = ObaPresentation.page,
    bool captureNavigation = true,
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
    page = ObaLinkOpenerScope(opener: opener, child: page);
    return ObaScope(
      application: app,
      onNavigate: captureNavigation
          ? (context, route) {
              pushed.add(route);
              return true;
            }
          : null,
      child: MaterialApp(
        theme: ObaTheme.buildThemeData(),
        darkTheme: ObaTheme.buildThemeData(brightness: Brightness.dark),
        themeMode: themeMode,
        localizationsDelegates: obaLocalizationsDelegates,
        supportedLocales: obaSupportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: page,
      ),
    );
  }

  Future<void> pump(
    WidgetTester tester,
    Widget page, {
    ThemeMode themeMode = ThemeMode.light,
    double textScale = 1,
    ObaMapCoordinator? coordinator,
    ObaPresentation presentation = ObaPresentation.page,
    bool captureNavigation = true,
    Size surfaceSize = const Size(390, 4000),
  }) async {
    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      wrap(
        page,
        themeMode: themeMode,
        textScale: textScale,
        coordinator: coordinator,
        presentation: presentation,
        captureNavigation: captureNavigation,
      ),
    );
    await settle(tester);
  }

  static Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 3; i++) {
      await tester.pumpAndSettle();
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    }
    await tester.pumpAndSettle();
  }

  /// Light and dark accessibility checks, and 200% text without overflow.
  Future<void> expectAccessible(
    WidgetTester tester,
    Widget Function() page, {
    ObaPresentation presentation = ObaPresentation.page,
  }) async {
    for (final mode in [ThemeMode.light, ThemeMode.dark]) {
      await pump(tester, page(), themeMode: mode, presentation: presentation);
      await expectObaAccessibility(tester);
    }
    await pump(
      tester,
      page(),
      textScale: 2,
      surfaceSize: const Size(390, 844),
      presentation: presentation,
    );
    expect(tester.takeException(), isNull);
  }

  void dispose() => app.dispose();
}

/// Wraps feed-style widgets (cards, sections) in the Material a page would
/// provide.
Widget feed(List<Widget> children) =>
    Material(child: ListView(children: children));

/// Records what is put on the clipboard.
List<String> trackClipboard(WidgetTester tester) {
  final copied = <String>[];
  tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
    SystemChannels.platform,
    (call) async {
      if (call.method == 'Clipboard.setData') {
        copied.add((call.arguments as Map)['text'] as String);
      }
      return null;
    },
  );
  addTearDown(
    () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    ),
  );
  return copied;
}
