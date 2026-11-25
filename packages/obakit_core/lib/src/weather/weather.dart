import 'dart:async';

import 'package:clock/clock.dart';
import 'package:onebusaway/onebusaway.dart';

import '../foundation/change_notifier.dart';

/// A weather condition family. Day and night variants share one value; the
/// icon conveys the time of day (iOS `WeatherFormatter.ConditionKey`).
enum WeatherCondition {
  clear,
  partlyCloudy,
  cloudy,
  rain,
  sleet,
  snow,
  wind,
  fog,

  /// An icon key the app does not model.
  unknown;

  /// From an Obaco (Dark Sky-style) icon key such as `partly-cloudy-day`.
  static WeatherCondition fromIconKey(String iconKey) => switch (iconKey) {
    'clear-day' || 'clear-night' => clear,
    'partly-cloudy-day' || 'partly-cloudy-night' => partlyCloudy,
    'cloudy' => cloudy,
    'rain' => rain,
    'sleet' => sleet,
    'snow' => snow,
    'wind' => wind,
    'fog' => fog,
    _ => unknown,
  };
}

/// Whether an Obaco icon key is a night variant.
bool isNightWeatherIcon(String iconKey) => iconKey.endsWith('-night');

enum TemperatureUnit { fahrenheit, celsius }

enum SpeedUnit { milesPerHour, kilometersPerHour, metersPerSecond }

/// A pair of units, for the data a forecast carries or for display.
class WeatherUnits {
  const WeatherUnits(this.temperature, this.speed);

  final TemperatureUnit temperature;
  final SpeedUnit speed;

  /// The units of a forecast's `units` field (Dark Sky conventions): `us`
  /// is °F and mph, `si` °C and m/s, `ca` °C and km/h, `uk2` °C and mph.
  /// Anything else is read as `us`, which is what Obaco sends.
  static WeatherUnits ofSource(String units) => switch (units.toLowerCase()) {
    'si' => const WeatherUnits(
      TemperatureUnit.celsius,
      SpeedUnit.metersPerSecond,
    ),
    'ca' => const WeatherUnits(
      TemperatureUnit.celsius,
      SpeedUnit.kilometersPerHour,
    ),
    'uk2' => const WeatherUnits(
      TemperatureUnit.celsius,
      SpeedUnit.milesPerHour,
    ),
    _ => const WeatherUnits(TemperatureUnit.fahrenheit, SpeedUnit.milesPerHour),
  };

  /// The units a locale reads: °F in the United States, Liberia and
  /// Myanmar (and for a bare `en`, which Flutter treats as en-US), °C
  /// elsewhere; mph there and in the United Kingdom, km/h elsewhere.
  static WeatherUnits forLocale({
    required String languageCode,
    String? countryCode,
  }) {
    final country =
        countryCode?.toUpperCase() ??
        (languageCode.toLowerCase() == 'en' ? 'US' : null);
    const fahrenheit = {'US', 'LR', 'MM', 'PR', 'GU', 'VI', 'AS', 'MP', 'UM'};
    const mph = {...fahrenheit, 'GB'};
    return WeatherUnits(
      fahrenheit.contains(country)
          ? TemperatureUnit.fahrenheit
          : TemperatureUnit.celsius,
      mph.contains(country)
          ? SpeedUnit.milesPerHour
          : SpeedUnit.kilometersPerHour,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is WeatherUnits &&
      other.temperature == temperature &&
      other.speed == speed;

  @override
  int get hashCode => Object.hash(temperature, speed);
}

double convertTemperature(
  double value, {
  required TemperatureUnit from,
  required TemperatureUnit to,
}) {
  if (from == to) return value;
  return from == TemperatureUnit.fahrenheit
      ? (value - 32) * 5 / 9
      : value * 9 / 5 + 32;
}

double convertSpeed(
  double value, {
  required SpeedUnit from,
  required SpeedUnit to,
}) {
  if (from == to) return value;
  final metersPerSecond = switch (from) {
    SpeedUnit.milesPerHour => value * 0.44704,
    SpeedUnit.kilometersPerHour => value / 3.6,
    SpeedUnit.metersPerSecond => value,
  };
  return switch (to) {
    SpeedUnit.milesPerHour => metersPerSecond / 0.44704,
    SpeedUnit.kilometersPerHour => metersPerSecond * 3.6,
    SpeedUnit.metersPerSecond => metersPerSecond,
  };
}

/// The rolling next 24 hours of [hourly]: drops hours before the one
/// containing [now], sorts, removes repeated timestamps, and caps at
/// [limit] (iOS `WeatherFormatter.upcomingHourly`). The hourly list and the
/// high/low use the same window so they never disagree.
List<HourlyForecast> upcomingHourly(
  Iterable<HourlyForecast> hourly, {
  DateTime? now,
  int limit = 24,
}) {
  final n = now ?? clock.now();
  final currentHourStart = DateTime.fromMillisecondsSinceEpoch(
    n.millisecondsSinceEpoch - n.millisecondsSinceEpoch % 3600000,
    isUtc: true,
  );
  final sorted =
      hourly.where((h) => !h.time.isBefore(currentHourStart)).toList()
        ..sort((a, b) => a.time.compareTo(b.time));
  final seen = <int>{};
  return sorted
      .where((h) => seen.add(h.time.millisecondsSinceEpoch))
      .take(limit)
      .toList();
}

/// Highest and lowest temperature over [hourly] (pass [upcomingHourly]'s
/// window), in the forecast's units; null when empty.
({double high, double low})? weatherHighLow(Iterable<HourlyForecast> hourly) {
  if (hourly.isEmpty) return null;
  var high = hourly.first.temperature;
  var low = high;
  for (final h in hourly) {
    if (h.temperature > high) high = h.temperature;
    if (h.temperature < low) low = h.temperature;
  }
  return (high: high, low: low);
}

/// The current region's forecast from Obaco, cached for [ttl] per region.
///
/// Concurrent [load] calls share one request. A failed fetch is remembered
/// for [failureBackoff], so a map control that asks on every rebuild does
/// not hammer the server; [load] with `force: true` retries at once.
class WeatherService extends ObaChangeNotifier {
  WeatherService({
    required this._obaco,
    this.ttl = const Duration(minutes: 15),
    this.failureBackoff = const Duration(minutes: 5),
  });

  final ObacoClient? Function() _obaco;
  final Duration ttl;
  final Duration failureBackoff;

  WeatherForecast? _forecast;
  int? _forecastRegion;
  DateTime? _fetchedAt;
  Object? _error;
  int? _errorRegion;
  DateTime? _failedAt;
  Future<WeatherForecast?>? _inFlight;
  int? _inFlightRegion;

  /// Whether a weather server exists for the current region.
  bool get isAvailable => _obaco() != null;

  /// The cached forecast for the current region, even when stale; null
  /// when there is none or the region changed.
  WeatherForecast? get forecast {
    final c = _obaco();
    return c != null && _forecastRegion == c.regionId ? _forecast : null;
  }

  /// The last fetch error for the current region, until a fetch succeeds.
  Object? get error {
    final c = _obaco();
    return c != null && _errorRegion == c.regionId ? _error : null;
  }

  bool get isLoading => _inFlight != null;

  /// Whether [forecast] is younger than [ttl].
  bool get isFresh {
    final at = _fetchedAt;
    return forecast != null && at != null && clock.now().difference(at) < ttl;
  }

  bool get _inBackoff {
    final at = _failedAt;
    return error != null &&
        at != null &&
        clock.now().difference(at) < failureBackoff;
  }

  /// Returns the cached forecast when fresh, otherwise fetches it. Returns
  /// null without a weather server. Never throws; failures are in [error].
  Future<WeatherForecast?> load({bool force = false}) {
    final client = _obaco();
    if (client == null) return Future.value(null);
    if (!force && isFresh) return Future.value(_forecast);
    if (!force && _inBackoff) return Future.value(forecast);
    final pending = _inFlight;
    if (pending != null && _inFlightRegion == client.regionId) return pending;
    final region = client.regionId;
    final future = _fetch(client, region);
    _inFlight = future;
    _inFlightRegion = region;
    notifyListeners();
    return future;
  }

  Future<WeatherForecast?> _fetch(ObacoClient client, int region) async {
    try {
      final result = await client.getWeather();
      if (isDisposed) return null;
      _forecast = result;
      _forecastRegion = region;
      _fetchedAt = clock.now();
      _error = null;
      _failedAt = null;
      return result;
    } catch (e) {
      if (isDisposed) return null;
      _error = e;
      _errorRegion = region;
      _failedAt = clock.now();
      return forecast;
    } finally {
      if (!isDisposed && _inFlightRegion == region) {
        _inFlight = null;
        _inFlightRegion = null;
        notifyListeners();
      }
    }
  }
}
