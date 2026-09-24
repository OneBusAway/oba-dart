import '../core/json.dart';

class Agency {
  const Agency({
    required this.id,
    required this.name,
    this.url,
    this.timezone,
    this.phone,
  });

  factory Agency.fromJson(JsonMap json) => Agency(
        id: readString(json, 'id'),
        name: readString(json, 'name'),
        url: readOptString(json, 'url'),
        timezone: readOptString(json, 'timezone'),
        phone: readOptString(json, 'phone'),
      );

  final String id;
  final String name;
  final String? url;
  final String? timezone;
  final String? phone;
}
