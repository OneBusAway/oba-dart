import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

import '../../support/oba_test_harness.dart';

/// The server time of `arrivals_mts_24151.json`.
final DateTime fixtureNow = DateTime.fromMillisecondsSinceEpoch(1790228579290);

/// Runs [body] with the clock at the arrivals fixture's time, so its
/// departures are still ahead.
Future<T> atFixtureTime<T>(Future<T> Function() body) =>
    withClock(Clock.fixed(fixtureNow), body);

const kStopId = 'MTS_24151';
const kPugetSoundId = 1;

StoredStop kStop({String id = kStopId, String name = 'Pine St & 3rd Ave'}) =>
    StoredStop(
      id: id,
      name: name,
      lat: 47.61,
      lon: -122.34,
      code: id.split('_').last,
      direction: 'N',
    );

Bookmark stopBookmark(
  String name, {
  String stopId = kStopId,
  int regionId = kPugetSoundId,
}) => Bookmark.forStop(
  name: name,
  regionId: regionId,
  stop: kStop(id: stopId, name: 'Stop of $name'),
);

/// Route 30 to Old Town at the fixture stop.
Bookmark tripBookmark(String name) => Bookmark(
  id: 'trip-$name',
  name: name,
  regionId: kPugetSoundId,
  stop: kStop(),
  dateCreated: DateTime.utc(2026),
  routeShortName: '30',
  tripHeadsign: 'Old Town',
  routeId: 'MTS_30',
);

/// Records every navigation request.
class RecordingNavigator extends ObaNavigator {
  final pushed = <ObaRoute>[];
  int popToRoots = 0;
  int pops = 0;

  @override
  Future<T?> push<T extends Object?>(ObaRoute route) async {
    pushed.add(route);
    return null;
  }

  @override
  Future<T?> replace<T extends Object?>(ObaRoute route) async {
    pushed.add(route);
    return null;
  }

  @override
  void pop<T extends Object?>([T? result]) => pops++;

  @override
  void popToRoot() => popToRoots++;

  @override
  bool get canPop => true;
}

Widget withNavigator(RecordingNavigator nav, Widget child) =>
    ObaNavigatorScope(navigator: nav, child: child);

/// Tears the tree down so periodic timers are cancelled.
Future<void> unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
}

Future<ObaTestEnv> arrivalsEnv({Map<String, String> extra = const {}}) =>
    ObaTestEnv.create(
      responses: {
        'arrivals-and-departures-for-stop': fixture('arrivals_mts_24151.json'),
        ...extra,
      },
    );
