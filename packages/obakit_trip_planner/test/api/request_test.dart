import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:obakit_trip_planner/obakit_trip_planner.dart';

TripPlanRequest _request({
  List<TransportMode> modes = const [TransportMode.transit, TransportMode.walk],
  bool arriveBy = false,
  bool wheelchair = false,
  OtpCoordinate? via,
  DateTime? dateTime,
}) => TripPlanRequest(
  origin: const OtpCoordinate(32.88012, -117.23401),
  destination: const OtpCoordinate(32.7157, -117.1611),
  dateTime: dateTime ?? DateTime(2026, 11, 25, 9, 5),
  transportModes: modes,
  maxWalkDistance: 1609,
  wheelchairAccessible: wheelchair,
  arriveBy: arriveBy,
  viaPoint: via,
);

void main() {
  final client = http.Client();
  tearDownAll(client.close);

  group('TripPlanRequest wire formatting', () {
    test('date is MM-dd-yyyy and time is h:mm AM/PM', () {
      expect(_request().formattedDate, '11-25-2026');
      expect(_request().formattedTime, '9:05 AM');
      final evening = _request(dateTime: DateTime(2026, 1, 2, 21, 0));
      expect(evening.formattedDate, '01-02-2026');
      expect(evening.formattedTime, '9:00 PM');
      expect(
        _request(dateTime: DateTime(2026, 1, 2)).formattedTime,
        '12:00 AM',
      );
      expect(
        _request(dateTime: DateTime(2026, 1, 2, 12, 30)).formattedTime,
        '12:30 PM',
      );
    });

    test('coordinates format with four decimals', () {
      expect(
        const OtpCoordinate(47.60971, -122.3331).formattedForApi,
        '47.6097,-122.3331',
      );
    });

    test('composite modes expand and dedupe in first-seen order', () {
      final request = _request(
        modes: [TransportMode.transitBikeRental, TransportMode.walk],
      );
      expect(request.wireTransportModes, [
        TransportMode.transit,
        TransportMode.walk,
        TransportMode.bikeRental,
      ]);
      expect(request.transportModesString, 'TRANSIT,WALK,BICYCLE_RENT');
      expect(TransportMode.bike.apiModes, [
        TransportMode.bike,
        TransportMode.walk,
      ]);
    });

    test('isValid rejects bad coordinates, distances and empty modes', () {
      expect(_request().isValid, isTrue);
      expect(_request(modes: const []).isValid, isFalse);
      expect(
        TripPlanRequest(
          origin: const OtpCoordinate(91, 0),
          destination: const OtpCoordinate(0, 0),
          dateTime: DateTime(2026),
        ).isValid,
        isFalse,
      );
    });
  });

  group('OtpRestService', () {
    test('appends routers/default to a bare OTP root', () {
      for (final base in [
        'https://realtime.sdmts.com:9091/otp',
        'https://realtime.sdmts.com:9091/otp/',
      ]) {
        final service = OtpRestService(
          baseUrl: Uri.parse(base),
          httpClient: client,
        );
        expect(
          service.baseUrl.toString(),
          'https://realtime.sdmts.com:9091/otp/routers/default',
        );
      }
    });

    test('keeps an existing router segment', () {
      final service = OtpRestService(
        baseUrl: Uri.parse(
          'https://otp.prod.sound.obaweb.org/otp/routers/default/',
        ),
        httpClient: client,
      );
      expect(service.buildUri(_request()).path, '/otp/routers/default/plan');
    });

    test('builds the OTPKit query in order with percent-encoding', () {
      final service = OtpRestService(
        baseUrl: Uri.parse('https://example.org/otp/'),
        httpClient: client,
      );
      final uri = service.buildUri(_request(arriveBy: true, wheelchair: true));
      expect(
        uri.toString(),
        'https://example.org/otp/routers/default/plan'
        '?fromPlace=32.8801%2C-117.2340'
        '&toPlace=32.7157%2C-117.1611'
        '&time=9%3A05%20AM'
        '&date=11-25-2026'
        '&mode=TRANSIT%2CWALK'
        '&arriveBy=true'
        '&maxWalkDistance=1609'
        '&wheelchair=true'
        '&showIntermediateStops=true',
      );
      expect(uri.queryParameters['time'], '9:05 AM');
    });

    test('adds intermediatePlaces for a via point', () {
      final service = OtpRestService(
        baseUrl: Uri.parse('https://example.org/otp/'),
        httpClient: client,
      );
      final uri = service.buildUri(
        _request(via: const OtpCoordinate(32.75, -117.2)),
      );
      expect(uri.queryParameters['intermediatePlaces'], '32.7500,-117.2000');
    });
  });

  group('OtpGraphQLService', () {
    test('normalizes the endpoint from either URL flavour', () {
      for (final (base, expected) in [
        (
          'https://sound-transit-otp.ibi-transit.com/otp/',
          'https://sound-transit-otp.ibi-transit.com/otp/gtfs/v1',
        ),
        (
          'https://sound-transit-otp.ibi-transit.com/otp',
          'https://sound-transit-otp.ibi-transit.com/otp/gtfs/v1',
        ),
        (
          'https://otp.example.org/otp/routers/default/',
          'https://otp.example.org/otp/gtfs/v1',
        ),
        (
          'https://otp.example.org/otp/gtfs/v1/',
          'https://otp.example.org/otp/gtfs/v1',
        ),
      ]) {
        expect(
          OtpGraphQLService.normalizeEndpoint(Uri.parse(base)).toString(),
          expected,
          reason: base,
        );
      }
    });

    test('builds query and variables like OTPKit', () {
      final service = OtpGraphQLService(
        baseUrl: Uri.parse('https://example.org/otp/'),
        httpClient: client,
      );
      final body = service.buildBody(
        _request(
          modes: [TransportMode.bike, TransportMode.bikeRental],
          arriveBy: true,
        ),
      );
      final variables = body['variables'] as Map<String, Object?>;
      expect(variables, {
        'from': {'lat': 32.88012, 'lon': -117.23401},
        'to': {'lat': 32.7157, 'lon': -117.1611},
        'date': '11-25-2026',
        'time': '9:05 AM',
        'transportModes': [
          {'mode': 'BICYCLE'},
          {'mode': 'BICYCLE', 'qualifier': 'RENT'},
        ],
        'arriveBy': true,
        'wheelchair': false,
        'maxWalkDistance': 1609.0,
      });
      final query = body['query'] as String;
      expect(query, contains(r'plan('));
      expect(query, contains('longName'));
      expect(query, isNot(contains('via')));
      // The body must be JSON-encodable as sent.
      expect(() => jsonEncode(body), returnsNormally);
    });

    test('declares via only when the request has one', () {
      final service = OtpGraphQLService(
        baseUrl: Uri.parse('https://example.org/otp/'),
        httpClient: client,
      );
      final body = service.buildBody(_request(via: const OtpCoordinate(1, 2)));
      expect(body['query'], contains(r'$via: [PlanViaLocationInput!]'));
      expect(body['query'], contains(r'via: $via'));
      expect((body['variables'] as Map)['via'], [
        {
          'visit': {
            'coordinate': {'latitude': 1.0, 'longitude': 2.0},
          },
        },
      ]);
    });
  });

  group('OtpClient.fromRegion', () {
    test('returns null without any usable URL', () {
      expect(OtpClient.fromRegion(), isNull);
      expect(OtpClient.fromRegion(otpBaseUrl: '  '), isNull);
    });

    test('configures whichever flavours the region has', () {
      final both = OtpClient.fromRegion(
        otpBaseGraphqlUrl: 'https://sound-transit-otp.ibi-transit.com/otp/',
        otpBaseUrl: 'https://otp.prod.sound.obaweb.org/otp/routers/default/',
        httpClient: client,
      )!;
      expect(both.graphql, isNotNull);
      expect(both.rest, isNotNull);
      expect(both.supportsVehicleRental, isTrue);

      final restOnly = OtpClient.fromRegion(
        otpBaseUrl: 'https://realtime.sdmts.com:9091/otp',
        httpClient: client,
      )!;
      expect(restOnly.graphql, isNull);
      expect(restOnly.supportsVehicleRental, isFalse);
    });
  });
}
