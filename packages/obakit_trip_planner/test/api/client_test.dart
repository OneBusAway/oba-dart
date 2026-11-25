import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart';

import '../support/fixtures.dart';

final _request = TripPlanRequest(
  origin: const OtpCoordinate(47.6097, -122.3331),
  destination: const OtpCoordinate(47.6615, -122.3130),
  dateTime: DateTime(2026, 11, 25, 9),
);

final _graphqlUrl = Uri.parse('https://gql.example.org/otp/');
final _restUrl = Uri.parse('https://rest.example.org/otp/');

http.Response _json(String body, [int status = 200]) => http.Response(
  body,
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

void main() {
  group('OtpGraphQLService over HTTP', () {
    test('POSTs JSON to gtfs/v1 and parses the response', () async {
      late http.Request sent;
      final client = OtpClient(
        graphqlBaseUrl: _graphqlUrl,
        headers: {'x-api-key': 'secret'},
        httpClient: MockClient((request) async {
          sent = request;
          return _json(fixtureString(stGraphQLFixture));
        }),
      );
      final plan = await client.plan(_request);
      expect(plan.itineraries, hasLength(3));
      expect(sent.method, 'POST');
      expect(sent.url.toString(), 'https://gql.example.org/otp/gtfs/v1');
      expect(sent.headers['Content-Type'], startsWith('application/json'));
      expect(sent.headers['x-api-key'], 'secret');
      final body = jsonDecode(sent.body) as Map<String, dynamic>;
      expect(body.keys, containsAll(['query', 'variables']));
      expect(body['variables']['time'], '9:00 AM');
    });
  });

  group('error mapping', () {
    test('non-200 is OtpHttpException', () async {
      final client = OtpClient(
        restBaseUrl: _restUrl,
        httpClient: MockClient((_) async => _json('{}', 503)),
      );
      await expectLater(
        client.plan(_request),
        throwsA(
          isA<OtpHttpException>().having((e) => e.statusCode, 'status', 503),
        ),
      );
    });

    test('a client exception is OtpNetworkException', () async {
      final client = OtpClient(
        restBaseUrl: _restUrl,
        httpClient: MockClient((_) async => throw http.ClientException('down')),
      );
      await expectLater(
        client.plan(_request),
        throwsA(isA<OtpNetworkException>()),
      );
    });

    test('a timeout is OtpNetworkException', () async {
      final client = OtpClient(
        restBaseUrl: _restUrl,
        timeout: const Duration(milliseconds: 10),
        httpClient: MockClient((_) => Completer<http.Response>().future),
      );
      await expectLater(
        client.plan(_request),
        throwsA(isA<OtpNetworkException>()),
      );
    });

    test('non-JSON and wrongly-typed bodies are OtpFormatException', () async {
      for (final body in ['<html>', '[]', '{"plan": {"date": "soon"}}']) {
        final client = OtpClient(
          restBaseUrl: _restUrl,
          httpClient: MockClient((_) async => _json(body)),
        );
        await expectLater(
          client.plan(_request),
          throwsA(isA<OtpFormatException>()),
          reason: body,
        );
      }
    });
  });

  group('GraphQL → REST fallback', () {
    late List<Uri> calls;

    OtpClient both(http.Response Function(http.Request) graphql) {
      calls = [];
      return OtpClient(
        graphqlBaseUrl: _graphqlUrl,
        restBaseUrl: _restUrl,
        httpClient: MockClient((request) async {
          calls.add(request.url);
          if (request.url.host == 'gql.example.org') return graphql(request);
          return _json(fixtureString(sdRestFixture));
        }),
      );
    }

    test('uses GraphQL when it succeeds', () async {
      final client = both((_) => _json(fixtureString(stGraphQLFixture)));
      final plan = await client.plan(_request);
      expect(plan.source, OtpApiFlavor.graphql);
      expect(calls, hasLength(1));
    });

    test('falls back on HTTP errors', () async {
      final client = both((_) => _json('not found', 404));
      final plan = await client.plan(_request);
      expect(plan.source, OtpApiFlavor.rest);
      expect(calls.map((u) => u.host), ['gql.example.org', 'rest.example.org']);
      expect(calls.last.path, '/otp/routers/default/plan');
    });

    test('falls back on GraphQL errors', () async {
      final client = both(
        (_) => _json('{"errors":[{"message":"Unknown field longName"}]}'),
      );
      expect((await client.plan(_request)).source, OtpApiFlavor.rest);
    });

    test('falls back on malformed responses', () async {
      final client = both((_) => _json('<html>'));
      expect((await client.plan(_request)).source, OtpApiFlavor.rest);
    });

    test('does not fall back on a planner answer', () async {
      final client = both(
        (_) => _json(fixtureString('graphql/graphql_plan_routing_error.json')),
      );
      await expectLater(
        client.plan(_request),
        throwsA(isA<OtpPlannerException>()),
      );
      expect(calls, hasLength(1));
    });

    test('throws the REST error when both fail', () async {
      final client = OtpClient(
        graphqlBaseUrl: _graphqlUrl,
        restBaseUrl: _restUrl,
        httpClient: MockClient(
          (request) async => request.url.host == 'gql.example.org'
              ? _json('{}', 500)
              : _json('{}', 502),
        ),
      );
      await expectLater(
        client.plan(_request),
        throwsA(
          isA<OtpHttpException>().having((e) => e.statusCode, 'status', 502),
        ),
      );
    });

    test('REST-only clients go straight to REST', () async {
      calls = [];
      final client = OtpClient(
        restBaseUrl: _restUrl,
        httpClient: MockClient((request) async {
          calls.add(request.url);
          return _json(fixtureString(sdRestFixture));
        }),
      );
      expect((await client.plan(_request)).source, OtpApiFlavor.rest);
      expect(calls.single.queryParameters['showIntermediateStops'], 'true');
    });
  });
}
