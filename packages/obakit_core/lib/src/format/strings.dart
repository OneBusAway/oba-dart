import 'package:onebusaway/onebusaway.dart';

/// English text used by the formatters. Subclass and override to localise
/// (the obakit UI package does this from its ARB files).
class ObaCoreStrings {
  const ObaCoreStrings();

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

  String stopCodeNumeric(String code) => 'Stop #$code';
  String stopCodeNonNumeric(String code) => "Stop: '$code'";

  String get justNow => 'Just Now';
  String secondsAgo(int n) => '$n sec. ago';
  String minutesAgo(int n) => '$n min. ago';
  String hoursAgo(int n) => '$n hr. ago';
  String daysAgo(int n) => n == 1 ? '1 day ago' : '$n days ago';

  String meters(String n) => '$n m';
  String kilometers(String n) => '$n km';
  String feet(String n) => '$n ft';
  String miles(String n) => '$n mi';
}
