import 'package:onebusaway/onebusaway.dart';

import '../foundation/json.dart';

/// Points at one arrival of one trip at one stop. Port of iOS
/// `ArrivalDepartureDeepLink`; used by shared trip links and alarms.
class TripDeepLink {
  const TripDeepLink({
    required this.title,
    required this.regionId,
    required this.stopId,
    required this.tripId,
    required this.serviceDate,
    required this.stopSequence,
    this.vehicleId,
    this.destinationStopId,
  });

  factory TripDeepLink.fromArrival(
    ArrivalAndDeparture arrival, {
    required int regionId,
    String? title,
    String? destinationStopId,
  }) => TripDeepLink(
    title:
        title ??
        [
          arrival.routeShortName,
          arrival.tripHeadsign,
        ].whereType<String>().where((s) => s.trim().isNotEmpty).join(' - '),
    regionId: regionId,
    stopId: arrival.stopId,
    tripId: arrival.tripId,
    serviceDate: arrival.serviceDate,
    stopSequence: arrival.stopSequence,
    vehicleId: arrival.vehicleId,
    destinationStopId: destinationStopId,
  );

  factory TripDeepLink.fromJson(JsonObject j) => TripDeepLink(
    title: jString(j, 'title') ?? '',
    regionId: jInt(j, 'regionId') ?? (throw const FormatException('regionId')),
    stopId: jString(j, 'stopId') ?? (throw const FormatException('stopId')),
    tripId: jString(j, 'tripId') ?? (throw const FormatException('tripId')),
    serviceDate:
        jDate(j, 'serviceDate') ?? (throw const FormatException('serviceDate')),
    stopSequence: jInt(j, 'stopSequence') ?? 0,
    vehicleId: jString(j, 'vehicleId'),
    destinationStopId: jString(j, 'destinationStopId'),
  );

  final String title;
  final int regionId;
  final String stopId;
  final String tripId;
  final DateTime serviceDate;
  final int stopSequence;
  final String? vehicleId;
  final String? destinationStopId;

  JsonObject toJson() => {
    'title': title,
    'regionId': regionId,
    'stopId': stopId,
    'tripId': tripId,
    'serviceDate': isoDate(serviceDate),
    'stopSequence': stopSequence,
    'vehicleId': ?vehicleId,
    'destinationStopId': ?destinationStopId,
  };

  @override
  bool operator ==(Object other) =>
      other is TripDeepLink &&
      other.title == title &&
      other.regionId == regionId &&
      other.stopId == stopId &&
      other.tripId == tripId &&
      other.serviceDate.isAtSameMomentAs(serviceDate) &&
      other.stopSequence == stopSequence &&
      other.vehicleId == vehicleId &&
      other.destinationStopId == destinationStopId;

  @override
  int get hashCode => Object.hash(
    title,
    regionId,
    stopId,
    tripId,
    serviceDate.millisecondsSinceEpoch,
    stopSequence,
    vehicleId,
    destinationStopId,
  );

  @override
  String toString() => 'TripDeepLink($regionId, $stopId, $tripId)';
}
