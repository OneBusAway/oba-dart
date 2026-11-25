import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import 'settings_support.dart';

void main() {
  late SettingsEnv env;

  Future<void> boot({
    bool analytics = false,
    Map<String, String>? store,
  }) async {
    env = await SettingsEnv.create(
      withAnalytics: analytics,
      storeValues: store ?? const {},
    );
    addTearDown(env.dispose);
  }

  Future<void> tapSwitch(WidgetTester tester, String label) async {
    final finder = find.widgetWithText(SwitchListTile, label);
    await tester.ensureVisible(finder);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  testWidgets('switches write to ObaSettings', (tester) async {
    await boot();
    await env.pump(tester, const SettingsPage());
    final s = env.core.settings;

    await tapSwitch(tester, 'Show heading');
    expect(s.mapShowsHeading, isFalse);
    expect(find.text('Show stop labels'), findsNothing);
    await tapSwitch(tester, 'Reduce colors on stop pages');
    expect(s.reducedColors, isTrue);
    expect(find.text('Compact stop and trip pages'), findsNothing);
    await tapSwitch(tester, 'Bike mode');
    expect(s.bikeModeEnabled, isTrue);
  });

  testWidgets('radio groups write to ObaSettings', (tester) async {
    await boot();
    await env.pump(tester, const SettingsPage());
    final s = env.core.settings;

    Future<void> choose(String label) async {
      final f = find.text(label);
      await tester.ensureVisible(f);
      await tester.tap(f);
      await tester.pumpAndSettle();
    }

    await choose('Real-time only');
    expect(s.arrivalDepartureFilter, ArrivalDepartureFilter.estimatedOnly);
    await choose('Scheduled only');
    expect(s.arrivalDepartureFilter, ArrivalDepartureFilter.scheduledOnly);
    await choose('Fast');
    expect(s.walkingSpeedPreset, WalkingSpeedPreset.fast);
    expect(s.walkingSpeedMetersPerSecond, 1.8);
    await choose('Google Maps');
    expect(s.walkingDirectionsProvider, WalkingDirectionsProvider.googleMaps);
    await choose('Ask every time');
    expect(s.walkingDirectionsProvider, WalkingDirectionsProvider.askEveryTime);
  });

  testWidgets('Apple Maps is offered on Apple platforms only', (tester) async {
    await boot();
    await env.pump(tester, const SettingsPage());
    expect(find.text('Apple Maps'), findsNothing);

    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await env.pump(tester, const SettingsPage());
      expect(find.text('Apple Maps'), findsOneWidget);
      await tester.tap(find.text('Apple Maps'));
      await tester.pumpAndSettle();
      expect(
        env.core.settings.walkingDirectionsProvider,
        WalkingDirectionsProvider.appleMaps,
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('a synced walking speed shows as custom', (tester) async {
    await boot();
    env.core.settings.walkingSpeedMetersPerSecond = 1.2;
    await env.pump(tester, const SettingsPage());
    expect(find.text('Custom (1.2 m/s)'), findsOneWidget);
  });

  testWidgets('the map row opens map settings', (tester) async {
    await boot();
    await env.pump(tester, const SettingsPage());
    await tester.tap(find.text('Map type and layers'));
    expect(env.pushed, [const MapSettingsRoute()]);
  });

  testWidgets('privacy appears only with analytics', (tester) async {
    await boot();
    await env.pump(tester, const SettingsPage());
    expect(find.text('Send usage data to the developers'), findsNothing);
    env.dispose();

    await boot(analytics: true);
    await env.pump(tester, const SettingsPage());
    expect(find.text('Send usage data to the developers'), findsOneWidget);
    await tapSwitch(tester, 'Send usage data to the developers');
    expect(env.core.settings.analyticsReportingEnabled, isFalse);
  });

  testWidgets('surveys switches', (tester) async {
    await boot();
    await env.pump(tester, const SettingsPage());
    await tapSwitch(tester, 'Always show surveys on stops');
    expect(env.core.userData.alwaysShowSurveysOnStops, isTrue);
    await tapSwitch(tester, 'Show surveys');
    expect(env.core.userData.isSurveyEnabled, isFalse);
  });

  testWidgets('debug section: debug mode reveals the feedback controls', (
    tester,
  ) async {
    await boot();
    await env.pump(tester, const SettingsPage());
    expect(kDebugMode, isTrue);
    expect(find.text('Debug mode'), findsOneWidget);
    expect(find.text('Reset feedback prompt state'), findsNothing);
    await tapSwitch(tester, 'Debug mode');
    expect(env.core.settings.debugMode, isTrue);
    await tapSwitch(tester, 'Always show the feedback prompt');
    expect(env.core.reviewPrompt.alwaysShow, isTrue);
    await tester.ensureVisible(find.text('Reset feedback prompt state'));
    await tester.tap(find.text('Reset feedback prompt state'));
    expect(env.core.reviewPrompt.alwaysShow, isTrue);
  });

  testWidgets('trip planner switch for a region with OTP', (tester) async {
    await boot();
    expect(env.core.currentRegion!.supportsOtp, isTrue);
    await env.pump(tester, const SettingsPage());
    await tapSwitch(tester, 'Trip planner in this region');
    expect(env.core.userData.isTripPlanningEnabled(1), isFalse);
  });

  testWidgets('works embedded and in the sheet', (tester) async {
    await boot();
    for (final p in [ObaPresentation.embedded, ObaPresentation.sheet]) {
      await env.pump(tester, const SettingsPage(), presentation: p);
      expect(find.text('Walking speed'), findsWidgets);
    }
  });

  testWidgets('accessibility', (tester) async {
    await boot(analytics: true);
    await env.expectAccessible(tester, () => const SettingsPage());
  });
}
