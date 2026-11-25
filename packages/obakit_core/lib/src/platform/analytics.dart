import 'package:onebusaway/onebusaway.dart';

/// Analytics sink (Firebase, Umami, ...). Mirrors iOS `Analytics`.
abstract class ObaAnalytics {
  /// Called when the current region changes, for per-region servers.
  void updateServer(Region region) {}

  void reportEvent({
    required String pageUrl,
    required String label,
    Object? value,
  });

  void reportSearchQuery(String query);

  void reportStopViewed({
    required String name,
    required String id,
    required String stopDistance,
  });

  void reportSetRegion(String name);

  void setReportingEnabled(bool enabled);

  bool get reportingEnabled;

  void setUserProperty(String key, String? value);

  void reportError(Object error, [StackTrace? stackTrace]) {}
}

/// Discards everything.
class NoopAnalytics extends ObaAnalytics {
  bool _enabled = true;

  @override
  void reportEvent({
    required String pageUrl,
    required String label,
    Object? value,
  }) {}

  @override
  void reportSearchQuery(String query) {}

  @override
  void reportSetRegion(String name) {}

  @override
  void reportStopViewed({
    required String name,
    required String id,
    required String stopDistance,
  }) {}

  @override
  bool get reportingEnabled => _enabled;

  @override
  void setReportingEnabled(bool enabled) => _enabled = enabled;

  @override
  void setUserProperty(String key, String? value) {}
}

/// Event labels, matching iOS `AnalyticsLabels` so dashboards line up.
abstract final class AnalyticsLabels {
  static const reportProblem = 'report_problem';
  static const setRegionAutomatically = 'Set region automatically';
  static const setRegionManually = 'Set region manually';
  static const manuallySelectedRegionChanged = 'selected manually';
  static const farePayment = 'fare_payment';
  static const addBookmark = 'Starred route';
  static const removeBookmark = 'Unstarred route';
  static const searchSelected = 'Search box selected';
  static const mapStopAnnotationTapped = 'Clicked MapStopIcon';
  static const mapShowUserLocationButtonTapped = 'Clicked My Location Button';
  static const mapLayerToggled = 'Map Layer Toggled';
  static const donationLearnMoreShown = 'Donation Learn More Shown';
  static const donateButtonTapped = 'Donation Button Tapped';
  static const donationSuccess = 'Donation Success';
  static const donationError = 'Donation Error';
  static const donationCanceled = 'Donation Canceled';
  static const donationPushNotificationTapped =
      'Donation Push Notification Tapped';
  static const donationPushNotificationSuccess =
      'Donation Push Notification Success';
  static const feedbackPromptShown = 'Feedback Prompt Shown';
  static const feedbackPositive = 'Feedback Positive';
  static const feedbackNegative = 'Feedback Negative';
  static const feedbackDeferred = 'Feedback Deferred';
  static const feedbackEmailOpened = 'Feedback Email Opened';
  static const feedbackEmailSent = 'Feedback Email Sent';
  static const feedbackEmailUnavailable = 'Feedback Email Unavailable';
  static const feedbackEmailFailed = 'Feedback Email Failed';
  static const rateAppRowTapped = 'Rate App Row Tapped';

  /// Value for [addBookmark]/[removeBookmark] events.
  static String addRemoveBookmarkValue({
    required String routeId,
    String? headsign,
    required String stopId,
  }) => '${routeId}_${headsign ?? ''} for $stopId';
}
