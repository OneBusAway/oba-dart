import 'package:clock/clock.dart';

import '../platform/key_value_store.dart';

/// How a rider answered the "Enjoying the app?" prompt.
enum FeedbackPromptOutcome { positive, negative, deferred }

/// Decides when to ask for an app review. Port of iOS `ReviewPromptPolicy`.
///
/// Call [recordSuccess] after something good happened (a stop loaded, a
/// bookmark saved). After [successThreshold] successes the prompt becomes
/// pending, subject to the ask limit, a per-version limit and a back-off
/// after a "not now" (60 days) or a negative answer (180 days).
class ReviewPromptPolicy {
  ReviewPromptPolicy(
    this._store, {
    required this.appVersion,
    this.enabled = true,
    this.canReview = true,
  });

  final KeyValueStore _store;

  /// The running app version; one prompt per version at most.
  final String appVersion;

  /// `ObaAppConfig.feedbackPromptEnabled`.
  final bool enabled;

  /// Whether there is somewhere to send a happy rider (a store id).
  final bool canReview;

  static const successThreshold = 5;
  static const maximumAsks = 3;
  static const deferredBackoff = Duration(days: 60);
  static const negativeBackoff = Duration(days: 180);

  static const _p = 'oba.prompts.review.';
  static const _kSuccess = '${_p}successCount';
  static const _kAsks = '${_p}askCount';
  static const _kLastAsked = '${_p}lastAskedDate';
  static const _kOutcome = '${_p}outcome';
  static const _kLastVersion = '${_p}lastVersionPrompted';
  static const _kAlwaysShow = '${_p}alwaysShow';

  int get successCount => _store.readInt(_kSuccess) ?? 0;
  int get askCount => _store.readInt(_kAsks) ?? 0;

  FeedbackPromptOutcome? get outcome {
    final raw = _store.readStringValue(_kOutcome);
    for (final o in FeedbackPromptOutcome.values) {
      if (o.name == raw) return o;
    }
    return null;
  }

  DateTime? get lastAskedDate =>
      DateTime.tryParse(_store.readStringValue(_kLastAsked) ?? '');

  /// Debug switch: show the prompt whenever it is asked for.
  bool get alwaysShow => _store.readBool(_kAlwaysShow) ?? false;
  set alwaysShow(bool v) => _store.writeJson(_kAlwaysShow, v);

  void recordSuccess() => _store.writeJson(_kSuccess, successCount + 1);

  /// Call when the prompt is shown.
  void recordPromptPresented() {
    if (!alwaysShow) {
      _store.writeJson(_kAsks, askCount + 1);
      _store.writeJson(_kLastVersion, appVersion);
    }
    _store.writeJson(_kLastAsked, clock.now().toIso8601String());
    _store.writeJson(_kOutcome, FeedbackPromptOutcome.deferred.name);
    _store.writeJson(_kSuccess, 0);
  }

  void recordOutcome(FeedbackPromptOutcome outcome) {
    if (alwaysShow) return;
    _store.writeJson(_kOutcome, outcome.name);
    if (lastAskedDate == null) {
      _store.writeJson(_kLastAsked, clock.now().toIso8601String());
      _store.writeJson(_kSuccess, 0);
    }
  }

  bool get isPromptPending {
    if (!enabled || !canReview) return false;
    if (alwaysShow) return true;
    if (askCount >= maximumAsks) return false;
    if (outcome == FeedbackPromptOutcome.positive) return false;
    if (successCount < successThreshold) return false;
    if (_store.readStringValue(_kLastVersion) == appVersion) return false;
    final last = lastAskedDate;
    if (last != null) {
      final backoff = outcome == FeedbackPromptOutcome.negative
          ? negativeBackoff
          : deferredBackoff;
      if (clock.now().isBefore(last.add(backoff))) return false;
    }
    return true;
  }

  /// Clears the saved state but leaves [alwaysShow].
  void reset() {
    for (final k in [
      _kSuccess,
      _kAsks,
      _kLastAsked,
      _kOutcome,
      _kLastVersion,
    ]) {
      _store.writeJson(k, null);
    }
  }
}

/// When to show the donation card. Port of the date rules in iOS
/// `DonationsManager` (the storefront check is an App Store rule and is
/// left to the host through [enabled]).
class DonationPromptState {
  DonationPromptState(
    this._store, {
    required this.enabled,
    required this.appLaunchCount,
  });

  final KeyValueStore _store;

  /// Donations are on in this app (`ObaAppConfig.donations.enabled`, and
  /// whatever store rules the host applies).
  final bool enabled;
  final int Function() appLaunchCount;

  static const minimumLaunches = 3;
  static const remindDelay = Duration(days: 14);

  static const _kDismissed = 'oba.prompts.donation.dismissedDate';
  static const _kReminder = 'oba.prompts.donation.reminderDate';

  DateTime? get dismissedDate =>
      DateTime.tryParse(_store.readStringValue(_kDismissed) ?? '');
  DateTime? get reminderDate =>
      DateTime.tryParse(_store.readStringValue(_kReminder) ?? '');

  /// "No thanks" or "Donate": never ask again.
  void dismiss() =>
      _store.writeJson(_kDismissed, clock.now().toIso8601String());

  /// "Remind me later": ask again in two weeks.
  void remindLater() => _store.writeJson(
    _kReminder,
    clock.now().add(remindDelay).toIso8601String(),
  );

  bool get shouldRequest {
    if (!enabled) return false;
    if (appLaunchCount() < minimumLaunches) return false;
    final reminder = reminderDate;
    if (reminder != null && reminder.isAfter(clock.now())) return false;
    return dismissedDate == null;
  }

  void reset() {
    _store.writeJson(_kDismissed, null);
    _store.writeJson(_kReminder, null);
  }
}

/// Keeps prompts from piling up: one review prompt per session, and two
/// weeks of quiet after any inline card was shown. Port
/// of iOS `PromptCoordinator`.
class PromptCoordinator {
  PromptCoordinator(this._store);

  final KeyValueStore _store;

  static const engagementCooldown = Duration(days: 14);
  static const _kLastEngagement = 'oba.prompts.lastEngagementDate';

  final Set<PromptKind> _shownThisSession = {};

  DateTime? get lastEngagement =>
      DateTime.tryParse(_store.readStringValue(_kLastEngagement) ?? '');

  bool canShowReviewPrompt() {
    if (_shownThisSession.isNotEmpty) return false;
    final last = lastEngagement;
    if (last != null && clock.now().isBefore(last.add(engagementCooldown))) {
      return false;
    }
    return true;
  }

  /// Donation and survey cards yield to a review prompt in the same session.
  bool canShowInlineCards() => !_shownThisSession.contains(PromptKind.review);

  void noteShown(PromptKind kind) {
    _shownThisSession.add(kind);
    if (kind != PromptKind.review) {
      _store.writeJson(_kLastEngagement, clock.now().toIso8601String());
    }
  }

  /// The rider answered a survey: start the cooldown.
  void noteSurveyEngaged() =>
      _store.writeJson(_kLastEngagement, clock.now().toIso8601String());

  void beginNewSession() => _shownThisSession.clear();

  void reset() {
    _store.writeJson(_kLastEngagement, null);
    beginNewSession();
  }
}

enum PromptKind { review, donationModal, surveyPrompt }
