import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:obakit_core/obakit_core.dart';
import 'package:obakit_trip_planner/obakit_trip_planner.dart' as tp;

import '../platform/geolocator_location_provider.dart';
import '../platform/nominatim_place_search.dart';
import '../platform/shared_preferences_store.dart';
import '../platform/trip_place_search_bridge.dart';
import 'map_config.dart';

/// The platform services an [ObaAppConfig] needs. [defaults] builds the
/// SDK's own adapters; pass your own to [ObaApplication.create] to replace
/// any of them.
class ObaPlatformServices {
  const ObaPlatformServices({
    required this.keyValueStore,
    required this.locationProvider,
    this.placeSearchProvider,
  });

  final KeyValueStore keyValueStore;
  final LocationProvider locationProvider;
  final PlaceSearchProvider? placeSearchProvider;

  /// `shared_preferences` storage (keys under `oba.`), `geolocator`
  /// location (which never prompts until the UI asks), and Nominatim
  /// address search when [nominatimUserAgent] is given.
  static Future<ObaPlatformServices> defaults({
    KeyValueStore? keyValueStore,
    LocationProvider? locationProvider,
    PlaceSearchProvider? placeSearchProvider,
    String? nominatimUserAgent,
    Uri? nominatimEndpoint,
    http.Client? httpClient,
  }) async {
    GeolocatorLocationProvider? geo;
    final location = locationProvider ?? (geo = GeolocatorLocationProvider());
    // The store load and the location warm-up (which seeds the last fix for
    // region selection and never prompts) are independent: run them
    // together.
    final (store, _) = await (
      keyValueStore == null
          ? SharedPreferencesKeyValueStore.create()
          : Future<KeyValueStore>.value(keyValueStore),
      geo?.warmUp() ?? Future<void>.value(),
    ).wait;
    return ObaPlatformServices(
      keyValueStore: store,
      locationProvider: location,
      placeSearchProvider:
          placeSearchProvider ??
          (nominatimUserAgent == null
              ? null
              : NominatimPlaceSearch(
                  userAgent: nominatimUserAgent,
                  endpoint: nominatimEndpoint,
                  httpClient: httpClient,
                )),
    );
  }
}

/// The SDK's application object: the core application ([core]) plus the UI
/// configuration. Create one per app (or per embedding), put it in an
/// `ObaScope`, and dispose it when done.
///
/// ```dart
/// final app = await ObaApplication.create(
///   map: const ObaMapConfig(userAgentPackageName: 'org.example.app'),
///   config: (services) => ObaAppConfig(
///     appName: 'OneBusAway',
///     apiKey: 'org.onebusaway.iphone',
///     appVersion: '1.0.0',
///     keyValueStore: services.keyValueStore,
///     locationProvider: services.locationProvider,
///     placeSearchProvider: services.placeSearchProvider,
///   ),
/// );
/// ```
///
/// Creating one is cheap: no location prompt, no GPS until a visible screen
/// holds a location lease, and no regions download when the config sets
/// `regionsPath: null` (a host with a [FixedRegionConfig] needs nothing
/// else). The regions list defaults to the one bundled with the SDK
/// ([bundledRegionsAssetKey]); `ObaAppConfig.bundledRegionsJson` overrides
/// it.
class ObaApplication {
  ObaApplication({
    required this.core,
    required this.map,
    this.ownsPlaceSearch = false,
  });

  /// Whether [dispose] closes the place search provider (true when
  /// [create] built it).
  final bool ownsPlaceSearch;

  /// The SDK's bundled regions list, an asset of this package. Used when
  /// `ObaAppConfig.bundledRegionsJson` is empty and no downloaded list is
  /// cached yet.
  static const bundledRegionsAssetKey = 'packages/obakit/assets/regions.json';

  /// Reads [bundledRegionsAssetKey]. [create] passes it to the core
  /// application as its `bundledRegionsLoader`; pass it yourself when you
  /// construct `ObaCoreApplication` directly.
  static Future<String> loadBundledRegionsJson() =>
      rootBundle.loadString(bundledRegionsAssetKey);

  /// Builds platform adapters (unless [services] is given), the core
  /// application from [config], and starts it. When [config] has no
  /// `bundledRegionsJson`, the SDK's bundled list is read (only if no
  /// downloaded list is cached).
  static Future<ObaApplication> create({
    required ObaAppConfig Function(ObaPlatformServices services) config,
    required ObaMapConfig map,
    ObaPlatformServices? services,
    String? nominatimUserAgent,
  }) async {
    final s =
        services ??
        await ObaPlatformServices.defaults(
          nominatimUserAgent: nominatimUserAgent,
        );
    final app = ObaApplication(
      core: ObaCoreApplication(
        config(s),
        bundledRegionsLoader: loadBundledRegionsJson,
      ),
      map: map,
      ownsPlaceSearch: services == null,
    );
    await app.start();
    return app;
  }

  final ObaCoreApplication core;
  final ObaMapConfig map;

  bool get isStarted => core.isStarted;

  /// Starts [core] (loads the store, selects a region). Idempotent.
  Future<void> start() => core.start();

  ObaAppConfig get config => core.config;

  /// The trip planner's place search, backed by the configured
  /// [PlaceSearchProvider]; null when there is none.
  late final tp.TripPlaceSearch? tripPlaceSearch =
      config.placeSearchProvider == null
      ? null
      : PlaceSearchTripBridge(
          config.placeSearchProvider!,
          region: () => core.currentRegion?.serviceRect,
        );

  tp.OtpClient? _otp;
  Region? _otpRegion;

  /// An OTP client for the current region (cached until the region
  /// changes), or null when trip planning is off there. It shares the
  /// core application's HTTP client (the host's `ObaAppConfig.httpClient`
  /// when given); closing the OTP client never closes that shared client.
  tp.OtpClient? otpClient() {
    final region = core.currentRegion;
    if (core.tripPlanningStatus != FeatureStatus.running || region == null) {
      return null;
    }
    if (_otp != null && identical(_otpRegion, region)) return _otp;
    _otp?.close();
    _otpRegion = region;
    return _otp = tp.OtpClient.fromRegion(
      otpBaseGraphqlUrl: region.otpBaseGraphqlUrl?.toString(),
      otpBaseUrl: region.otpBaseUrl?.toString(),
      httpClient: core.httpClient,
    );
  }

  void dispose() {
    _otp?.close();
    final search = config.placeSearchProvider;
    if (ownsPlaceSearch && search is NominatimPlaceSearch) search.close();
    core.dispose();
  }
}
