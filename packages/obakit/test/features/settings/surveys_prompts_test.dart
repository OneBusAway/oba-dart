import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';
import 'settings_support.dart';

/// The answers of a survey submission request, decoded (the request body
/// carries them as a JSON string inside JSON).
List<Map<String, Object?>> _answersOf(http.Request request) {
  final body = jsonDecode(request.body) as Map<String, Object?>;
  final responses = body['responses'];
  final decoded = responses is String ? jsonDecode(responses) : responses;
  return [for (final r in decoded as List) (r as Map).cast<String, Object?>()];
}

Map<String, Object?> _surveysJson(List<Map<String, Object?>> questions) {
  final json = jsonDecode(
    fixture('surveys_always_visible_one_time.json'),
  ) as Map<String, Object?>;
  final survey = Map<String, Object?>.from(
    (json['surveys']! as List).first as Map,
  )..['questions'] = questions;
  return {
    ...json,
    'surveys': [survey],
  };
}

Map<String, Object?> _q(
  int id,
  int position,
  String type,
  String label, {
  bool required = true,
  Map<String, Object?> extra = const {},
}) => {
  'id': id,
  'position': position,
  'required': required,
  'content': {'type': type, 'label_text': label, ...extra},
};

void main() {
  late SettingsEnv env;

  Future<void> boot({
    Map<String, Object?>? surveys,
    DonationsConfig donations = DonationsConfig.disabled,
    String? playStoreId,
    String? developerEmail,
    FakeLinkOpener? opener,
  }) async {
    env = await SettingsEnv.create(
      responses: {
        'surveys.json': surveys == null
            ? fixture('surveys_always_visible_one_time.json')
            : jsonEncode(surveys),
        'survey_responses': fixture('survey_submission_response.json'),
      },
      withAnalytics: true,
      donations: donations,
      playStoreId: playStoreId,
      developerEmail: developerEmail,
      opener: opener,
    );
    addTearDown(env.dispose);
  }

  Future<void> pumpCard(WidgetTester tester, {Stop? stop}) async {
    await env.pump(tester, feed([ObaSurveyCard(key: UniqueKey(), stop: stop)]));
    await SettingsEnv.settle(tester);
  }

  const stop1 = Stop(id: 'STOP_1', name: 'Stop 1', lat: 1, lon: 2);

  group('ObaSurveyCard', () {
    testWidgets('shows nothing unless surveys should show', (tester) async {
      await boot();
      await pumpCard(tester);
      expect(find.text('Help improve transit'), findsNothing);
    });

    testWidgets('shows the hero question and submits it, then the rest', (
      tester,
    ) async {
      await boot();
      env.core.userData.alwaysShowSurveysOnStops = true;
      await pumpCard(tester, stop: stop1);
      expect(find.text('Help improve transit'), findsOneWidget);
      expect(find.text('Do you like OBA IOS App ?'), findsOneWidget);
      // Next is disabled until the hero is answered.
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next'))
            .onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextField), 'Love it');
      await tester.pump();
      await tester.tap(find.text('Next'));
      await SettingsEnv.settle(tester);

      final post = env.requests.singleWhere((r) => r.method == 'POST');
      expect(post.url.path, contains('survey_responses'));
      expect(post.body, contains('STOP_1'));
      expect(post.body, contains('Love it'));
      expect(
        env.pushed.single,
        isA<ObaSurveyRoute>().having(
          (r) => r.heroResponseId,
          'response',
          '808d3a515daa39f4c15a',
        ),
      );
      expect(
        env.core.userData.isSurveyCompleted(
          1,
          env.core.userData.surveyUserIdentifier,
        ),
        isTrue,
      );
      // The card is gone.
      expect(find.text('Help improve transit'), findsNothing);
    });

    testWidgets('a single-question survey says thanks', (tester) async {
      await boot(
        surveys: _surveysJson([
          _q(
            1,
            1,
            'radio',
            'Happy?',
            extra: {
              'options': ['Yes', 'No'],
            },
          ),
        ]),
      );
      env.core.userData.alwaysShowSurveysOnStops = true;
      await pumpCard(tester);
      await tester.tap(find.text('Yes'));
      await tester.pump();
      await tester.tap(find.text('Submit survey'));
      await SettingsEnv.settle(tester);
      expect(find.text('Thanks for your feedback.'), findsOneWidget);
      expect(env.pushed, isEmpty);
    });

    testWidgets('checkbox answers are sent as a JSON array', (tester) async {
      await boot(
        surveys: _surveysJson([
          _q(
            1,
            1,
            'checkbox',
            'Which?',
            extra: {
              'options': ['A', 'B', 'C'],
            },
          ),
        ]),
      );
      env.core.userData.alwaysShowSurveysOnStops = true;
      await pumpCard(tester);
      await tester.tap(find.text('C'));
      await tester.pump();
      await tester.tap(find.text('A'));
      await tester.pump();
      await tester.tap(find.text('Submit survey'));
      await SettingsEnv.settle(tester);
      final answers = _answersOf(
        env.requests.singleWhere((r) => r.method == 'POST'),
      );
      expect(answers.single['answer'], '["A","C"]');
    });

    testWidgets('a failed submission keeps the card and says why', (
      tester,
    ) async {
      await boot(
        surveys: _surveysJson([
          _q(
            1,
            1,
            'radio',
            'Happy?',
            extra: {
              'options': ['Yes', 'No'],
            },
          ),
        ]),
      );
      env.core.userData.alwaysShowSurveysOnStops = true;
      await pumpCard(tester);
      env.dispose();
      // Break the server: submissions now 404.
      env = await SettingsEnv.create(
        responses: {
          'surveys.json': jsonEncode(
            _surveysJson([
              _q(
                1,
                1,
                'radio',
                'Happy?',
                extra: {
                  'options': ['Yes', 'No'],
                },
              ),
            ]),
          ),
        },
      );
      addTearDown(env.dispose);
      env.core.userData.alwaysShowSurveysOnStops = true;
      await pumpCard(tester);
      await tester.tap(find.text('Yes'));
      await tester.pump();
      await tester.tap(find.text('Submit survey'));
      await SettingsEnv.settle(tester);
      expect(
        find.text("Your answers couldn't be sent. Please try again."),
        findsOneWidget,
      );
      expect(find.text('Help improve transit'), findsOneWidget);
    });

    testWidgets('external survey opens its link and completes', (tester) async {
      await boot(
        surveys: _surveysJson([
          _q(
            1,
            1,
            'external_survey',
            'Take our survey',
            extra: {
              'url': 'https://forms.example.com/s',
              'embedded_data_fields': ['stop_id'],
              'button_label': 'share_feedback',
            },
          ),
        ]),
      );
      env.core.userData.alwaysShowSurveysOnStops = true;
      await pumpCard(tester, stop: stop1);
      expect(find.text('Take our survey'), findsOneWidget);
      await tester.tap(find.text('Share feedback'));
      await SettingsEnv.settle(tester);
      expect(
        env.opener.opened.single.toString(),
        'https://forms.example.com/s?stop_id=STOP_1',
      );
      expect(
        env.core.userData.isSurveyCompleted(
          1,
          env.core.userData.surveyUserIdentifier,
        ),
        isTrue,
      );
    });

    testWidgets('external survey link failure shows an error', (tester) async {
      final opener = FakeLinkOpener(accept: (_) => false);
      await boot(
        surveys: _surveysJson([
          _q(
            1,
            1,
            'external_survey',
            'Take our survey',
            extra: {'url': 'https://forms.example.com/s'},
          ),
        ]),
        opener: opener,
      );
      env.core.userData.alwaysShowSurveysOnStops = true;
      await pumpCard(tester);
      await tester.tap(find.text('Open survey'));
      await SettingsEnv.settle(tester);
      expect(
        find.text(
          "This survey link couldn't be opened. Please try again later.",
        ),
        findsOneWidget,
      );
      expect(
        env.core.userData.isSurveyCompleted(
          1,
          env.core.userData.surveyUserIdentifier,
        ),
        isFalse,
      );
    });

    testWidgets('not now postpones, dismiss completes', (tester) async {
      await boot();
      env.core.userData.alwaysShowSurveysOnStops = true;
      await pumpCard(tester);
      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();
      expect(env.core.userData.nextSurveyReminderDate, isNotNull);
      expect(
        env.core.userData.isSurveyMarkedForLater(
          1,
          env.core.userData.surveyUserIdentifier,
        ),
        isTrue,
      );
      expect(find.text('Help improve transit'), findsNothing);

      env.dispose();
      await boot();
      env.core.userData.alwaysShowSurveysOnStops = true;
      await pumpCard(tester);
      await tester.tap(find.byTooltip('Dismiss survey'));
      await tester.pumpAndSettle();
      expect(
        env.core.userData.isSurveyCompleted(
          1,
          env.core.userData.surveyUserIdentifier,
        ),
        isTrue,
      );
    });

    testWidgets('accessibility', (tester) async {
      await boot(
        surveys: _surveysJson([
          _q(
            1,
            1,
            'radio',
            'Happy?',
            extra: {
              'options': ['Yes', 'No', 'Maybe'],
            },
          ),
          _q(2, 2, 'text', 'Why?', required: false),
        ]),
      );
      env.core.userData.alwaysShowSurveysOnStops = true;
      await env.expectAccessible(tester, () => feed(const [ObaSurveyCard()]));
    });
  });

  group('ObaSurveyPage', () {
    Future<Survey> survey() async {
      await env.core.surveys.fetchSurveys(force: true);
      return env.core.surveys.allSurveys.first;
    }

    testWidgets('required questions block submit', (tester) async {
      await boot();
      final s = await survey();
      await env.pump(tester, ObaSurveyPage(survey: s, heroResponseId: 'abc'));
      expect(find.text('Do you ? (Required)'), findsOneWidget);
      await tester.tap(find.text('Submit survey'));
      await tester.pumpAndSettle();
      expect(
        find.text('Please answer all required questions before submitting.'),
        findsOneWidget,
      );
      expect(env.requests.where((r) => r.method == 'PUT'), isEmpty);
    });

    testWidgets('submits the remaining answers to the hero response', (
      tester,
    ) async {
      await boot();
      final s = await survey();
      await env.pump(tester, ObaSurveyPage(survey: s, heroResponseId: 'abc'));
      await tester.tap(find.text('Yes'));
      await tester.tap(find.text('1'));
      await tester.pump();
      await tester.tap(find.text('2'));
      await tester.pump();
      await tester.tap(find.text('Submit survey'));
      await SettingsEnv.settle(tester);
      final put = env.requests.singleWhere((r) => r.method == 'PUT');
      expect(put.url.path, endsWith('/survey_responses/abc'));
      final answers = _answersOf(put);
      expect(answers.map((a) => a['answer']), ['Yes', '["1","2"]']);
      expect(
        env.core.userData.isSurveyCompleted(
          1,
          env.core.userData.surveyUserIdentifier,
        ),
        isTrue,
      );
    });

    testWidgets('accessibility', (tester) async {
      await boot();
      final s = await survey();
      await env.expectAccessible(
        tester,
        () => ObaSurveyPage(survey: s, heroResponseId: 'abc'),
      );
    });
  });

  group('ObaDonationCard', () {
    DonationsConfig on() => const DonationsConfig(enabled: true);

    void launches(int n) {
      for (var i = 0; i < n; i++) {
        env.core.userData.incrementAppLaunchCount();
      }
    }

    Future<void> pumpDonation(WidgetTester tester) =>
        env.pump(tester, feed([ObaDonationCard(key: UniqueKey())]));

    testWidgets('hidden when donations are off', (tester) async {
      await boot();
      launches(5);
      await pumpDonation(tester);
      expect(find.text('OneBusAway needs your help'), findsNothing);
    });

    testWidgets('hidden before three launches', (tester) async {
      await boot(donations: on());
      await pumpDonation(tester);
      expect(find.text('OneBusAway needs your help'), findsNothing);
    });

    testWidgets('donate opens the page and stops asking', (tester) async {
      await boot(donations: on());
      launches(2);
      await pumpDonation(tester);
      expect(find.text('OneBusAway needs your help'), findsOneWidget);
      await tester.tap(find.text('Donate now'));
      await SettingsEnv.settle(tester);
      expect(
        env.opener.opened.single.host,
        'opentransitsoftwarefoundation.org',
      );
      expect(env.analytics.has(AnalyticsLabels.donateButtonTapped), isTrue);
      expect(env.core.donationPrompt.shouldRequest, isFalse);
      expect(find.text('OneBusAway needs your help'), findsNothing);
    });

    testWidgets('remind later waits two weeks, no thanks is final', (
      tester,
    ) async {
      await boot(donations: on());
      launches(2);
      await pumpDonation(tester);
      await tester.tap(find.text('Remind me later'));
      await tester.pumpAndSettle();
      expect(env.core.donationPrompt.reminderDate, isNotNull);
      expect(env.core.donationPrompt.dismissedDate, isNull);
      expect(find.text('Donate now'), findsNothing);

      env.dispose();
      await boot(donations: on());
      launches(2);
      await pumpDonation(tester);
      await tester.tap(find.text('No thanks'));
      await tester.pumpAndSettle();
      expect(env.core.donationPrompt.dismissedDate, isNotNull);
    });

    testWidgets('learn more opens the explanation', (tester) async {
      await boot(donations: on());
      launches(2);
      await pumpDonation(tester);
      await tester.tap(find.text('Learn more'));
      expect(env.pushed.single, const ObaDonationRoute());
      expect(env.analytics.has(AnalyticsLabels.donationLearnMoreShown), isTrue);
      await env.pump(tester, const ObaDonationPage());
      expect(find.text("Here's why we need your help"), findsOneWidget);
      await tester.tap(find.text('Donate on our website'));
      await tester.pump();
      expect(env.opener.opened, hasLength(1));
    });

    testWidgets('accessibility', (tester) async {
      await boot(donations: on());
      launches(2);
      await env.expectAccessible(tester, () => feed(const [ObaDonationCard()]));
      await env.expectAccessible(tester, () => const ObaDonationPage());
    });
  });

  group('ObaFeedbackPrompt', () {
    void succeed(int n) {
      for (var i = 0; i < n; i++) {
        env.core.reviewPrompt.recordSuccess();
      }
    }

    Future<void> pumpPrompt(WidgetTester tester) =>
        env.pump(tester, feed(const [ObaFeedbackPrompt()]));

    testWidgets('hidden until enough successes', (tester) async {
      await boot(playStoreId: 'org.x');
      succeed(4);
      await pumpPrompt(tester);
      expect(find.text('Enjoying OneBusAway?'), findsNothing);
    });

    testWidgets('showing it is recorded', (tester) async {
      await boot(playStoreId: 'org.x');
      succeed(5);
      await pumpPrompt(tester);
      expect(find.text('Enjoying OneBusAway?'), findsOneWidget);
      expect(env.core.reviewPrompt.askCount, 1);
      expect(env.core.reviewPrompt.successCount, 0);
      expect(env.analytics.has(AnalyticsLabels.feedbackPromptShown), isTrue);
    });

    testWidgets('yes opens the store page', (tester) async {
      await boot(playStoreId: 'org.x');
      succeed(5);
      await pumpPrompt(tester);
      await tester.tap(find.text('Yes!'));
      await SettingsEnv.settle(tester);
      expect(env.opener.opened.single.toString(), contains('org.x'));
      expect(env.core.reviewPrompt.outcome, FeedbackPromptOutcome.positive);
      expect(env.analytics.has(AnalyticsLabels.feedbackPositive), isTrue);
      expect(find.text('Enjoying OneBusAway?'), findsNothing);
    });

    testWidgets('not really offers an email', (tester) async {
      await boot(playStoreId: 'org.x', developerEmail: 'dev@example.com');
      succeed(5);
      await pumpPrompt(tester);
      await tester.tap(find.text('Not really'));
      await tester.pumpAndSettle();
      expect(find.text('Sorry about that.'), findsOneWidget);
      expect(env.core.reviewPrompt.outcome, FeedbackPromptOutcome.negative);
      await tester.tap(find.text('Send feedback'));
      await SettingsEnv.settle(tester);
      expect(env.opener.opened.single.path, 'dev@example.com');
      expect(env.analytics.has(AnalyticsLabels.feedbackEmailOpened), isTrue);
    });

    testWidgets('no thanks after a negative answer just closes', (
      tester,
    ) async {
      await boot(playStoreId: 'org.x');
      succeed(5);
      await pumpPrompt(tester);
      await tester.tap(find.text('Not really'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('No thanks'));
      await tester.pumpAndSettle();
      expect(env.opener.attempted, isEmpty);
      expect(find.text('Sorry about that.'), findsNothing);
    });

    testWidgets('ask me later defers', (tester) async {
      await boot(playStoreId: 'org.x');
      succeed(5);
      await pumpPrompt(tester);
      await tester.tap(find.text('Ask me later'));
      await tester.pumpAndSettle();
      expect(env.core.reviewPrompt.outcome, FeedbackPromptOutcome.deferred);
      expect(env.analytics.has(AnalyticsLabels.feedbackDeferred), isTrue);
    });

    testWidgets('one prompt per session: yields after a donation card', (
      tester,
    ) async {
      await boot(playStoreId: 'org.x');
      succeed(5);
      env.core.prompts.noteShown(PromptKind.donationModal);
      await pumpPrompt(tester);
      expect(find.text('Enjoying OneBusAway?'), findsNothing);
    });

    testWidgets('accessibility', (tester) async {
      await boot(playStoreId: 'org.x');
      succeed(5);
      await env.expectAccessible(
        tester,
        () => feed(const [ObaFeedbackPrompt()]),
      );
    });
  });
}
