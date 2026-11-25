import 'package:clock/clock.dart';
import 'package:onebusaway/onebusaway.dart';

import '../arrivals/arrival_logic.dart';
import '../user_data/stored_stop.dart';
import 'strings.dart';

/// A compact route list for map pins: shown names plus how many more.
class RouteListLabel {
  const RouteListLabel({required this.routeNames, required this.overflowCount});

  final List<String> routeNames;
  final int overflowCount;

  @override
  bool operator ==(Object other) =>
      other is RouteListLabel &&
      other.overflowCount == overflowCount &&
      other.routeNames.join('\u0000') == routeNames.join('\u0000');

  @override
  int get hashCode => Object.hash(Object.hashAll(routeNames), overflowCount);

  @override
  String toString() => 'RouteListLabel($routeNames, +$overflowCount)';
}

enum DistanceUnits { metric, imperial }

/// Text formatting for stops, routes, departures and distances. Port of the
/// locale-independent parts of iOS `Formatters`; clock times and dates are
/// left to the UI's `intl` formatting.
class ObaFormatters {
  const ObaFormatters([this.strings = const ObaCoreStrings()]);

  final ObaCoreStrings strings;

  // -- Stops ----------------------------------------------------------------------

  /// `"Pine St & 3rd Ave (SW)"`, or the bare name without a direction.
  String stopTitle({required String name, String? direction}) {
    final d = StopDirection.parse(direction);
    return d == StopDirection.unknown
        ? name
        : '$name (${strings.directionAbbreviation(d)})';
  }

  String stopTitleFor(Stop stop) =>
      stopTitle(name: stop.name, direction: stop.direction);

  /// `"Stop #1234"` for numeric codes, `"Stop: 'Old Library'"` otherwise.
  String stopCode(String code) => RegExp(r'^\d+$').hasMatch(code)
      ? strings.stopCodeNumeric(code)
      : strings.stopCodeNonNumeric(code);

  /// `"Stop #1234 — Southbound"`.
  String stopSubtitle({required String code, String? direction}) {
    final formatted = stopCode(code);
    final d = StopDirection.parse(direction);
    return d == StopDirection.unknown
        ? formatted
        : '$formatted — ${strings.directionAdjective(d)}';
  }

  String stopSubtitleFor(Stop stop) => stopSubtitle(
    code: stop.code ?? _stripAgency(stop.id),
    direction: stop.direction,
  );

  String storedStopSubtitle(StoredStop stop) => stopSubtitle(
    code: stop.code ?? _stripAgency(stop.id),
    direction: stop.direction,
  );

  /// Screen-reader label: bookmark name (when different), name, direction,
  /// routes, stop id, joined with `"; "`.
  String stopAccessibilityLabel({
    required String name,
    required String code,
    String? direction,
    List<Route> routes = const [],
    String? bookmarkName,
  }) {
    final d = StopDirection.parse(direction);
    return [
      if (bookmarkName != null &&
          bookmarkName.isNotEmpty &&
          bookmarkName != name)
        bookmarkName,
      name,
      if (d != StopDirection.unknown) strings.directionName(d),
      ?formattedRoutes(routes),
      strings.stopId(code),
    ].join('; ');
  }

  String? directionName(String? direction) {
    final d = StopDirection.parse(direction);
    return d == StopDirection.unknown ? null : strings.directionName(d);
  }

  String? directionAdjective(String? direction) {
    final d = StopDirection.parse(direction);
    return d == StopDirection.unknown ? null : strings.directionAdjective(d);
  }

  // -- Routes ---------------------------------------------------------------------

  String? routeTypeName(RouteType type) {
    final s = strings.routeTypeName(type);
    return s.isEmpty ? null : s;
  }

  /// Short names in natural order; when no route has one (e.g. ferries),
  /// the distinct route-type names instead.
  List<String> sortedRouteNames(Iterable<Route> routes) {
    final names = [
      for (final r in routes)
        if (r.shortName case final s? when s.isNotEmpty) s,
    ]..sort(naturalCompare);
    if (names.isNotEmpty) return names;
    return {for (final r in routes) ?routeTypeName(r.routeType)}.toList()
      ..sort(naturalCompare);
  }

  /// Up to [limit] names and the overflow count; null when nothing to show.
  RouteListLabel? routeListLabel(Iterable<Route> routes, {int limit = 3}) {
    final names = sortedRouteNames(routes);
    if (names.isEmpty || limit <= 0) return null;
    final shown = names.take(limit).toList();
    return RouteListLabel(
      routeNames: shown,
      overflowCount: names.length - shown.length,
    );
  }

  /// `"10, 12, 49…"` — the map pin route list.
  String? formattedMapRoutes(Iterable<Route> routes, {int limit = 3}) {
    final label = routeListLabel(routes, limit: limit);
    if (label == null) return null;
    final names = label.routeNames.join(', ');
    return label.overflowCount > 0 ? strings.mapRoutesOverflow(names) : names;
  }

  /// `"Routes: 10, 12, 49"`, or `"Routes: 10, 12, + 3 more"` past [limit].
  String? formattedRoutes(Iterable<Route> routes, {int? limit}) {
    final names = sortedRouteNames(routes);
    if (names.isEmpty) return null;
    if (limit != null && names.length > limit) {
      return strings.routesLabelPlusMore(
        names.take(limit).join(', '),
        names.length - limit,
      );
    }
    return strings.routesLabel(names.join(', '));
  }

  /// Distinct agency names for [routes], sorted.
  String formattedAgencies(Iterable<Route> routes, References references) => ({
    for (final r in routes) ?references.agency(r.agencyId)?.name,
  }.toList()..sort()).join(', ');

  String searchPlaceholder(Region region) =>
      strings.searchPlaceholder(region.regionName);

  // -- Departures -------------------------------------------------------------------

  /// `"7m"`, `"-3m"`, or `"NOW"`.
  String shortTimeUntil(ArrivalAndDeparture a, DateTime now) {
    final m = a.minutesUntil(now) ?? 0;
    return a.temporalState(now) == TemporalState.present
        ? strings.now
        : strings.shortMinutes(m);
  }

  /// Spelled out for screen readers: `"7 minutes"`, `"One minute"`, `"NOW"`.
  String timeUntil(ArrivalAndDeparture a, DateTime now) {
    final m = a.minutesUntil(now) ?? 0;
    if (m == 0) return strings.now;
    if (m == -1) return strings.oneMinuteAgo;
    if (m == 1) return strings.oneMinute;
    return strings.minutes(m);
  }

  /// `"Arrives in 5 min"`, `"Departed 2 min ago"`, `"Arriving now"`.
  String explanation(ArrivalAndDeparture a, DateTime now) {
    final m = a.minutesUntil(now) ?? 0;
    final departing =
        a.arrivalDepartureStatus == ArrivalDepartureStatus.departing;
    return switch (a.temporalState(now)) {
      TemporalState.past =>
        departing ? strings.departedMinAgo(-m) : strings.arrivedMinAgo(-m),
      TemporalState.present =>
        departing ? strings.departingNow : strings.arrivingNow,
      TemporalState.future =>
        departing ? strings.departsInMin(m) : strings.arrivesInMin(m),
    };
  }

  /// `"arrives 3 min late"` etc., regardless of whether a prediction exists.
  String formattedScheduleDeviation(ArrivalAndDeparture a, DateTime now) {
    final dev = a.deviationFromScheduleInMinutes;
    final past = a.temporalState(now) == TemporalState.past;
    final departing =
        a.arrivalDepartureStatus == ArrivalDepartureStatus.departing;
    String pick(
      String Function(int) late,
      String Function(int) early,
      String onTime,
    ) => dev > 0 ? late(dev) : (dev < 0 ? early(-dev) : onTime);
    return switch ((past, departing)) {
      (true, false) => pick(
        strings.arrivedLate,
        strings.arrivedEarly,
        strings.arrivedOnTime,
      ),
      (true, true) => pick(
        strings.departedLate,
        strings.departedEarly,
        strings.departedOnTime,
      ),
      (false, false) => pick(
        strings.arrivesLate,
        strings.arrivesEarly,
        strings.arrivesOnTime,
      ),
      (false, true) => pick(
        strings.departsLate,
        strings.departsEarly,
        strings.departsOnTime,
      ),
    };
  }

  /// The deviation phrase when a prediction exists, otherwise
  /// "Scheduled/not real-time" (iOS `deviationLabel`).
  String scheduleDeviationLabel(ArrivalAndDeparture a, DateTime now) =>
      a.scheduleStatus == ScheduleStatus.unknown
      ? strings.scheduledNotRealTime
      : formattedScheduleDeviation(a, now);

  // -- Relative time --------------------------------------------------------------

  /// `"Just Now"` under 5 seconds, then `"31 sec. ago"`, `"4 min. ago"`...
  String timeAgo(DateTime date, {DateTime? now}) {
    final diff = (now ?? clock.now()).difference(date).abs();
    if (diff.inSeconds < 5) return strings.justNow;
    if (diff.inMinutes < 1) return strings.secondsAgo(diff.inSeconds);
    if (diff.inHours < 1) return strings.minutesAgo(diff.inMinutes);
    if (diff.inDays < 1) return strings.hoursAgo(diff.inHours);
    return strings.daysAgo(diff.inDays);
  }

  String updatedText(DateTime date, {DateTime? now}) =>
      strings.updatedAt(timeAgo(date, now: now));

  // -- Distance -------------------------------------------------------------------

  /// `"350 m"`, `"1.2 km"`, `"500 ft"`, `"0.3 mi"`.
  String distance(double meters, {DistanceUnits units = DistanceUnits.metric}) {
    switch (units) {
      case DistanceUnits.metric:
        if (meters < 1000) return strings.meters('${_roundTo(meters, 10)}');
        return strings.kilometers(_oneDecimal(meters / 1000));
      case DistanceUnits.imperial:
        final feet = meters * 3.28084;
        if (feet < 1000) return strings.feet('${_roundTo(feet, 10)}');
        return strings.miles(_oneDecimal(meters / 1609.344));
    }
  }

  static int _roundTo(double v, int step) => ((v / step).round() * step);

  static String _oneDecimal(double v) {
    final s = v.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }

  // -- Alarms ---------------------------------------------------------------------

  String alarmLeadTimeLabel(int minutes) => strings.alarmMinutes(minutes);

  static String _stripAgency(String id) {
    final i = id.indexOf('_');
    return i < 0 ? id : id.substring(i + 1);
  }
}

/// Alarm lead-time choices for a departure [minutesUntilDeparture] away,
/// largest first: every minute up to 10, then every 5 to 30, every 15 to
/// 120, every 30 beyond, all strictly below the departure
/// (iOS `AlarmTimePickerManager.incrementsForDeparture`).
List<int> alarmLeadTimeChoices(int minutesUntilDeparture) {
  final out = <int>[];
  var cursor = 1;
  while (cursor < minutesUntilDeparture) {
    out.add(cursor);
    if (cursor < 10) {
      cursor += 1;
    } else if (cursor < 30) {
      cursor += 5;
    } else if (cursor < 120) {
      cursor += 15;
    } else {
      cursor += 30;
    }
  }
  return out.reversed.toList();
}

/// The choice in [choices] closest to [preferred] (the default lead time),
/// or null when there are none.
int? closestAlarmLeadTime(List<int> choices, int preferred) {
  int? best;
  for (final c in choices) {
    if (best == null || (c - preferred).abs() < (best - preferred).abs()) {
      best = c;
    }
  }
  return best;
}
