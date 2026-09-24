import '../core/json.dart';

class Route {
  const Route({
    required this.id,
    required this.agencyId,
    this.shortName,
    this.longName,
    this.description,
    this.type,
    this.color,
    this.textColor,
    this.url,
  });

  factory Route.fromJson(JsonMap json) => Route(
        id: readString(json, 'id'),
        agencyId: readString(json, 'agencyId'),
        shortName: readOptString(json, 'shortName'),
        longName: readOptString(json, 'longName'),
        description: readOptString(json, 'description'),
        type: readOptInt(json, 'type'),
        color: readOptString(json, 'color'),
        textColor: readOptString(json, 'textColor'),
        url: readOptString(json, 'url'),
      );

  final String id;
  final String agencyId;
  final String? shortName;
  final String? longName;
  final String? description;

  /// GTFS route_type (3 = bus).
  final int? type;

  /// GTFS hex color without `#`, possibly lowercase, e.g. `ffcd00`.
  final String? color;
  final String? textColor;
  final String? url;
}
