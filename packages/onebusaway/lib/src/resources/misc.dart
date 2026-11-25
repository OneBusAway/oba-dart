import '../core/responses.dart';
import '../core/transport.dart';
import '../models/agency_with_coverage.dart';
import '../models/current_time.dart';
import '../models/server_identity.dart';
import '../models/shape.dart';

/// `current-time`.
class CurrentTimeResource {
  CurrentTimeResource(this._transport);

  final Transport _transport;

  /// The server's clock.
  Future<ObaEntryResponse<CurrentTime>> get() async =>
      (await _transport.get('current-time')).toEntry(CurrentTime.fromJson);
}

/// `agencies-with-coverage`.
class AgenciesResource {
  AgenciesResource(this._transport);

  final Transport _transport;

  /// Every agency the server covers, with its coverage area. Agency details
  /// are in `references.agencies`.
  Future<ObaListResponse<AgencyWithCoverage>> withCoverage() async =>
      (await _transport.get('agencies-with-coverage'))
          .toList(AgencyWithCoverage.fromJson);
}

/// `shape/{id}`.
class ShapesResource {
  ShapesResource(this._transport);

  final Transport _transport;

  /// The encoded polyline for a trip's `shapeId`.
  Future<ObaEntryResponse<Shape>> byId(String shapeId) async =>
      (await _transport.get('shape', id: shapeId)).toEntry(Shape.fromJson);
}

/// `config`.
class ConfigResource {
  ConfigResource(this._transport);

  final Transport _transport;

  /// The server's identity. Servers without this endpoint (older Java, or
  /// maglev before 2026-02-22) answer an HTML 404 or HTML 200, which surface
  /// as `ObaApiException(httpStatus)` or `ObaFormatException`.
  Future<ObaEntryResponse<ServerIdentity>> get() async =>
      (await _transport.get('config')).toEntry(ServerIdentity.fromJson);
}
