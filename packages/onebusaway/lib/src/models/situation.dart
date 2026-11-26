import '../core/errors.dart';
import '../core/json.dart';

/// A service alert (OBA calls them *situations*), found in
/// `References.situations`.
class Situation {
  const Situation({
    required this.id,
    this.creationTime,
    this.activeWindows = const [],
    this.publicationWindows = const [],
    this.allAffects = const [],
    this.consequences = const [],
    this.reason,
    this.severity,
    this.summary,
    this.description,
    this.url,
  });

  factory Situation.fromJson(JsonMap json) {
    TranslatedString? translated(String key) {
      final map = readOptMap(json, key);
      return map == null ? null : TranslatedString.fromJson(map);
    }

    return Situation(
      id: readString(json, 'id'),
      creationTime: readEpochMs(json, 'creationTime'),
      activeWindows: readObjectList(json, 'activeWindows', TimeWindow.fromJson),
      publicationWindows: readObjectList(
        json,
        'publicationWindows',
        TimeWindow.fromJson,
      ),
      allAffects: readObjectList(json, 'allAffects', AffectedEntity.fromJson),
      consequences: readObjectList(json, 'consequences', Consequence.fromJson),
      reason: readOptString(json, 'reason'),
      severity: readOptString(json, 'severity'),
      summary: translated('summary'),
      description: translated('description'),
      url: translated('url'),
    );
  }

  final String id;
  final DateTime? creationTime;

  /// When the alert is in effect, in server order.
  final List<TimeWindow> activeWindows;
  final List<TimeWindow> publicationWindows;

  /// The agencies, routes, stops and trips the alert applies to.
  final List<AffectedEntity> allAffects;
  final List<Consequence> consequences;

  /// e.g. `CONSTRUCTION`; `""` becomes null.
  final String? reason;

  /// e.g. `SEVERE`; `""` becomes null.
  final String? severity;
  final TranslatedString? summary;
  final TranslatedString? description;
  final TranslatedString? url;

  /// Whether any [activeWindows] contains [time]. An alert with no windows
  /// is always active.
  bool isActiveAt(DateTime time) =>
      activeWindows.isEmpty || activeWindows.any((w) => w.contains(time));
}

/// Alias matching the iOS app's name for [Situation].
typedef ServiceAlert = Situation;

/// A time range. Servers send `from`/`to` in epoch seconds or milliseconds;
/// values above 1e10 are read as milliseconds, smaller ones as seconds.
///
/// An open end is sent as a missing or null `to`, or (by servers whose
/// time range holds plain numbers) as `0`, OBA's usual "no value": all
/// three become a null [to]. A `to` of 0 read as 1970 would end every such
/// alert before it began.
class TimeWindow {
  const TimeWindow({required this.from, this.to});

  factory TimeWindow.fromJson(JsonMap json) {
    final from = _readTimestamp(json, 'from');
    if (from == null) throw const ObaFormatException('Missing "from"');
    final to = _readTimestamp(json, 'to');
    return TimeWindow(
      from: from,
      to: to == null || to.millisecondsSinceEpoch == 0 ? null : to,
    );
  }

  static DateTime? _readTimestamp(JsonMap json, String key) {
    final value = readOptInt(json, key);
    if (value == null) return null;
    final ms = value > 10000000000 ? value : value * 1000;
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: true);
  }

  final DateTime from;

  /// Null means open-ended.
  final DateTime? to;

  /// Inclusive of both ends. A window whose [to] precedes [from] covers
  /// only the instant [from].
  bool contains(DateTime time) {
    if (time.isBefore(from)) return false;
    final end = to;
    if (end == null) return true;
    if (end.isBefore(from)) return time.isAtSameMomentAs(from);
    return !time.isAfter(end);
  }
}

/// One entry of a situation's `allAffects`. Blank ids become null.
class AffectedEntity {
  const AffectedEntity({
    this.agencyId,
    this.applicationId,
    this.directionId,
    this.routeId,
    this.stopId,
    this.tripId,
  });

  factory AffectedEntity.fromJson(JsonMap json) => AffectedEntity(
    agencyId: readOptString(json, 'agencyId'),
    applicationId: readOptString(json, 'applicationId'),
    directionId: readOptString(json, 'directionId'),
    routeId: readOptString(json, 'routeId'),
    stopId: readOptString(json, 'stopId'),
    tripId: readOptString(json, 'tripId'),
  );

  final String? agencyId;
  final String? applicationId;
  final String? directionId;
  final String? routeId;
  final String? stopId;
  final String? tripId;
}

class Consequence {
  const Consequence({required this.condition, this.conditionDetails});

  factory Consequence.fromJson(JsonMap json) {
    final details = readOptMap(json, 'conditionDetails');
    return Consequence(
      condition: readString(json, 'condition'),
      conditionDetails: details == null
          ? null
          : ConditionDetails.fromJson(details),
    );
  }

  /// e.g. `detour`.
  final String condition;
  final ConditionDetails? conditionDetails;
}

class ConditionDetails {
  const ConditionDetails({
    this.diversionPath,
    this.diversionStopIds = const [],
  });

  factory ConditionDetails.fromJson(JsonMap json) {
    final path = readOptMap(json, 'diversionPath');
    return ConditionDetails(
      diversionPath: path == null ? null : readOptString(path, 'points'),
      diversionStopIds: readStringList(json, 'diversionStopIds'),
    );
  }

  /// Encoded polyline of the detour.
  final String? diversionPath;
  final List<String> diversionStopIds;
}

class TranslatedString {
  const TranslatedString({required this.value, this.lang});

  factory TranslatedString.fromJson(JsonMap json) => TranslatedString(
    value: readString(json, 'value'),
    lang: readOptString(json, 'lang'),
  );

  final String value;
  final String? lang;
}
