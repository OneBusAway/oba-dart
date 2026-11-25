import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import 'settings_support.dart';

void main() {
  late SettingsEnv env;

  Future<void> boot({
    String region = 'Puget Sound',
    DonationsConfig donations = DonationsConfig.disabled,
    MoreTabConfig? moreTab,
    String? appStoreId,
    String? playStoreId,
    String os = 'android',
    bool analytics = true,
    Uri? privacy,
    String? developerEmail,
    FakeLinkOpener? opener,
  }) async {
    env = await SettingsEnv.create(
      region: region,
      donations: donations,
      moreTab: moreTab,
      appStoreId: appStoreId,
      playStoreId: playStoreId,
      operatingSystem: os,
      withAnalytics: analytics,
      privacyPolicyUrl: privacy,
      developerEmail: developerEmail,
      opener: opener,
    );
    addTearDown(env.dispose);
  }

  Future<void> tapRow(WidgetTester tester, String text) async {
    final f = find.text(text);
    await tester.ensureVisible(f);
    await tester.pumpAndSettle();
    await tester.tap(f);
    await tester.pumpAndSettle();
  }

  testWidgets('default rows, header and version', (tester) async {
    await boot();
    await env.pump(tester, const MorePage());
    expect(
      find.text('This app is made and supported by volunteers.'),
      findsOne,
    );
    expect(find.text('Alerts'), findsOneWidget);
    expect(find.text('Region'), findsOneWidget);
    expect(find.text('Puget Sound'), findsOneWidget);
    expect(find.text('Agencies'), findsOneWidget);
    expect(find.text('Contact us'), findsOneWidget);
    expect(find.text('Credits'), findsOneWidget);
    // Hidden by default.
    expect(find.text('Donate to OneBusAway'), findsNothing);
    expect(find.text('Privacy policy'), findsNothing);
    expect(find.textContaining('Rate '), findsNothing);
    expect(find.text('Tutorials'), findsNothing);
    await tester.ensureVisible(find.text('OneBusAway version 1.2.3'));
    expect(find.text('OneBusAway version 1.2.3'), findsOneWidget);
    // The default config offers the source code link but no translation link.
    expect(find.text('Help fix bugs and build new features'), findsOneWidget);
    expect(find.text('Help translate the app'), findsNothing);
  });

  testWidgets('navigation rows push routes', (tester) async {
    await boot();
    await env.pump(tester, const MorePage());
    await tapRow(tester, 'Alerts');
    await tapRow(tester, 'Region');
    await tapRow(tester, 'Agencies');
    await tapRow(tester, 'Credits');
    expect(env.pushed, [
      const AlertsListRoute(),
      const RegionPickerRoute(),
      const AgenciesRoute(),
      const CreditsRoute(),
    ]);
  });

  testWidgets('config drives the optional rows', (tester) async {
    await boot(
      donations: DonationsConfig(
        enabled: true,
        managementPortal: Uri.parse('https://donate.example.com/manage'),
      ),
      moreTab: MoreTabConfig(
        headerSupportText: 'Powered by UCSD.',
        translateUrl: Uri.parse('https://translate.example.com'),
        tutorialUrl: Uri.parse('https://example.com/help'),
        phoneUrl: Uri.parse('tel:+18585551234'),
        textUrl: Uri.parse('sms:12345'),
        customLinks: [
          MoreTabLink(
            title: 'Shuttle rules',
            url: Uri.parse('https://example.com/rules'),
          ),
        ],
      ),
      privacy: Uri.parse('https://example.com/privacy'),
      playStoreId: 'org.example.app',
    );
    await env.pump(tester, const MorePage());
    for (final t in [
      'Powered by UCSD.',
      'Donate to OneBusAway',
      'Manage donations',
      'Help translate the app',
      'Tutorials',
      'Call agency',
      'Message agency',
      'Shuttle rules',
      'Privacy policy',
      'Rate OneBusAway',
    ]) {
      await tester.ensureVisible(find.text(t));
      expect(find.text(t), findsOneWidget, reason: t);
    }
    // This MoreTabConfig has no develop URL.
    expect(find.text('Help fix bugs and build new features'), findsNothing);

    await tapRow(tester, 'Tutorials');
    await tapRow(tester, 'Call agency');
    await tapRow(tester, 'Shuttle rules');
    await tapRow(tester, 'Privacy policy');
    await tapRow(tester, 'Rate OneBusAway');
    expect(env.opener.opened.map((u) => u.toString()), [
      'https://example.com/help',
      'tel:+18585551234',
      'https://example.com/rules',
      'https://example.com/privacy',
      'https://play.google.com/store/apps/details?id=org.example.app',
    ]);
    expect(env.analytics.has(AnalyticsLabels.rateAppRowTapped), isTrue);
  });

  testWidgets('help-out section can be hidden', (tester) async {
    await boot(
      moreTab: MoreTabConfig(
        showHelpOutSection: false,
        translateUrl: Uri.parse('https://t.example.com'),
        developUrl: Uri.parse('https://d.example.com'),
      ),
    );
    await env.pump(tester, const MorePage());
    expect(find.text('Help make the app better'), findsNothing);
  });

  testWidgets('donate opens the donation page and stops the card', (
    tester,
  ) async {
    await boot(donations: const DonationsConfig(enabled: true));
    await env.pump(tester, const MorePage());
    await tapRow(tester, 'Donate to OneBusAway');
    expect(env.opener.opened.single.host, 'opentransitsoftwarefoundation.org');
    expect(env.analytics.has(AnalyticsLabels.donateButtonTapped), isTrue);
    expect(env.core.donationPrompt.dismissedDate, isNotNull);
  });

  group('Pay my fare', () {
    testWidgets('hidden when the region has no payment app', (tester) async {
      await boot(region: 'MTA New York');
      await env.pump(tester, const MorePage());
      expect(find.text('Pay my fare'), findsNothing);
    });

    testWidgets('warning once, then the store page on Android', (tester) async {
      await boot();
      await env.pump(tester, const MorePage());
      await tapRow(tester, 'Pay my fare');
      expect(find.text('Check before you buy!'), findsOneWidget);
      // Cancel opens nothing.
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(env.opener.attempted, isEmpty);

      await tapRow(tester, 'Pay my fare');
      await tester.tap(find.text("Continue and don't show again"));
      await tester.pumpAndSettle();
      expect(env.opener.opened.single.toString(), contains('co.bytemark.tgt'));
      expect(
        env.analytics.has(AnalyticsLabels.farePayment, 'download_app'),
        isTrue,
      );

      await tapRow(tester, 'Pay my fare');
      expect(find.text('Check before you buy!'), findsNothing);
      expect(env.opener.opened, hasLength(2));
    });

    testWidgets('iOS opens the app, then falls back to the App Store', (
      tester,
    ) async {
      final opener = FakeLinkOpener(
        accept: (u) => u.scheme != 'co.bytemark.tgt',
      );
      await boot(os: 'ios', opener: opener);
      env.core.farePayments.suppressWarning(env.core.currentRegion!);
      await env.pump(tester, const MorePage());
      await tapRow(tester, 'Pay my fare');
      expect(opener.attempted.map((u) => u.toString()), [
        'co.bytemark.tgt://',
        'https://apps.apple.com/app/id1131345078',
      ]);
      expect(
        env.analytics.has(AnalyticsLabels.farePayment, 'download_app'),
        isTrue,
      );

      opener.attempted.clear();
      opener.accept = (_) => true;
      await tapRow(tester, 'Pay my fare');
      expect(opener.opened.last.toString(), 'co.bytemark.tgt://');
      expect(
        env.analytics.has(AnalyticsLabels.farePayment, 'open_app'),
        isTrue,
      );
    });
  });

  group('Contact us', () {
    testWidgets('opens a mail with app and region details', (tester) async {
      await boot(developerEmail: 'dev@example.com');
      await env.pump(tester, const MorePage());
      await tapRow(tester, 'Contact us');
      expect(find.text('Feature request or bug report'), findsOneWidget);
      await tester.tap(find.text('Feature request or bug report'));
      await tester.pumpAndSettle();
      final uri = env.opener.opened.single;
      expect(uri.scheme, 'mailto');
      expect(uri.path, 'dev@example.com');
      expect(uri.queryParameters['subject'], 'OneBusAway feedback');
      final body = uri.queryParameters['body']!;
      expect(body, contains('App version = 1.2.3'));
      expect(body, contains('Region = Puget Sound'));
      expect(body, contains('Operating system = android'));
      expect(body, contains('User ID = ${env.core.userUuid}'));
      expect(
        env.analytics.has(
          AnalyticsLabels.reportProblem,
          'feedback_app_feedback_email',
        ),
        isTrue,
      );
    });

    testWidgets('the agency address comes from the region', (tester) async {
      await boot();
      await env.pump(tester, const MorePage());
      await tapRow(tester, 'Contact us');
      await tester.tap(find.text('Vehicle or schedule problem'));
      await tester.pumpAndSettle();
      expect(env.opener.opened.single.path, 'onebusaway@soundtransit.org');
      expect(
        env.opener.opened.single.queryParameters['body'],
        isNot(contains('User ID')),
      );
    });

    testWidgets('without a mail app it offers to copy', (tester) async {
      final copied = trackClipboard(tester);
      final opener = FakeLinkOpener(accept: (u) => u.scheme != 'mailto');
      await boot(opener: opener);
      await env.pump(tester, const MorePage());
      await tapRow(tester, 'Contact us');
      await tester.tap(find.text('Feature request or bug report'));
      await tester.pumpAndSettle();
      expect(find.text("Can't open your email app"), findsOneWidget);
      expect(
        find.textContaining(ObaSupport.defaultDeveloperEmail),
        findsOneWidget,
      );
      await tester.tap(find.text('Copy email address'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Copy debug info'));
      await tester.pumpAndSettle();
      expect(copied.first, ObaSupport.defaultDeveloperEmail);
      expect(copied.last, contains('Region = Puget Sound'));
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
      expect(find.text("Can't open your email app"), findsNothing);
    });
  });

  test('review URLs follow the platform', () async {
    await boot(appStoreId: '123', playStoreId: 'org.x');
    ObaAppConfig cfg(String os) => ObaAppConfig(
      appName: 'a',
      apiKey: 'k',
      appVersion: '1',
      bundledRegionsJson: '{}',
      keyValueStore: env.store,
      locationProvider: env.location,
      appStoreId: '123',
      playStoreId: 'org.x',
      operatingSystem: os,
    );
    expect(
      ObaSupport.reviewUrl(cfg('ios')).toString(),
      'https://apps.apple.com/app/id123?action=write-review',
    );
    expect(
      ObaSupport.reviewUrl(cfg('android')).toString(),
      'https://play.google.com/store/apps/details?id=org.x',
    );
  });

  testWidgets('accessibility, embedded and sheet', (tester) async {
    await boot(
      donations: DonationsConfig(
        enabled: true,
        managementPortal: Uri.parse('https://donate.example.com/manage'),
      ),
      moreTab: MoreTabConfig(
        tutorialUrl: Uri.parse('https://example.com/help'),
        translateUrl: Uri.parse('https://t.example.com'),
        developUrl: Uri.parse('https://d.example.com'),
      ),
      privacy: Uri.parse('https://example.com/privacy'),
      playStoreId: 'org.example.app',
    );
    await env.expectAccessible(tester, () => const MorePage());
    await env.pump(
      tester,
      const MorePage(),
      presentation: ObaPresentation.embedded,
    );
    expect(find.text('Alerts'), findsOneWidget);
    await env.pump(
      tester,
      const MorePage(),
      presentation: ObaPresentation.sheet,
    );
    expect(find.text('Alerts'), findsOneWidget);
  });
}
