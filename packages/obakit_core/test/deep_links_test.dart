import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  const router = DeepLinkRouter(scheme: 'onebusaway');
  DeepLink? parse(String s) => router.parse(Uri.parse(s));

  group('custom scheme', () {
    test('view-stop and aliases', () {
      expect(
        parse('onebusaway://view-stop?stopID=1_100&regionID=1'),
        const ViewStopDeepLink(stopId: '1_100', regionId: 1),
      );
      expect(
        parse('onebusaway://viewStop?stop_id=1_100&region_id=1'),
        const ViewStopDeepLink(stopId: '1_100', regionId: 1),
      );
      expect(
        parse('onebusaway://stop?id=1_100'),
        const ViewStopDeepLink(stopId: '1_100'),
      );
      expect(parse('onebusaway://view-stop?stopID=1_100'), isNull);
      expect(parse('onebusaway://view-stop?stopID=1_100&regionID=x'), isNull);
      expect(parse('onebusaway://stop?region=1'), isNull);
      expect(parse('other://view-stop?stopID=1&regionID=1'), isNull);
      expect(parse('onebusaway://unknown'), isNull);
    });

    test('add-region', () {
      final link = parse(
        'onebusaway://add-region?name=Test&oba-url=https%3A%2F%2Foba.example.com%2F'
        '&region-id=%201500%20&otp-graphql-url=https%3A%2F%2Fotp.example.com%2Fgql'
        '&otp-graphql-bikeshare=TRUE&sidecar-url=https%3A%2F%2Fsc.example.com'
        '&umami-url=https%3A%2F%2Fu.example.com&umami-id=%20abc%20&otp-url=notaurl',
      ) as AddRegionDeepLink;
      final d = link.data!;
      expect(d.name, 'Test');
      expect(d.obaUrl.host, 'oba.example.com');
      expect(d.regionId, 1500);
      expect(d.otpUrl, isNull);
      expect(d.supportsOtpGraphqlBikeshare, isTrue);
      expect(d.umamiAnalytics!.id, 'abc');
      final region = d.toRegion();
      expect(region.custom, isTrue);
      expect(region.id, 1500);
      expect(region.sidecarBaseUrl!.host, 'sc.example.com');
      expect(region.supportsOtp, isTrue);

      final bad = parse(
        'onebusaway://add-region?name=Test&oba-url=%20',
      ) as AddRegionDeepLink;
      expect(bad.data, isNull);
      final noUmamiUrl = parse(
        'onebusaway://add-region?name=T&oba-url=https://o&umami-id=x',
      ) as AddRegionDeepLink;
      expect(noUmamiUrl.data!.umamiAnalytics, isNull);
    });

    test('builds view-stop urls that parse back', () {
      final url = router.viewStopUrl(stopId: '1_100', regionId: 1);
      expect(url.toString(), 'onebusaway://view-stop?stopID=1_100&regionID=1');
      expect(
        router.parse(url),
        const ViewStopDeepLink(stopId: '1_100', regionId: 1),
      );
    });
  });

  group('sidecar links', () {
    final region = regionNamed('Puget Sound');

    test('trip share links round-trip', () {
      final a = arrival(
        stopId: '1_10020',
        tripId: '1_604670535',
        stopSequence: 7,
        serviceDate: DateTime.utc(2020, 1, 1, 8),
      );
      final url = DeepLinkRouter.tripShareUrl(
        region: region,
        arrival: a,
        destinationStopId: '1_99',
      )!;
      expect(url.path, '/regions/1/stops/1_10020/trips');
      expect(url.queryParameters['service_date'], '1577865600.0');
      final parsed = router.parse(url) as TripArrivalDeepLink;
      expect(parsed.link.tripId, '1_604670535');
      expect(parsed.link.serviceDate, DateTime.utc(2020, 1, 1, 8));
      expect(parsed.link.stopSequence, 7);
      expect(parsed.link.regionId, 1);
      expect(parsed.link.destinationStopId, '1_99');
    });

    test('iOS-shaped trip urls and invalid ones', () {
      final ok = parse(
        'https://onebusaway.co/regions/1/stops/1_10020/trips?trip_id=t&service_date=1577836800'
        '&stop_sequence=3&vehicle_id=v&title=10%20-%20UW',
      ) as TripArrivalDeepLink;
      expect(ok.link.vehicleId, 'v');
      expect(ok.link.title, '10 - UW');
      expect(
        parse(
          'https://onebusaway.co/regions/1/stops/1_1/trips?trip_id=t&stop_sequence=3',
        ),
        isNull,
      );
      expect(
        parse(
          'https://onebusaway.co/regions/x/stops/1_1/trips?trip_id=t&service_date=1&stop_sequence=3',
        ),
        isNull,
      );
    });

    test('stop page urls', () {
      expect(
        parse('https://onebusaway.co/regions/1/stops/1_75403'),
        const ViewStopDeepLink(stopId: '1_75403', regionId: 1),
      );
      final share = DeepLinkRouter.stopShareUrl(
        region: region,
        stopId: '1_75403',
      )!;
      expect(share.path, '/regions/1/stops/1_75403');
      expect(
        router.parse(share),
        const ViewStopDeepLink(stopId: '1_75403', regionId: 1),
      );
      expect(parse('https://onebusaway.co/regions/1/stops/a/b'), isNull);
    });

    test('no sidecar, no share url', () {
      final none = Region.custom(
        name: 'n',
        obaBaseUrl: Uri.parse('https://o'),
        center: const Coordinate(0, 0),
        latSpan: 1,
        lonSpan: 1,
      );
      expect(DeepLinkRouter.stopShareUrl(region: none, stopId: 's'), isNull);
      expect(
        DeepLinkRouter.tripShareUrl(region: none, arrival: arrival()),
        isNull,
      );
    });
  });

  test('TripDeepLink JSON round-trip and fromArrival', () {
    final link = TripDeepLink.fromArrival(
      arrival(vehicleId: 'v1'),
      regionId: 1,
    );
    expect(link.title, '10 - Downtown');
    expect(TripDeepLink.fromJson(link.toJson()), link);
  });
}
