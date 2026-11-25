import 'dart:ui' show Locale;

import 'package:flutter/material.dart' show MaterialLocalizations, TimeOfDay;

import '../api/api.dart';

enum DistanceUnits {
  metric,
  imperial;

  /// Imperial for the US, Liberia and Myanmar (as iOS's `.us` measurement
  /// system), metric elsewhere.
  static DistanceUnits forLocale(Locale? locale) =>
      switch (locale?.countryCode?.toUpperCase()) {
        'US' || 'LR' || 'MM' => imperial,
        _ => metric,
      };
}

/// A distance split into a number and unit, before localization. Distances
/// under 0.1 mi are feet (imperial); under 1 km, meters (metric). Short units
/// are whole numbers, long ones keep one decimal.
typedef DistanceParts = ({double value, DistanceUnit unit});

enum DistanceUnit { feet, miles, meters, kilometers }

DistanceParts distanceParts(double meters, DistanceUnits units) {
  if (units == DistanceUnits.imperial) {
    final feet = meters * 3.28084;
    if (feet < 528) {
      return (value: feet.roundToDouble(), unit: DistanceUnit.feet);
    }
    return (value: _oneDecimal(meters * 0.000621371), unit: DistanceUnit.miles);
  }
  if (meters < 1000) {
    return (value: meters.roundToDouble(), unit: DistanceUnit.meters);
  }
  return (value: _oneDecimal(meters / 1000), unit: DistanceUnit.kilometers);
}

double _oneDecimal(double value) => (value * 10).round() / 10;

/// `12` for whole values, `1.5` otherwise.
String formatNumber(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toStringAsFixed(1);

/// Hours and minutes for a duration in seconds, never less than one minute
/// for a non-zero duration (a rider never wants to read "0 min").
({int hours, int minutes}) durationParts(int seconds) {
  if (seconds <= 0) return (hours: 0, minutes: 0);
  final totalMinutes = (seconds / 60).round().clamp(1, 1 << 30);
  return (hours: totalMinutes ~/ 60, minutes: totalMinutes % 60);
}

/// `$2.50`, or `2.50 EUR` when the server sent no symbol.
String formatMoney(Money money) {
  final digits = money.fractionDigits.clamp(0, 4);
  var divisor = 1;
  for (var i = 0; i < digits; i++) {
    divisor *= 10;
  }
  final amount = (money.cents / divisor).toStringAsFixed(digits);
  final symbol = money.symbol;
  return symbol == null || symbol.isEmpty
      ? '$amount ${money.currencyCode}'
      : '$symbol$amount';
}

/// A clock time in the locale's format, honoring the device 24-hour
/// setting when [alwaysUse24HourFormat] is passed from `MediaQuery`.
String formatClockTime(
  DateTime time,
  MaterialLocalizations localizations, {
  bool alwaysUse24HourFormat = false,
}) => localizations.formatTimeOfDay(
  TimeOfDay.fromDateTime(time.toLocal()),
  alwaysUse24HourFormat: alwaysUse24HourFormat,
);

/// Real-time status of a departure or arrival (OTPKit `RealTimeStatus`).
sealed class RealTimeStatus {
  const RealTimeStatus();

  /// From a leg's real-time flag and a delay in seconds (positive = late),
  /// rounded to whole minutes.
  factory RealTimeStatus.of({required bool realTime, int? delaySeconds}) {
    if (!realTime || delaySeconds == null) return const ScheduledStatus();
    final minutes = (delaySeconds / 60).round();
    if (minutes > 0) return LateStatus(minutes);
    if (minutes < 0) return EarlyStatus(-minutes);
    return const OnTimeStatus();
  }
}

final class OnTimeStatus extends RealTimeStatus {
  const OnTimeStatus();

  @override
  bool operator ==(Object other) => other is OnTimeStatus;

  @override
  int get hashCode => (OnTimeStatus).hashCode;
}

final class LateStatus extends RealTimeStatus {
  const LateStatus(this.minutes);

  final int minutes;

  @override
  bool operator ==(Object other) =>
      other is LateStatus && other.minutes == minutes;

  @override
  int get hashCode => Object.hash(LateStatus, minutes);
}

final class EarlyStatus extends RealTimeStatus {
  const EarlyStatus(this.minutes);

  final int minutes;

  @override
  bool operator ==(Object other) =>
      other is EarlyStatus && other.minutes == minutes;

  @override
  int get hashCode => Object.hash(EarlyStatus, minutes);
}

final class ScheduledStatus extends RealTimeStatus {
  const ScheduledStatus();

  @override
  bool operator ==(Object other) => other is ScheduledStatus;

  @override
  int get hashCode => (ScheduledStatus).hashCode;
}

extension LegRealTime on Leg {
  RealTimeStatus get departureStatus =>
      RealTimeStatus.of(realTime: realTime, delaySeconds: departureDelay);

  RealTimeStatus get arrivalStatus =>
      RealTimeStatus.of(realTime: realTime, delaySeconds: arrivalDelay);
}
