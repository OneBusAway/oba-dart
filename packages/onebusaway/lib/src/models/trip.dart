import '../core/json.dart';

class Trip {
  const Trip({
    required this.id,
    required this.routeId,
    this.tripHeadsign,
    this.directionId,
    this.serviceId,
    this.blockId,
    this.shapeId,
    this.routeShortName,
    this.tripShortName,
    this.timeZone,
  });

  factory Trip.fromJson(JsonMap json) => Trip(
    id: readString(json, 'id'),
    routeId: readString(json, 'routeId'),
    tripHeadsign: readOptString(json, 'tripHeadsign'),
    directionId: readOptString(json, 'directionId'),
    serviceId: readOptString(json, 'serviceId'),
    blockId: readOptString(json, 'blockId'),
    shapeId: readOptString(json, 'shapeId'),
    routeShortName: readOptString(json, 'routeShortName'),
    tripShortName: readOptString(json, 'tripShortName'),
    timeZone: readOptString(json, 'timeZone'),
  );

  final String id;
  final String routeId;
  final String? tripHeadsign;
  final String? directionId;
  final String? serviceId;
  final String? blockId;
  final String? shapeId;

  /// Trip-level override of the route's short name; usually null.
  final String? routeShortName;
  final String? tripShortName;
  final String? timeZone;
}
