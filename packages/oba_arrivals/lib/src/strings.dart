/// Every user-facing string in the panel. Subclass and override to localize.
class ObaArrivalsStrings {
  const ObaArrivalsStrings();

  String get now => 'now';
  String minutesCompact(int minutes) => '${minutes}m';
  String minLate(int minutes) => '$minutes min late';
  String minEarly(int minutes) => '$minutes min early';
  String get onTime => 'on time';
  String get scheduled => 'scheduled';
  String get canceled => 'canceled';
  String everyMinutesFrom(int minutes, String time) => 'every $minutes min from $time';
  String everyMinutesUntil(int minutes, String time) => 'every $minutes min until $time';

  String stopNumber(String code) => 'Stop #$code';

  /// [code] is a compass code like `SW`; unknown codes are shown as-is.
  String directionBound(String code) {
    final name = switch (code) {
      'N' => 'North',
      'NE' => 'Northeast',
      'E' => 'East',
      'SE' => 'Southeast',
      'S' => 'South',
      'SW' => 'Southwest',
      'W' => 'West',
      'NW' => 'Northwest',
      _ => code,
    };
    return '$name bound';
  }

  String get refresh => 'Refresh arrivals';
  String get retry => 'Retry';
  String noArrivals(int minutes) => 'No arrivals in the next $minutes minutes';
  String get stopNotFound => 'Stop not found or service unavailable';
  String get networkError => "Couldn't reach the transit server. Check your connection.";
  String get loadError => "Couldn't load arrivals.";
  String staleNotice(String time) => "Couldn't update. Showing results from $time";

  // Accessibility.
  String get arrivingNow => 'arriving now';
  String arrivingInMinutes(int minutes) =>
      minutes == 1 ? 'arriving in 1 minute' : 'arriving in $minutes minutes';
  String get realtime => 'real-time';
  String get rowTapHint => 'show details';
}
