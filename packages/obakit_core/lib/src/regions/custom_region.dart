import 'package:http/http.dart' as http;
import 'package:onebusaway/onebusaway.dart';

/// Why a custom-region field is invalid.
enum CustomRegionFieldError { required, invalidUrl, invalidNumber, outOfRange }

/// The raw text of the custom-region form, and the logic to turn it into a
/// [Region]. Port of the validation in iOS `RegionCustomForm`.
class CustomRegionDraft {
  const CustomRegionDraft({
    this.name = '',
    this.obaUrl = '',
    this.sidecarUrl = '',
    this.otpUrl = '',
    this.otpGraphqlUrl = '',
    this.latitude = '',
    this.longitude = '',
    this.latSpan = '',
    this.lonSpan = '',
    this.contactEmail = '',
  });

  /// Prefills from an add-region link.
  factory CustomRegionDraft.fromRegion(Region r) {
    final b = r.bounds.isEmpty ? null : r.bounds.first;
    String n(double? v) => v == null ? '' : '$v';
    return CustomRegionDraft(
      name: r.regionName,
      obaUrl: r.obaBaseUrl.toString(),
      sidecarUrl: r.sidecarBaseUrl?.toString() ?? '',
      otpUrl: r.otpBaseUrl?.toString() ?? '',
      otpGraphqlUrl: r.otpBaseGraphqlUrl?.toString() ?? '',
      latitude: n(b?.lat),
      longitude: n(b?.lon),
      latSpan: n(b?.latSpan),
      lonSpan: n(b?.lonSpan),
      contactEmail: r.contactEmail,
    );
  }

  final String name;
  final String obaUrl;
  final String sidecarUrl;
  final String otpUrl;
  final String otpGraphqlUrl;
  final String latitude;
  final String longitude;
  final String latSpan;
  final String lonSpan;
  final String contactEmail;

  CustomRegionDraft copyWith({
    String? name,
    String? obaUrl,
    String? sidecarUrl,
    String? otpUrl,
    String? otpGraphqlUrl,
    String? latitude,
    String? longitude,
    String? latSpan,
    String? lonSpan,
    String? contactEmail,
  }) => CustomRegionDraft(
    name: name ?? this.name,
    obaUrl: obaUrl ?? this.obaUrl,
    sidecarUrl: sidecarUrl ?? this.sidecarUrl,
    otpUrl: otpUrl ?? this.otpUrl,
    otpGraphqlUrl: otpGraphqlUrl ?? this.otpGraphqlUrl,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    latSpan: latSpan ?? this.latSpan,
    lonSpan: lonSpan ?? this.lonSpan,
    contactEmail: contactEmail ?? this.contactEmail,
  );

  /// Parses an http(s) URL with a host, tolerating surrounding spaces.
  static Uri? parseHttpUrl(String raw) {
    final u = Uri.tryParse(raw.trim());
    if (u == null || u.host.isEmpty) return null;
    if (u.scheme != 'http' && u.scheme != 'https') return null;
    return u;
  }

  CustomRegionFieldError? nameError() =>
      name.trim().isEmpty ? CustomRegionFieldError.required : null;

  CustomRegionFieldError? obaUrlError() => obaUrl.trim().isEmpty
      ? CustomRegionFieldError.required
      : parseHttpUrl(obaUrl) == null
      ? CustomRegionFieldError.invalidUrl
      : null;

  /// Optional URL fields: empty is fine.
  static CustomRegionFieldError? optionalUrlError(String raw) =>
      raw.trim().isEmpty || parseHttpUrl(raw) != null
      ? null
      : CustomRegionFieldError.invalidUrl;

  static CustomRegionFieldError? _number(
    String raw, {
    required double min,
    required double max,
    bool exclusiveMin = false,
  }) {
    if (raw.trim().isEmpty) return CustomRegionFieldError.required;
    final v = double.tryParse(raw.trim());
    if (v == null || v.isNaN || v.isInfinite) {
      return CustomRegionFieldError.invalidNumber;
    }
    if (v > max || v < min || (exclusiveMin && v == min)) {
      return CustomRegionFieldError.outOfRange;
    }
    return null;
  }

  CustomRegionFieldError? latitudeError() =>
      _number(latitude, min: -90, max: 90);
  CustomRegionFieldError? longitudeError() =>
      _number(longitude, min: -180, max: 180);
  CustomRegionFieldError? latSpanError() =>
      _number(latSpan, min: 0, max: 180, exclusiveMin: true);
  CustomRegionFieldError? lonSpanError() =>
      _number(lonSpan, min: 0, max: 360, exclusiveMin: true);

  bool get isValid =>
      nameError() == null &&
      obaUrlError() == null &&
      optionalUrlError(sidecarUrl) == null &&
      optionalUrlError(otpUrl) == null &&
      optionalUrlError(otpGraphqlUrl) == null &&
      latitudeError() == null &&
      longitudeError() == null &&
      latSpanError() == null &&
      lonSpanError() == null;

  /// The region this draft describes. [id] keeps the id when editing.
  /// Throws [StateError] when [isValid] is false.
  Region toRegion({int? id}) {
    if (!isValid) throw StateError('The draft is not valid');
    Uri? opt(String raw) => raw.trim().isEmpty ? null : parseHttpUrl(raw);
    return Region.custom(
      id: id,
      name: name.trim(),
      obaBaseUrl: parseHttpUrl(obaUrl)!,
      center: Coordinate(
        double.parse(latitude.trim()),
        double.parse(longitude.trim()),
      ),
      latSpan: double.parse(latSpan.trim()),
      lonSpan: double.parse(lonSpan.trim()),
      contactEmail: contactEmail.trim(),
      otpBaseUrl: opt(otpUrl),
      otpBaseGraphqlUrl: opt(otpGraphqlUrl),
      sidecarBaseUrl: opt(sidecarUrl),
    );
  }
}

/// Result of probing an OBA server URL.
enum ServerCheck { valid, unreachable, notOneBusAway }

/// Checks that a URL is an OBA server: it must answer `current-time` (or
/// `config`) with a valid OBA envelope.
class ObaServerValidator {
  ObaServerValidator({required this.apiKey, http.Client? httpClient})
    : _http = httpClient;

  final String apiKey;
  final http.Client? _http;

  Future<ServerCheck> check(Uri baseUrl) async {
    final client = OneBusAwayClient(
      baseUrl: baseUrl,
      apiKey: apiKey,
      httpClient: _http,
      timeout: const Duration(seconds: 10),
    );
    try {
      try {
        await client.currentTime.get();
        return ServerCheck.valid;
      } on ObaNetworkException {
        return ServerCheck.unreachable;
      } on ObaException {
        // Fall through: some servers lack current-time; try config.
      }
      try {
        await client.config.get();
        return ServerCheck.valid;
      } on ObaNetworkException {
        return ServerCheck.unreachable;
      } on ObaException {
        return ServerCheck.notOneBusAway;
      }
    } finally {
      client.close();
    }
  }
}
