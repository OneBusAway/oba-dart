import 'package:clock/clock.dart';
import 'package:onebusaway/onebusaway.dart';

import '../user_data/stored_stop.dart';
import 'measurement.dart';
import 'strings.dart';

enum DistanceUnits {
  metric,
  imperial;

  /// The distance units [system] reads.
  static DistanceUnits of(MeasurementSystem system) =>
      system.usesMiles ? imperial : metric;
}

/// Text formatting for stops, routes, departures and distances. Port of the
/// locale-independent parts of iOS `Formatters`; clock times and dates are
/// left to the UI's `intl` formatting.
class ObaFormatters {
  const ObaFormatters([
    this.strings = const ObaCoreStrings(),
    this.units = DistanceUnits.metric,
  ]);

  final ObaCoreStrings strings;

  /// The units [distance] uses unless told otherwise.
  final DistanceUnits units;

  // -- Stops ----------------------------------------------------------------------

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

  String storedStopSubtitle(StoredStop stop) => stopSubtitle(
    code: stop.code ?? agencyLocalId(stop.id),
    direction: stop.direction,
  );

  // -- Routes ---------------------------------------------------------------------

  /// Distinct agency names for [routes], sorted.
  String formattedAgencies(Iterable<Route> routes, References references) => ({
    for (final r in routes) ?references.agency(r.agencyId)?.name,
  }.toList()..sort()).join(', ');

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

  // -- Distance -------------------------------------------------------------------

  /// `"350 m"`, `"1.2 km"`, `"500 ft"`, `"0.3 mi"`.
  String distance(double meters, {DistanceUnits? units}) {
    switch (units ?? this.units) {
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
