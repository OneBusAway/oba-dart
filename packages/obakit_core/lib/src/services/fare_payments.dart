import 'package:onebusaway/onebusaway.dart';

import '../platform/key_value_store.dart';

/// What to open for a region's mobile fare payment app.
class FarePaymentTarget {
  const FarePaymentTarget({this.appUri, this.storeUri});

  /// A URL that opens the installed app (iOS URL scheme), or null.
  final Uri? appUri;

  /// The app's store page, to fall back to.
  final Uri? storeUri;

  bool get isEmpty => appUri == null && storeUri == null;
}

/// Pay My Fare logic. Port of iOS `FarePayments`: a region may name a
/// payment app and a warning to show once (the app may not cover the whole
/// region).
class FarePayments {
  FarePayments(this._store);

  final KeyValueStore _store;

  /// [platform] is `ios`, `macos` or `android` (any other value is treated
  /// like Android's store link only when the region has an Android app id).
  static bool isApplePlatform(String platform) =>
      platform == 'ios' || platform == 'macos';

  /// Whether the region has a payment app for [platform].
  static bool isSupported(Region region, String platform) =>
      isApplePlatform(platform)
      ? region.supportsMobileFarePayment
      : region.paymentAndroidAppId != null &&
            region.paymentAndroidAppId!.isNotEmpty;

  static FarePaymentTarget targetFor(Region region, String platform) {
    if (isApplePlatform(platform)) {
      final scheme = region.paymentIosAppUrlScheme;
      final id = region.paymentIosAppStoreIdentifier;
      return FarePaymentTarget(
        appUri: scheme == null || scheme.isEmpty
            ? null
            : Uri.tryParse(scheme.contains('://') ? scheme : '$scheme://'),
        storeUri: id == null || id.isEmpty
            ? null
            : Uri.parse('https://apps.apple.com/app/id$id'),
      );
    }
    final id = region.paymentAndroidAppId;
    return FarePaymentTarget(
      storeUri: id == null || id.isEmpty
          ? null
          : Uri.https('play.google.com', '/store/apps/details', {'id': id}),
    );
  }

  static String _key(Region region) =>
      'oba.farePayments.showWarning.${region.id}';

  /// True until the rider chose "Continue and don't show again", and only
  /// when the region has a warning.
  bool shouldShowWarning(Region region) =>
      region.paymentAppDoesNotCoverFullRegion &&
      (_store.readBool(_key(region)) ?? true);

  void suppressWarning(Region region) => _store.writeJson(_key(region), false);
}
