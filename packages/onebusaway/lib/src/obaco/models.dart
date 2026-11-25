import 'dart:convert';

import '../core/errors.dart';
import '../core/json.dart';
import '../models/coordinate.dart';

DateTime _isoDate(JsonMap json, String key) {
  final raw = readString(json, key);
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) throw ObaFormatException('Invalid date at "$key": $raw');
  return parsed.toUtc();
}

DateTime? _optIsoDate(JsonMap json, String key) =>
    json[key] == null ? null : _isoDate(json, key);

DateTime? _optEpochSeconds(JsonMap json, String key) {
  final v = readOptDouble(json, key);
  if (v == null) return null;
  return DateTime.fromMillisecondsSinceEpoch((v * 1000).round(), isUtc: true);
}

/// A created arrival alarm. [url] is what to DELETE to cancel it.
class Alarm {
  const Alarm({required this.url, this.tripDate, this.alarmDate});

  factory Alarm.fromJson(JsonMap json) => Alarm(
    url: Uri.parse(readString(json, 'url')),
    tripDate: _optEpochSeconds(json, 'tripDate'),
    alarmDate: _optEpochSeconds(json, 'alarmDate'),
  );

  final Uri url;
  final DateTime? tripDate;
  final DateTime? alarmDate;
}

/// A vehicle returned by the vehicle search endpoint.
class AgencyVehicle {
  const AgencyVehicle({
    required this.agencyId,
    required this.agencyName,
    this.vehicleId,
  });

  factory AgencyVehicle.fromJson(JsonMap json) => AgencyVehicle(
    agencyId: readString(json, 'id'),
    agencyName: readString(json, 'name'),
    vehicleId: readOptString(json, 'vehicle_id'),
  );

  final String agencyId;
  final String agencyName;
  final String? vehicleId;
}

/// Input for a ghost bus report.
class GhostBusReportDraft {
  GhostBusReportDraft({
    required this.tripId,
    required this.serviceDate,
    this.waitDurationMinutes = 15,
    this.routeId,
    this.stopId,
    this.vehicleId,
    this.stopSequence,
    this.predicted,
    this.scheduledArrivalAt,
    this.predictedArrivalAt,
    this.scheduleDeviationMinutes,
    this.predictionLastUpdatedAt,
    this.comment,
    this.userLatitude,
    this.userLongitude,
  });

  String tripId;
  DateTime serviceDate;
  int waitDurationMinutes;
  String? routeId;
  String? stopId;
  String? vehicleId;
  int? stopSequence;
  bool? predicted;
  DateTime? scheduledArrivalAt;
  DateTime? predictedArrivalAt;
  int? scheduleDeviationMinutes;
  DateTime? predictionLastUpdatedAt;
  String? comment;
  double? userLatitude;
  double? userLongitude;
}

class GhostBusReport {
  const GhostBusReport({required this.id});

  factory GhostBusReport.fromJson(JsonMap json) =>
      GhostBusReport(id: readString(json, 'id'));

  final String id;
}

class HourlyForecast {
  const HourlyForecast({
    required this.iconName,
    required this.precipPerHour,
    required this.precipProbability,
    required this.summary,
    required this.temperature,
    required this.temperatureFeelsLike,
    required this.time,
    required this.windSpeed,
  });

  factory HourlyForecast.fromJson(JsonMap json) => HourlyForecast(
    iconName: readString(json, 'icon'),
    precipPerHour: readOptDouble(json, 'precip_per_hour') ?? 0,
    precipProbability: readOptDouble(json, 'precip_probability') ?? 0,
    summary: readString(json, 'summary'),
    temperature: readOptDouble(json, 'temperature') ?? 0,
    temperatureFeelsLike: readOptDouble(json, 'temperature_feels_like') ?? 0,
    time:
        _optEpochSeconds(json, 'time') ??
        (throw const ObaFormatException('Missing "time"')),
    windSpeed: readOptDouble(json, 'wind_speed') ?? 0,
  );

  final String iconName;
  final double precipPerHour;
  final double precipProbability;
  final String summary;
  final double temperature;
  final double temperatureFeelsLike;
  final DateTime time;
  final double windSpeed;
}

class WeatherForecast {
  const WeatherForecast({
    required this.location,
    required this.regionId,
    required this.regionName,
    required this.retrievedAt,
    required this.units,
    required this.todaySummary,
    required this.currentForecast,
    required this.hourlyForecasts,
  });

  factory WeatherForecast.fromJson(JsonMap json) => WeatherForecast(
    location: Coordinate(
      readOptDouble(json, 'latitude') ??
          (throw const ObaFormatException('Missing "latitude"')),
      readOptDouble(json, 'longitude') ??
          (throw const ObaFormatException('Missing "longitude"')),
    ),
    regionId: readInt(json, 'region_identifier'),
    regionName: readString(json, 'region_name'),
    retrievedAt: _isoDate(json, 'retrieved_at'),
    units: readString(json, 'units'),
    todaySummary: readString(json, 'today_summary'),
    currentForecast: HourlyForecast.fromJson(readMap(json, 'current_forecast')),
    hourlyForecasts: readList(
      json,
      'hourly_forecast',
      (i) => HourlyForecast.fromJson(asJsonMap(i, 'hourly_forecast[]')),
    ),
  );

  final Coordinate location;
  final int regionId;
  final String regionName;
  final DateTime retrievedAt;
  final String units;
  final String todaySummary;
  final HourlyForecast currentForecast;
  final List<HourlyForecast> hourlyForecasts;
}

// -- Surveys ----------------------------------------------------------------

enum QuestionType {
  text('text'),
  radio('radio'),
  checkbox('checkbox'),
  label('label'),
  externalSurvey('external_survey');

  const QuestionType(this.wireName);
  final String wireName;

  static QuestionType parse(String raw) {
    for (final t in values) {
      if (t.wireName == raw) return t;
    }
    throw ObaFormatException('Unknown question type "$raw"');
  }
}

class QuestionContent {
  const QuestionContent({
    required this.labelText,
    required this.type,
    this.options,
    this.url,
    this.surveyProvider,
    this.embeddedDataFields,
    this.buttonLabel,
  });

  factory QuestionContent.fromJson(JsonMap json) => QuestionContent(
    labelText: readString(json, 'label_text'),
    type: QuestionType.parse(readString(json, 'type')),
    options: json['options'] == null ? null : readStringList(json, 'options'),
    url: readOptString(json, 'url'),
    surveyProvider: readOptString(json, 'survey_provider'),
    embeddedDataFields: json['embedded_data_fields'] == null
        ? null
        : readStringList(json, 'embedded_data_fields'),
    buttonLabel: readOptString(json, 'button_label'),
  );

  final String labelText;
  final QuestionType type;
  final List<String>? options;
  final String? url;
  final String? surveyProvider;
  final List<String>? embeddedDataFields;
  final String? buttonLabel;

  /// One of `open_survey`, `learn_more`, `share_feedback`, `sign_up`;
  /// anything else (or absent) is `open_survey`.
  String get externalSurveyButtonKey =>
      const {
        'open_survey',
        'learn_more',
        'share_feedback',
        'sign_up',
      }.contains(buttonLabel)
      ? buttonLabel!
      : 'open_survey';
}

class SurveyQuestion {
  const SurveyQuestion({
    required this.id,
    required this.position,
    required this.required,
    required this.content,
  });

  factory SurveyQuestion.fromJson(JsonMap json) => SurveyQuestion(
    id: readInt(json, 'id'),
    position: readInt(json, 'position'),
    required: readBool(json, 'required'),
    content: QuestionContent.fromJson(readMap(json, 'content')),
  );

  final int id;
  final int position;
  final bool required;
  final QuestionContent content;
}

class Study {
  const Study({required this.id, required this.name, this.description});

  factory Study.fromJson(JsonMap json) => Study(
    id: readInt(json, 'id'),
    name: readString(json, 'name'),
    description: readOptString(json, 'description'),
  );

  final int id;
  final String name;
  final String? description;
}

class SurveyRegion {
  const SurveyRegion({required this.id, required this.name});

  factory SurveyRegion.fromJson(JsonMap json) =>
      SurveyRegion(id: readInt(json, 'id'), name: readString(json, 'name'));

  final int id;
  final String name;
}

class Survey {
  const Survey({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.study,
    required this.questions,
    this.showOnMap = false,
    this.showOnStops = false,
    this.startDate,
    this.endDate,
    this.visibleStopsList,
    this.visibleRoutesList,
    this.allowsMultipleResponses = false,
    this.alwaysVisible = false,
  });

  factory Survey.fromJson(JsonMap json) => Survey(
    id: readInt(json, 'id'),
    name: readString(json, 'name'),
    createdAt: _isoDate(json, 'created_at'),
    updatedAt: _isoDate(json, 'updated_at'),
    showOnMap: readBool(json, 'show_on_map'),
    showOnStops: readBool(json, 'show_on_stops'),
    startDate: _optIsoDate(json, 'start_date'),
    endDate: _optIsoDate(json, 'end_date'),
    visibleStopsList: json['visible_stop_list'] == null
        ? null
        : readStringList(json, 'visible_stop_list'),
    visibleRoutesList: json['visible_route_list'] == null
        ? null
        : readStringList(json, 'visible_route_list'),
    allowsMultipleResponses: readBool(json, 'allows_multiple_responses'),
    alwaysVisible: readBool(json, 'always_visible'),
    study: Study.fromJson(readMap(json, 'study')),
    questions: readList(
      json,
      'questions',
      (i) => SurveyQuestion.fromJson(asJsonMap(i, 'questions[]')),
    ),
  );

  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool showOnMap;
  final bool showOnStops;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? visibleStopsList;
  final List<String>? visibleRoutesList;
  final bool allowsMultipleResponses;
  final bool alwaysVisible;
  final Study study;
  final List<SurveyQuestion> questions;

  /// Within [startDate]..[endDate] at [now] (default: the current time).
  bool isActive([DateTime? now]) {
    final t = now ?? DateTime.now();
    if (startDate != null && t.isBefore(startDate!)) return false;
    if (endDate != null && t.isAfter(endDate!)) return false;
    return true;
  }

  SurveyQuestion? get heroQuestion {
    for (final q in questions) {
      if (q.position == 1) return q;
    }
    return null;
  }

  List<SurveyQuestion> get remainingQuestions {
    final hero = heroQuestion;
    if (hero == null) return questions;
    return [
      for (final q in questions)
        if (q.id != hero.id) q,
    ];
  }

  bool get isExternalSurvey =>
      heroQuestion?.content.type == QuestionType.externalSurvey;

  bool shouldShowOnStop(String stopId, [DateTime? now]) {
    if (!showOnStops || !isActive(now)) return false;
    final list = visibleStopsList;
    return list == null || list.isEmpty || list.contains(stopId);
  }

  bool shouldShowOnRoute(String routeId, [DateTime? now]) {
    if (!showOnStops || !isActive(now)) return false;
    final list = visibleRoutesList;
    return list == null || list.isEmpty || list.contains(routeId);
  }

  bool shouldShowOnMap([DateTime? now]) => showOnMap && isActive(now);
}

class StudyResponse {
  const StudyResponse({required this.surveys, required this.region});

  factory StudyResponse.fromJson(JsonMap json) => StudyResponse(
    surveys: readList(
      json,
      'surveys',
      (i) => Survey.fromJson(asJsonMap(i, 'surveys[]')),
    ),
    region: SurveyRegion.fromJson(readMap(json, 'region')),
  );

  final List<Survey> surveys;
  final SurveyRegion region;
}

class QuestionAnswerSubmission {
  const QuestionAnswerSubmission({
    required this.questionId,
    required this.questionType,
    required this.questionLabel,
    required this.answer,
  });

  final int questionId;
  final String questionType;
  final String questionLabel;
  final String answer;

  JsonMap toJson() => {
    'question_id': questionId,
    'question_type': questionType,
    'question_label': questionLabel,
    'answer': answer,
  };
}

class SurveySubmission {
  const SurveySubmission({
    required this.userIdentifier,
    required this.surveyId,
    required this.responses,
    this.stopIdentifier,
    this.stopLatitude,
    this.stopLongitude,
  });

  final String userIdentifier;
  final int surveyId;
  final String? stopIdentifier;
  final double? stopLatitude;
  final double? stopLongitude;
  final List<QuestionAnswerSubmission> responses;

  /// The server expects `responses` as a JSON-encoded string, not an array.
  JsonMap toJson() => {
    'user_identifier': userIdentifier,
    'survey_id': surveyId,
    if (stopIdentifier != null) 'stop_identifier': stopIdentifier,
    if (stopLongitude != null) 'stop_longitude': stopLongitude,
    if (stopLatitude != null) 'stop_latitude': stopLatitude,
    'responses': jsonEncode([for (final r in responses) r.toJson()]),
  };
}

class SurveySubmissionResponse {
  const SurveySubmissionResponse({
    required this.id,
    required this.updatePath,
    required this.userIdentifier,
  });

  factory SurveySubmissionResponse.fromJson(JsonMap json) {
    final nested = readMap(json, 'survey_response');
    return SurveySubmissionResponse(
      id: readString(nested, 'id'),
      updatePath: readString(nested, 'update_path'),
      userIdentifier: readString(nested, 'user_identifier'),
    );
  }

  final String id;
  final String updatePath;
  final String userIdentifier;
}
