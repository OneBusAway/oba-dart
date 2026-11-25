import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:onebusaway/onebusaway.dart';

import '../alerts/service_alerts.dart';
import '../config/app_config.dart';
import '../deep_links/deep_link_router.dart';
import '../format/formatters.dart';
import '../foundation/change_notifier.dart';
import '../platform/analytics.dart';
import '../platform/key_value_store.dart';
import '../platform/location.dart';
import '../platform/location_service.dart';
import '../prompts/prompts.dart';
import '../foundation/uuid.dart';
import '../regions/regions_service.dart';
import '../search/search_service.dart';
import '../services/alarm_service.dart';
import '../services/fare_payments.dart';
import '../services/problem_report_service.dart';
import '../settings/settings.dart';
import '../surveys/survey_service.dart';
import '../user_data/user_data_store.dart';

/// Whether an optional feature can be used (iOS `FeatureStatus`).
enum FeatureStatus {
  /// Not available in this app or region.
  off,

  /// Available, but not set up yet (may become [running]).
  notRunning,

  /// Ready.
  running,
}

/// The API clients for the current region. Replaced as a whole when the
/// region changes; the previous instance is closed.
class RegionClients {
  const RegionClients({required this.region, required this.rest, this.obaco});

  final Region region;
  final OneBusAwayClient rest;

  /// Null when the region has no sidecar (Obaco) server.
  final ObacoClient? obaco;
}

/// Owns the stores and services of a OneBusAway app. Port of iOS
/// `CoreApplication` plus the non-UI parts of `Application`.
///
/// ```dart
/// final app = ObaCoreApplication(config);
/// await app.start();          // loads the store; required before use
/// app.regions.currentRegion;  // ...
/// app.dispose();
/// ```
///
/// Notifies listeners when the region clients change, when the location
/// permission changes, and when feature availability may have changed. Each
/// store/service has its own listeners for its own state (listen to
/// [locationListenable] for location fixes).
///
/// Location is demand-driven ([locationService]): [start] never subscribes
/// to the device's position stream. A screen that needs live location
/// holds a lease ([LocationService.acquire]) while it is visible.
///
/// [bundledRegionsLoader] supplies the regions list when the config has
/// none (`bundledRegionsJson` empty) and nothing is cached yet; `obakit`
/// passes one that reads its bundled asset.
class ObaCoreApplication extends ObaChangeNotifier {
  ObaCoreApplication(this.config, {this.bundledRegionsLoader})
    : _ownsHttp = config.httpClient == null,
      httpClient = config.httpClient ?? http.Client(),
      locationService = LocationService(config.locationProvider);

  final ObaAppConfig config;

  /// Loads a default regions list (an OBA envelope with `data.list`) when
  /// [ObaAppConfig.bundledRegionsJson] is empty. Called at most once, in
  /// [start], and only when no downloaded list is cached.
  final Future<String> Function()? bundledRegionsLoader;

  /// Device location, subscribed only while a lease is held.
  final LocationService locationService;

  /// The HTTP client every API client shares.
  final http.Client httpClient;
  final bool _ownsHttp;

  static const userUuidKey = 'oba.app.userUUID';

  late final ObaSettings settings;
  late final UserDataStore userData;
  late final RegionsService regions;
  late final SearchService search;
  late final AlarmService alarms;
  late final ProblemReportService problemReports;
  late final SurveyService surveys;
  late final ServiceAlertTracker alerts;
  late final FarePayments farePayments;
  late final ReviewPromptPolicy reviewPrompt;
  late final DonationPromptState donationPrompt;
  late final PromptCoordinator prompts;
  late final DeepLinkRouter deepLinks = DeepLinkRouter(
    scheme: config.urlScheme,
  );
  final ObaFormatters formatters = const ObaFormatters();

  final ObaValueNotifier<RegionClients?> _clients = ObaValueNotifier(null);
  final ObaValueNotifier<String?> _regionTimeZone = ObaValueNotifier(null);
  bool _started = false;
  int _timeZoneGeneration = 0;

  bool get isStarted => _started;

  KeyValueStore get store => config.keyValueStore;
  LocationProvider get locationProvider => config.locationProvider;
  ObaAnalytics get analytics => config.analytics ?? _noop;
  static final ObaAnalytics _noop = NoopAnalytics();

  /// Loads persisted state, builds the services, selects a region, builds
  /// its clients, and starts a regions refresh (not awaited; await
  /// [regions].updateRegionsList yourself if you need it). Call once.
  Future<void> start() async {
    if (_started) return;
    await store.load();
    settings = ObaSettings(
      store,
      defaultArrivalDepartureFilter: config.defaultArrivalDepartureFilter,
    );
    userData = UserDataStore(store);
    locationService.readLastKnown();
    final lastKnown = locationService.currentLocation;
    regions = RegionsService(
      store: store,
      bundledRegionsJson: await _regionsJson(),
      client: config.regionsPath == null
          ? null
          : RegionsClient(
              baseUrl: config.regionsBaseUrl,
              path: config.regionsPath!,
              httpClient: httpClient,
            ),
      initialLocation: lastKnown,
      fixedRegion: config.fixedRegion,
      refreshInterval: config.regionsRefreshInterval,
    );
    search = SearchService(
      client: () => restClient,
      region: () => currentRegion,
      obaco: () => obacoClient,
      placeSearchProvider: config.placeSearchProvider,
      userData: userData,
      analytics: config.analytics,
    );
    alarms = AlarmService(
      obaco: () => obacoClient,
      region: () => currentRegion,
      userData: userData,
      pushServiceProvider: config.pushServiceProvider,
    );
    problemReports = ProblemReportService(
      client: () => restClient,
      obaco: () => obacoClient,
      currentLocation: () => locationService.currentLocation,
      userId: () => userUuid,
      analytics: config.analytics,
    );
    surveys = SurveyService(
      obaco: () => obacoClient,
      userData: userData,
      regionId: () => currentRegion?.id,
      currentLocation: () => locationService.currentLocation?.coordinate,
    );
    alerts = ServiceAlertTracker(userData);
    farePayments = FarePayments(store);
    reviewPrompt = ReviewPromptPolicy(
      store,
      appVersion: config.appVersion,
      enabled: config.feedbackPromptEnabled,
      canReview: config.appStoreId != null || config.playStoreId != null,
    );
    donationPrompt = DonationPromptState(
      store,
      enabled: config.donations.enabled,
      appLaunchCount: () => userData.appLaunchCount,
    );
    prompts = PromptCoordinator(store);

    userData.incrementAppLaunchCount();
    userData.deleteExpiredAlarms();
    analytics.setReportingEnabled(settings.analyticsReportingEnabled);
    settings.addListener(_onSettingsChanged);
    regions.currentRegionListenable.addListener(_onRegionChanged);
    locationService.locationListenable.addListener(_onLocation);
    locationService.addListener(notifyListeners);
    _started = true;
    _rebuildClients();

    final permission = await locationService.checkPermission();
    // Automatic region selection with no fix to go on: one fix, no
    // continuous updates.
    if (permission.isGranted &&
        regions.automaticallySelectRegion &&
        locationService.currentLocation == null) {
      unawaited(locationService.requestFix());
    }
    unawaited(regions.updateRegionsList());
    notifyListeners();
  }

  Future<String> _regionsJson() async {
    final given = config.bundledRegionsJson;
    final loader = bundledRegionsLoader;
    if (given.trim().isNotEmpty ||
        loader == null ||
        RegionsService.hasCachedRegions(store)) {
      return given;
    }
    try {
      return await loader();
    } catch (_) {
      // No bundled list: a cached or downloaded one, or a custom region,
      // still works.
      return given;
    }
  }

  // -- Region and clients ---------------------------------------------------------

  Region? get currentRegion => regions.currentRegion;

  /// Notifies when the region's clients are rebuilt.
  ObaValueListenable<RegionClients?> get clientsListenable => _clients;

  RegionClients? get clients => _clients.value;

  /// The OBA REST client for the current region; null before a region is
  /// chosen.
  OneBusAwayClient? get restClient => _clients.value?.rest;

  /// The Obaco client; null when the region has no sidecar.
  ObacoClient? get obacoClient => _clients.value?.obaco;

  void _onRegionChanged() {
    _rebuildClients();
    final region = currentRegion;
    if (region != null) analytics.updateServer(region);
    notifyListeners();
  }

  void _rebuildClients() {
    final region = currentRegion;
    final old = _clients.value;
    if (region == null) {
      _clients.value = null;
    } else if (old == null || old.region != region) {
      final sidecar = region.sidecarBaseUrl;
      _clients.value = RegionClients(
        region: region,
        rest: OneBusAwayClient(
          baseUrl: region.obaBaseUrl,
          apiKey: config.apiKey,
          httpClient: httpClient,
        ),
        obaco: sidecar == null
            ? null
            : ObacoClient(
                baseUrl: sidecar,
                regionId: region.id,
                httpClient: httpClient,
                apiKey: config.apiKey,
                appVersion: config.appVersion,
                appUid: userUuid,
                operatingSystem: config.operatingSystem,
                apnsSandbox: config.apnsSandbox,
              ),
      );
    }
    if (!identical(old, _clients.value)) {
      old?.rest.close();
      old?.obaco?.close();
    }
    _refreshRegionTimeZone();
  }

  // -- Location ---------------------------------------------------------------------

  LocationPermissionStatus get locationPermission => locationService.permission;

  /// False when the host gave the SDK no location ([NoLocationProvider]).
  bool get isLocationAvailable => locationService.isAvailable;

  /// The latest known location.
  ObaValueListenable<ObaLocation?> get locationListenable =>
      locationService.locationListenable;

  /// The last known location. Reading it never starts the GPS.
  ObaLocation? get currentLocation => locationService.currentLocation;

  /// Claims live location updates until the lease is released (see
  /// [LocationService.acquire]).
  LocationLease acquireLocation() => locationService.acquire();

  /// Asks for location permission and, when granted, takes one fix (which
  /// also drives automatic region selection). Continuous updates run only
  /// while a screen holds a lease.
  Future<LocationPermissionStatus> requestLocationPermission() async {
    final status = await locationService.requestPermission();
    notifyListeners();
    return status;
  }

  void _onLocation() {
    final location = locationService.currentLocation;
    if (location != null) regions.updateLocation(location);
  }

  // -- Region time zone --------------------------------------------------------------

  /// The IANA time zone the region's agencies use most, when
  /// [ObaSettings.showRegionTimeZone] is on and it has been resolved;
  /// otherwise null (use the device zone).
  ObaValueListenable<String?> get regionTimeZoneListenable => _regionTimeZone;

  String? get regionTimeZone => _regionTimeZone.value;

  void _onSettingsChanged() {
    analytics.setReportingEnabled(settings.analyticsReportingEnabled);
    _refreshRegionTimeZone();
  }

  Future<void> _refreshRegionTimeZone() async {
    final generation = ++_timeZoneGeneration;
    final client = restClient;
    if (!settings.showRegionTimeZone || client == null) {
      _regionTimeZone.value = null;
      return;
    }
    try {
      final response = await client.agencies.withCoverage();
      if (generation != _timeZoneGeneration) return;
      _regionTimeZone.value = preferredTimeZone([
        for (final a in response.list)
          ?response.references.agency(a.agencyId)?.timezone,
      ]);
    } catch (_) {
      if (generation == _timeZoneGeneration) _regionTimeZone.value = null;
    }
  }

  /// The most common identifier, ties broken alphabetically (iOS
  /// `preferredScheduleTimeZone`).
  static String? preferredTimeZone(Iterable<String> identifiers) {
    final counts = <String, int>{};
    for (final id in identifiers) {
      if (id.isEmpty) continue;
      counts[id] = (counts[id] ?? 0) + 1;
    }
    if (counts.isEmpty) return null;
    final max = counts.values.reduce((a, b) => a > b ? a : b);
    return (counts.entries
            .where((e) => e.value == max)
            .map((e) => e.key)
            .toList()
          ..sort())
        .first;
  }

  // -- Identity ---------------------------------------------------------------------

  /// A random, stable per-install identifier.
  String get userUuid {
    final existing = store.readStringValue(userUuidKey);
    if (existing != null) return existing;
    final id = generateUuid();
    store.writeJson(userUuidKey, id);
    return id;
  }

  // -- Feature availability ------------------------------------------------------------

  FeatureStatus get obacoStatus {
    if (currentRegion?.sidecarBaseUrl == null) return FeatureStatus.off;
    return obacoClient == null
        ? FeatureStatus.notRunning
        : FeatureStatus.running;
  }

  FeatureStatus get pushStatus {
    final push = config.pushServiceProvider;
    if (push == null) return FeatureStatus.off;
    return push.isAvailable ? FeatureStatus.running : FeatureStatus.notRunning;
  }

  /// Sharing links need the region's sidecar server.
  FeatureStatus get deepLinkingStatus => currentRegion?.sidecarBaseUrl == null
      ? FeatureStatus.off
      : FeatureStatus.running;

  /// OTP trip planning: the region must support it and the user must not
  /// have switched it off for the region.
  FeatureStatus get tripPlanningStatus {
    final region = currentRegion;
    if (region == null || !region.supportsOtp) return FeatureStatus.off;
    return userData.isTripPlanningEnabled(region.id)
        ? FeatureStatus.running
        : FeatureStatus.off;
  }

  /// Alarms need push and Obaco.
  bool get alarmsAvailable => alarms.isAvailable;

  // -- Lifecycle ----------------------------------------------------------------------

  @override
  void dispose() {
    if (_started) {
      locationService.locationListenable.removeListener(_onLocation);
      locationService.removeListener(notifyListeners);
      settings.removeListener(_onSettingsChanged);
      regions.currentRegionListenable.removeListener(_onRegionChanged);
      regions.dispose();
      settings.dispose();
      userData.dispose();
      surveys.dispose();
    }
    final c = _clients.value;
    c?.rest.close();
    c?.obaco?.close();
    _clients.dispose();
    locationService.dispose();
    _regionTimeZone.dispose();
    if (_ownsHttp) httpClient.close();
    super.dispose();
  }
}
