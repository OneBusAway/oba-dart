import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';
import 'package:onebusaway/onebusaway.dart' show Route;

void main() {
  const strings = ObaArrivalsStrings();
  const refs = References(
    routes: {
      'MTS_30': Route(id: 'MTS_30', agencyId: 'MTS', shortName: '30'),
      'NCTD_301': Route(id: 'NCTD_301', agencyId: 'NCTD', shortName: '101'),
      'UCSD_1040': Route(id: 'UCSD_1040', agencyId: 'UCSD', shortName: 'IL'),
      'UCSD_1020': Route(id: 'UCSD_1020', agencyId: 'UCSD', shortName: 'S'),
      'MTS_201': Route(id: 'MTS_201', agencyId: 'MTS', shortName: '201'),
      'UCSD_9': Route(id: 'UCSD_9', agencyId: 'UCSD'),
    },
  );

  const stop = Stop(
    id: 'MTS_24151',
    code: '24151',
    name: 'Eighth College / Theatre District (North)',
    lat: 0,
    lon: 0,
    direction: 'SW',
    routeIds: ['MTS_30', 'NCTD_301', 'UCSD_1040', 'UCSD_1020'],
  );

  test('subtitle matches Wayfinder: only routes serving the stop, sorted', () {
    expect(
      stopSubtitle(stop, refs, strings),
      'Stop #24151 · Southwest bound · 101, 30, IL, S',
    );
  });

  test('falls back to id without agency prefix; omits empty direction', () {
    const s = Stop(
      id: 'MTS_99',
      name: 'X',
      lat: 0,
      lon: 0,
      routeIds: ['UCSD_9'],
    );
    expect(stopSubtitle(s, refs, strings), 'Stop #99 · 9');
  });

  test('unknown direction code is shown as-is', () {
    const s = Stop(
      id: 'A_1',
      code: '1',
      name: 'X',
      lat: 0,
      lon: 0,
      direction: 'NNW',
    );
    expect(stopSubtitle(s, refs, strings), 'Stop #1 · NNW bound');
  });

  test('stripAgencyPrefix keeps everything after the first underscore', () {
    expect(stripAgencyPrefix('MTS_24151'), '24151');
    expect(stripAgencyPrefix('A_B_C'), 'B_C');
    expect(stripAgencyPrefix('plain'), 'plain');
  });
}
