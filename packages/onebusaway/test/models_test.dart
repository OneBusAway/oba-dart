import 'dart:convert';
import 'dart:io';

import 'package:onebusaway/onebusaway.dart';
import 'package:onebusaway/src/core/json.dart';
import 'package:test/test.dart';

JsonMap loadFixture(String name) =>
    jsonDecode(File('test/fixtures/$name').readAsStringSync()) as JsonMap;

void main() {
  final data = loadFixture('arrivals_mts_24151.json')['data'] as JsonMap;
  final entry = StopWithArrivalsAndDepartures.fromJson(data['entry'] as JsonMap);
  final refs = References.fromJson(data['references'] as JsonMap);

  test('entry parses stop id and all arrivals in server order', () {
    expect(entry.stopId, 'MTS_24151');
    expect(entry.nearbyStopIds, ['MTS_24150']);
    expect(entry.arrivalsAndDepartures.map((a) => a.tripHeadsign),
        ['UTC', 'Old Town', 'Inside Loop', 'SIO']);
  });

  test('predicted arrival fields', () {
    final il = entry.arrivalsAndDepartures[2];
    expect(il.routeId, 'UCSD_1040');
    expect(il.routeShortName, 'IL');
    expect(il.predicted, isTrue);
    expect(il.predictedArrivalTime,
        DateTime.fromMillisecondsSinceEpoch(1790228820000, isUtc: true));
    expect(il.scheduledArrivalTime!.millisecondsSinceEpoch, 1790228700000);
    expect(il.stopSequence, 3);
    expect(il.totalStopsInTrip, 12);
    expect(il.blockTripSequence, 4);
    expect(il.vehicleId, 'UCSD_12');
    expect(il.distanceFromStop, 1210.5);
    expect(il.tripStatus!.scheduleDeviation, 120);
    expect(il.tripStatus!.phase, 'in_progress');
    expect(il.frequency, isNull);
  });

  test('scheduled-only arrival: 0 times and "" vehicle become null', () {
    final sio = entry.arrivalsAndDepartures[3];
    expect(sio.predicted, isFalse);
    expect(sio.predictedArrivalTime, isNull);
    expect(sio.vehicleId, isNull);
    expect(sio.tripStatus, isNull);
  });

  test('frequency parses headway in seconds', () {
    final f = Frequency.fromJson(
        {'startTime': 1790200000000, 'endTime': 1790240000000, 'headway': 600});
    expect(f.headway, 600);
    expect(f.startTime.millisecondsSinceEpoch, 1790200000000);
  });

  test('frequency without times is a format error', () {
    expect(() => Frequency.fromJson({'headway': 600}),
        throwsA(isA<ObaFormatException>()));
  });

  test('stop requires lat coordinate', () {
    expect(() => Stop.fromJson({'id': 'X', 'name': 'N', 'lon': 1.0}),
        throwsA(isA<ObaFormatException>()));
  });

  group('References', () {
    test('looks up stops, routes, agencies and trips by id', () {
      final stop = refs.stop('MTS_24151')!;
      expect(stop.code, '24151');
      expect(stop.direction, 'SW');
      expect(stop.name, 'Eighth College / Theatre District (North)');
      expect(stop.routeIds, ['MTS_30', 'NCTD_301', 'UCSD_1040', 'UCSD_1020']);
      expect(refs.route('UCSD_1040')!.color, 'ffcd00');
      expect(refs.route('UCSD_1040')!.textColor, isNull); // "" -> null
      expect(refs.route('NCTD_301')!.shortName, '101');
      expect(refs.route('MTS_201'), isNotNull);
      expect(refs.agency('MTS')!.timezone, 'America/Los_Angeles');
      expect(refs.trip('MTS_19630024')!.blockId, 'MTS_103004');
    });

    test('missing ids return null; null json is empty', () {
      expect(refs.route('nope'), isNull);
      expect(References.fromJson(null).routes, isEmpty);
      expect(References.empty.stop('MTS_24151'), isNull);
    });
  });
}
