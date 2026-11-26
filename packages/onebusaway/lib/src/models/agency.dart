import '../core/json.dart';

class Agency {
  const Agency({
    required this.id,
    required this.name,
    this.url,
    this.timezone,
    this.phone,
    this.language,
    this.email,
    this.fareUrl,
    this.disclaimer,
    this.privateService = false,
  });

  factory Agency.fromJson(JsonMap json) => Agency(
    id: readString(json, 'id'),
    name: readString(json, 'name'),
    url: readOptString(json, 'url'),
    timezone: readOptString(json, 'timezone'),
    phone: readOptString(json, 'phone'),
    language: readOptString(json, 'lang'),
    email: readOptString(json, 'email'),
    fareUrl: readOptString(json, 'fareUrl'),
    disclaimer: readOptString(json, 'disclaimer'),
    privateService: readBool(json, 'privateService'),
  );

  final String id;
  final String name;
  final String? url;

  /// IANA time zone name, e.g. `America/Los_Angeles`.
  final String? timezone;
  final String? phone;

  /// The agency's language code (`lang`), e.g. `en`. Case varies by feed.
  final String? language;
  final String? email;
  final String? fareUrl;
  final String? disclaimer;
  final bool privateService;
}
