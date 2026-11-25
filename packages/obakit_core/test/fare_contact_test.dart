import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  final regions = regionsFixture();
  final puget = regions.firstWhere((r) => r.regionName == 'Puget Sound');
  final tampa = regions.firstWhere((r) => r.regionName == 'Tampa Bay');
  final newYork = regions.firstWhere((r) => r.regionName == 'MTA New York');

  group('FarePayments', () {
    test('support depends on platform', () {
      expect(FarePayments.isSupported(puget, 'ios'), isTrue);
      expect(FarePayments.isSupported(puget, 'android'), isTrue);
      expect(FarePayments.isSupported(newYork, 'ios'), isFalse);
      expect(FarePayments.isSupported(newYork, 'android'), isFalse);
    });

    test('targets', () {
      final ios = FarePayments.targetFor(puget, 'ios');
      expect(ios.appUri, Uri.parse('co.bytemark.tgt://'));
      expect(
        ios.storeUri,
        Uri.parse('https://apps.apple.com/app/id1131345078'),
      );
      final android = FarePayments.targetFor(puget, 'android');
      expect(android.appUri, isNull);
      expect(
        android.storeUri.toString(),
        'https://play.google.com/store/apps/details?id=co.bytemark.tgt',
      );
      expect(FarePayments.targetFor(newYork, 'android').isEmpty, isTrue);
    });

    test('the warning shows until suppressed, per region', () {
      final f = FarePayments(InMemoryKeyValueStore());
      expect(f.shouldShowWarning(puget), isTrue);
      expect(f.shouldShowWarning(tampa), isFalse, reason: 'no warning text');
      f.suppressWarning(puget);
      expect(f.shouldShowWarning(puget), isFalse);
    });
  });

  group('ContactUsMessage', () {
    final message = ContactUsMessage(
      target: ContactTarget.appDevelopers,
      address: 'app@example.com',
      subject: 'OneBusAway Feedback',
      intro: 'How can we help?',
      debugIntro: 'For troubleshooting.',
      debugInfo: const [
        DebugInfoEntry('App Version', '1.0.0'),
        DebugInfoEntry('Region', 'Puget Sound'),
      ],
    );

    test('mailto encodes subject and body', () {
      final uri = message.mailto;
      expect(uri.scheme, 'mailto');
      expect(uri.path, 'app@example.com');
      expect(uri.queryParameters['subject'], 'OneBusAway Feedback');
      expect(uri.queryParameters['body'], contains('App Version = 1.0.0'));
      expect(uri.toString(), isNot(contains('+')));
    });

    test('agency mail has no debug block', () {
      const m = ContactUsMessage(
        target: ContactTarget.transitAgency,
        address: 'a@b.c',
        subject: 's',
        intro: 'hi',
      );
      expect(m.body, isNot(contains('---')));
    });
  });

  test('donate url defaults to OTSF', () {
    expect(
      DonationsConfig.disabled.effectiveDonateUrl.host,
      'opentransitsoftwarefoundation.org',
    );
    expect(
      const DonationsConfig(donateUrl: null).effectiveDonateUrl,
      DonationsConfig.defaultDonateUrl,
    );
  });
}
