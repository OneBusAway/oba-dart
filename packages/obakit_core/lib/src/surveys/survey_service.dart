import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:onebusaway/onebusaway.dart';

import '../foundation/change_notifier.dart';
import '../user_data/user_data_store.dart';

/// Thrown when there is no Obaco server for surveys.
class SurveyServiceUnavailableException implements Exception {
  const SurveyServiceUnavailableException();

  @override
  String toString() =>
      'SurveyServiceUnavailableException: the region has no survey server';
}

/// Builds the URL for an external survey (iOS `ExternalSurveyURLBuilder`):
/// the hero question's `url` plus the `embedded_data_fields` it asks for.
class ExternalSurveyUrlBuilder {
  const ExternalSurveyUrlBuilder({
    required this.userId,
    required this.regionId,
    required this.currentLocation,
    required this.recentStopIds,
  });

  final String userId;
  final int? Function() regionId;
  final Coordinate? Function() currentLocation;
  final List<String> Function() recentStopIds;

  /// Null when the survey has no valid http(s) URL.
  Uri? build(Survey survey, {Stop? stop}) {
    final content = survey.questions.firstOrNull?.content;
    final raw = content?.url;
    if (raw == null) return null;
    final base = Uri.tryParse(raw);
    if (base == null ||
        !(base.scheme == 'http' || base.scheme == 'https') ||
        base.host.isEmpty) {
      return null;
    }
    final extra = <String, String>{};
    for (final key in content?.embeddedDataFields ?? const <String>[]) {
      final value = _value(key, stop);
      if (value != null) extra[key] = value;
    }
    if (extra.isEmpty) return base;
    return base.replace(
      queryParameters: {...base.queryParametersAll, ...extra},
    );
  }

  String? _value(String key, Stop? stop) {
    switch (key) {
      case 'user_id':
        return userId;
      case 'region_id':
        final id = regionId();
        return id == null ? null : '$id';
      case 'route_id':
        return stop == null || stop.routeIds.isEmpty
            ? null
            : stop.routeIds.join(',');
      case 'stop_id':
        return stop?.id;
      case 'recent_stop_ids':
        final ids = recentStopIds();
        return ids.isEmpty ? null : ids.join(',');
      case 'current_location':
        final c = currentLocation();
        return c == null ? null : '${c.lat},${c.lon}';
      default:
        return null;
    }
  }
}

/// Fetches surveys from the Obaco server and decides which one to show.
/// Port of iOS `SurveyService`. Notifies listeners when [allSurveys],
/// [visibleSurveys], [isLoading] or [lastError] change.
class SurveyService extends ObaChangeNotifier {
  SurveyService({
    required this._obaco,
    required this.userData,
    int? Function()? regionId,
    Coordinate? Function()? currentLocation,
  }) : _regionId = regionId ?? (() => null),
       _currentLocation = currentLocation ?? (() => null);

  final ObacoClient? Function() _obaco;
  final UserDataStore userData;
  final int? Function() _regionId;
  final Coordinate? Function() _currentLocation;

  static const launchInterval = 3;
  static const fetchCooldown = Duration(minutes: 5);
  static const reminderDelay = Duration(days: 3);

  List<Survey> _all = [];
  List<Survey> _visible = [];
  bool _isLoading = false;
  Object? _lastError;
  DateTime? _lastFetch;

  List<Survey> get allSurveys => List.unmodifiable(_all);

  /// Surveys active now.
  List<Survey> get visibleSurveys => List.unmodifiable(_visible);
  bool get isLoading => _isLoading;
  Object? get lastError => _lastError;

  ExternalSurveyUrlBuilder get externalUrlBuilder => ExternalSurveyUrlBuilder(
    userId: userData.surveyUserIdentifier,
    regionId: _regionId,
    currentLocation: _currentLocation,
    recentStopIds: () => [for (final r in userData.recentStops) r.stop.id],
  );

  Uri? externalSurveyUrl(Survey survey, {Stop? stop}) =>
      externalUrlBuilder.build(survey, stop: stop);

  /// Fetches surveys unless a fetch is running or one succeeded within
  /// [fetchCooldown] (pass [force] to skip the cooldown). Errors land in
  /// [lastError].
  Future<void> fetchSurveys({bool force = false}) async {
    if (_isLoading) return;
    final last = _lastFetch;
    if (!force &&
        _all.isNotEmpty &&
        last != null &&
        clock.now().difference(last).abs() < fetchCooldown) {
      return;
    }
    final obaco = _obaco();
    if (obaco == null) {
      _lastError = const SurveyServiceUnavailableException();
      notifyListeners();
      return;
    }
    _isLoading = true;
    _lastError = null;
    notifyListeners();
    try {
      final response = await obaco.getSurveys(
        userId: userData.surveyUserIdentifier,
      );
      _all = List.of(response.surveys);
      _updateVisible();
      _lastFetch = clock.now();
    } catch (e) {
      _lastError = e;
      if (_all.isEmpty) _visible = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Whether to show any survey this launch: surveys enabled, and either
  /// "always show" is on, or this is every third launch and no reminder
  /// date is pending.
  bool shouldShowSurvey() {
    if (!userData.isSurveyEnabled) return false;
    if (userData.alwaysShowSurveysOnStops) return true;
    final launches = userData.appLaunchCount;
    if (launches <= 0 || launches % launchInterval != 0) return false;
    final reminder = userData.nextSurveyReminderDate;
    if (reminder != null && reminder.isAfter(clock.now())) return false;
    return true;
  }

  /// The survey to show on a stop page.
  Survey? surveyForStop(String stopId, List<String> routeIds) =>
      _find(onStop: true, stopId: stopId, routeIds: routeIds);

  /// The survey to show on the map.
  Survey? surveyForMap() => _find(onStop: false, stopId: null, routeIds: []);

  void setNextReminderDate() =>
      userData.nextSurveyReminderDate = clock.now().add(reminderDelay);

  void markCompleted(Survey survey) {
    userData.markSurveyCompleted(survey.id, userData.surveyUserIdentifier);
    _updateVisible();
    notifyListeners();
  }

  void markForLater(Survey survey) {
    userData.markSurveyForLater(survey.id, userData.surveyUserIdentifier);
    _updateVisible();
    notifyListeners();
  }

  /// "Remind me later": mark for later and hold all surveys for 3 days.
  void postpone(Survey survey) {
    markForLater(survey);
    setNextReminderDate();
  }

  void dismiss(Survey survey) => markCompleted(survey);

  Future<SurveySubmissionResponse> submitHeroQuestion({
    required Survey survey,
    required QuestionAnswerSubmission answer,
    String? stopId,
    Coordinate? stopLocation,
  }) async {
    final obaco = _obaco();
    if (obaco == null) throw const SurveyServiceUnavailableException();
    return obaco.submitSurveyResponse(
      SurveySubmission(
        userIdentifier: userData.surveyUserIdentifier,
        surveyId: survey.id,
        stopIdentifier: stopId,
        stopLatitude: stopLocation?.lat,
        stopLongitude: stopLocation?.lon,
        responses: [answer],
      ),
    );
  }

  Future<SurveySubmissionResponse> submitAdditionalQuestions({
    required String responseId,
    required List<QuestionAnswerSubmission> answers,
  }) async {
    final obaco = _obaco();
    if (obaco == null) throw const SurveyServiceUnavailableException();
    return obaco.updateSurveyResponse(responseId, answers);
  }

  static QuestionAnswerSubmission answerFor(
    SurveyQuestion question,
    String answer,
  ) => QuestionAnswerSubmission(
    questionId: question.id,
    questionType: question.content.type.wireName,
    questionLabel: question.content.labelText,
    answer: answer,
  );

  /// Checkbox answers are sent as a JSON array string.
  static String formatCheckboxAnswer(List<String> selections) =>
      jsonEncode(selections);

  void _updateVisible() {
    final now = clock.now();
    _visible = _all.where((s) => s.isActive(now)).toList();
  }

  /// Priority: (1) always-visible single-response not yet completed, at
  /// once; (2) the first one-time survey not completed (or due again after
  /// "later"); (3) the first always-visible multi-response survey.
  Survey? _find({
    required bool onStop,
    required String? stopId,
    required List<String> routeIds,
  }) {
    final userId = userData.surveyUserIdentifier;
    final now = clock.now();
    Survey? alwaysVisible;
    Survey? oneTime;
    for (final survey in _visible) {
      if (survey.questions.isEmpty) continue;
      final visible = onStop
          ? _visibleOnStop(survey, stopId, routeIds, now)
          : survey.shouldShowOnMap(now);
      if (!visible) continue;
      final completed = userData.isSurveyCompleted(survey.id, userId);
      if (survey.alwaysVisible) {
        if (survey.allowsMultipleResponses) {
          alwaysVisible ??= survey;
        } else if (!completed) {
          return survey;
        }
      } else if (userData.isSurveyMarkedForLater(survey.id, userId)) {
        if (userData.shouldShowSurveyLater(survey.id, userId)) {
          oneTime ??= survey;
        }
      } else if (!completed) {
        oneTime ??= survey;
      }
    }
    return oneTime ?? alwaysVisible;
  }

  bool _visibleOnStop(
    Survey survey,
    String? stopId,
    List<String> routeIds,
    DateTime now,
  ) {
    if (!survey.showOnStops || !survey.isActive(now)) return false;
    if (stopId == null) return true;
    final stopTargeted = survey.visibleStopsList?.isNotEmpty ?? false;
    final routeTargeted = survey.visibleRoutesList?.isNotEmpty ?? false;
    if (!stopTargeted && !routeTargeted) return true;
    if (stopTargeted && survey.shouldShowOnStop(stopId, now)) return true;
    if (routeTargeted) {
      return routeIds.any((r) => survey.shouldShowOnRoute(r, now));
    }
    return false;
  }
}
