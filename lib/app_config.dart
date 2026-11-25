import 'package:http/http.dart' as http;
import 'package:obakit/obakit.dart';

/// The `--dart-define` overrides the shim accepts.
const _apiKeyDefine = String.fromEnvironment('OBA_API_KEY');
const _fixedRegionNameDefine = String.fromEnvironment('OBA_FIXED_REGION_NAME');
const _fixedRegionUrlDefine = String.fromEnvironment('OBA_FIXED_REGION_URL');

/// The app's identity, shared with the iOS app (`Apps/OneBusAway`).
const obaAppName = 'OneBusAway';
const obaAppVersion = '1.0.0';
const obaDefaultApiKey = 'org.onebusaway.iphone';

/// This app's own identity, sent in the map tile and Nominatim User-Agent
/// headers (the OSM and Nominatim usage policies ask for one that names the
/// app). It is the iOS bundle id of this Flutter app, not the iOS app's.
const obaBundleIdentifier = 'org.onebusaway.obaDart';

/// The Flutter equivalent of the iOS app's `OBAKitConfig` Info.plist
/// dictionary. [apiKey], [fixedRegionName] and [fixedRegionUrl] default to
/// the `OBA_API_KEY`, `OBA_FIXED_REGION_NAME` and `OBA_FIXED_REGION_URL`
/// dart-defines; an empty value means "not set".
Map<String, Object?> buildObaKitConfig({
  String apiKey = _apiKeyDefine,
  String fixedRegionName = _fixedRegionNameDefine,
  String fixedRegionUrl = _fixedRegionUrlDefine,
}) => {
  'RESTServerAPIKey': apiKey.isEmpty ? obaDefaultApiKey : apiKey,
  'RegionsServerBaseAddress': 'https://regions.onebusaway.org',
  'RegionsServerAPIPath': '/regions-v3.json',
  if (fixedRegionName.isNotEmpty) 'FixedRegionName': fixedRegionName,
  if (fixedRegionUrl.isNotEmpty) 'FixedRegionOBABaseURL': fixedRegionUrl,
  'ExtensionURLScheme': 'onebusaway',
  'AppDevelopersEmailAddress': 'iphone-app@onebusaway.org',
  'AppStoreID': '329380089',
  'PrivacyPolicyURL':
      'https://opentransitsoftwarefoundation.org/onebusaway/privacy/',
  'Donations': {
    'Enabled': true,
    'DonationManagementPortal':
        'https://opentransitsoftwarefoundation.org/manage-donations',
  },
  'MoreTab': {
    'ShowHelpOutSection': true,
    'DevelopURL': 'https://github.com/oneBusAway/onebusaway-ios',
  },
};

/// Builds the [ObaAppConfig] from [buildObaKitConfig] plus the platform
/// services. Without [bundledRegionsJson], `ObaApplication.create` uses
/// the regions list bundled with obakit.
ObaAppConfig buildObaAppConfig({
  required ObaPlatformServices services,
  String? bundledRegionsJson,
  Map<String, Object?>? kitConfig,
  String operatingSystem = 'android',
  http.Client? httpClient,
}) => ObaAppConfig.fromOBAKitConfig(
  kitConfig ?? buildObaKitConfig(),
  appName: obaAppName,
  appVersion: obaAppVersion,
  bundledRegionsJson: bundledRegionsJson,
  keyValueStore: services.keyValueStore,
  locationProvider: services.locationProvider,
  placeSearchProvider: services.placeSearchProvider,
  operatingSystem: operatingSystem,
  httpClient: httpClient,
);
