import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit/src/features/settings/settings_routes.dart'
    show settingsHomeSections;

import 'settings_support.dart';

void main() {
  late SettingsEnv env;

  setUp(() async => env = await SettingsEnv.create());
  tearDown(() => env.dispose());

  testWidgets('route builder maps routes to pages', (tester) async {
    await env.pump(tester, const SizedBox());
    final context = tester.element(find.byType(SizedBox).first);
    for (final (route, type) in <(ObaRoute, Type)>[
      (const SettingsRoute(), SettingsPage),
      (const MoreRoute(), MorePage),
      (const RegionPickerRoute(), RegionPickerPage),
      (const CustomRegionRoute(), CustomRegionPage),
      (const CreditsRoute(), CreditsPage),
      (const ObaLicensesRoute(), ObaLicensesPage),
      (const ObaDonationRoute(), ObaDonationPage),
    ]) {
      expect(
        ObaRouteBuilder.build(context, route).runtimeType,
        type,
        reason: '$route',
      );
    }
    expect(
      ObaRouteBuilder.build(
        context,
        const OnboardingRoute(OnboardingStep.welcome),
      ),
      isA<OnboardingStepPage>(),
    );
  });

  testWidgets('the home section opens map settings, settings and more', (
    tester,
  ) async {
    final section = settingsHomeSections.single;
    expect(section.id, 'more');
    expect(section.order, 50);
    await env.pump(
      tester,
      feed([Builder(builder: section.builder)]),
      presentation: ObaPresentation.embedded,
    );
    expect(find.text('Settings and more'), findsOneWidget);
    await tester.tap(find.text('Customize map'));
    await tester.tap(find.text('Settings'));
    await tester.tap(find.text('More'));
    expect(env.pushed, [
      const MapSettingsRoute(),
      const SettingsRoute(),
      const MoreRoute(),
    ]);
  });

  testWidgets('home section accessibility', (tester) async {
    await env.expectAccessible(
      tester,
      () => feed(const [SettingsAndMoreSection()]),
    );
  });
}
