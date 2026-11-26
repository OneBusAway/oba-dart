import '../core/json.dart';

/// Entry of `schedule-for-stop/{id}`.
class ScheduleForStop {
  const ScheduleForStop({
    required this.stopId,
    required this.date,
    this.stopRouteSchedules = const [],
  });

  factory ScheduleForStop.fromJson(JsonMap json) => ScheduleForStop(
    stopId: readString(json, 'stopId'),
    date: readRequiredEpochMs(json, 'date'),
    stopRouteSchedules: readObjectList(
      json,
      'stopRouteSchedules',
      StopRouteSchedule.fromJson,
    ),
  );

  final String stopId;

  /// The day the schedule is for, as an instant.
  final DateTime date;
  final List<StopRouteSchedule> stopRouteSchedules;
}

class StopRouteSchedule {
  const StopRouteSchedule({
    required this.routeId,
    this.stopRouteDirectionSchedules = const [],
  });

  factory StopRouteSchedule.fromJson(JsonMap json) => StopRouteSchedule(
    routeId: readString(json, 'routeId'),
    stopRouteDirectionSchedules: readObjectList(
      json,
      'stopRouteDirectionSchedules',
      StopRouteDirectionSchedule.fromJson,
    ),
  );

  final String routeId;
  final List<StopRouteDirectionSchedule> stopRouteDirectionSchedules;
}

class StopRouteDirectionSchedule {
  const StopRouteDirectionSchedule({
    this.tripHeadsign,
    this.scheduleFrequencies = const [],
    this.scheduleStopTimes = const [],
  });

  factory StopRouteDirectionSchedule.fromJson(JsonMap json) =>
      StopRouteDirectionSchedule(
        tripHeadsign: readOptString(json, 'tripHeadsign'),
        scheduleFrequencies: readObjectList(
          json,
          'scheduleFrequencies',
          ScheduleFrequency.fromJson,
        ),
        scheduleStopTimes: readObjectList(
          json,
          'scheduleStopTimes',
          StopScheduleStopTime.fromJson,
        ),
      );

  final String? tripHeadsign;
  final List<ScheduleFrequency> scheduleFrequencies;
  final List<StopScheduleStopTime> scheduleStopTimes;
}

/// A scheduled visit to the stop. Times are absolute instants.
class StopScheduleStopTime {
  const StopScheduleStopTime({
    required this.tripId,
    required this.arrivalTime,
    required this.departureTime,
    this.serviceId,
    this.arrivalEnabled = true,
    this.departureEnabled = true,
    this.stopHeadsign,
  });

  factory StopScheduleStopTime.fromJson(JsonMap json) => StopScheduleStopTime(
    tripId: readString(json, 'tripId'),
    serviceId: readOptString(json, 'serviceId'),
    arrivalTime: readRequiredEpochMs(json, 'arrivalTime'),
    departureTime: readRequiredEpochMs(json, 'departureTime'),
    arrivalEnabled: readBool(json, 'arrivalEnabled', defaultValue: true),
    departureEnabled: readBool(json, 'departureEnabled', defaultValue: true),
    stopHeadsign: readOptString(json, 'stopHeadsign'),
  );

  final String tripId;
  final String? serviceId;
  final DateTime arrivalTime;
  final DateTime departureTime;
  final bool arrivalEnabled;
  final bool departureEnabled;
  final String? stopHeadsign;
}

/// A frequency-based block of service. Times are absolute instants.
class ScheduleFrequency {
  const ScheduleFrequency({
    required this.startTime,
    required this.endTime,
    required this.headway,
  });

  factory ScheduleFrequency.fromJson(JsonMap json) => ScheduleFrequency(
    startTime: readRequiredEpochMs(json, 'startTime'),
    endTime: readRequiredEpochMs(json, 'endTime'),
    headway: readInt(json, 'headway'),
  );

  final DateTime startTime;
  final DateTime endTime;

  /// Seconds between departures.
  final int headway;
}
