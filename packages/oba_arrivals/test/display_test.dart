import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';

DateTime t(int hour, int minute, [int second = 0]) =>
    DateTime.utc(2026, 9, 24, hour, minute, second);

ArrivalAndDeparture arrival({
  DateTime? scheduled,
  DateTime? predictedTime,
  bool predicted = false,
  Frequency? frequency,
  TripStatus? tripStatus,
}) =>
    ArrivalAndDeparture(
      routeId: 'R',
      tripId: 'T',
      serviceDate: DateTime.utc(2026, 9, 24),
      stopId: 'S',
      stopSequence: 1,
      scheduledArrivalTime: scheduled,
      predictedArrivalTime: predictedTime,
      predicted: predicted,
      frequency: frequency,
      tripStatus: tripStatus,
    );

String fmt(DateTime d) => '${d.hour}:${d.minute.toString().padLeft(2, '0')}';

void main() {
  const strings = ObaArrivalsStrings();
  final now = t(13, 50, 40);

  group('minutesUntil', () {
    test('uses predicted time when predicted, flooring to minutes', () {
      final a = arrival(
          scheduled: t(13, 51), predictedTime: t(13, 53, 59), predicted: true);
      expect(minutesUntil(a, now), 3); // 13:53 - 13:50
    });

    test('falls back to scheduled when not predicted', () {
      final a = arrival(scheduled: t(13, 58), predictedTime: t(13, 59));
      expect(minutesUntil(a, now), 8);
    });

    test('falls back to scheduled when predicted but no predicted time', () {
      final a = arrival(scheduled: t(13, 58), predicted: true);
      expect(minutesUntil(a, now), 8);
      expect(hasPrediction(a), isFalse);
    });

    test('same minute is 0, past is negative, no times is null', () {
      expect(minutesUntil(arrival(scheduled: t(13, 50, 5)), now), 0);
      expect(minutesUntil(arrival(scheduled: t(13, 47)), now), -3);
      expect(minutesUntil(arrival(), now), isNull);
    });
  });

  group('status', () {
    ArrivalAndDeparture withDelay(int minutes) => arrival(
        scheduled: t(14, 0),
        predictedTime: t(14, 0).add(Duration(minutes: minutes)),
        predicted: true);

    test('late', () {
      expect(delayMinutes(withDelay(4)), 4);
      expect(statusKind(withDelay(4)), ArrivalStatusKind.late);
      expect(statusText(withDelay(4), now, strings, formatTime: fmt), '4 min late');
    });

    test('1 min early: early text but on-time color (matches Wayfinder)', () {
      expect(statusText(withDelay(-1), now, strings, formatTime: fmt), '1 min early');
      expect(statusKind(withDelay(-1)), ArrivalStatusKind.onTime);
    });

    test('2 min early: early text and early color', () {
      expect(statusText(withDelay(-2), now, strings, formatTime: fmt), '2 min early');
      expect(statusKind(withDelay(-2)), ArrivalStatusKind.early);
    });

    test('on time', () {
      expect(statusText(withDelay(0), now, strings, formatTime: fmt), 'on time');
      expect(statusKind(withDelay(0)), ArrivalStatusKind.onTime);
    });

    test('scheduled only', () {
      final a = arrival(scheduled: t(14, 0));
      expect(delayMinutes(a), isNull);
      expect(statusKind(a), ArrivalStatusKind.scheduled);
      expect(statusText(a, now, strings, formatTime: fmt), 'scheduled');
    });

    test('canceled via tripStatus wins over everything', () {
      final a = arrival(
          scheduled: t(14, 0),
          predictedTime: t(14, 5),
          predicted: true,
          tripStatus: const TripStatus(status: 'CANCELED'));
      expect(isCanceled(a), isTrue);
      expect(statusKind(a), ArrivalStatusKind.canceled);
      expect(statusText(a, now, strings, formatTime: fmt), 'canceled');
    });

    test('frequency: headway seconds -> minutes, from/until', () {
      final before = arrival(
          scheduled: t(14, 0),
          frequency: Frequency(startTime: t(14, 0), endTime: t(18, 0), headway: 600));
      expect(statusText(before, now, strings, formatTime: fmt), 'every 10 min from 14:00');
      final during = arrival(
          scheduled: t(14, 0),
          frequency: Frequency(startTime: t(13, 0), endTime: t(18, 0), headway: 450));
      expect(statusText(during, now, strings, formatTime: fmt), 'every 7 min until 18:00');
    });
  });

  test('displayTime prefers predicted when predicted', () {
    expect(displayTime(arrival(scheduled: t(14, 0), predictedTime: t(14, 2), predicted: true)),
        t(14, 2));
    expect(displayTime(arrival(scheduled: t(14, 0), predictedTime: t(14, 2))), t(14, 0));
  });

  test('etaLabel', () {
    expect(etaLabel(0, strings), 'now');
    expect(etaLabel(13, strings), '13m');
  });
}
