import 'dart:convert';
import 'dart:math' as math;

import '../core/errors.dart';
import '../core/json.dart';
import '../models/coordinate.dart';

/// Parses a URL leniently, as the Swift app does for server-supplied garbage:
/// null, blank, unparseable, or scheme-less (and not `/`-rooted) values
/// become null.
Uri? _tolerantUri(JsonMap json, String key) {
  final raw = json[key];
  if (raw is! String || raw.trim().isEmpty) return null;
  final uri = Uri.tryParse(raw);
  if (uri == null) return null;
  if (uri.hasScheme || raw.startsWith('/')) return uri;
  return null;
}

String? _optStr(JsonMap json, String key) {
  final v = json[key];
  return v is String ? v : null;
}

/// One bounding box of a region's service area: a centre and spans (degrees).
class RegionBound {
  const RegionBound({
    required this.lat,
    required this.lon,
    required this.latSpan,
    required this.lonSpan,
  });

  factory RegionBound.fromJson(JsonMap json) => RegionBound(
    lat: readOptDouble(json, 'lat') ?? 0,
    lon: readOptDouble(json, 'lon') ?? 0,
    latSpan: readOptDouble(json, 'latSpan') ?? 0,
    lonSpan: readOptDouble(json, 'lonSpan') ?? 0,
  );

  final double lat;
  final double lon;
  final double latSpan;
  final double lonSpan;

  JsonMap toJson() => {
    'lat': lat,
    'lon': lon,
    'latSpan': latSpan,
    'lonSpan': lonSpan,
  };
}

/// A lat/lon rectangle (the union of a region's bounds).
class RegionRect {
  const RegionRect({
    required this.minLat,
    required this.maxLat,
    required this.minLon,
    required this.maxLon,
  });

  final double minLat;
  final double maxLat;
  final double minLon;
  final double maxLon;

  Coordinate get center =>
      Coordinate((minLat + maxLat) / 2, (minLon + maxLon) / 2);

  bool contains(double lat, double lon) =>
      lat >= minLat && lat <= maxLat && lon >= minLon && lon <= maxLon;
}

class UmamiAnalytics {
  const UmamiAnalytics({required this.url, required this.id});

  factory UmamiAnalytics.fromJson(JsonMap json) =>
      UmamiAnalytics(url: readString(json, 'url'), id: readString(json, 'id'));

  final String url;
  final String id;

  JsonMap toJson() => {'url': url, 'id': id};
}

class Open311Server {
  const Open311Server({
    this.jurisdictionId,
    required this.apiKey,
    required this.baseUrl,
  });

  factory Open311Server.fromJson(JsonMap json) => Open311Server(
    // The live feed has misspelled this key as "juridisctionId".
    jurisdictionId:
        readOptString(json, 'jurisdictionId') ??
        readOptString(json, 'juridisctionId'),
    apiKey: readString(json, 'apiKey'),
    baseUrl: readString(json, 'baseUrl'),
  );

  final String? jurisdictionId;
  final String apiKey;
  final String baseUrl;

  JsonMap toJson() => {
    if (jurisdictionId != null) 'jurisdictionId': jurisdictionId,
    'apiKey': apiKey,
    'baseUrl': baseUrl,
  };
}

/// A OneBusAway server deployment (Puget Sound, Tampa, ...).
class Region {
  const Region({
    required this.id,
    required this.regionName,
    required this.obaBaseUrl,
    this.active = true,
    this.experimental = false,
    this.custom = false,
    this.sidecarBaseUrl,
    this.umamiAnalytics,
    this.siriBaseUrl,
    this.otpBaseUrl,
    this.otpBaseGraphqlUrl,
    this.stopInfoUrl,
    this.bounds = const [],
    this.open311Servers = const [],
    this.supportsEmbeddedSocial = false,
    this.supportsObaRealtimeApis = true,
    this.supportsObaDiscoveryApis = true,
    this.supportsOtpBikeshare = false,
    this.supportsOtpGraphqlBikeshare = false,
    this.supportsSiriRealtimeApis = false,
    this.contactEmail = '',
    this.twitterUrl,
    this.facebookUrl,
    this.otpContactEmail,
    this.language,
    this.obaVersionInfo = '',
    this.paymentWarningBody,
    this.paymentWarningTitle,
    this.paymentAndroidAppId,
    this.paymentIosAppStoreIdentifier,
    this.paymentIosAppUrlScheme,
  });

  /// Builds a user-defined region (for testing against a private server).
  /// Mirrors the Swift custom-region initializer. When [id] is omitted a
  /// random id in 1000...1999 is used.
  factory Region.custom({
    required String name,
    required Uri obaBaseUrl,
    required Coordinate center,
    required double latSpan,
    required double lonSpan,
    String contactEmail = '',
    int? id,
    Uri? otpBaseUrl,
    Uri? otpBaseGraphqlUrl,
    bool supportsOtpGraphqlBikeshare = false,
    Uri? sidecarBaseUrl,
    UmamiAnalytics? umamiAnalytics,
  }) => Region(
    id: id ?? 1000 + math.Random().nextInt(1000),
    regionName: name,
    obaBaseUrl: obaBaseUrl,
    custom: true,
    sidecarBaseUrl: sidecarBaseUrl,
    umamiAnalytics: umamiAnalytics,
    otpBaseUrl: otpBaseUrl,
    otpBaseGraphqlUrl: otpBaseGraphqlUrl,
    supportsOtpGraphqlBikeshare: supportsOtpGraphqlBikeshare,
    bounds: [
      RegionBound(
        lat: center.lat,
        lon: center.lon,
        latSpan: latSpan,
        lonSpan: lonSpan,
      ),
    ],
    contactEmail: contactEmail,
    language: 'en_US',
    obaVersionInfo: 'x.y.z.custom',
  );

  factory Region.fromJson(JsonMap json) {
    final base = _tolerantUri(json, 'obaBaseUrl');
    if (base == null) {
      throw const ObaFormatException('Region has no valid "obaBaseUrl"');
    }
    final umami = json['umamiAnalytics'];
    UmamiAnalytics? umamiConfig;
    if (umami is Map<String, Object?>) {
      try {
        umamiConfig = UmamiAnalytics.fromJson(umami);
        if (umamiConfig.id.trim().isEmpty) umamiConfig = null;
      } on ObaFormatException {
        umamiConfig = null;
      }
    }
    return Region(
      id: readInt(json, 'id'),
      regionName: readString(json, 'regionName'),
      active: readBool(json, 'active'),
      experimental: readBool(json, 'experimental'),
      custom: readBool(json, 'custom'),
      obaBaseUrl: base,
      sidecarBaseUrl: _tolerantUri(json, 'sidecarBaseUrl'),
      umamiAnalytics: umamiConfig,
      siriBaseUrl: _tolerantUri(json, 'siriBaseUrl'),
      otpBaseUrl: _tolerantUri(json, 'otpBaseUrl'),
      otpBaseGraphqlUrl: _tolerantUri(json, 'otpBaseGraphqlUrl'),
      stopInfoUrl: _tolerantUri(json, 'stopInfoUrl'),
      bounds: readList(
        json,
        'bounds',
        (item) => RegionBound.fromJson(asJsonMap(item, 'bounds[]')),
      ),
      open311Servers: readList(
        json,
        'open311Servers',
        (item) => Open311Server.fromJson(asJsonMap(item, 'open311Servers[]')),
      ),
      supportsEmbeddedSocial: readBool(json, 'supportsEmbeddedSocial'),
      supportsObaRealtimeApis: readBool(json, 'supportsObaRealtimeApis'),
      supportsObaDiscoveryApis: readBool(json, 'supportsObaDiscoveryApis'),
      supportsOtpBikeshare: readBool(json, 'supportsOtpBikeshare'),
      supportsOtpGraphqlBikeshare: readBool(
        json,
        'supportsOtpGraphqlBikeshare',
      ),
      supportsSiriRealtimeApis: readBool(json, 'supportsSiriRealtimeApis'),
      contactEmail: _optStr(json, 'contactEmail') ?? '',
      twitterUrl: _tolerantUri(json, 'twitterUrl'),
      facebookUrl: _tolerantUri(json, 'facebookUrl'),
      otpContactEmail: _optStr(json, 'otpContactEmail'),
      language: _optStr(json, 'language'),
      obaVersionInfo: _optStr(json, 'obaVersionInfo') ?? '',
      paymentWarningBody: _optStr(json, 'paymentWarningBody'),
      paymentWarningTitle: _optStr(json, 'paymentWarningTitle'),
      paymentAndroidAppId: _optStr(json, 'paymentAndroidAppId'),
      paymentIosAppStoreIdentifier: _optStr(
        json,
        'paymentiOSAppStoreIdentifier',
      ),
      paymentIosAppUrlScheme: _optStr(json, 'paymentiOSAppUrlScheme'),
    );
  }

  /// Parses a regions file (standard OBA envelope with `data.list`), such as
  /// a bundled `regions-v3.json`. Throws [ObaException] subtypes.
  static List<Region> listFromJson(String body) {
    if (body.trim().isEmpty) {
      throw const ObaApiException(ObaApiErrorKind.emptyResponse);
    }
    final Object? decoded;
    try {
      decoded = jsonDecode(body);
    } on FormatException catch (e) {
      throw ObaFormatException('Response is not valid JSON: ${e.message}');
    }
    return listFromEnvelope(asJsonMap(decoded, 'response'));
  }

  /// Parses an already-decoded regions envelope.
  static List<Region> listFromEnvelope(JsonMap envelope) {
    final code = readInt(envelope, 'code');
    if (code != 200) {
      throw ObaApiException(
        ObaApiErrorKind.envelope,
        code: code,
        text: readOptString(envelope, 'text'),
      );
    }
    final data = readMap(envelope, 'data');
    return List.unmodifiable(
      readList(
        data,
        'list',
        (item) => Region.fromJson(asJsonMap(item, 'list[]')),
      ),
    );
  }

  final int id;
  final String regionName;
  final bool active;
  final bool experimental;
  final bool custom;
  final Uri obaBaseUrl;
  final Uri? sidecarBaseUrl;
  final UmamiAnalytics? umamiAnalytics;
  final Uri? siriBaseUrl;
  final Uri? otpBaseUrl;
  final Uri? otpBaseGraphqlUrl;
  final Uri? stopInfoUrl;
  final List<RegionBound> bounds;
  final List<Open311Server> open311Servers;
  final bool supportsEmbeddedSocial;
  final bool supportsObaRealtimeApis;
  final bool supportsObaDiscoveryApis;
  final bool supportsOtpBikeshare;
  final bool supportsOtpGraphqlBikeshare;
  final bool supportsSiriRealtimeApis;
  final String contactEmail;
  final Uri? twitterUrl;
  final Uri? facebookUrl;
  final String? otpContactEmail;
  final String? language;
  final String obaVersionInfo;
  final String? paymentWarningBody;
  final String? paymentWarningTitle;
  final String? paymentAndroidAppId;
  final String? paymentIosAppStoreIdentifier;
  final String? paymentIosAppUrlScheme;

  /// Serializes with the same keys [Region.fromJson] reads.
  JsonMap toJson() => {
    'id': id,
    'regionName': regionName,
    'active': active,
    'experimental': experimental,
    'custom': custom,
    'obaBaseUrl': obaBaseUrl.toString(),
    'sidecarBaseUrl': sidecarBaseUrl?.toString(),
    if (umamiAnalytics != null) 'umamiAnalytics': umamiAnalytics!.toJson(),
    if (siriBaseUrl != null) 'siriBaseUrl': siriBaseUrl.toString(),
    if (otpBaseUrl != null) 'otpBaseUrl': otpBaseUrl.toString(),
    if (otpBaseGraphqlUrl != null)
      'otpBaseGraphqlUrl': otpBaseGraphqlUrl.toString(),
    if (stopInfoUrl != null) 'stopInfoUrl': stopInfoUrl.toString(),
    'bounds': [for (final b in bounds) b.toJson()],
    'open311Servers': [for (final s in open311Servers) s.toJson()],
    'supportsEmbeddedSocial': supportsEmbeddedSocial,
    'supportsObaRealtimeApis': supportsObaRealtimeApis,
    'supportsObaDiscoveryApis': supportsObaDiscoveryApis,
    'supportsOtpBikeshare': supportsOtpBikeshare,
    'supportsOtpGraphqlBikeshare': supportsOtpGraphqlBikeshare,
    'supportsSiriRealtimeApis': supportsSiriRealtimeApis,
    'contactEmail': contactEmail,
    if (twitterUrl != null) 'twitterUrl': twitterUrl.toString(),
    if (facebookUrl != null) 'facebookUrl': facebookUrl.toString(),
    if (otpContactEmail != null) 'otpContactEmail': otpContactEmail,
    'language': language,
    'obaVersionInfo': obaVersionInfo,
    if (paymentWarningBody != null) 'paymentWarningBody': paymentWarningBody,
    if (paymentWarningTitle != null) 'paymentWarningTitle': paymentWarningTitle,
    if (paymentAndroidAppId != null) 'paymentAndroidAppId': paymentAndroidAppId,
    if (paymentIosAppStoreIdentifier != null)
      'paymentiOSAppStoreIdentifier': paymentIosAppStoreIdentifier,
    if (paymentIosAppUrlScheme != null)
      'paymentiOSAppUrlScheme': paymentIosAppUrlScheme,
  };

  bool get supportsOtp => otpBaseGraphqlUrl != null || otpBaseUrl != null;

  bool get isBikeshareEnabled =>
      supportsOtpGraphqlBikeshare && otpBaseGraphqlUrl != null;

  /// OBA 2.0.x has no schedule-for-route endpoint. [obaVersionInfo] looks
  /// like `2.4.15-cs|2|4|15|cs|<hash>`; if it can't be parsed, assume support.
  bool get supportsScheduleForRoute {
    final parts = obaVersionInfo.split('|').where((s) => s.isNotEmpty).toList();
    if (parts.length < 3) return true;
    final major = int.tryParse(parts[1]);
    final minor = int.tryParse(parts[2]);
    if (major == null || minor == null) return true;
    return !(major == 2 && minor == 0);
  }

  bool get supportsMobileFarePayment => paymentIosAppUrlScheme != null;

  bool get paymentAppDoesNotCoverFullRegion =>
      paymentWarningTitle != null && paymentWarningBody != null;

  /// Union of all [bounds] boxes (each is centre +/- span/2). A region with
  /// no bounds yields a zero rect at 0,0.
  RegionRect get serviceRect {
    if (bounds.isEmpty) {
      return const RegionRect(minLat: 0, maxLat: 0, minLon: 0, maxLon: 0);
    }
    var minLat = double.infinity;
    var maxLat = double.negativeInfinity;
    var minLon = double.infinity;
    var maxLon = double.negativeInfinity;
    for (final b in bounds) {
      minLat = math.min(minLat, b.lat - b.latSpan / 2);
      maxLat = math.max(maxLat, b.lat + b.latSpan / 2);
      minLon = math.min(minLon, b.lon - b.lonSpan / 2);
      maxLon = math.max(maxLon, b.lon + b.lonSpan / 2);
    }
    return RegionRect(
      minLat: minLat,
      maxLat: maxLat,
      minLon: minLon,
      maxLon: maxLon,
    );
  }

  Coordinate get centerCoordinate => serviceRect.center;

  /// Whether the point lies inside [serviceRect]. False when there are no
  /// bounds.
  bool contains(double lat, double lon) =>
      bounds.isNotEmpty && serviceRect.contains(lat, lon);

  /// Great-circle (haversine) distance in metres to the centre of
  /// [serviceRect].
  double distanceFrom(double lat, double lon) {
    const earthRadius = 6371008.8;
    final c = centerCoordinate;
    double rad(double d) => d * math.pi / 180;
    final dLat = rad(c.lat - lat);
    final dLon = rad(c.lon - lon);
    final a =
        math.pow(math.sin(dLat / 2), 2) +
        math.cos(rad(lat)) *
            math.cos(rad(c.lat)) *
            math.pow(math.sin(dLon / 2), 2);
    return 2 * earthRadius * math.asin(math.sqrt(a));
  }

  @override
  bool operator ==(Object other) =>
      other is Region && jsonEncode(toJson()) == jsonEncode(other.toJson());

  @override
  int get hashCode => jsonEncode(toJson()).hashCode;

  @override
  String toString() => 'Region($id, $regionName)';
}
