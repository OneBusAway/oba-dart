import 'package:onebusaway/onebusaway.dart';

/// English text used by the formatters. Subclass and override to localise
/// (the obakit UI package does this from its ARB files).
class ObaCoreStrings {
  const ObaCoreStrings();

  String directionName(StopDirection d) => switch (d) {
    StopDirection.n => 'North',
    StopDirection.ne => 'Northeast',
    StopDirection.e => 'East',
    StopDirection.se => 'Southeast',
    StopDirection.s => 'South',
    StopDirection.sw => 'Southwest',
    StopDirection.w => 'West',
    StopDirection.nw => 'Northwest',
    StopDirection.unknown => '',
  };

  String directionAbbreviation(StopDirection d) => switch (d) {
    StopDirection.unknown => '',
    _ => d.name.toUpperCase(),
  };

  /// "Northbound", "NE bound", ...
  String directionAdjective(StopDirection d) => switch (d) {
    StopDirection.n => 'Northbound',
    StopDirection.ne => 'NE bound',
    StopDirection.e => 'Eastbound',
    StopDirection.se => 'SE bound',
    StopDirection.s => 'Southbound',
    StopDirection.sw => 'SW bound',
    StopDirection.w => 'Westbound',
    StopDirection.nw => 'NW bound',
    StopDirection.unknown => '',
  };

  String routeTypeName(RouteType t) => switch (t) {
    RouteType.lightRail => 'Light Rail',
    RouteType.subway => 'Subway',
    RouteType.rail => 'Rail',
    RouteType.bus => 'Bus',
    RouteType.ferry => 'Ferry',
    RouteType.cableCar => 'Cable Car',
    RouteType.gondola => 'Gondola',
    RouteType.funicular => 'Funicular',
    RouteType.unknown => '',
  };

  String stopCodeNumeric(String code) => 'Stop #$code';
  String stopCodeNonNumeric(String code) => "Stop: '$code'";
  String stopId(String code) => 'Stop ID: $code';
  String routesLabel(String list) => 'Routes: $list';
  String routesLabelPlusMore(String list, int more) =>
      'Routes: $list, + $more more';
  String mapRoutesOverflow(String list) => '$list…';
  String searchPlaceholder(String regionName) => 'Search in $regionName';

  String get now => 'NOW';
  String shortMinutes(int minutes) => '${minutes}m';
  String get oneMinute => 'One minute';
  String get oneMinuteAgo => 'One minute ago';
  String minutes(int minutes) => '$minutes minutes';
  String get justNow => 'Just Now';
  String secondsAgo(int n) => '$n sec. ago';
  String minutesAgo(int n) => '$n min. ago';
  String hoursAgo(int n) => '$n hr. ago';
  String daysAgo(int n) => n == 1 ? '1 day ago' : '$n days ago';
  String updatedAt(String ago) => 'Updated: $ago';

  String get scheduledNotRealTime => 'Scheduled/not real-time';

  String arrivedMinAgo(int m) => 'Arrived $m min ago';
  String departedMinAgo(int m) => 'Departed $m min ago';
  String get arrivingNow => 'Arriving now';
  String get departingNow => 'Departing now';
  String arrivesInMin(int m) => 'Arrives in $m min';
  String departsInMin(int m) => 'Departs in $m min';

  String arrivedLate(int m) => 'arrived $m min late';
  String arrivedEarly(int m) => 'arrived $m min early';
  String get arrivedOnTime => 'arrived on time';
  String departedLate(int m) => 'departed $m min late';
  String departedEarly(int m) => 'departed $m min early';
  String get departedOnTime => 'departed on time';
  String arrivesLate(int m) => 'arrives $m min late';
  String arrivesEarly(int m) => 'arrives $m min early';
  String get arrivesOnTime => 'arrives on time';
  String departsLate(int m) => 'departs $m min late';
  String departsEarly(int m) => 'departs $m min early';
  String get departsOnTime => 'departs on time';

  String meters(String n) => '$n m';
  String kilometers(String n) => '$n km';
  String feet(String n) => '$n ft';
  String miles(String n) => '$n mi';

  String alarmMinutes(int m) => m == 1 ? '1 minute' : '$m minutes';
}
