import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onebusaway/onebusaway.dart';
import 'package:test/test.dart';

import 'support/fixtures.dart';

void main() {
  late List<Region> regions;
  setUpAll(() => regions = Region.listFromJson(fixture('regions-v3.json')));

  Region byName(String n) => regions.firstWhere((r) => r.regionName == n);

  group('parsing', () {
    test('parses every region in the bundled file', () {
      expect(regions.length, greaterThan(5));
      final tampa = byName('Tampa Bay');
      expect(tampa.id, 0);
      expect(
        tampa.obaBaseUrl,
        Uri.parse('https://api.tampa.onebusaway.org/api/'),
      );
      expect(tampa.sidecarBaseUrl, Uri.parse('https://onebusaway.co'));
      expect(tampa.umamiAnalytics!.id, 'abc-123-uuid');
      expect(tampa.supportsOtpBikeshare, isTrue);
      expect(tampa.open311Servers, hasLength(1));
      expect(tampa.paymentIosAppUrlScheme, 'fb313213768708402HART');
      expect(tampa.supportsMobileFarePayment, isTrue);
    });

    test('blank and garbage URLs become null', () {
      final tampa = byName('Tampa Bay');
      expect(tampa.facebookUrl, isNull); // ""
      expect(tampa.stopInfoUrl, isNull); // null
      final r = Region.fromJson({
        ...byName('Puget Sound').toJson(),
        'twitterUrl': 'not a url',
        'facebookUrl': '   ',
      });
      expect(r.twitterUrl, isNull);
      expect(r.facebookUrl, isNull);
    });

    test('missing obaBaseUrl is a format error', () {
      final json = byName('Puget Sound').toJson()..remove('obaBaseUrl');
      expect(() => Region.fromJson(json), throwsA(isA<ObaFormatException>()));
    });

    test('envelope errors surface', () {
      expect(
        () => Region.listFromJson('{"code":500,"text":"boom","data":{}}'),
        throwsA(isA<ObaApiException>()),
      );
      expect(
        () => Region.listFromJson('nope'),
        throwsA(isA<ObaFormatException>()),
      );
      expect(() => Region.listFromJson(''), throwsA(isA<ObaApiException>()));
    });
  });

  group('derived values', () {
    test('supportsOtp', () {
      expect(byName('Tampa Bay').supportsOtp, isTrue);
      final none = Region(
        id: 1,
        regionName: 'x',
        obaBaseUrl: Uri.parse('https://x.test/'),
      );
      expect(none.supportsOtp, isFalse);
    });

    test('supportsScheduleForRoute follows obaVersionInfo', () {
      Region withVersion(String v) => Region(
        id: 1,
        regionName: 'x',
        obaBaseUrl: Uri.parse('https://x.test/'),
        obaVersionInfo: v,
      );
      expect(
        withVersion('2.0.1|2|0|1|x|abc').supportsScheduleForRoute,
        isFalse,
      );
      expect(
        withVersion('2.4.15-cs|2|4|15|cs|abc').supportsScheduleForRoute,
        isTrue,
      );
      expect(withVersion('').supportsScheduleForRoute, isTrue);
      expect(withVersion('garbage').supportsScheduleForRoute, isTrue);
      expect(withVersion('a|b|c').supportsScheduleForRoute, isTrue);
    });

    test('serviceRect is the union of the bounds boxes', () {
      final r = Region(
        id: 1,
        regionName: 'x',
        obaBaseUrl: Uri.parse('https://x.test/'),
        bounds: const [
          RegionBound(lat: 10, lon: 20, latSpan: 2, lonSpan: 4),
          RegionBound(lat: 12, lon: 25, latSpan: 2, lonSpan: 2),
        ],
      );
      final rect = r.serviceRect;
      expect(rect.minLat, 9);
      expect(rect.maxLat, 13);
      expect(rect.minLon, 18);
      expect(rect.maxLon, 26);
      expect(r.centerCoordinate, const Coordinate(11, 22));
      expect(r.contains(11, 22), isTrue);
      expect(r.contains(8, 22), isFalse);
      expect(r.contains(11, 27), isFalse);
    });

    test('distanceFrom is the haversine distance to the centre', () {
      final r = Region.custom(
        name: 'x',
        obaBaseUrl: Uri.parse('https://x.test/'),
        center: const Coordinate(0, 0),
        latSpan: 1,
        lonSpan: 1,
      );
      // One degree of latitude is about 111.2 km.
      expect(r.distanceFrom(1, 0), closeTo(111195, 100));
      expect(r.distanceFrom(0, 0), 0);
    });

    test('Puget Sound contains Seattle but not Tampa', () {
      final ps = byName('Puget Sound');
      expect(ps.contains(47.6062, -122.3321), isTrue);
      expect(ps.contains(27.95, -82.46), isFalse);
      expect(
        ps.distanceFrom(47.6062, -122.3321),
        lessThan(ps.distanceFrom(27.95, -82.46)),
      );
    });

    test('region with no bounds contains nothing', () {
      final r = Region(
        id: 1,
        regionName: 'x',
        obaBaseUrl: Uri.parse('https://x.test/'),
      );
      expect(r.contains(0, 0), isFalse);
    });
  });

  group('JSON round trip', () {
    test('every bundled region survives toJson/fromJson', () {
      for (final r in regions) {
        final again = Region.fromJson(
          jsonDecode(jsonEncode(r.toJson())) as Map<String, Object?>,
        );
        expect(again, r, reason: r.regionName);
        expect(again.hashCode, r.hashCode);
        expect(jsonEncode(again.toJson()), jsonEncode(r.toJson()));
      }
    });

    test('custom region round trips and has Swift defaults', () {
      final r = Region.custom(
        name: 'Mine',
        obaBaseUrl: Uri.parse('https://oba.example.com/'),
        center: const Coordinate(1, 2),
        latSpan: 0.5,
        lonSpan: 0.25,
        contactEmail: 'a@b.c',
        id: 1234,
        otpBaseGraphqlUrl: Uri.parse('https://otp.example.com/gql'),
        supportsOtpGraphqlBikeshare: true,
      );
      expect(r.custom, isTrue);
      expect(r.active, isTrue);
      expect(r.obaVersionInfo, 'x.y.z.custom');
      expect(r.supportsOtp, isTrue);
      expect(r.isBikeshareEnabled, isTrue);
      final again = Region.fromJson(
        jsonDecode(jsonEncode(r.toJson())) as Map<String, Object?>,
      );
      expect(again, r);
      expect(again.custom, isTrue);
      expect(again.serviceRect.minLat, 0.75);
    });

    test('random custom id is in 1000..1999', () {
      final r = Region.custom(
        name: 'x',
        obaBaseUrl: Uri.parse('https://x.test/'),
        center: const Coordinate(0, 0),
        latSpan: 1,
        lonSpan: 1,
      );
      expect(r.id, inInclusiveRange(1000, 1999));
    });
  });

  group('RegionsClient', () {
    test('defaults to regions.onebusaway.org/regions-v3.json', () async {
      late http.BaseRequest seen;
      final client = RegionsClient(
        httpClient: MockClient((request) async {
          seen = request;
          return http.Response(fixture('regions-v3.json'), 200);
        }),
      );
      final list = await client.fetch();
      expect(seen.method, 'GET');
      expect(
        seen.url.toString(),
        'https://regions.onebusaway.org/regions-v3.json',
      );
      expect(list, hasLength(regions.length));
    });

    test('custom base URL, path and key', () async {
      late Uri seen;
      final client = RegionsClient(
        baseUrl: Uri.parse('https://example.com/prefix/'),
        path: '/r.json',
        apiKey: 'k',
        httpClient: MockClient((request) async {
          seen = request.url;
          return http.Response(
            fixture('regions-puget-sound-no-sidecar.json'),
            200,
          );
        }),
      );
      final list = await client.fetch();
      expect(seen.toString(), 'https://example.com/prefix/r.json?key=k');
      expect(list.single.sidecarBaseUrl, isNull);
    });

    test('maps failures to ObaException', () async {
      RegionsClient with_(http.Response Function() f) =>
          RegionsClient(httpClient: MockClient((_) async => f()));
      await expectLater(
        with_(() => http.Response('', 500)).fetch(),
        throwsA(
          isA<ObaApiException>().having(
            (e) => e.kind,
            'kind',
            ObaApiErrorKind.httpStatus,
          ),
        ),
      );
      await expectLater(
        with_(() => http.Response('', 200)).fetch(),
        throwsA(
          isA<ObaApiException>().having(
            (e) => e.kind,
            'kind',
            ObaApiErrorKind.emptyResponse,
          ),
        ),
      );
      await expectLater(
        with_(() => http.Response('<html>', 200)).fetch(),
        throwsA(isA<ObaFormatException>()),
      );
      await expectLater(
        RegionsClient(
          httpClient: MockClient(
            (_) async => throw http.ClientException('down'),
          ),
        ).fetch(),
        throwsA(isA<ObaNetworkException>()),
      );
    });
  });
}
