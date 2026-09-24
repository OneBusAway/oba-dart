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
  });

  factory Trip.fromJson(JsonMap json) => Trip(
    id: readString(json, 'id'),
    routeId: readString(json, 'routeId'),
    tripHeadsign: readOptString(json, 'tripHeadsign'),
    directionId: readOptString(json, 'directionId'),
    serviceId: readOptString(json, 'serviceId'),
    blockId: readOptString(json, 'blockId'),
    shapeId: readOptString(json, 'shapeId'),
  );

  final String id;
  final String routeId;
  final String? tripHeadsign;
  final String? directionId;
  final String? serviceId;
  final String? blockId;
  final String? shapeId;
}
