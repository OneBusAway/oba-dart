import 'package:http/http.dart' as http;

import '../core/errors.dart';
import '../core/json.dart';
import 'http_support.dart';
import 'models.dart';

/// Client for the OneBusAway.co "Obaco" sidecar server
/// (`Region.sidecarBaseUrl`): weather, arrival alarms, vehicle search, ghost
/// bus reports, push registrations and surveys.
class ObacoClient {
  ObacoClient({
    required this.baseUrl,
    required this.regionId,
    http.Client? httpClient,
    Duration timeout = const Duration(seconds: 30),
    this.apiKey,
    this.appVersion,
    this.appUid,
    this.operatingSystem = 'ios',
    this.apnsSandbox = false,
  }) : _ownsClient = httpClient == null,
       _http = HttpSupport(
         httpClient: httpClient ?? http.Client(),
         timeout: timeout,
       );

  final Uri baseUrl;
  final int regionId;

  /// Optional default query parameters (`key`, `app_ver`, `app_uid`) sent on
  /// every request, as the iOS app does. `version=2` is always sent.
  final String? apiKey;
  final String? appVersion;
  final String? appUid;

  /// Value of the `operating_system` form field (`ios` or `android`).
  final String operatingSystem;

  /// When true, `apns_sandbox=1` is added to alarms and push registrations.
  final bool apnsSandbox;

  final bool _ownsClient;
  final HttpSupport _http;

  Map<String, String> get _defaultQuery => {
    'key': ?apiKey,
    'app_uid': ?appUid,
    'app_ver': ?appVersion,
    'version': '2',
  };

  Uri _uri(String path, [Map<String, String> query = const {}]) =>
      joinUrl(baseUrl, path, {..._defaultQuery, ...query});

  static int _ms(DateTime d) => d.millisecondsSinceEpoch;

  // -- Weather ---------------------------------------------------------------

  Future<WeatherForecast> getWeather() async {
    final r = await _http.send(
      'GET',
      _uri('/api/v1/regions/$regionId/weather.json'),
    );
    return WeatherForecast.fromJson(HttpSupport.decodeObject(r));
  }

  // -- Alarms ------------------------------------------------------------------

  Future<Alarm> postAlarm({
    required Duration secondsBefore,
    required String stopId,
    required String tripId,
    required DateTime serviceDate,
    String? vehicleId,
    required int stopSequence,
    required String userPushId,
  }) async {
    final form = <String, String>{
      'seconds_before': '${secondsBefore.inSeconds}',
      'stop_id': stopId,
      'trip_id': tripId,
      'service_date': '${_ms(serviceDate)}',
      'stop_sequence': '$stopSequence',
      'user_push_id': userPushId,
      'operating_system': operatingSystem,
      'vehicle_id': ?vehicleId,
      if (apnsSandbox) 'apns_sandbox': '1',
    };
    final r = await _http.send(
      'POST',
      _uri('/api/v2/regions/$regionId/alarms'),
      form: form,
    );
    return Alarm.fromJson(HttpSupport.decodeObject(r));
  }

  /// DELETEs [alarmUrl] (the `url` of an [Alarm]).
  Future<void> deleteAlarm(Uri alarmUrl) async {
    await _http.send('DELETE', alarmUrl);
  }

  // -- Vehicles ----------------------------------------------------------------

  Future<List<AgencyVehicle>> getVehicles(String query) async {
    final r = await _http.send(
      'GET',
      _uri('/api/v1/regions/$regionId/vehicles', {'query': query}),
    );
    final decoded = HttpSupport.decodeJson(r);
    if (decoded is! List) {
      throw ObaFormatException(
        'Expected list at "response", got ${decoded.runtimeType}',
      );
    }
    return List.unmodifiable(
      decoded.map((e) => AgencyVehicle.fromJson(asJsonMap(e, 'response[]'))),
    );
  }

  // -- Ghost bus reports -----------------------------------------------------

  Future<GhostBusReport> postGhostBusReport(
    GhostBusReportDraft draft, {
    required String userId,
  }) async {
    final form = <String, String>{
      'user_identifier': userId,
      'trip_identifier': draft.tripId,
      'service_date': '${_ms(draft.serviceDate)}',
      'wait_duration_minutes': '${draft.waitDurationMinutes}',
      'route_identifier': ?draft.routeId,
      'stop_identifier': ?draft.stopId,
      'vehicle_identifier': ?draft.vehicleId,
      if (draft.stopSequence != null) 'stop_sequence': '${draft.stopSequence}',
      if (draft.predicted != null) 'predicted': draft.predicted! ? '1' : '0',
      if (draft.scheduledArrivalAt != null)
        'scheduled_arrival_at': '${_ms(draft.scheduledArrivalAt!)}',
      if (draft.predictedArrivalAt != null)
        'predicted_arrival_at': '${_ms(draft.predictedArrivalAt!)}',
      if (draft.scheduleDeviationMinutes != null)
        'schedule_deviation_minutes': '${draft.scheduleDeviationMinutes}',
      if (draft.predictionLastUpdatedAt != null)
        'prediction_last_updated_at': '${_ms(draft.predictionLastUpdatedAt!)}',
      if (draft.comment != null && draft.comment!.isNotEmpty)
        'comment': draft.comment!,
      if (draft.userLatitude != null) 'user_latitude': '${draft.userLatitude}',
      if (draft.userLongitude != null)
        'user_longitude': '${draft.userLongitude}',
    };
    final r = await _http.send(
      'POST',
      _uri('/api/v2/regions/$regionId/ghost_bus_reports'),
      form: form,
    );
    return GhostBusReport.fromJson(HttpSupport.decodeObject(r));
  }

  // -- Push registrations ----------------------------------------------------

  Future<void> postPushRegistration({
    required String token,
    required String locale,
    bool testDevice = false,
    String? description,
  }) async {
    final form = <String, String>{
      'token': token,
      'operating_system': operatingSystem,
      'locale': locale,
      'test_device': testDevice ? 'true' : 'false',
      if (description != null && description.isNotEmpty)
        'description': description,
      if (apnsSandbox) 'apns_sandbox': '1',
    };
    await _http.send(
      'POST',
      _uri('/api/v2/regions/$regionId/push_registrations'),
      form: form,
    );
  }

  Future<void> deletePushRegistration(String token) async {
    await _http.send(
      'DELETE',
      _uri('/api/v2/regions/$regionId/push_registrations', {'token': token}),
    );
  }

  // -- Surveys ---------------------------------------------------------------

  Future<StudyResponse> getSurveys({required String userId}) async {
    final r = await _http.send(
      'GET',
      _uri('/api/v1/regions/$regionId/surveys.json', {'user_id': userId}),
    );
    return StudyResponse.fromJson(HttpSupport.decodeObject(r));
  }

  Future<SurveySubmissionResponse> submitSurveyResponse(
    SurveySubmission submission,
  ) async {
    final r = await _http.send(
      'POST',
      _uri('/api/v1/survey_responses/'),
      jsonBody: submission.toJson(),
    );
    return SurveySubmissionResponse.fromJson(HttpSupport.decodeObject(r));
  }

  Future<SurveySubmissionResponse> updateSurveyResponse(
    String responseId,
    List<QuestionAnswerSubmission> additionalResponses,
  ) async {
    final r = await _http.send(
      'PUT',
      _uri('/api/v1/survey_responses/${Uri.encodeComponent(responseId)}'),
      jsonBody: {'responses': _encodeResponses(additionalResponses)},
    );
    return SurveySubmissionResponse.fromJson(HttpSupport.decodeObject(r));
  }

  static String _encodeResponses(List<QuestionAnswerSubmission> r) =>
      SurveySubmission(
            userIdentifier: '',
            surveyId: 0,
            responses: r,
          ).toJson()['responses']!
          as String;

  /// Closes the HTTP client only if this client created it.
  void close() {
    if (_ownsClient) _http.httpClient.close();
  }
}
