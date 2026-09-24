import 'package:onebusaway/onebusaway.dart';

import '../strings.dart';

enum ArrivalStatusKind { onTime, late, early, scheduled, canceled }

int _floorMinutes(DateTime t) => t.millisecondsSinceEpoch ~/ 60000;

/// True when the row has a usable real-time prediction.
bool hasPrediction(ArrivalAndDeparture a) =>
    a.predicted && a.predictedArrivalTime != null;

/// The time shown in the row: predicted when available, else scheduled.
DateTime? displayTime(ArrivalAndDeparture a) =>
    hasPrediction(a) ? a.predictedArrivalTime : a.scheduledArrivalTime;

/// Whole minutes from [now] until the row's display time (floored, like
/// Wayfinder). Negative when already passed; null when the row has no times.
int? minutesUntil(ArrivalAndDeparture a, DateTime now) {
  final time = displayTime(a);
  if (time == null) return null;
  return _floorMinutes(time) - _floorMinutes(now);
}

/// Predicted minus scheduled, in whole minutes; null without a prediction.
int? delayMinutes(ArrivalAndDeparture a) {
  final scheduled = a.scheduledArrivalTime;
  if (!hasPrediction(a) || scheduled == null) return null;
  return _floorMinutes(a.predictedArrivalTime!) - _floorMinutes(scheduled);
}

bool isCanceled(ArrivalAndDeparture a) => a.tripStatus?.status == 'CANCELED';

/// Drives the status color. Deliberately differs from [statusText] at
/// exactly 1 minute early, matching Wayfinder.
ArrivalStatusKind statusKind(ArrivalAndDeparture a) {
  if (isCanceled(a)) return ArrivalStatusKind.canceled;
  final delay = delayMinutes(a);
  if (delay == null) return ArrivalStatusKind.scheduled;
  if (delay > 0) return ArrivalStatusKind.late;
  if (delay < -1) return ArrivalStatusKind.early;
  return ArrivalStatusKind.onTime;
}

String statusText(
  ArrivalAndDeparture a,
  DateTime now,
  ObaArrivalsStrings strings, {
  required String Function(DateTime time) formatTime,
}) {
  if (isCanceled(a)) return strings.canceled;
  final frequency = a.frequency;
  if (frequency != null) {
    final headwayMinutes = frequency.headway ~/ 60;
    return now.isBefore(frequency.startTime)
        ? strings.everyMinutesFrom(
            headwayMinutes,
            formatTime(frequency.startTime),
          )
        : strings.everyMinutesUntil(
            headwayMinutes,
            formatTime(frequency.endTime),
          );
  }
  final delay = delayMinutes(a);
  if (delay == null) return strings.scheduled;
  if (delay > 0) return strings.minLate(delay);
  if (delay < 0) return strings.minEarly(-delay);
  return strings.onTime;
}

String etaLabel(int eta, ObaArrivalsStrings strings) =>
    eta == 0 ? strings.now : strings.minutesCompact(eta);
