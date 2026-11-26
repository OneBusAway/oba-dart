import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  const valid = CustomRegionDraft(
    name: ' Campus ',
    obaUrl: 'https://oba.example.com/',
    latitude: '32.88',
    longitude: '-117.24',
    latSpan: '0.1',
    lonSpan: '0.2',
  );

  group('CustomRegionDraft', () {
    test('a complete draft builds a custom region', () {
      expect(valid.isValid, isTrue);
      final r = valid.toRegion(id: 1042);
      expect(r.id, 1042);
      expect(r.custom, isTrue);
      expect(r.regionName, 'Campus');
      expect(r.contains(32.88, -117.24), isTrue);
      expect(r.contains(40, -117.24), isFalse);
    });

    test('errors per field', () {
      const d = CustomRegionDraft(
        obaUrl: 'ftp://x',
        latitude: '91',
        longitude: 'abc',
        latSpan: '0',
        sidecarUrl: 'nope',
      );
      expect(d.nameError(), CustomRegionFieldError.required);
      expect(d.obaUrlError(), CustomRegionFieldError.invalidUrl);
      expect(d.latitudeError(), CustomRegionFieldError.outOfRange);
      expect(d.longitudeError(), CustomRegionFieldError.invalidNumber);
      expect(d.latSpanError(), CustomRegionFieldError.outOfRange);
      expect(d.lonSpanError(), CustomRegionFieldError.required);
      expect(
        CustomRegionDraft.optionalUrlError(d.sidecarUrl),
        CustomRegionFieldError.invalidUrl,
      );
      expect(CustomRegionDraft.optionalUrlError(''), isNull);
      expect(d.isValid, isFalse);
      expect(() => d.toRegion(), throwsStateError);
    });

    test('optional URLs are kept', () {
      final r = valid
          .copyWith(
            sidecarUrl: 'https://sidecar.example.com',
            otpUrl: 'https://otp.example.com/otp/',
          )
          .toRegion();
      expect(r.sidecarBaseUrl, Uri.parse('https://sidecar.example.com'));
      expect(r.otpBaseUrl, Uri.parse('https://otp.example.com/otp/'));
    });

    test('fromRegion round-trips', () {
      final r = valid.toRegion(id: 5);
      final back = CustomRegionDraft.fromRegion(r);
      expect(back.name, 'Campus');
      expect(back.latitude, '32.88');
      expect(back.toRegion(id: 5).obaBaseUrl, r.obaBaseUrl);
    });
  });

  group('ObaServerValidator', () {
    Future<ServerCheck> check(Map<String, (int, String)> routes) {
      final http = FakeHttp(routes);
      return ObaServerValidator(
        apiKey: 'k',
        httpClient: http.client,
      ).check(Uri.parse('https://oba.example.com/'));
    }

    test('valid when current-time answers', () async {
      expect(
        await check({'current-time': (200, fixture('current_time.json'))}),
        ServerCheck.valid,
      );
    });

    test('falls back to config', () async {
      expect(
        await check({
          'current-time': (404, 'x'),
          'config': (200, fixture('config-java.json')),
        }),
        ServerCheck.valid,
      );
    });

    test('a server that answers neither is not OneBusAway', () async {
      expect(await check({}), ServerCheck.notOneBusAway);
      expect(
        await check({'current-time': (200, '<html></html>')}),
        ServerCheck.notOneBusAway,
      );
    });
  });
}
