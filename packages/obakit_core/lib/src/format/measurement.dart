/// Which units a country reads, for distances, temperatures and speeds.
/// The one policy behind `ObaFormatters` distances and [WeatherUnits]
/// (`obakit_trip_planner` mirrors the distance part in its own
/// `DistanceUnits.forLocale`).
enum MeasurementSystem {
  /// Metres, kilometres, °C, km/h.
  metric,

  /// Feet and miles, mph, but °C (the United Kingdom).
  uk,

  /// Feet and miles, °F, mph: the United States and its territories,
  /// Liberia and Myanmar.
  us;

  static const _us = {'US', 'LR', 'MM', 'PR', 'GU', 'VI', 'AS', 'MP', 'UM'};

  /// The system for an ISO 3166 [countryCode] (any case); metric when null
  /// or unknown.
  static MeasurementSystem forCountry(String? countryCode) {
    final country = countryCode?.toUpperCase();
    if (_us.contains(country)) return us;
    if (country == 'GB') return uk;
    return metric;
  }

  /// Distances in feet and miles.
  bool get usesMiles => this != metric;

  /// Temperatures in °F.
  bool get usesFahrenheit => this == us;
}
