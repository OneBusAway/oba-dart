import 'package:clock/clock.dart';
import 'package:onebusaway/onebusaway.dart';

import '../arrivals/arrival_logic.dart';
import '../deep_links/trip_deep_link.dart';
import '../platform/push.dart';
import '../user_data/stored_alarm.dart';
import '../user_data/user_data_store.dart';

enum AlarmUnavailableReason {
  /// The host configured no [PushServiceProvider], or it is unavailable.
  noPushService,

  /// The current region has no Obaco server.
  noObaco,

  /// No region is selected.
  noRegion,

  /// The user declined notifications.
  permissionDenied,

  /// No push token yet.
  noPushToken,

  /// The departure is too close (no lead time below it).
  tooSoon,
}

class AlarmUnavailableException implements Exception {
  const AlarmUnavailableException(this.reason);

  final AlarmUnavailableReason reason;

  @override
  String toString() => 'AlarmUnavailableException(${reason.name})';
}

/// Creates, records and removes arrival alarms (iOS `AlarmBuilder` +
/// `AlarmRemover`). Alarm state lives in [UserDataStore.alarms]; listen to
/// the store for changes.
class AlarmService {
  AlarmService({
    required this._obaco,
    required this._region,
    required this.userData,
    this.pushServiceProvider,
  });

  final ObacoClient? Function() _obaco;
  final Region? Function() _region;
  final UserDataStore userData;
  final PushServiceProvider? pushServiceProvider;

  /// Whether alarms can be offered at all right now (push configured and a
  /// region with an Obaco server).
  bool get isAvailable =>
      (pushServiceProvider?.isAvailable ?? false) &&
      _region() != null &&
      _obaco() != null;

  /// Whether an alarm can be set for [arrival] (available, and departing at
  /// least two minutes from [now]).
  bool canCreateAlarm(ArrivalAndDeparture arrival, DateTime now) =>
      isAvailable && (arrival.minutesUntil(now) ?? 0) > 1;

  /// The stored alarm for this departure, matched by trip, stop, service
  /// date and stop sequence.
  StoredAlarm? alarmFor(ArrivalAndDeparture arrival) => userData.alarms
      .where(
        (a) =>
            a.deepLink != null &&
            a.deepLink!.tripId == arrival.tripId &&
            a.deepLink!.stopId == arrival.stopId &&
            a.deepLink!.stopSequence == arrival.stopSequence &&
            a.deepLink!.serviceDate.isAtSameMomentAs(arrival.serviceDate),
      )
      .firstOrNull;

  /// Creates an alarm [minutesBefore] the departure, records it, and
  /// returns it. Asks for push permission if needed. Throws
  /// [AlarmUnavailableException] or the Obaco client's exceptions.
  Future<StoredAlarm> createAlarm(
    ArrivalAndDeparture arrival, {
    required int minutesBefore,
    String? title,
  }) async {
    final push = pushServiceProvider;
    if (push == null || !push.isAvailable) {
      throw const AlarmUnavailableException(
        AlarmUnavailableReason.noPushService,
      );
    }
    final region = _region();
    if (region == null) {
      throw const AlarmUnavailableException(AlarmUnavailableReason.noRegion);
    }
    final obaco = _obaco();
    if (obaco == null) {
      throw const AlarmUnavailableException(AlarmUnavailableReason.noObaco);
    }
    if (minutesBefore < 1 ||
        minutesBefore >= (arrival.minutesUntil(clock.now()) ?? 0)) {
      throw const AlarmUnavailableException(AlarmUnavailableReason.tooSoon);
    }
    var token = await push.pushToken();
    if (token == null) {
      if (!await push.requestPermission()) {
        throw const AlarmUnavailableException(
          AlarmUnavailableReason.permissionDenied,
        );
      }
      token = await push.pushToken();
    }
    if (token == null) {
      throw const AlarmUnavailableException(AlarmUnavailableReason.noPushToken);
    }
    final created = await obaco.postAlarm(
      secondsBefore: Duration(minutes: minutesBefore),
      stopId: arrival.stopId,
      tripId: arrival.tripId,
      serviceDate: arrival.serviceDate,
      vehicleId: arrival.vehicleId,
      stopSequence: arrival.stopSequence,
      userPushId: token,
    );
    final tripDate = arrival.bestDate ?? created.tripDate;
    final alarm = StoredAlarm(
      url: created.url,
      tripDate: tripDate,
      alarmDate:
          tripDate?.subtract(Duration(minutes: minutesBefore)) ??
          created.alarmDate,
      leadTimeMinutes: minutesBefore,
      deepLink: TripDeepLink.fromArrival(
        arrival,
        regionId: region.id,
        title: title,
      ),
    );
    userData.addAlarm(alarm);
    return alarm;
  }

  /// Deletes the alarm on the server and locally. A 404 means it already
  /// fired, which counts as deleted. Throws (keeping the local copy) on
  /// other failures, or when there is no Obaco server.
  Future<void> removeAlarm(StoredAlarm alarm) async {
    final obaco = _obaco();
    if (obaco == null) {
      throw const AlarmUnavailableException(AlarmUnavailableReason.noObaco);
    }
    try {
      await obaco.deleteAlarm(alarm.url);
    } on ObaApiException catch (e) {
      if (!(e.kind == ObaApiErrorKind.httpStatus && e.code == 404)) rethrow;
    }
    userData.deleteAlarm(alarm.url);
  }

  /// Drops alarms whose departure has passed.
  void pruneExpiredAlarms() => userData.deleteExpiredAlarms();
}
