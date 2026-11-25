import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

import 'support/support.dart';

void main() {
  final t0 = DateTime.utc(2024, 1, 1, 12);
  DateTime at(int minutes, [int seconds = 0]) =>
      t0.add(Duration(minutes: minutes, seconds: seconds));

  group('per-row logic', () {
    test('departures use departure times; arrivals use arrival times', () {
      final a = ArrivalAndDeparture(
        routeId: 'r',
        tripId: 't',
        serviceDate: t0,
        stopId: 's',
        stopSequence: 0,
        scheduledArrivalTime: at(1),
        scheduledDepartureTime: at(5),
      );
      expect(a.arrivalDepartureStatus, ArrivalDepartureStatus.departing);
      expect(a.bestDate, at(5));
      final b = arrival(scheduled: at(3), predicted: at(4), isPredicted: true);
      expect(b.arrivalDepartureStatus, ArrivalDepartureStatus.arriving);
      expect(b.bestDate, at(4));
    });

    test('minutes floor; temporal state boundaries', () {
      final a = arrival(scheduled: at(5));
      expect(a.minutesUntil(at(0)), 5);
      expect(a.minutesUntil(at(0, 30)), 4);
      expect(a.minutesUntil(at(5, 1)), -1);
      expect(a.temporalState(at(4, 30)), TemporalState.present);
      expect(a.temporalState(at(5)), TemporalState.present);
      expect(a.temporalState(at(6)), TemporalState.past);
      expect(a.temporalState(at(0)), TemporalState.future);
      expect(arrival().minutesUntil(t0), isNull);
    });

    test('schedule status thresholds at 1.5 minutes', () {
      ScheduleStatus status(int secondsLate) => arrival(
        scheduled: at(10),
        predicted: at(10, secondsLate),
        isPredicted: true,
      ).scheduleStatus;
      expect(status(80), ScheduleStatus.onTime);
      expect(status(95), ScheduleStatus.delayed);
      expect(status(-95), ScheduleStatus.early);
      expect(arrival(scheduled: at(1)).scheduleStatus, ScheduleStatus.unknown);
      expect(
        arrival(
          scheduled: at(10),
          predicted: at(13),
          isPredicted: true,
        ).deviationFromScheduleInMinutes,
        3,
      );
    });

    test('visit id distinguishes sequence and status', () {
      expect(
        arrival(stopSequence: 1).visitId,
        isNot(arrival(stopSequence: 2).visitId),
      );
      expect(arrival().visitId, arrival().visitId);
    });

    test('routeAndHeadsign skips blanks', () {
      expect(arrival().routeAndHeadsign(), '10 - Downtown');
      expect(arrival(headsign: ' ').routeAndHeadsign(), '10');
      expect(
        arrival(routeShortName: null).routeAndHeadsign(),
        '1_10 - Downtown',
      );
    });
  });

  group('deduplication', () {
    test(
      'fixture with two vehicles on one trip collapses to the newest',
      () async {
        final r = await loadArrivals(
          'arrivals-and-departures-for-stop-1_10914-duplicates.json',
          '1_10914',
        );
        final raw = r.entry.arrivalsAndDepartures;
        expect(raw, hasLength(3));
        final clean = cleanArrivals(raw);
        expect(clean, hasLength(2));
        expect(clean.first.tripId, '1_40984902');
        expect(clean.first.vehicleId, '1_8109999');
        expect(clean.last.tripId, '1_40984903');
      },
    );

    test('implausible dates are dropped', () {
      final epoch = DateTime.utc(1970);
      expect(
        filterImplausibleDates([
          arrival(scheduled: epoch),
          arrival(scheduled: at(1)),
        ]),
        hasLength(1),
      );
    });

    test('terminal duplicates prefer real-time, then the departure', () {
      final arriving = arrival(stopSequence: 9, scheduled: at(1));
      final departing = arrival(stopSequence: 0, scheduled: at(5));
      expect(
        filterTerminalDuplicates([arriving, departing]).single.stopSequence,
        0,
      );
      final predictedArrival = arrival(
        stopSequence: 9,
        scheduled: at(1),
        isPredicted: true,
      );
      expect(
        filterTerminalDuplicates([predictedArrival, departing])
            .single
            .stopSequence,
        9,
      );
      expect(
        filterTerminalDuplicates([departing, arriving]).single.stopSequence,
        0,
      );
      expect(
        filterTerminalDuplicates([arrival(tripId: 'a'), arrival(tripId: 'b')]),
        hasLength(2),
      );
    });
  });

  group('filtering, grouping, sorting', () {
    final rt = arrival(tripId: 'rt', isPredicted: true, scheduled: at(3));
    final sched = arrival(
      tripId: 'sc',
      routeId: '1_20',
      routeShortName: '20',
      scheduled: at(1),
    );
    final later = arrival(
      tripId: 'l',
      routeId: '1_2',
      routeShortName: '2',
      scheduled: at(9),
    );

    test('by real-time availability', () {
      expect(
        filterByArrivalDepartureFilter([rt, sched], ArrivalDepartureFilter.all),
        hasLength(2),
      );
      expect(
        filterByArrivalDepartureFilter([
          rt,
          sched,
        ], ArrivalDepartureFilter.estimatedOnly).single.tripId,
        'rt',
      );
      expect(
        filterByArrivalDepartureFilter([
          rt,
          sched,
        ], ArrivalDepartureFilter.scheduledOnly).single.tripId,
        'sc',
      );
    });

    test('hidden routes', () {
      final prefs = const StopPreferences(hiddenRoutes: ['1_20']);
      expect(filterHiddenRoutes([rt, sched], prefs).single.tripId, 'rt');
    });

    test('sortByTime', () {
      expect(
        sortByTime([later, rt, arrival(tripId: 'none'), sched])
            .map((a) => a.tripId),
        ['sc', 'rt', 'l', 'none'],
      );
    });

    test('group by route, sorted by name or soonest', () {
      final refs = References(
        routes: {
          '1_10': const Route(id: '1_10', agencyId: '1', shortName: '10'),
        },
      );
      final byName = groupArrivalsByRoute(
        [rt, sched, later],
        references: refs,
        sort: StopSort.route,
      );
      expect(byName.map((g) => g.displayName), ['2', '10', '20']);
      expect(byName[1].route!.id, '1_10');
      final byTime = groupArrivalsByRoute([rt, sched, later], references: refs);
      expect(byTime.map((g) => g.routeId), ['1_20', '1_10', '1_2']);
      final hidden = groupArrivalsByRoute(
        [rt, sched],
        references: refs,
        preferences: const StopPreferences(hiddenRoutes: ['1_20']),
      );
      expect(hidden.single.routeId, '1_10');
      final shown = groupArrivalsByRoute(
        [rt, sched],
        references: refs,
        preferences: const StopPreferences(hiddenRoutes: ['1_20']),
        hideRoutes: false,
      );
      expect(shown, hasLength(2));
    });

    test('trip key matching', () {
      final key = TripBookmarkKey(
        stopId: '1_100',
        routeShortName: '10',
        routeId: '1_10',
        tripHeadsign: 'Downtown',
      );
      final second = arrival(tripId: 'rt2', scheduled: at(1));
      expect(
        arrivalsMatchingTripKey([rt, sched, second], key).map((a) => a.tripId),
        ['rt2', 'rt'],
      );
      final grouped = groupArrivalsByTripKey([rt, sched, second]);
      expect(grouped, hasLength(2));
      expect(grouped[key]!.first.tripId, 'rt2');
      expect(key.routeAndHeadsign, '10 - Downtown');
      final noName = arrival(routeShortName: null, headsign: null);
      final refs = References(
        routes: {
          '1_10': const Route(id: '1_10', agencyId: '1', shortName: '10'),
        },
      );
      expect(
        groupArrivalsByTripKey([noName], references: refs).keys.single,
        const TripBookmarkKey(
          stopId: '1_100',
          routeShortName: '10',
          routeId: '1_10',
          tripHeadsign: '',
        ),
      );
    });
  });

  test('naturalCompare', () {
    final names = ['10X', 'A Line', '2', '10', 'b', '1'];
    names.sort(naturalCompare);
    expect(names, ['1', '2', '10', '10X', 'A Line', 'b']);
  });

  group('walk time', () {
    const stop = Coordinate(47.6, -122.33);
    test('rounds up, suppressed near the stop or without data', () {
      // ~1112 m north.
      const user = Coordinate(47.61, -122.33);
      final w = WalkTime.compute(user: user, stop: stop, metersPerSecond: 1.4)!;
      expect(w.distanceMeters, closeTo(1112, 2));
      expect(w.minutes, 14); // 794 s
      expect(
        WalkTime.compute(user: stop, stop: stop, metersPerSecond: 1.4),
        isNull,
      );
      expect(
        WalkTime.compute(
          user: const Coordinate(47.6003, -122.33),
          stop: stop,
          metersPerSecond: 1.4,
        ),
        isNull,
      );
      expect(
        WalkTime.compute(user: null, stop: stop, metersPerSecond: 1.4),
        isNull,
      );
      expect(
        WalkTime.compute(user: user, stop: stop, metersPerSecond: 0),
        isNull,
      );
      expect(travelTimeSeconds(user, stop, metersPerSecond: -1), isNull);
    });

    test('partition and divider index', () {
      final rows = [
        arrival(tripId: 'past', scheduled: at(-3)),
        arrival(tripId: 'soon', scheduled: at(2)),
        arrival(tripId: 'edge', scheduled: at(5)),
        arrival(tripId: 'later', scheduled: at(12)),
      ];
      final p = partitionByWalkTime(rows.reversed, now: t0, walkMinutes: 5);
      expect(p.past.map((a) => a.tripId), ['past']);
      expect(p.missed.map((a) => a.tripId), ['soon']);
      expect(p.reachable.map((a) => a.tripId), ['edge', 'later']);
      expect(p.showsWalkDivider, isTrue);
      final none = partitionByWalkTime(rows, now: t0);
      expect(none.missed, isEmpty);
      expect(none.reachable, hasLength(3));

      expect(walkTimeDividerIndex(rows, now: t0, walkMinutes: 5), 2);
      expect(walkTimeDividerIndex(rows, now: t0, walkMinutes: 1), isNull);
      expect(walkTimeDividerIndex(rows, now: t0, walkMinutes: 60), 4);
      expect(walkTimeDividerIndex(rows, now: t0), isNull);
    });
  });
}
