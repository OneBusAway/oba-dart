import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';
import 'settings_support.dart';

void main() {
  late SettingsEnv env;

  Future<void> boot({bool serverOk = true}) async {
    env = await SettingsEnv.create(
      responses: {if (serverOk) 'current-time': fixture('current_time.json')},
    );
    addTearDown(env.dispose);
  }

  Finder field(String label) => find.widgetWithText(TextField, label);

  Future<void> type(WidgetTester tester, String label, String text) async {
    await tester.ensureVisible(field(label));
    await tester.enterText(field(label), text);
    await tester.pump();
  }

  Future<void> fillArea(WidgetTester tester) async {
    await type(tester, 'Center latitude', '32.88');
    await type(tester, 'Center longitude', '-117.24');
    await type(tester, 'Latitude span (degrees)', '0.1');
    await type(tester, 'Longitude span (degrees)', '0.2');
  }

  testWidgets('prefills from a deep link and checks the server', (
    tester,
  ) async {
    await boot();
    final prefill = AddRegionData(
      name: 'Campus',
      obaUrl: Uri.parse('https://oba.example.com/'),
      otpUrl: Uri.parse('https://otp.example.com/otp/'),
    );
    await env.pump(tester, CustomRegionPage(prefill: prefill));
    expect(tester.widget<TextField>(field('Name')).controller!.text, 'Campus');
    expect(
      tester.widget<TextField>(field('OneBusAway server URL')).controller!.text,
      'https://oba.example.com/',
    );
    expect(
      tester
          .widget<TextField>(field('Trip planner URL (optional)'))
          .controller!
          .text,
      'https://otp.example.com/otp/',
    );
    expect(find.text('The server responded'), findsOneWidget);
    expect(
      env.requests.any((r) => r.url.path.contains('current-time')),
      isTrue,
    );
  });

  testWidgets('typing a URL checks it after a pause', (tester) async {
    await boot();
    await env.pump(tester, const CustomRegionPage());
    await type(tester, 'OneBusAway server URL', 'ftp://nope');
    expect(
      find.text('Enter a web address that starts with http:// or https://'),
      findsOneWidget,
    );
    await type(tester, 'OneBusAway server URL', 'https://oba.example.com/');
    // Not yet: debounced.
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      env.requests.where((r) => r.url.path.contains('current-time')),
      isEmpty,
    );
    await tester.pump(CustomRegionPage.checkDebounce);
    await SettingsEnv.settle(tester);
    expect(find.text('The server responded'), findsOneWidget);
    expect(
      env.requests.where((r) => r.url.path.contains('current-time')),
      hasLength(1),
    );
  });

  testWidgets('a server that is not OneBusAway is reported', (tester) async {
    await boot(serverOk: false);
    await env.pump(tester, const CustomRegionPage());
    await type(tester, 'OneBusAway server URL', 'https://example.com/');
    await tester.pump(CustomRegionPage.checkDebounce);
    await SettingsEnv.settle(tester);
    expect(
      find.text("This server didn't answer like OneBusAway"),
      findsOneWidget,
    );
  });

  testWidgets('save validates, then adds and selects the region', (
    tester,
  ) async {
    await boot();
    await env.pump(tester, const CustomRegionPage());
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.text('This field is required'), findsWidgets);
    expect(env.core.regions.customRegions, isEmpty);

    await type(tester, 'Name', 'Campus');
    await type(tester, 'OneBusAway server URL', 'https://oba.example.com/');
    await type(
      tester,
      'Sidecar server URL (optional)',
      'https://sidecar.example.com',
    );
    await fillArea(tester);
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await SettingsEnv.settle(tester);

    final saved = env.core.regions.customRegions.single;
    expect(saved.regionName, 'Campus');
    expect(saved.sidecarBaseUrl, Uri.parse('https://sidecar.example.com'));
    expect(saved.contains(32.88, -117.24), isTrue);
    expect(env.core.currentRegion!.id, saved.id);
    expect(env.core.regions.automaticallySelectRegion, isFalse);
  });

  testWidgets('save is refused when the server does not answer', (
    tester,
  ) async {
    await boot(serverOk: false);
    await env.pump(tester, const CustomRegionPage());
    await type(tester, 'Name', 'Campus');
    await type(tester, 'OneBusAway server URL', 'https://example.com/');
    await fillArea(tester);
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await SettingsEnv.settle(tester);
    expect(env.core.regions.customRegions, isEmpty);
    expect(
      find.text("This server didn't answer like OneBusAway"),
      findsOneWidget,
    );
  });

  testWidgets('editing keeps the id and replaces the region', (tester) async {
    await boot();
    env.core.regions.addCustomRegion(
      Region.custom(
        id: 1042,
        name: 'Old name',
        obaBaseUrl: Uri.parse('https://oba.example.com/'),
        center: const Coordinate(32.88, -117.24),
        latSpan: 0.1,
        lonSpan: 0.2,
      ),
    );
    await env.pump(tester, const CustomRegionPage(editRegionId: 1042));
    expect(find.text('Edit custom region'), findsOneWidget);
    expect(
      tester.widget<TextField>(field('Name')).controller!.text,
      'Old name',
    );
    await type(tester, 'Name', 'New name');
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await SettingsEnv.settle(tester);
    final r = env.core.regions.customRegions.single;
    expect((r.id, r.regionName), (1042, 'New name'));
  });

  testWidgets('the service area can come from the current map view', (
    tester,
  ) async {
    await boot();
    final coordinator = ObaMapCoordinator()
      ..updateCamera(
        center: const Coordinate(47.6, -122.3),
        zoom: 12,
        visibleBounds: const RegionRect(
          minLat: 47.5,
          maxLat: 47.7,
          minLon: -122.5,
          maxLon: -122.1,
        ),
      );
    await env.pump(tester, const CustomRegionPage(), coordinator: coordinator);
    await tester.ensureVisible(find.text('Use the current map area'));
    await tester.tap(find.text('Use the current map area'));
    await tester.pump();
    expect(
      tester.widget<TextField>(field('Center latitude')).controller!.text,
      '47.60000',
    );
    expect(
      tester
          .widget<TextField>(field('Longitude span (degrees)'))
          .controller!
          .text,
      '0.40000',
    );
  });

  testWidgets('no map button without a map', (tester) async {
    await boot();
    await env.pump(tester, const CustomRegionPage());
    expect(find.text('Use the current map area'), findsNothing);
  });

  testWidgets('accessibility', (tester) async {
    await boot();
    await env.expectAccessible(tester, () => const CustomRegionPage());
    await env.pump(
      tester,
      const CustomRegionPage(),
      presentation: ObaPresentation.embedded,
    );
    expect(find.text('Name'), findsOneWidget);
  });
}
