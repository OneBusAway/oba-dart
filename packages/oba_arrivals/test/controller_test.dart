import 'dart:async';
import 'dart:convert';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:oba_arrivals/oba_arrivals.dart';

import 'support/fixtures.dart';

void main() {
  final deviceStart = DateTime.utc(
    2026,
    9,
    24,
    4,
    0,
  ); // 1 h 43 min behind server

  ArrivalsController controllerFor(
    FakeAsync async,
    Future<http.Response> Function(http.Request) handler, {
    void Function(Object error, StackTrace stackTrace)? onError,
  }) => ArrivalsController(
    client: fakeClient(handler),
    stopId: 'MTS_24151',
    clock: () => deviceStart.add(async.elapsed),
    onError: onError,
  );

  test('resume() loads the stop and arrivals', () {
    fakeAsync((async) {
      final c = controllerFor(async, (_) async => okResponse());
      expect(c.state.status, ArrivalsStatus.loading);
      c.resume();
      expect(c.state.isRefreshing, isTrue);
      async.flushMicrotasks();

      expect(c.state.status, ArrivalsStatus.loaded);
      expect(c.state.isRefreshing, isFalse);
      expect(c.state.stop!.name, 'Eighth College / Theatre District (North)');
      expect(c.state.rawArrivals, hasLength(4)); // unfiltered
      expect(c.state.error, isNull);
      c.dispose();
    });
  });

  test('requests minutesAfter', () {
    fakeAsync((async) {
      late Uri url;
      final c = controllerFor(async, (r) async {
        url = r.url;
        return okResponse();
      });
      c.resume();
      async.flushMicrotasks();
      expect(url.queryParameters['minutesAfter'], '35');
      c.dispose();
    });
  });

  test('polls refreshInterval after each response completes', () {
    fakeAsync((async) {
      var requests = 0;
      final c = controllerFor(async, (_) async {
        requests++;
        return okResponse();
      });
      c.resume();
      async.flushMicrotasks();
      expect(requests, 1);
      async.elapse(const Duration(seconds: 29));
      expect(requests, 1);
      async.elapse(const Duration(seconds: 1));
      expect(requests, 2);
      c.dispose();
    });
  });

  test('slow responses never pile up', () {
    fakeAsync((async) {
      var requests = 0;
      final pending = Completer<http.Response>();
      final c = controllerFor(async, (_) {
        requests++;
        return requests == 1 ? pending.future : Future.value(okResponse());
      });
      c.resume();
      async.elapse(const Duration(seconds: 10)); // < 15 s timeout
      expect(requests, 1);
      pending.complete(okResponse());
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 29));
      expect(requests, 1);
      async.elapse(const Duration(seconds: 1));
      expect(requests, 2);
      c.dispose();
    });
  });

  test('a stale response is discarded', () {
    fakeAsync((async) {
      final first = Completer<http.Response>();
      var requests = 0;
      final c = controllerFor(async, (_) {
        requests++;
        return requests == 1 ? first.future : Future.value(okResponse());
      });
      c.resume();
      async.flushMicrotasks();
      c.refresh(); // supersedes request 1
      async.flushMicrotasks();
      expect(c.state.status, ArrivalsStatus.loaded);
      first.complete(http.Response('', 500)); // late failure must be ignored
      async.flushMicrotasks();
      expect(c.state.error, isNull);
      c.dispose();
    });
  });

  test('a failed refresh keeps data and records the error', () {
    fakeAsync((async) {
      var requests = 0;
      final c = controllerFor(async, (_) async {
        requests++;
        return requests == 1 ? okResponse() : http.Response('', 500);
      });
      c.resume();
      async.flushMicrotasks();
      async.elapse(const Duration(seconds: 30));
      expect(c.state.status, ArrivalsStatus.loaded);
      expect(c.state.rawArrivals, hasLength(4));
      expect(c.state.error, isA<ObaApiException>());
      c.dispose();
    });
  });

  test('a failure with no data is the error state', () {
    fakeAsync((async) {
      final c = controllerFor(async, (_) async => http.Response('', 200));
      c.resume();
      async.flushMicrotasks();
      expect(c.state.status, ArrivalsStatus.error);
      expect(
        c.state.error,
        isA<ObaApiException>().having(
          (e) => e.kind,
          'kind',
          ObaApiErrorKind.emptyResponse,
        ),
      );
      expect(c.state.hasData, isFalse);
      c.dispose();
    });
  });

  test('onError receives each failed fetch with its stack trace', () {
    fakeAsync((async) {
      final errors = <(Object, StackTrace)>[];
      var requests = 0;
      final c = controllerFor(async, (_) async {
        requests++;
        return switch (requests) {
          1 => http.Response('', 200),
          2 => okResponse(),
          _ => http.Response('', 500),
        };
      }, onError: (e, s) => errors.add((e, s)));
      c.resume();
      async.flushMicrotasks();
      expect(errors, hasLength(1));
      expect(
        errors[0].$1,
        isA<ObaApiException>().having(
          (e) => e.kind,
          'kind',
          ObaApiErrorKind.emptyResponse,
        ),
      );
      expect(errors[0].$1, same(c.state.error));

      async.elapse(const Duration(seconds: 30)); // succeeds
      expect(errors, hasLength(1));

      async.elapse(const Duration(seconds: 30)); // fails with data
      expect(errors, hasLength(2));
      expect(
        errors[1].$1,
        isA<ObaApiException>().having((e) => e.code, 'code', 500),
      );
      expect(errors[1].$2, isNot(StackTrace.empty));
      c.dispose();
    });
  });

  test('onError skips a discarded stale failure', () {
    fakeAsync((async) {
      final errors = <Object>[];
      final first = Completer<http.Response>();
      var requests = 0;
      final c = controllerFor(async, (_) {
        requests++;
        return requests == 1 ? first.future : Future.value(okResponse());
      }, onError: (e, _) => errors.add(e));
      c.resume();
      c.refresh(); // supersedes request 1
      async.flushMicrotasks();
      first.complete(http.Response('', 500));
      async.flushMicrotasks();
      expect(errors, isEmpty);
      c.dispose();
    });
  });

  test('a throwing onError is reported and does not stop polling', () {
    fakeAsync((async) {
      final reported = <FlutterErrorDetails>[];
      final previous = FlutterError.onError;
      FlutterError.onError = reported.add;
      addTearDown(() => FlutterError.onError = previous);
      var requests = 0;
      final c = controllerFor(async, (_) async {
        requests++;
        return http.Response('', 500);
      }, onError: (_, _) => throw StateError('host bug'));
      c.resume();
      async.flushMicrotasks();
      expect(c.state.status, ArrivalsStatus.error);
      expect(reported.single.exception, isA<StateError>());
      async.elapse(const Duration(seconds: 30));
      expect(requests, 2);
      c.dispose();
    });
  });

  test('the error state never flips to loading on a background poll', () {
    fakeAsync((async) {
      var requests = 0;
      final c = controllerFor(async, (_) async {
        requests++;
        return requests <= 2 ? http.Response('', 200) : okResponse();
      });
      final statuses = <ArrivalsStatus>[];
      c.addListener(() => statuses.add(c.state.status));
      c.resume();
      async.flushMicrotasks();
      expect(c.state.status, ArrivalsStatus.error);

      statuses.clear();
      c.addListener(() {
        if (c.state.isRefreshing) {
          expect(c.state.error, isNotNull); // message stays visible
        }
      });
      async.elapse(const Duration(seconds: 30)); // background poll fails
      expect(requests, 2);
      expect(statuses, isNot(contains(ArrivalsStatus.loading)));
      expect(statuses, [ArrivalsStatus.error, ArrivalsStatus.error]);
      expect(c.state.status, ArrivalsStatus.error);
      expect(c.state.isRefreshing, isFalse);

      statuses.clear();
      c.refresh(); // Retry, now succeeding
      expect(c.state.status, ArrivalsStatus.error);
      expect(c.state.isRefreshing, isTrue);
      async.flushMicrotasks();
      expect(statuses, isNot(contains(ArrivalsStatus.loading)));
      expect(c.state.status, ArrivalsStatus.loaded);
      expect(c.state.error, isNull);
      c.dispose();
    });
  });

  test('a stale response does not move the server clock offset', () {
    fakeAsync((async) {
      final first = Completer<http.Response>();
      var requests = 0;
      final c = controllerFor(async, (_) {
        requests++;
        return requests == 1 ? first.future : Future.value(okResponse());
      });
      c.resume();
      async.flushMicrotasks();
      c.refresh(); // supersedes request 1
      async.flushMicrotasks();
      expect(c.now(), fixtureServerTime);

      // Request 1 answers late with a server time an hour later.
      final json = jsonDecode(arrivalsFixture()) as Map<String, dynamic>;
      json['currentTime'] = (json['currentTime'] as int) + 3600 * 1000;
      first.complete(okResponse(jsonEncode(json)));
      async.flushMicrotasks();
      expect(c.now(), fixtureServerTime);
      c.dispose();
    });
  });

  test('acquire() is reference counted: polls while any holder remains', () {
    fakeAsync((async) {
      var requests = 0;
      final c = controllerFor(async, (_) async {
        requests++;
        return okResponse();
      });
      c.acquire();
      async.flushMicrotasks();
      expect(requests, 1); // 0 -> 1 refreshes now
      expect(c.isRunning, isTrue);
      c.acquire();
      async.flushMicrotasks();
      expect(requests, 1); // 1 -> 2 does not refetch

      c.release(); // 2 -> 1 keeps polling
      expect(c.isRunning, isTrue);
      async.elapse(const Duration(seconds: 30));
      expect(requests, 2);

      c.release(); // 1 -> 0 stops
      expect(c.isRunning, isFalse);
      async.elapse(const Duration(minutes: 5));
      expect(requests, 2);
      expect(async.pendingTimers, isEmpty);

      c.acquire(); // 0 -> 1 again refreshes now
      async.flushMicrotasks();
      expect(requests, 3);
      c.dispose();
    });
  });

  test('release() during an in-flight request does not schedule a poll', () {
    fakeAsync((async) {
      var requests = 0;
      final pending = Completer<http.Response>();
      final c = controllerFor(async, (_) {
        requests++;
        return pending.future;
      });
      c.acquire();
      c.release();
      pending.complete(okResponse());
      async.flushMicrotasks();
      async.elapse(const Duration(minutes: 2));
      expect(requests, 1);
      expect(c.state.status, ArrivalsStatus.loaded);
      c.dispose();
    });
  });

  test('pause() stops polling; resume() refreshes immediately', () {
    fakeAsync((async) {
      var requests = 0;
      final c = controllerFor(async, (_) async {
        requests++;
        return okResponse();
      });
      c.resume();
      async.flushMicrotasks();
      c.pause();
      expect(c.isRunning, isFalse);
      async.elapse(const Duration(minutes: 5));
      expect(requests, 1);
      c.resume();
      async.flushMicrotasks();
      expect(requests, 2);
      c.dispose();
    });
  });

  test('pause() during an in-flight request does not schedule a poll', () {
    fakeAsync((async) {
      var requests = 0;
      final pending = Completer<http.Response>();
      final c = controllerFor(async, (_) {
        requests++;
        return pending.future;
      });
      c.resume();
      c.pause();
      pending.complete(okResponse());
      async.flushMicrotasks();
      async.elapse(const Duration(minutes: 2));
      expect(requests, 1);
      expect(c.state.status, ArrivalsStatus.loaded); // result still applied
      c.dispose();
    });
  });

  test('now() follows server time, not the device clock', () {
    fakeAsync((async) {
      final c = controllerFor(async, (_) async => okResponse());
      expect(c.now(), deviceStart); // no offset before the first response
      c.resume();
      async.flushMicrotasks();
      expect(c.now(), fixtureServerTime);
      c.pause();
      async.elapse(const Duration(seconds: 90));
      expect(c.now(), fixtureServerTime.add(const Duration(seconds: 90)));
      c.dispose();
    });
  });

  test('dispose during a request is safe', () {
    fakeAsync((async) {
      final pending = Completer<http.Response>();
      final c = controllerFor(async, (_) => pending.future);
      c.resume();
      c.dispose();
      pending.complete(okResponse());
      async.flushMicrotasks();
      expect(async.pendingTimers, isEmpty); // no poll scheduled after dispose
    });
  });
}
