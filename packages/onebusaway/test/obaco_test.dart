import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:onebusaway/onebusaway.dart';
import 'package:test/test.dart';

import 'support/fixtures.dart';

http.Response ok(String body) => http.Response.bytes(utf8.encode(body), 200);

typedef Handler = http.Response Function(http.Request request);

ObacoClient make(
  Handler handler, {
  List<http.Request>? log,
  String base = 'https://onebusaway.co',
  bool apnsSandbox = false,
}) => ObacoClient(
  baseUrl: Uri.parse(base),
  regionId: 1,
  apnsSandbox: apnsSandbox,
  httpClient: MockClient((request) async {
    log?.add(request);
    return handler(request);
  }),
);

void main() {
  group('weather', () {
    test('GET weather.json and parse', () async {
      final log = <http.Request>[];
      final c = make((_) => ok(fixture('pugetsound-weather.json')), log: log);
      final w = await c.getWeather();
      expect(log.single.method, 'GET');
      expect(log.single.url.path, '/api/v1/regions/1/weather.json');
      expect(log.single.url.queryParameters['version'], '2');
      expect(w.regionId, 1);
      expect(w.regionName, 'Puget Sound');
      expect(w.location, const Coordinate(47.63671875, -122.6953125));
      expect(w.retrievedAt, DateTime.utc(2018, 10, 17, 22, 15, 55));
      expect(w.currentForecast.iconName, 'clear-day');
      expect(
        w.currentForecast.time,
        DateTime.fromMillisecondsSinceEpoch(1539812965000, isUtc: true),
      );
      expect(w.currentForecast.temperature, 70.51);
      expect(w.hourlyForecasts, isNotEmpty);
    });

    test('keeps a base URL path prefix and default query items', () async {
      final log = <http.Request>[];
      final c = ObacoClient(
        baseUrl: Uri.parse('https://x.test/side/'),
        regionId: 7,
        apiKey: 'k',
        appUid: 'u',
        appVersion: '1.0',
        httpClient: MockClient((r) async {
          log.add(r);
          return ok(fixture('pugetsound-weather.json'));
        }),
      );
      await c.getWeather();
      expect(log.single.url.path, '/side/api/v1/regions/7/weather.json');
      expect(log.single.url.queryParameters, {
        'key': 'k',
        'app_uid': 'u',
        'app_ver': '1.0',
        'version': '2',
      });
    });
  });

  group('alarms', () {
    test('POST form body and parse Alarm', () async {
      final log = <http.Request>[];
      final c = make((_) => ok(fixture('create_alarm.json')), log: log);
      final alarm = await c.postAlarm(
        secondsBefore: const Duration(minutes: 5),
        stopId: '1_75403',
        tripId: '1_trip',
        serviceDate: DateTime.fromMillisecondsSinceEpoch(
          1700000000000,
          isUtc: true,
        ),
        vehicleId: '1_99',
        stopSequence: 12,
        userPushId: 'tok',
      );
      final r = log.single;
      expect(r.method, 'POST');
      expect(r.url.path, '/api/v2/regions/1/alarms');
      expect(
        r.headers['content-type'],
        startsWith('application/x-www-form-urlencoded'),
      );
      expect(Uri.splitQueryString(r.body), {
        'seconds_before': '300',
        'stop_id': '1_75403',
        'trip_id': '1_trip',
        'service_date': '1700000000000',
        'stop_sequence': '12',
        'user_push_id': 'tok',
        'operating_system': 'ios',
        'vehicle_id': '1_99',
      });
      expect(
        alarm.url,
        Uri.parse('https://alerts.example.com/regions/1/alarms/1234567890'),
      );
      expect(alarm.tripDate, isNull);
    });

    test('omits vehicle_id and stamps apns_sandbox', () async {
      final log = <http.Request>[];
      final c = make(
        (_) => ok(fixture('create_alarm.json')),
        log: log,
        apnsSandbox: true,
      );
      await c.postAlarm(
        secondsBefore: const Duration(minutes: 1),
        stopId: 's',
        tripId: 't',
        serviceDate: DateTime.utc(2024),
        stopSequence: 1,
        userPushId: 'p',
      );
      final body = Uri.splitQueryString(log.single.body);
      expect(body.containsKey('vehicle_id'), isFalse);
      expect(body['apns_sandbox'], '1');
    });

    test('DELETE the alarm url', () async {
      final log = <http.Request>[];
      final c = make((_) => http.Response('', 204), log: log);
      await c.deleteAlarm(
        Uri.parse('https://alerts.example.com/regions/1/alarms/9'),
      );
      expect(log.single.method, 'DELETE');
      expect(
        log.single.url.toString(),
        'https://alerts.example.com/regions/1/alarms/9',
      );
    });

    test('alarm dates are epoch seconds', () {
      final a = Alarm.fromJson({
        'url': 'https://a.test/1',
        'tripDate': 1700000000,
        'alarmDate': 1699999700,
      });
      expect(
        a.tripDate,
        DateTime.fromMillisecondsSinceEpoch(1700000000000, isUtc: true),
      );
      expect(
        a.alarmDate,
        DateTime.fromMillisecondsSinceEpoch(1699999700000, isUtc: true),
      );
    });
  });

  group('vehicles', () {
    test('GET with query and parse list', () async {
      final log = <http.Request>[];
      final c = make((_) => ok(fixture('vehicles-query-1_1.json')), log: log);
      final v = await c.getVehicles('11');
      expect(log.single.method, 'GET');
      expect(log.single.url.path, '/api/v1/regions/1/vehicles');
      expect(log.single.url.queryParameters['query'], '11');
      expect(v, isNotEmpty);
      expect(v.first.agencyId, '1');
      expect(v.first.agencyName, 'Metro Transit');
      expect(v.first.vehicleId, '1_1156');
    });

    test('non-list body is a format error', () async {
      final c = make((_) => http.Response('{}', 200));
      await expectLater(c.getVehicles('x'), throwsA(isA<ObaFormatException>()));
    });
  });

  group('ghost bus reports', () {
    test('POST form body', () async {
      final log = <http.Request>[];
      final c = make(
        (_) => ok(fixture('create_ghost_bus_report.json')),
        log: log,
      );
      final report = await c.postGhostBusReport(
        GhostBusReportDraft(
          tripId: '1_t',
          serviceDate: DateTime.fromMillisecondsSinceEpoch(
            1700000000000,
            isUtc: true,
          ),
          routeId: '1_r',
          stopId: '1_s',
          predicted: true,
          scheduledArrivalAt: DateTime.fromMillisecondsSinceEpoch(
            1700000600000,
            isUtc: true,
          ),
          scheduleDeviationMinutes: -2,
          comment: 'never came',
          userLatitude: 47.5,
          userLongitude: -122.3,
        ),
        userId: 'u1',
      );
      expect(report.id, 'c0ffee00c0ffee00c0ff');
      final r = log.single;
      expect(r.method, 'POST');
      expect(r.url.path, '/api/v2/regions/1/ghost_bus_reports');
      expect(Uri.splitQueryString(r.body), {
        'user_identifier': 'u1',
        'trip_identifier': '1_t',
        'service_date': '1700000000000',
        'wait_duration_minutes': '15',
        'route_identifier': '1_r',
        'stop_identifier': '1_s',
        'predicted': '1',
        'scheduled_arrival_at': '1700000600000',
        'schedule_deviation_minutes': '-2',
        'comment': 'never came',
        'user_latitude': '47.5',
        'user_longitude': '-122.3',
      });
    });
  });

  group('push registrations', () {
    test('POST form body', () async {
      final log = <http.Request>[];
      final c = make((_) => http.Response('', 201), log: log);
      await c.postPushRegistration(
        token: 'abc',
        locale: 'en_US',
        testDevice: true,
        description: 'Pixel',
      );
      expect(log.single.method, 'POST');
      expect(log.single.url.path, '/api/v2/regions/1/push_registrations');
      expect(Uri.splitQueryString(log.single.body), {
        'token': 'abc',
        'operating_system': 'ios',
        'locale': 'en_US',
        'test_device': 'true',
        'description': 'Pixel',
      });
    });

    test('DELETE with token query', () async {
      final log = <http.Request>[];
      final c = make((_) => http.Response('', 200), log: log);
      await c.deletePushRegistration('abc');
      expect(log.single.method, 'DELETE');
      expect(log.single.url.path, '/api/v2/regions/1/push_registrations');
      expect(log.single.url.queryParameters['token'], 'abc');
    });
  });

  group('surveys', () {
    test('GET surveys.json?user_id= and parse', () async {
      final log = <http.Request>[];
      final c = make(
        (_) => ok(fixture('surveys_always_visible_one_time.json')),
        log: log,
      );
      final res = await c.getSurveys(userId: 'u-1');
      expect(log.single.url.path, '/api/v1/regions/1/surveys.json');
      expect(log.single.url.queryParameters['user_id'], 'u-1');
      expect(res.region.name, 'Puget Sound');
      final s = res.surveys.first;
      expect(s.name, startsWith('Always Visible'));
      expect(s.alwaysVisible, isTrue);
      expect(s.createdAt, DateTime.utc(2025, 11, 21, 9, 32, 38, 934));
      expect(s.study.name, 'OBA 2025');
      expect(
        s.questions.map((q) => q.content.type),
        contains(QuestionType.externalSurvey),
      );
      expect(s.questions[1].content.options, ['Yes', 'No']);
      expect(s.heroQuestion!.position, 1);
      expect(s.remainingQuestions, isNot(contains(s.heroQuestion)));
      final inRange = DateTime.utc(2025, 1, 1);
      expect(s.isActive(inRange), isTrue);
      expect(s.isActive(DateTime.utc(2100)), isFalse);
      expect(s.shouldShowOnStop('STOP_1', inRange), isTrue);
      expect(s.shouldShowOnStop('OTHER', inRange), isFalse);
      expect(s.shouldShowOnRoute('ROUTE_2', inRange), isTrue);
      expect(s.shouldShowOnMap(inRange), isTrue);
    });

    test('missing optional fields default', () async {
      final c = make(
        (_) => ok(fixture('surveys_missing_optional_fields.json')),
      );
      final s = (await c.getSurveys(userId: 'u')).surveys.single;
      expect(s.alwaysVisible, isFalse);
      expect(s.allowsMultipleResponses, isFalse);
      expect(s.visibleStopsList, isNull);
    });

    test('malformed survey response is a format error', () async {
      final c = make((_) => ok(fixture('surveys_malformed_response.json')));
      await expectLater(
        c.getSurveys(userId: 'u'),
        throwsA(isA<ObaFormatException>()),
      );
    });

    test(
      'POST survey_responses sends JSON with responses as a string',
      () async {
        final log = <http.Request>[];
        final c = make(
          (_) => ok(fixture('survey_submission_response.json')),
          log: log,
        );
        final res = await c.submitSurveyResponse(
          const SurveySubmission(
            userIdentifier: 'u',
            surveyId: 3,
            stopIdentifier: '1_s',
            stopLatitude: 1.5,
            stopLongitude: 2.5,
            responses: [
              QuestionAnswerSubmission(
                questionId: 15,
                questionType: 'text',
                questionLabel: 'Q?',
                answer: 'yes',
              ),
            ],
          ),
        );
        final r = log.single;
        expect(r.method, 'POST');
        expect(r.url.path, '/api/v1/survey_responses/');
        expect(r.headers['content-type'], startsWith('application/json'));
        final body = jsonDecode(r.body) as Map<String, Object?>;
        expect(body['user_identifier'], 'u');
        expect(body['survey_id'], 3);
        expect(body['stop_identifier'], '1_s');
        expect(body['stop_latitude'], 1.5);
        expect(body['stop_longitude'], 2.5);
        expect(body['responses'], isA<String>());
        expect(jsonDecode(body['responses']! as String), [
          {
            'question_id': 15,
            'question_type': 'text',
            'question_label': 'Q?',
            'answer': 'yes',
          },
        ]);
        expect(res.id, '808d3a515daa39f4c15a');
        expect(res.updatePath, '/api/v1/survey_responses/808d3a515daa39f4c15a');
      },
    );

    test('malformed submission response is a format error', () async {
      final c = make(
        (_) => ok(fixture('survey_submission_malformed_response.json')),
      );
      await expectLater(
        c.submitSurveyResponse(
          const SurveySubmission(
            userIdentifier: 'u',
            surveyId: 1,
            responses: [],
          ),
        ),
        throwsA(isA<ObaFormatException>()),
      );
    });

    test('PUT survey_responses/{id}', () async {
      final log = <http.Request>[];
      final c = make(
        (_) => ok(fixture('survey_submission_response.json')),
        log: log,
      );
      await c.updateSurveyResponse('a/b', const [
        QuestionAnswerSubmission(
          questionId: 16,
          questionType: 'radio',
          questionLabel: 'L',
          answer: 'No',
        ),
      ]);
      final r = log.single;
      expect(r.method, 'PUT');
      expect(r.url.path, '/api/v1/survey_responses/a%2Fb');
      final body = jsonDecode(r.body) as Map<String, Object?>;
      expect(body.keys, ['responses']);
      expect(
        (jsonDecode(body['responses']! as String) as List).single['answer'],
        'No',
      );
    });
  });

  group('errors', () {
    test('non-2xx is httpStatus', () async {
      final c = make((_) => http.Response('', 503));
      await expectLater(
        c.getWeather(),
        throwsA(
          isA<ObaApiException>()
              .having((e) => e.kind, 'kind', ObaApiErrorKind.httpStatus)
              .having((e) => e.code, 'code', 503),
        ),
      );
    });

    test('empty 200 body is emptyResponse', () async {
      final c = make((_) => http.Response('', 200));
      await expectLater(
        c.getWeather(),
        throwsA(
          isA<ObaApiException>().having(
            (e) => e.kind,
            'kind',
            ObaApiErrorKind.emptyResponse,
          ),
        ),
      );
    });

    test('bad JSON is ObaFormatException', () async {
      final c = make((_) => http.Response('<html>', 200));
      await expectLater(c.getWeather(), throwsA(isA<ObaFormatException>()));
    });

    test('a body that is not UTF-8 is ObaFormatException', () async {
      // 0xC3 opens a two-byte sequence that 0x28 does not continue.
      final c = make((_) => http.Response.bytes([0x7B, 0xC3, 0x28, 0x7D], 200));
      await expectLater(c.getWeather(), throwsA(isA<ObaFormatException>()));
      await expectLater(c.getVehicles('x'), throwsA(isA<ObaFormatException>()));
    });

    test('an alarm URL nothing can be sent to is ObaFormatException', () {
      for (final url in ['http://[bad', '/regions/1/alarms/9', '']) {
        expect(
          () => Alarm.fromJson({'url': url}),
          throwsA(isA<ObaFormatException>()),
          reason: url,
        );
      }
    });

    test('transport failure is ObaNetworkException', () async {
      final c = ObacoClient(
        baseUrl: Uri.parse('https://x.test'),
        regionId: 1,
        httpClient: MockClient((_) async => throw http.ClientException('down')),
      );
      await expectLater(c.getWeather(), throwsA(isA<ObaNetworkException>()));
    });

    test('timeout is ObaNetworkException', () async {
      final c = ObacoClient(
        baseUrl: Uri.parse('https://x.test'),
        regionId: 1,
        timeout: const Duration(milliseconds: 10),
        httpClient: MockClient(
          (_) => Future.delayed(
            const Duration(seconds: 1),
            () => http.Response('{}', 200),
          ),
        ),
      );
      await expectLater(c.getWeather(), throwsA(isA<ObaNetworkException>()));
    });
  });
}
