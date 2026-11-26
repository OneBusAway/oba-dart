import 'package:http/http.dart' as http;

import '../platform/analytics.dart';
import '../platform/key_value_store.dart';
import '../platform/location.dart';
import '../platform/place_search.dart';
import '../platform/push.dart';
import '../user_data/stop_preferences.dart';

/// A region to select at first launch when no stored or location-matched
/// region exists. See `RegionsService` for the exact order.
class FixedRegionConfig {
  const FixedRegionConfig({required this.name, this.obaBaseUrl});

  /// Matched against `Region.regionName`.
  final String name;

  /// Fallback match against `Region.obaBaseUrl` when [name] matches nothing.
  final Uri? obaBaseUrl;
}

class DonationsConfig {
  const DonationsConfig({
    this.enabled = false,
    this.managementPortal,
    this.donateUrl,
  });

  static const disabled = DonationsConfig();

  /// Where "Donate" goes when [donateUrl] is null (iOS `DonationModel`).
  static final defaultDonateUrl = Uri.parse(
    'https://opentransitsoftwarefoundation.org/donate/',
  );

  final bool enabled;
  final Uri? managementPortal;

  /// The donation page; null uses [defaultDonateUrl].
  final Uri? donateUrl;

  Uri get effectiveDonateUrl => donateUrl ?? defaultDonateUrl;
}

/// A link row in the More screen.
class MoreTabLink {
  const MoreTabLink({required this.title, required this.url});

  final String title;
  final Uri url;

  /// Null when `Title` or `URL` is missing or the URL is empty or invalid.
  static MoreTabLink? fromMap(Map<String, Object?> map) {
    final title = map['Title'];
    final url = map['URL'];
    if (title is! String || url is! String || url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    return uri == null ? null : MoreTabLink(title: title, url: uri);
  }
}

/// Customises the More screen. Mirrors iOS `MoreTabConfiguration`.
class MoreTabConfig {
  const MoreTabConfig({
    this.headerSupportText,
    this.showHelpOutSection = true,
    this.translateUrl,
    this.developUrl,
    this.tutorialUrl,
    this.phoneUrl,
    this.textUrl,
    this.customLinks = const [],
  });

  static final MoreTabConfig defaults = MoreTabConfig(
    developUrl: Uri.parse('https://github.com/oneBusAway/onebusaway-ios'),
  );

  /// Parses an `OBAKitConfig.MoreTab`-style map, with the same keys and
  /// fallbacks as iOS (`DevelopURL` defaults to the OneBusAway repo; an
  /// empty string hides it).
  factory MoreTabConfig.fromMap(Map<String, Object?> map) {
    Uri? url(String key) {
      final v = map[key];
      return v is String && v.isNotEmpty ? Uri.tryParse(v) : null;
    }

    final develop = map['DevelopURL'];
    final links = map['CustomLinks'];
    return MoreTabConfig(
      headerSupportText: map['HeaderSupportText'] is String
          ? map['HeaderSupportText'] as String
          : null,
      showHelpOutSection: map['ShowHelpOutSection'] is bool
          ? map['ShowHelpOutSection'] as bool
          : true,
      translateUrl: url('TranslateURL'),
      developUrl: develop is String ? url('DevelopURL') : defaults.developUrl,
      tutorialUrl: url('TutorialURL'),
      phoneUrl: url('PhoneURL'),
      textUrl: url('TextURL'),
      customLinks: links is List
          ? [
              for (final l in links)
                if (l is Map<String, Object?>) ?MoreTabLink.fromMap(l),
            ]
          : const [],
    );
  }

  /// Null means "use the default localised copy".
  final String? headerSupportText;
  final bool showHelpOutSection;

  /// Null hides the row.
  final Uri? translateUrl;

  /// Null hides the row.
  final Uri? developUrl;
  final Uri? tutorialUrl;
  final Uri? phoneUrl;
  final Uri? textUrl;
  final List<MoreTabLink> customLinks;
}

/// Everything a host app supplies to configure OneBusAway: branding and
/// server settings (the iOS `OBAKitConfig` Info.plist dictionary) plus the
/// platform services (iOS `AppConfig`).
class ObaAppConfig {
  ObaAppConfig({
    required this.appName,
    required this.apiKey,
    required this.appVersion,
    String? bundledRegionsJson,
    required this.keyValueStore,
    required this.locationProvider,
    Uri? regionsBaseUrl,
    this.regionsPath = '/regions-v3.json',
    this.fixedRegion,
    this.defaultArrivalDepartureFilter = ArrivalDepartureFilter.all,
    this.urlScheme = 'onebusaway',
    this.developerEmail,
    this.privacyPolicyUrl,
    this.appStoreId,
    this.playStoreId,
    this.donations = DonationsConfig.disabled,
    MoreTabConfig? moreTab,
    this.feedbackPromptEnabled = true,
    this.operatingSystem = 'android',
    this.apnsSandbox = false,
    this.pushServiceProvider,
    this.analytics,
    this.placeSearchProvider,
    this.httpClient,
    this.regionsRefreshInterval = const Duration(days: 1),
  }) : bundledRegionsJson = bundledRegionsJson ?? '',
       regionsBaseUrl =
           regionsBaseUrl ?? Uri.parse('https://regions.onebusaway.org'),
       moreTab = moreTab ?? MoreTabConfig.defaults;

  /// Builds a config from an iOS-style `OBAKitConfig` dictionary (e.g. the
  /// host's JSON asset). Keys: `RESTServerAPIKey`, `RegionsServerBaseAddress`,
  /// `RegionsServerAPIPath`, `FixedRegionName`, `FixedRegionOBABaseURL`,
  /// `DefaultArrivalDepartureFilter`, `ExtensionURLScheme`,
  /// `AppDevelopersEmailAddress`, `PrivacyPolicyURL`, `AppStoreID`,
  /// `PlayStoreID`, `FeedbackPromptEnabled`, `Donations`
  /// (`Enabled`, `DonationManagementPortal`) and `MoreTab`.
  factory ObaAppConfig.fromOBAKitConfig(
    Map<String, Object?> map, {
    required String appName,
    required String appVersion,
    String? bundledRegionsJson,
    required KeyValueStore keyValueStore,
    required LocationProvider locationProvider,
    String operatingSystem = 'android',
    PushServiceProvider? pushServiceProvider,
    ObaAnalytics? analytics,
    PlaceSearchProvider? placeSearchProvider,
    http.Client? httpClient,
  }) {
    String? str(String key) {
      final v = map[key];
      return v is String && v.isNotEmpty ? v : null;
    }

    Uri? url(String key) {
      final v = str(key);
      return v == null ? null : Uri.tryParse(v);
    }

    final donations = map['Donations'];
    final moreTab = map['MoreTab'];
    final fixedName = str('FixedRegionName');
    return ObaAppConfig(
      appName: appName,
      appVersion: appVersion,
      apiKey: str('RESTServerAPIKey') ?? '',
      bundledRegionsJson: bundledRegionsJson,
      keyValueStore: keyValueStore,
      locationProvider: locationProvider,
      regionsBaseUrl: url('RegionsServerBaseAddress'),
      regionsPath: str('RegionsServerAPIPath') ?? '/regions-v3.json',
      fixedRegion: fixedName == null
          ? null
          : FixedRegionConfig(
              name: fixedName,
              obaBaseUrl: url('FixedRegionOBABaseURL'),
            ),
      defaultArrivalDepartureFilter: ArrivalDepartureFilter.parse(
        str('DefaultArrivalDepartureFilter'),
      ),
      urlScheme: str('ExtensionURLScheme') ?? 'onebusaway',
      developerEmail: str('AppDevelopersEmailAddress'),
      privacyPolicyUrl: url('PrivacyPolicyURL'),
      appStoreId: str('AppStoreID'),
      playStoreId: str('PlayStoreID'),
      feedbackPromptEnabled: map['FeedbackPromptEnabled'] is bool
          ? map['FeedbackPromptEnabled'] as bool
          : true,
      donations: donations is Map<String, Object?>
          ? DonationsConfig(
              enabled: donations['Enabled'] == true,
              managementPortal: donations['DonationManagementPortal'] is String
                  ? Uri.tryParse(
                      donations['DonationManagementPortal'] as String,
                    )
                  : null,
              donateUrl: donations['DonateURL'] is String
                  ? Uri.tryParse(donations['DonateURL'] as String)
                  : null,
            )
          : DonationsConfig.disabled,
      moreTab: moreTab is Map<String, Object?>
          ? MoreTabConfig.fromMap(moreTab)
          : null,
      operatingSystem: operatingSystem,
      pushServiceProvider: pushServiceProvider,
      analytics: analytics,
      placeSearchProvider: placeSearchProvider,
      httpClient: httpClient,
    );
  }

  final String appName;

  /// The OBA REST API key (`RESTServerAPIKey`).
  final String apiKey;
  final String appVersion;

  /// Regions server root. Set [regionsPath] to null to rely on the bundled
  /// list only.
  final Uri regionsBaseUrl;
  final String? regionsPath;

  /// The contents of a bundled `regions.json` (an OBA envelope with
  /// `data.list`), used until a downloaded list is cached. Empty when the
  /// host supplied none: `ObaApplication.create` (obakit) then uses the
  /// regions list bundled with the SDK
  /// (`ObaCoreApplication.bundledRegionsLoader`).
  final String bundledRegionsJson;
  final FixedRegionConfig? fixedRegion;

  /// The departure filter a fresh install starts with.
  final ArrivalDepartureFilter defaultArrivalDepartureFilter;

  /// Custom URL scheme for deep links (`ExtensionURLScheme`).
  final String urlScheme;
  final String? developerEmail;
  final Uri? privacyPolicyUrl;
  final String? appStoreId;
  final String? playStoreId;
  final DonationsConfig donations;
  final MoreTabConfig moreTab;
  final bool feedbackPromptEnabled;

  /// Sent to Obaco as `operating_system` (`ios` or `android`).
  final String operatingSystem;
  final bool apnsSandbox;

  final KeyValueStore keyValueStore;
  final LocationProvider locationProvider;

  /// Null disables alarms.
  final PushServiceProvider? pushServiceProvider;
  final ObaAnalytics? analytics;

  /// Null disables address search.
  final PlaceSearchProvider? placeSearchProvider;

  /// Shared HTTP client; obakit_core creates (and closes) one when null.
  final http.Client? httpClient;

  /// How stale the cached regions list may get before a refresh.
  final Duration regionsRefreshInterval;
}
