import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  late FakeHttp http;
  late UserDataStore userData;
  late SurveyService service;
  final now = DateTime.utc(2024, 6, 1);

  ObacoClient obaco() => ObacoClient(
    baseUrl: Uri.parse('https://sidecar.example.com'),
    regionId: 1,
    httpClient: http.client,
  );

  setUp(() async {
    http = FakeHttp({
      'surveys.json': (200, fixture('surveys_always_visible_one_time.json')),
      'survey_responses': (200, fixture('survey_submission_response.json')),
    });
    userData = UserDataStore(InMemoryKeyValueStore())
      ..surveyUserIdentifier = 'user-1';
    service = SurveyService(
      obaco: obaco,
      userData: userData,
      regionId: () => 1,
      currentLocation: () => const Coordinate(47.6, -122.3),
    );
    await withClock(Clock.fixed(now), () => service.fetchSurveys());
  });

  test('fetch loads surveys and respects the cooldown', () async {
    expect(service.allSurveys, hasLength(5));
    expect(service.visibleSurveys, hasLength(5));
    expect(http.requests.single.url.queryParameters['user_id'], 'user-1');
    await withClock(
      Clock.fixed(now.add(const Duration(minutes: 4))),
      () => service.fetchSurveys(),
    );
    expect(http.requests, hasLength(1));
    await withClock(
      Clock.fixed(now.add(const Duration(minutes: 6))),
      () => service.fetchSurveys(),
    );
    expect(http.requests, hasLength(2));
    await withClock(
      Clock.fixed(now.add(const Duration(minutes: 6))),
      () => service.fetchSurveys(force: true),
    );
    expect(http.requests, hasLength(3));
  });

  test('without Obaco, records an error', () async {
    final s = SurveyService(obaco: () => null, userData: userData);
    await s.fetchSurveys();
    expect(s.lastError, isA<SurveyServiceUnavailableException>());
  });

  test('priority: always-visible single response first, until completed', () {
    withClock(Clock.fixed(now), () {
      // Survey 1 targets STOP_1 and is always visible, single response.
      expect(service.surveyForStop('STOP_1', [])!.id, 1);
      service.markCompleted(service.allSurveys.firstWhere((s) => s.id == 1));
      expect(service.surveyForStop('STOP_1', []), isNull);
      // Route targeting: survey 3 (one-time) targets ROUTE_20.
      expect(service.surveyForStop('elsewhere', ['ROUTE_20'])!.id, 3);
      // A one-time survey outranks an always-visible multi-response one.
      expect(service.surveyForStop('STOP_3', [])!.id, 2);
      // Map: first one-time (3) wins over multi-response (2, 5).
      expect(service.surveyForMap()!.id, 3);
    });
  });

  test('"later" hides a one-time survey until every third launch', () {
    withClock(Clock.fixed(now), () {
      final s3 = service.allSurveys.firstWhere((s) => s.id == 3);
      service.postpone(s3);
      expect(userData.nextSurveyReminderDate, now.add(const Duration(days: 3)));
      expect(service.surveyForStop('STOP_5', []), isNull);
      for (var i = 0; i < 3; i++) {
        userData.incrementAppLaunchCount();
      }
      expect(service.surveyForStop('STOP_5', [])!.id, 3);
    });
  });

  test('shouldShowSurvey gating', () {
    withClock(Clock.fixed(now), () {
      expect(service.shouldShowSurvey(), isFalse); // launch 0
      for (var i = 0; i < 3; i++) {
        userData.incrementAppLaunchCount();
      }
      expect(service.shouldShowSurvey(), isTrue);
      userData.nextSurveyReminderDate = now.add(const Duration(days: 1));
      expect(service.shouldShowSurvey(), isFalse);
      userData.alwaysShowSurveysOnStops = true;
      expect(service.shouldShowSurvey(), isTrue);
      userData.isSurveyEnabled = false;
      expect(service.shouldShowSurvey(), isFalse);
    });
  });

  test('external survey URL with embedded fields', () {
    final survey = Survey.fromJson({
      'id': 9,
      'name': 'ext',
      'created_at': '2024-01-01T00:00:00Z',
      'updated_at': '2024-01-01T00:00:00Z',
      'study': {'id': 1, 'name': 's'},
      'questions': [
        {
          'id': 1,
          'position': 1,
          'required': false,
          'content': {
            'label_text': 'Go',
            'type': 'external_survey',
            'url': 'https://survey.example.com/s?src=app',
            'embedded_data_fields': [
              'user_id',
              'region_id',
              'stop_id',
              'route_id',
              'recent_stop_ids',
              'current_location',
              'bogus',
            ],
          },
        },
      ],
    });
    userData.addRecentStop(storedStop(id: '1_9'), regionId: 1);
    final url = service.externalSurveyUrl(
      survey,
      stop: const Stop(
        id: '1_1',
        name: 's',
        lat: 0,
        lon: 0,
        routeIds: ['1_10', '1_20'],
      ),
    )!;
    final q = url.queryParameters;
    expect(q['src'], 'app');
    expect(q['user_id'], 'user-1');
    expect(q['region_id'], '1');
    expect(q['stop_id'], '1_1');
    expect(q['route_id'], '1_10,1_20');
    expect(q['recent_stop_ids'], '1_9');
    expect(q['current_location'], '47.6,-122.3');
    expect(q.containsKey('bogus'), isFalse);

    final noFields = service.externalSurveyUrl(
      service.allSurveys.firstWhere((s) => s.id == 1),
    );
    expect(noFields, isNull); // first question is text, no URL
  });

  test('submission and checkbox formatting', () async {
    final survey = service.allSurveys.first;
    final answer = SurveyService.answerFor(survey.questions.first, 'yes');
    final response = await service.submitHeroQuestion(
      survey: survey,
      answer: answer,
      stopId: '1_1',
    );
    expect(response.id, isNotEmpty);
    final body = http.requests.last.body;
    expect(body, contains('user-1'));
    expect(
      SurveyService.formatCheckboxAnswer(['a', 'b']),
      jsonEncode(['a', 'b']),
    );
  });
}
