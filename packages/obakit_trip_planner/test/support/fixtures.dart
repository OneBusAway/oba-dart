import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/painting.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart';

/// Fixture paths are relative to the package directory, where tests run.
String fixtureString(String path) =>
    File('test/fixtures/$path').readAsStringSync();

Map<String, dynamic> fixtureJson(String path) =>
    jsonDecode(fixtureString(path)) as Map<String, dynamic>;

/// Real capture from SDMTS OTP 1.x (UCSD → downtown San Diego).
const sdRestFixture = 'rest/sdmts_ucsd_to_downtown.json';

/// Real capture from Sound Transit OTP 2.x GraphQL (Westlake → U District).
const stGraphQLFixture = 'graphql/soundtransit_westlake_to_udistrict.json';

TripPlan sdPlan() => parseRestPlanResponse(fixtureJson(sdRestFixture));
TripPlan stPlan() => parseGraphQLPlanResponse(fixtureJson(stGraphQLFixture));

const ucsd = TripPlace(name: 'Geisel Library', lat: 32.8801, lon: -117.2340);
const downtown = TripPlace(
  name: 'Horton Plaza',
  subtitle: 'Downtown San Diego',
  lat: 32.7157,
  lon: -117.1611,
);
const here = TripPlace(
  name: 'Here',
  lat: 32.8700,
  lon: -117.2200,
  isCurrentLocation: true,
);

/// In-memory [TripPlaceSearch] that matches on name substrings.
class FakeTripPlaceSearch implements TripPlaceSearch {
  FakeTripPlaceSearch([this.places = const [ucsd, downtown]]);

  final List<TripPlace> places;
  final queries = <String>[];
  final nears = <TripPlace?>[];
  Object? error;

  @override
  Future<List<TripPlace>> search(String query, {TripPlace? near}) async {
    queries.add(query);
    nears.add(near);
    if (error case final e?) throw e;
    final q = query.toLowerCase();
    return [
      for (final place in places)
        if (place.name.toLowerCase().contains(q)) place,
    ];
  }
}

/// A [TripPlanService] whose answers the test controls. Each `plan` call
/// waits on a fresh completer, completed through [complete] / [fail], unless
/// [result] / [error] is set for immediate answers.
class FakeTripPlanService implements TripPlanService {
  FakeTripPlanService({this.result, this.supportsVehicleRental = false});

  TripPlan? result;
  Object? error;
  final requests = <TripPlanRequest>[];
  final _pending = <Completer<TripPlan>>[];

  @override
  final bool supportsVehicleRental;

  @override
  Future<TripPlan> plan(TripPlanRequest request) {
    requests.add(request);
    if (error case final e?) return Future.error(e);
    if (result case final r?) return Future.value(r);
    final completer = Completer<TripPlan>();
    _pending.add(completer);
    return completer.future;
  }

  int get pendingCount => _pending.length;

  void complete(TripPlan plan, {int index = 0}) =>
      _pending[index].complete(plan);

  void fail(Object error, {int index = 0}) =>
      _pending[index].completeError(error);
}

/// Serves a transparent 1×1 PNG for every tile so map widgets render in
/// tests without network access.
class TransparentTileProvider extends TileProvider {
  TransparentTileProvider();

  static final _png = Uint8List.fromList(
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNk'
      'YPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
    ),
  );

  @override
  ImageProvider getImage(TileCoordinates coordinates, TileLayer options) =>
      MemoryImage(_png);
}

TripMapConfig testMapConfig() => TripMapConfig(
  userAgentPackageName: 'org.onebusaway.test',
  tileProvider: TransparentTileProvider(),
);
