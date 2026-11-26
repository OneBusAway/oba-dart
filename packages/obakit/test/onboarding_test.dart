import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import 'support/oba_test_harness.dart';

void main() {
  group('pendingSteps', () {
    test('a fresh install sees welcome and location', () async {
      final env = await ObaTestEnv.create(onboardingDone: false);
      expect(ObaOnboardingGate.pendingSteps(env.app.core), [
        OnboardingStep.welcome,
        OnboardingStep.location,
      ]);
      env.dispose();
    });

    test('granted location skips the location step', () async {
      final env = await ObaTestEnv.create(
        onboardingDone: false,
        permission: LocationPermissionStatus.whileInUse,
      );
      expect(ObaOnboardingGate.pendingSteps(env.app.core), [
        OnboardingStep.welcome,
      ]);
      env.dispose();
    });

    test('no region forces the region step even when seen', () async {
      final env = await ObaTestEnv.create(region: 'Nowhere');
      expect(env.app.core.regions.needsRegionSelection, isTrue);
      expect(ObaOnboardingGate.pendingSteps(env.app.core), [
        OnboardingStep.region,
      ]);
      env.dispose();
    });

    test('steps can be switched off, except region', () async {
      final env = await ObaTestEnv.create(
        onboardingDone: false,
        region: 'Nowhere',
      );
      expect(ObaOnboardingGate.pendingSteps(env.app.core, enabled: const {}), [
        OnboardingStep.region,
      ]);
      env.dispose();
    });
  });

  testWidgets('the gate walks through the steps to the shell', (tester) async {
    final env = await ObaTestEnv.create(
      onboardingDone: false,
      region: 'Nowhere',
    );
    addTearDown(env.dispose);
    await env.pumpApp(tester, surfaceSize: const Size(390, 844));
    expect(find.text('Welcome to OneBusAway'), findsOneWidget);
    expect(find.byType(ObaHomeShell), findsNothing);
    await expectObaAccessibility(tester);

    await tester.tap(find.text('Continue'));
    await ObaTestEnv.settle(tester);
    expect(find.text('Find stops near you'), findsOneWidget);
    await tester.tap(find.text('Allow location access'));
    await ObaTestEnv.settle(tester);
    expect(env.location.requestCount, 1);

    expect(find.text('Choose your region'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Puget Sound'), 100);
    await tester.tap(find.text('Puget Sound'));
    await ObaTestEnv.settle(tester);
    expect(find.byType(ObaHomeShell), findsOneWidget);
    expect(env.app.core.currentRegion?.regionName, 'Puget Sound');
  });

  testWidgets('"Allow" completes the location step even when the gate moves '
      'on before the first fix arrives', (tester) async {
    final provider = _SlowFixProvider();
    final env = await ObaTestEnv.create(
      onboardingDone: false,
      locationProvider: provider,
    );
    addTearDown(env.dispose);
    final settings = env.app.core.settings;
    const step = OnboardingStep.location;
    await env.pumpApp(tester, surfaceSize: const Size(390, 844));
    await tester.tap(find.text('Continue'));
    await ObaTestEnv.settle(tester);
    expect(find.text('Find stops near you'), findsOneWidget);

    // Granted at once; the fix takes a while (as a real GPS does), and the
    // gate shows the shell meanwhile.
    await tester.tap(find.text('Allow location access'));
    await ObaTestEnv.settle(tester);
    expect(provider.fix.isCompleted, isFalse);
    expect(find.byType(ObaHomeShell), findsOneWidget);
    provider.fix.complete(null);
    await ObaTestEnv.settle(tester);

    // Recorded: a permission that lapses later (iOS "Allow Once" ends with
    // the session) must not bring the step back on the next launch.
    expect(
      settings.needsOnboardingStep(step.settingsKey, step.version),
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });
}

/// Grants permission when asked; the first fix arrives when the test
/// completes [fix].
class _SlowFixProvider implements LocationProvider {
  final Completer<ObaLocation?> fix = Completer();
  bool _granted = false;

  LocationPermissionStatus get _status => _granted
      ? LocationPermissionStatus.whileInUse
      : LocationPermissionStatus.notDetermined;

  @override
  Future<LocationPermissionStatus> checkPermission() async => _status;

  @override
  Future<LocationPermissionStatus> requestPermission() async {
    _granted = true;
    return _status;
  }

  @override
  Future<ObaLocation?> currentPosition() => fix.future;

  @override
  Stream<ObaLocation> get positionStream => const Stream.empty();

  @override
  ObaLocation? get lastKnownLocation => null;
}
