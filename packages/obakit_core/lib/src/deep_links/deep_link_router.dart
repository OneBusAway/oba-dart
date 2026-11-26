import 'package:onebusaway/onebusaway.dart';

import 'trip_deep_link.dart';

/// A parsed incoming link.
sealed class DeepLink {
  const DeepLink();
}

/// Open a stop. [regionId] is null for `scheme://stop?id=…` links, meaning
/// "in the current region".
final class ViewStopDeepLink extends DeepLink {
  const ViewStopDeepLink({required this.stopId, this.regionId});

  final String stopId;
  final int? regionId;

  @override
  bool operator ==(Object other) =>
      other is ViewStopDeepLink &&
      other.stopId == stopId &&
      other.regionId == regionId;

  @override
  int get hashCode => Object.hash(stopId, regionId);

  @override
  String toString() => 'ViewStopDeepLink($stopId, region: $regionId)';
}

/// Add a custom region (`scheme://add-region?name=…&oba-url=…`). [data] is
/// null when the link lacks a name or a valid `oba-url`: the UI should show
/// the add-region form empty.
final class AddRegionDeepLink extends DeepLink {
  const AddRegionDeepLink(this.data);

  final AddRegionData? data;
}

/// Open one arrival of a trip (a shared trip link).
final class TripArrivalDeepLink extends DeepLink {
  const TripArrivalDeepLink(this.link);

  final TripDeepLink link;

  @override
  bool operator ==(Object other) =>
      other is TripArrivalDeepLink && other.link == link;

  @override
  int get hashCode => link.hashCode;
}

/// The fields of an add-region link (iOS `AddRegionURLData`).
class AddRegionData {
  const AddRegionData({
    required this.name,
    required this.obaUrl,
    this.regionId,
    this.otpUrl,
    this.otpGraphqlUrl,
    this.supportsOtpGraphqlBikeshare = false,
    this.sidecarUrl,
    this.umamiUrl,
    this.umamiId,
  });

  final String name;
  final Uri obaUrl;
  final int? regionId;
  final Uri? otpUrl;
  final Uri? otpGraphqlUrl;
  final bool supportsOtpGraphqlBikeshare;
  final Uri? sidecarUrl;
  final Uri? umamiUrl;
  final String? umamiId;

  /// Both-or-nothing Umami config.
  UmamiAnalytics? get umamiAnalytics => umamiUrl != null && umamiId != null
      ? UmamiAnalytics(url: umamiUrl.toString(), id: umamiId!)
      : null;

  /// A custom region built from this link. [center] and spans default to a
  /// zero box at 0,0 when not known (the UI can refine them, e.g. from
  /// agencies-with-coverage).
  Region toRegion({
    Coordinate center = const Coordinate(0, 0),
    double latSpan = 0,
    double lonSpan = 0,
  }) => Region.custom(
    name: name,
    obaBaseUrl: obaUrl,
    center: center,
    latSpan: latSpan,
    lonSpan: lonSpan,
    id: regionId,
    otpBaseUrl: otpUrl,
    otpBaseGraphqlUrl: otpGraphqlUrl,
    supportsOtpGraphqlBikeshare: supportsOtpGraphqlBikeshare,
    sidecarBaseUrl: sidecarUrl,
    umamiAnalytics: umamiAnalytics,
  );
}

/// Parses incoming links and builds share links. Combines iOS
/// `URLSchemeRouter` (custom scheme: `view-stop`, `stop`, `add-region`) and
/// `AppLinksRouter` (sidecar universal links:
/// `/regions/{id}/stops/{stop}` and `/regions/{id}/stops/{stop}/trips`).
class DeepLinkRouter {
  const DeepLinkRouter({required this.scheme});

  /// The app's custom URL scheme, e.g. `onebusaway`.
  final String scheme;

  static final _tripPath = RegExp(
    r'^/regions/([^/]+)/stops/(.+)/trips/?$',
    caseSensitive: false,
  );
  static final _stopPath = RegExp(
    r'^/regions/([^/]+)/stops/([^/]+)/?$',
    caseSensitive: false,
  );

  /// Parses [uri], or returns null when it is not a link this app handles
  /// (including one whose percent-encoding is not valid UTF-8).
  DeepLink? parse(Uri uri) {
    try {
      if (uri.scheme.toLowerCase() == scheme.toLowerCase()) {
        return _parseScheme(uri);
      }
      if (uri.scheme == 'http' || uri.scheme == 'https') {
        return parseTripLink(uri) ?? _parseStopPath(uri);
      }
    } on FormatException {
      // `Uri.queryParameters` and `Uri.decodeComponent` throw on malformed
      // escapes such as `%FF`. Links come from outside the app.
    } on ArgumentError {
      // Same, for an illegal percent-encoding.
    }
    return null;
  }

  DeepLink? _parseScheme(Uri uri) {
    // Dart lower-cases URI hosts, so `viewStop` arrives as `viewstop`.
    switch (uri.host.toLowerCase()) {
      case 'view-stop' || 'stop' || 'viewstop':
        final q = uri.queryParameters;
        final stopId = q['stopID'] ?? q['stop_id'] ?? q['id'];
        if (stopId == null) return null;
        final regionRaw = q['regionID'] ?? q['region_id'] ?? q['region'];
        if (regionRaw == null) {
          return uri.host.toLowerCase() == 'stop'
              ? ViewStopDeepLink(stopId: stopId)
              : null;
        }
        final regionId = int.tryParse(regionRaw);
        return regionId == null
            ? null
            : ViewStopDeepLink(stopId: stopId, regionId: regionId);
      case 'add-region':
        return AddRegionDeepLink(_parseAddRegion(uri.queryParameters));
      default:
        return null;
    }
  }

  AddRegionData? _parseAddRegion(Map<String, String> q) {
    final name = q['name'];
    final oba = _validUrl(q['oba-url']);
    if (name == null || oba == null) return null;
    final umamiId = q['umami-id']?.trim();
    final bikeshare = q['otp-graphql-bikeshare']?.trim().toLowerCase();
    return AddRegionData(
      name: name,
      obaUrl: oba,
      regionId: int.tryParse(q['region-id']?.trim() ?? ''),
      otpUrl: _validUrl(q['otp-url']),
      otpGraphqlUrl: _validUrl(q['otp-graphql-url']),
      supportsOtpGraphqlBikeshare: bikeshare == 'true' || bikeshare == '1',
      sidecarUrl: _validUrl(q['sidecar-url']),
      umamiUrl: _validUrl(q['umami-url']),
      umamiId: umamiId == null || umamiId.isEmpty ? null : umamiId,
    );
  }

  /// A URL with a scheme, or a `/`-rooted path; null for blank or invalid.
  static Uri? _validUrl(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    final uri = Uri.tryParse(raw);
    if (uri == null) return null;
    return uri.hasScheme || raw.startsWith('/') ? uri : null;
  }

  ViewStopDeepLink? _parseStopPath(Uri uri) {
    final m = _stopPath.firstMatch(uri.path);
    if (m == null) return null;
    final regionId = int.tryParse(m[1]!);
    final stopId = Uri.decodeComponent(m[2]!);
    if (regionId == null || stopId.isEmpty) return null;
    return ViewStopDeepLink(stopId: stopId, regionId: regionId);
  }

  /// Parses a sidecar trip link (`/regions/{r}/stops/{s}/trips?trip_id=…
  /// &service_date=…&stop_sequence=…`). `service_date` is seconds since the
  /// epoch (fractional allowed), as iOS writes it.
  TripArrivalDeepLink? parseTripLink(Uri uri) {
    final m = _tripPath.firstMatch(uri.path);
    if (m == null) return null;
    final q = uri.queryParameters;
    final regionId = int.tryParse(m[1]!);
    final tripId = q['trip_id'];
    final serviceSeconds = double.tryParse(q['service_date'] ?? '');
    final stopSequence = int.tryParse(q['stop_sequence'] ?? '');
    if (regionId == null ||
        tripId == null ||
        serviceSeconds == null ||
        stopSequence == null) {
      return null;
    }
    return TripArrivalDeepLink(
      TripDeepLink(
        title: q['title'] ?? '',
        regionId: regionId,
        stopId: Uri.decodeComponent(m[2]!),
        tripId: tripId,
        serviceDate: DateTime.fromMillisecondsSinceEpoch(
          (serviceSeconds * 1000).round(),
          isUtc: true,
        ),
        stopSequence: stopSequence,
        vehicleId: q['vehicle_id'],
        destinationStopId: q['destination_stop_id'],
      ),
    );
  }

  // -- Building links ----------------------------------------------------------------

  /// `scheme://view-stop?stopID=…&regionID=…`.
  Uri viewStopUrl({required String stopId, required int regionId}) => Uri(
    scheme: scheme,
    host: 'view-stop',
    queryParameters: {'stopID': stopId, 'regionID': '$regionId'},
  );

  /// The sidecar web page for a stop, or null when the region has no
  /// sidecar.
  static Uri? stopShareUrl({required Region region, required String stopId}) {
    final base = region.sidecarBaseUrl;
    if (base == null) return null;
    return Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.hasPort ? base.port : null,
      path: '/regions/${region.id}/stops/${Uri.encodeComponent(stopId)}',
    );
  }

  /// The sidecar link for one arrival of a trip, or null without a sidecar.
  static Uri? tripShareUrl({
    required Region region,
    required ArrivalAndDeparture arrival,
    String? destinationStopId,
  }) {
    final base = region.sidecarBaseUrl;
    if (base == null) return null;
    final seconds = arrival.serviceDate.millisecondsSinceEpoch / 1000;
    return Uri(
      scheme: base.scheme,
      host: base.host,
      port: base.hasPort ? base.port : null,
      path:
          '/regions/${region.id}/stops/${Uri.encodeComponent(arrival.stopId)}/trips',
      queryParameters: {
        'trip_id': arrival.tripId,
        'service_date': '$seconds',
        'stop_sequence': '${arrival.stopSequence}',
        'destination_stop_id': ?destinationStopId,
      },
    );
  }
}
