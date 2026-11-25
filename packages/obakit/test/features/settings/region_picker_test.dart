import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';
import 'settings_support.dart';

void main() {
  late SettingsEnv env;

  Future<void> boot({
    String? regionsPath,
    Map<String, String> responses = const {},
    Map<String, int> statuses = const {},
  }) async {
    env = await SettingsEnv.create(
      withAnalytics: true,
      regionsPath: regionsPath,
      responses: responses,
      statuses: statuses,
    );
    addTearDown(env.dispose);
  }

  Region custom({int id = 1042, String name = 'Campus shuttle'}) =>
      Region.custom(
        id: id,
        name: name,
        obaBaseUrl: Uri.parse('https://oba.example.com/'),
        center: const Coordinate(32.88, -117.24),
        latSpan: 0.1,
        lonSpan: 0.1,
      );

  testWidgets('lists regions, marks the current one with text and icon', (
    tester,
  ) async {
    await boot();
    await env.pump(tester, const RegionPickerPage());
    expect(find.text('Puget Sound'), findsOneWidget);
    expect(find.text('Tampa Bay'), findsOneWidget);
    expect(find.text('Current region'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    // Experimental and inactive regions are hidden by default.
    expect(find.text('Mayaguez (beta)'), findsNothing);
    expect(find.text('Atlanta'), findsNothing);
  });

  testWidgets('experimental and inactive toggles', (tester) async {
    await boot();
    await env.pump(tester, const RegionPickerPage());
    await tester.tap(find.text('Show experimental regions'));
    await tester.pumpAndSettle();
    expect(env.core.settings.showExperimentalRegions, isTrue);
    expect(find.text('Mayaguez (beta)'), findsOneWidget);
    expect(find.text('Experimental'), findsWidgets);

    await tester.tap(find.text('Show inactive regions'));
    await tester.pumpAndSettle();
    expect(find.text('Atlanta'), findsOneWidget);
    expect(find.text('Inactive'), findsWidgets);
  });

  testWidgets('choosing a region turns automatic selection off', (
    tester,
  ) async {
    await boot();
    await env.pump(tester, const RegionPickerPage());
    env.core.regions.automaticallySelectRegion = true;
    await tester.tap(find.text('Tampa Bay'));
    await tester.pumpAndSettle();
    expect(env.core.currentRegion!.regionName, 'Tampa Bay');
    expect(env.core.regions.automaticallySelectRegion, isFalse);
    expect(
      env.analytics.has(AnalyticsLabels.setRegionManually, 'Tampa Bay'),
      isTrue,
    );
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });

  testWidgets('the automatic switch follows the location', (tester) async {
    await boot();
    env.core.regions.automaticallySelectRegion = false;
    await env.pump(tester, const RegionPickerPage());
    await tester.tap(find.text('Choose region automatically'));
    await tester.pumpAndSettle();
    expect(env.core.regions.automaticallySelectRegion, isTrue);
    expect(env.analytics.has(AnalyticsLabels.setRegionAutomatically), isTrue);
  });

  testWidgets('custom regions: listed with edit and delete, add pushes form', (
    tester,
  ) async {
    await boot();
    env.core.regions.addCustomRegion(custom());
    await env.pump(tester, const RegionPickerPage());
    expect(find.text('Custom regions'), findsOneWidget);
    expect(find.text('Campus shuttle'), findsOneWidget);

    await tester.tap(find.byTooltip('Edit Campus shuttle'));
    expect(env.pushed.last, const CustomRegionRoute(editRegionId: 1042));
    await tester.tap(find.text('Add custom region'));
    expect(env.pushed.last, const CustomRegionRoute());

    await tester.tap(find.byTooltip('Delete Campus shuttle'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Campus shuttle?'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(env.core.regions.customRegions, hasLength(1));

    await tester.tap(find.byTooltip('Delete Campus shuttle'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete'));
    await tester.pumpAndSettle();
    expect(env.core.regions.customRegions, isEmpty);
    expect(find.text('Campus shuttle'), findsNothing);
  });

  testWidgets('the current custom region cannot be deleted', (tester) async {
    await boot();
    final r = custom();
    env.core.regions.addCustomRegion(r);
    env.core.regions.setCurrentRegion(r);
    await env.pump(tester, const RegionPickerPage());
    await tester.tap(find.byTooltip('Delete Campus shuttle'));
    await tester.pumpAndSettle();
    expect(find.text('Delete Campus shuttle?'), findsNothing);
    expect(
      find.text('Choose another region before deleting this one.'),
      findsOneWidget,
    );
    expect(env.core.regions.customRegions, hasLength(1));
  });

  testWidgets('refresh success and error state with retry', (tester) async {
    await boot(
      regionsPath: '/regions-v3.json',
      responses: {'regions-v3.json': fixture('regions-v3.json')},
      statuses: {'regions-v3.json': 500},
    );
    await env.pump(tester, const RegionPickerPage());
    await tester.tap(find.byTooltip('Refresh regions'));
    await SettingsEnv.settle(tester);
    expect(
      find.text("Couldn't update the regions list. Showing the saved list."),
      findsOneWidget,
    );
    // The saved list is still usable.
    expect(find.text('Puget Sound'), findsOneWidget);

    // The server recovers.
    env.dispose();
    await boot(
      regionsPath: '/regions-v3.json',
      responses: {'regions-v3.json': fixture('regions-v3.json')},
    );
    await env.pump(tester, const RegionPickerPage());
    await tester.tap(find.byTooltip('Refresh regions'));
    await SettingsEnv.settle(tester);
    expect(find.textContaining("Couldn't update"), findsNothing);
    expect(
      env.requests.where((r) => r.url.path.contains('regions')),
      isNotEmpty,
    );
  });

  testWidgets('works embedded and in the sheet', (tester) async {
    await boot();
    for (final p in [ObaPresentation.embedded, ObaPresentation.sheet]) {
      await env.pump(tester, const RegionPickerPage(), presentation: p);
      expect(find.text('Puget Sound'), findsOneWidget);
    }
  });

  testWidgets('accessibility', (tester) async {
    await boot();
    env.core.regions.addCustomRegion(custom());
    await env.expectAccessible(tester, () => const RegionPickerPage());
  });
}
