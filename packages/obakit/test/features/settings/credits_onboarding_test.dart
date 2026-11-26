import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import 'settings_support.dart';

void main() {
  late SettingsEnv env;

  Future<void> boot({
    LocationPermissionStatus permission =
        LocationPermissionStatus.notDetermined,
    ObaLocation? location,
    String region = 'Puget Sound',
    bool onboardingDone = true,
  }) async {
    env = await SettingsEnv.create(
      permission: permission,
      location: location,
      region: region,
      onboardingDone: onboardingDone,
    );
    addTearDown(env.dispose);
  }

  group('credits', () {
    testWidgets('shows the license, the map attribution and the licenses row', (
      tester,
    ) async {
      await boot();
      await env.pump(tester, const CreditsPage());
      expect(
        find.textContaining('Apache License, Version 2.0'),
        findsOneWidget,
      );
      expect(find.text('Map data: OpenStreetMap contributors'), findsOneWidget);
      await tester.tap(find.text('Map data: OpenStreetMap contributors'));
      expect(env.opener.opened.single.host, 'www.openstreetmap.org');
      await tester.ensureVisible(
        find.text('The libraries this app is built with.'),
      );
      await tester.tap(find.text('The libraries this app is built with.'));
      expect(env.pushed.last, const ObaLicensesRoute());
    });

    testWidgets('the licenses page lists packages from LicenseRegistry', (
      tester,
    ) async {
      LicenseRegistry.addLicense(
        () => Stream.value(
          const LicenseEntryWithLineBreaks(['zeta_pkg'], 'Zeta license text'),
        ),
      );
      await boot();
      await env.pump(tester, const ObaLicensesPage());
      expect(find.text('zeta_pkg'), findsOneWidget);
      expect(find.text('1 license'), findsWidgets);
      await tester.tap(find.text('zeta_pkg'));
      await tester.pumpAndSettle();
      expect(find.text('Zeta license text'), findsOneWidget);
    });

    testWidgets('accessibility', (tester) async {
      await boot();
      await env.expectAccessible(tester, () => const CreditsPage());
      await env.pump(
        tester,
        const CreditsPage(),
        presentation: ObaPresentation.embedded,
      );
      expect(find.text('Credits'), findsNothing);
      expect(find.text('OneBusAway'), findsOneWidget);
    });
  });

  group('onboarding', () {
    testWidgets('welcome continues', (tester) async {
      await boot();
      var done = 0;
      await env.pump(
        tester,
        OnboardingStepPage(
          step: OnboardingStep.welcome,
          onComplete: () => done++,
        ),
      );
      expect(find.text('Welcome to OneBusAway'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      expect(done, 1);
    });

    testWidgets('location: allow asks for permission, not now does not', (
      tester,
    ) async {
      await boot();
      var done = 0;
      await env.pump(
        tester,
        OnboardingStepPage(
          step: OnboardingStep.location,
          onComplete: () => done++,
        ),
      );
      expect(find.text('See nearby stops'), findsOneWidget);
      await tester.tap(find.text('Not now'));
      expect(done, 1);
      expect(env.location.requestCount, 0);
      await tester.tap(find.text('Allow location access'));
      await SettingsEnv.settle(tester);
      expect(env.location.requestCount, 1);
      expect(done, 2);
    });

    testWidgets('location: says so when access was refused', (tester) async {
      await boot(permission: LocationPermissionStatus.denied);
      await env.pump(
        tester,
        OnboardingStepPage(step: OnboardingStep.location, onComplete: () {}),
      );
      expect(
        find.text(
          'Location access is off. You can still choose your region yourself.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('region: the detected region is offered first', (tester) async {
      await boot(
        permission: LocationPermissionStatus.whileInUse,
        location: ObaLocation(
          lat: 47.6,
          lon: -122.33,
          timestamp: DateTime(2026),
        ),
      );
      env.core.regions.automaticallySelectRegion = false;
      env.core.regions.updateLocation(
        ObaLocation(lat: 47.6, lon: -122.33, timestamp: DateTime(2026)),
      );
      var done = 0;
      await env.pump(
        tester,
        OnboardingStepPage(
          step: OnboardingStep.region,
          onComplete: () => done++,
        ),
      );
      expect(find.text('Detected near you'), findsOneWidget);
      expect(find.text('Or choose another region'), findsOneWidget);
      await tester.tap(find.text('Use Puget Sound'));
      expect(done, 1);
      expect(env.core.currentRegion!.regionName, 'Puget Sound');
    });

    testWidgets('region: manual choice turns automatic selection off', (
      tester,
    ) async {
      await boot(region: 'Nowhere');
      var done = 0;
      await env.pump(
        tester,
        OnboardingStepPage(
          step: OnboardingStep.region,
          onComplete: () => done++,
        ),
      );
      expect(find.text('Detected near you'), findsNothing);
      await tester.tap(find.text('Tampa Bay'));
      expect(done, 1);
      expect(env.core.currentRegion!.regionName, 'Tampa Bay');
      expect(env.core.regions.automaticallySelectRegion, isFalse);
    });

    testWidgets('a step is shown again when its version is raised', (
      tester,
    ) async {
      await boot(onboardingDone: false);
      final s = env.core.settings;
      s.markOnboardingStepSeen(OnboardingStep.welcome.settingsKey, 1);
      expect(
        s.needsOnboardingStep(OnboardingStep.welcome.settingsKey, 1),
        isFalse,
      );
      expect(
        s.needsOnboardingStep(OnboardingStep.welcome.settingsKey, 2),
        isTrue,
      );
    });

    testWidgets('accessibility', (tester) async {
      await boot();
      for (final step in OnboardingStep.values) {
        await env.expectAccessible(
          tester,
          () => OnboardingStepPage(step: step, onComplete: () {}),
        );
      }
    });
  });

  test('kDebugMode is on in tests', () => expect(kDebugMode, isTrue));
}
