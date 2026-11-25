import 'dart:async';
import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:http/http.dart' as http;
import 'package:obakit_core/obakit_core.dart';

/// Address search over a Nominatim server (OpenStreetMap's geocoder).
///
/// The public server's usage policy
/// (https://operations.osmfoundation.org/policies/nominatim/) requires an
/// identifying User-Agent, at most one request per second, and no
/// autocomplete-style request per keystroke. This class:
///
/// - sends [userAgent] with every request (required, e.g.
///   `OneBusAway/1.0 (org.onebusaway.app)`);
/// - runs one request at a time and waits [minInterval] (1 s) between the
///   start of consecutive requests;
/// - drops a queued query when a newer one arrives (only the latest waiting
///   query runs; superseded callers get an empty list).
///
/// Callers must still debounce typing (the search screen does). Apps with
/// real traffic should point [endpoint] at their own Nominatim or a
/// commercial provider.
class NominatimPlaceSearch implements PlaceSearchProvider {
  NominatimPlaceSearch({
    required this.userAgent,
    Uri? endpoint,
    http.Client? httpClient,
    this.limit = 10,
    this.minInterval = const Duration(seconds: 1),
    this.acceptLanguage,
    this.email,
  }) : endpoint =
           endpoint ?? Uri.parse('https://nominatim.openstreetmap.org/search'),
       _ownsClient = httpClient == null,
       _client = httpClient ?? http.Client();

  /// The `/search` URL.
  final Uri endpoint;
  final String userAgent;
  final int limit;
  final Duration minInterval;

  /// Sent as `Accept-Language` (e.g. `en-US`), when set.
  final String? acceptLanguage;

  /// Sent as the `email` parameter, which the policy recommends for heavy
  /// users.
  final String? email;

  final http.Client _client;
  final bool _ownsClient;

  Future<void> _tail = Future.value();
  DateTime? _lastStart;
  int _generation = 0;

  /// Builds the request URL (exposed for tests).
  Uri buildUri(String query, {Coordinate? near, RegionRect? within}) {
    return endpoint.replace(
      queryParameters: {
        ...endpoint.queryParameters,
        'q': query,
        'format': 'jsonv2',
        'limit': '$limit',
        'addressdetails': '0',
        if (within != null) ...{
          'viewbox':
              '${within.minLon},${within.maxLat},${within.maxLon},${within.minLat}',
          'bounded': '1',
        } else if (near != null) ...{
          // A ~0.5 degree box around the point biases results without
          // excluding everything else.
          'viewbox':
              '${near.lon - 0.25},${near.lat + 0.25},${near.lon + 0.25},${near.lat - 0.25}',
        },
        'email': ?email,
      },
    );
  }

  /// Parses a `format=jsonv2` response body.
  static List<Place> parse(String body) {
    final decoded = jsonDecode(body);
    if (decoded is! List) return const [];
    final out = <Place>[];
    for (final item in decoded) {
      if (item is! Map) continue;
      final lat = double.tryParse('${item['lat']}');
      final lon = double.tryParse('${item['lon']}');
      final display = item['display_name'];
      if (lat == null || lon == null || display is! String) continue;
      final name = item['name'];
      final hasName = name is String && name.isNotEmpty;
      final title = hasName ? name : display.split(',').first.trim();
      String? subtitle = display;
      if (subtitle.startsWith(title)) {
        subtitle = subtitle
            .substring(title.length)
            .replaceFirst(RegExp(r'^,\s*'), '');
      }
      out.add(
        Place(
          name: title,
          subtitle: subtitle.isEmpty ? null : subtitle,
          coordinate: Coordinate(lat, lon),
          id: item['place_id']?.toString(),
        ),
      );
    }
    return out;
  }

  @override
  Future<List<Place>> search(
    String query, {
    Coordinate? near,
    RegionRect? within,
  }) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return Future.value(const []);
    final generation = ++_generation;
    final completer = Completer<List<Place>>();
    _tail = _tail.then((_) async {
      if (generation != _generation) {
        completer.complete(const []);
        return;
      }
      final last = _lastStart;
      if (last != null) {
        final wait = minInterval - clock.now().difference(last);
        if (wait > Duration.zero) await Future<void>.delayed(wait);
      }
      if (generation != _generation) {
        completer.complete(const []);
        return;
      }
      _lastStart = clock.now();
      try {
        final response = await _client.get(
          buildUri(trimmed, near: near, within: within),
          headers: {
            'User-Agent': userAgent,
            'Accept': 'application/json',
            'Accept-Language': ?acceptLanguage,
          },
        );
        if (response.statusCode != 200) {
          throw PlaceSearchException(
            'Nominatim returned HTTP ${response.statusCode}',
          );
        }
        completer.complete(parse(utf8.decode(response.bodyBytes)));
      } catch (e, st) {
        completer.completeError(
          e is PlaceSearchException ? e : PlaceSearchException('$e'),
          st,
        );
      }
    });
    return completer.future;
  }

  void close() {
    if (_ownsClient) _client.close();
  }
}

class PlaceSearchException implements Exception {
  const PlaceSearchException(this.message);
  final String message;

  @override
  String toString() => 'PlaceSearchException: $message';
}
