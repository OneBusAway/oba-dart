import 'package:clock/clock.dart';
import 'package:obakit_core/obakit_core.dart';
import 'package:test/test.dart';

void main() {
  final t0 = DateTime.utc(2026, 1, 1);

  group('ReviewPromptPolicy', () {
    late InMemoryKeyValueStore store;
    ReviewPromptPolicy policy({
      String version = '1.0.0',
      bool enabled = true,
    }) => ReviewPromptPolicy(store, appVersion: version, enabled: enabled);

    setUp(() => store = InMemoryKeyValueStore());

    void succeed(ReviewPromptPolicy p, int n) {
      for (var i = 0; i < n; i++) {
        p.recordSuccess();
      }
    }

    test('needs five successes', () {
      final p = policy();
      succeed(p, 4);
      expect(p.isPromptPending, isFalse);
      p.recordSuccess();
      expect(p.isPromptPending, isTrue);
    });

    test('disabled or without a store id never prompts', () {
      final off = policy(enabled: false)..alwaysShow = false;
      succeed(off, 9);
      expect(off.isPromptPending, isFalse);
      final noStore = ReviewPromptPolicy(
        store,
        appVersion: '1',
        canReview: false,
      );
      expect(noStore.isPromptPending, isFalse);
    });

    test('presenting resets successes and records the version', () {
      final p = policy();
      succeed(p, 5);
      p.recordPromptPresented();
      expect(p.successCount, 0);
      expect(p.askCount, 1);
      expect(p.outcome, FeedbackPromptOutcome.deferred);
      succeed(p, 5);
      // Same version: no second prompt.
      expect(p.isPromptPending, isFalse);
    });

    test('deferred backs off 60 days, negative 180, per version', () {
      withClock(Clock.fixed(t0), () {
        final p = policy();
        succeed(p, 5);
        p.recordPromptPresented();
        p.recordOutcome(FeedbackPromptOutcome.deferred);
        final v2 = policy(version: '2.0.0');
        succeed(v2, 5);
        withClock(Clock.fixed(t0.add(const Duration(days: 59))), () {
          expect(v2.isPromptPending, isFalse);
        });
        withClock(Clock.fixed(t0.add(const Duration(days: 61))), () {
          expect(v2.isPromptPending, isTrue);
        });
        v2.recordOutcome(FeedbackPromptOutcome.negative);
        withClock(Clock.fixed(t0.add(const Duration(days: 100))), () {
          expect(v2.isPromptPending, isFalse);
        });
        withClock(Clock.fixed(t0.add(const Duration(days: 181))), () {
          expect(v2.isPromptPending, isTrue);
        });
      });
    });

    test('positive is final; three asks is the limit', () {
      final p = policy();
      succeed(p, 5);
      p.recordOutcome(FeedbackPromptOutcome.positive);
      expect(p.isPromptPending, isFalse);

      store = InMemoryKeyValueStore();
      withClock(Clock.fixed(t0), () {
        for (var i = 1; i <= 3; i++) {
          final q = policy(version: '$i.0.0');
          succeed(q, 5);
          final at = t0.add(Duration(days: 100 * i));
          withClock(Clock.fixed(at), () {
            expect(q.isPromptPending, isTrue, reason: 'ask $i');
            q.recordPromptPresented();
          });
        }
        final q = policy(version: '4.0.0');
        succeed(q, 5);
        withClock(Clock.fixed(t0.add(const Duration(days: 900))), () {
          expect(q.isPromptPending, isFalse);
        });
      });
    });

    test('alwaysShow bypasses the gates; reset keeps it', () {
      final p = policy()..alwaysShow = true;
      expect(p.isPromptPending, isTrue);
      p.recordPromptPresented();
      expect(p.askCount, 0);
      p.reset();
      expect(p.alwaysShow, isTrue);
    });
  });

  group('DonationPromptState', () {
    late InMemoryKeyValueStore store;
    var launches = 3;
    DonationPromptState state({bool enabled = true}) => DonationPromptState(
      store,
      enabled: enabled,
      appLaunchCount: () => launches,
    );

    setUp(() {
      store = InMemoryKeyValueStore();
      launches = 3;
    });

    test('needs three launches and being enabled', () {
      expect(state().shouldRequest, isTrue);
      expect(state(enabled: false).shouldRequest, isFalse);
      launches = 2;
      expect(state().shouldRequest, isFalse);
    });

    test('remind later waits two weeks, dismiss is permanent', () {
      withClock(Clock.fixed(t0), () {
        final s = state()..remindLater();
        expect(s.shouldRequest, isFalse);
        withClock(Clock.fixed(t0.add(const Duration(days: 13))), () {
          expect(s.shouldRequest, isFalse);
        });
        withClock(Clock.fixed(t0.add(const Duration(days: 15))), () {
          expect(s.shouldRequest, isTrue);
          s.dismiss();
          expect(s.shouldRequest, isFalse);
        });
      });
    });
  });

  group('PromptCoordinator', () {
    late InMemoryKeyValueStore store;
    late PromptCoordinator c;
    setUp(() {
      store = InMemoryKeyValueStore();
      c = PromptCoordinator(store);
    });

    test('one review prompt per session', () {
      expect(c.canShowReviewPrompt(), isTrue);
      c.noteShown(PromptKind.review);
      expect(c.canShowReviewPrompt(), isFalse);
      expect(c.canShowInlineCards(), isFalse);
      c.beginNewSession();
      expect(c.canShowReviewPrompt(), isTrue);
    });

    test('an inline card starts a 14 day cooldown', () {
      withClock(Clock.fixed(t0), () {
        c.noteShown(PromptKind.donationModal);
        c.beginNewSession();
        expect(c.canShowReviewPrompt(), isFalse);
        withClock(Clock.fixed(t0.add(const Duration(days: 15))), () {
          expect(c.canShowReviewPrompt(), isTrue);
        });
      });
    });

    test('survey engagement starts the cooldown', () {
      withClock(Clock.fixed(t0), () {
        c.noteSurveyEngaged();
        expect(c.canShowReviewPrompt(), isFalse);
      });
    });
  });
}
