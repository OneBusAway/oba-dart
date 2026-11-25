import '../foundation/change_notifier.dart';
import '../platform/key_value_store.dart';
import '../user_data/stop_preferences.dart';

/// Walking-speed presets offered in Settings, in metres per second.
enum WalkingSpeedPreset {
  slow(0.9),
  average(1.4),
  fast(1.8);

  const WalkingSpeedPreset(this.metersPerSecond);

  final double metersPerSecond;

  /// The preset equal to [speed], or null for a custom (synced) speed.
  static WalkingSpeedPreset? matching(double speed) => WalkingSpeedPreset.values
      .where((p) => (p.metersPerSecond - speed).abs() < 0.001)
      .firstOrNull;
}

/// Where a stored speed came from.
enum SpeedSource { manual, synced }

enum MapType { standard, satellite, hybrid }

/// Which app opens walking directions.
enum WalkingDirectionsProvider { askEveryTime, appleMaps, googleMaps }

/// Typed, persisted user settings. Every setter that changes a value calls
/// [notifyListeners]. Values out of range are clamped, unknown enum values
/// fall back to the default.
class ObaSettings extends ObaChangeNotifier {
  ObaSettings(
    this._store, {
    this.defaultArrivalDepartureFilter = ArrivalDepartureFilter.all,
  });

  final KeyValueStore _store;

  /// The white-label default for [arrivalDepartureFilter].
  final ArrivalDepartureFilter defaultArrivalDepartureFilter;

  static const _p = 'oba.settings.';

  static const defaultWalkingSpeed = 1.4;
  static const walkingSpeedMin = 0.5;
  static const walkingSpeedMax = 5.0;
  static const defaultBikeSpeed = 4.2;
  static const bikeSpeedMin = 2.0;
  static const bikeSpeedMax = 20.0;
  static const defaultAlarmLeadTime = 10;

  T _get<T>(String key, T fallback) {
    final v = _store.readJson('$_p$key');
    if (v is T) return v;
    if (fallback is double && v is num) return v.toDouble() as T;
    return fallback;
  }

  void _set(String key, Object? value) {
    if (_store.readJson('$_p$key') == value) return;
    _store.writeJson('$_p$key', value);
    notifyListeners();
  }

  E _enum<E extends Enum>(String key, List<E> values, E fallback) {
    final name = _get<String?>(key, null);
    return values.where((v) => v.name == name).firstOrNull ?? fallback;
  }

  // -- Departures -------------------------------------------------------------

  /// The user's choice, or the white-label default.
  ArrivalDepartureFilter get arrivalDepartureFilter => _enum(
    'arrivalDepartureFilter',
    ArrivalDepartureFilter.values,
    defaultArrivalDepartureFilter,
  );

  set arrivalDepartureFilter(ArrivalDepartureFilter v) =>
      _set('arrivalDepartureFilter', v.name);

  // -- Travel speed -------------------------------------------------------------

  double get walkingSpeedMetersPerSecond => _get(
    'walkingSpeed',
    defaultWalkingSpeed,
  ).clamp(walkingSpeedMin, walkingSpeedMax);

  set walkingSpeedMetersPerSecond(double v) =>
      _set('walkingSpeed', v.clamp(walkingSpeedMin, walkingSpeedMax));

  WalkingSpeedPreset? get walkingSpeedPreset =>
      WalkingSpeedPreset.matching(walkingSpeedMetersPerSecond);

  set walkingSpeedPreset(WalkingSpeedPreset? preset) {
    if (preset == null) return;
    walkingSpeedMetersPerSecond = preset.metersPerSecond;
    walkingSpeedSource = SpeedSource.manual;
  }

  SpeedSource get walkingSpeedSource =>
      _enum('walkingSpeedSource', SpeedSource.values, SpeedSource.manual);

  set walkingSpeedSource(SpeedSource v) => _set('walkingSpeedSource', v.name);

  bool get bikeModeEnabled => _get('bikeModeEnabled', false);

  set bikeModeEnabled(bool v) => _set('bikeModeEnabled', v);

  double get bikeSpeedMetersPerSecond =>
      _get('bikeSpeed', defaultBikeSpeed).clamp(bikeSpeedMin, bikeSpeedMax);

  set bikeSpeedMetersPerSecond(double v) =>
      _set('bikeSpeed', v.clamp(bikeSpeedMin, bikeSpeedMax));

  SpeedSource get bikeSpeedSource =>
      _enum('bikeSpeedSource', SpeedSource.values, SpeedSource.manual);

  set bikeSpeedSource(SpeedSource v) => _set('bikeSpeedSource', v.name);

  /// Bike speed in bike mode, otherwise walking speed.
  double get effectiveTravelSpeedMetersPerSecond =>
      bikeModeEnabled ? bikeSpeedMetersPerSecond : walkingSpeedMetersPerSecond;

  // -- Map ----------------------------------------------------------------------

  MapType get mapType => _enum('mapType', MapType.values, MapType.standard);

  set mapType(MapType v) => _set('mapType', v.name);

  bool get mapShowsScale => _get('mapShowsScale', true);

  set mapShowsScale(bool v) => _set('mapShowsScale', v);

  bool get mapShowsHeading => _get('mapShowsHeading', true);

  set mapShowsHeading(bool v) => _set('mapShowsHeading', v);

  bool get mapShowsStopLabels => _get('mapShowsStopLabels', true);

  set mapShowsStopLabels(bool v) => _set('mapShowsStopLabels', v);

  WalkingDirectionsProvider get walkingDirectionsProvider => _enum(
    'walkingDirectionsProvider',
    WalkingDirectionsProvider.values,
    WalkingDirectionsProvider.askEveryTime,
  );

  set walkingDirectionsProvider(WalkingDirectionsProvider v) =>
      _set('walkingDirectionsProvider', v.name);

  // -- Display ------------------------------------------------------------------

  bool get reducedColors => _get('reducedColors', false);

  set reducedColors(bool v) => _set('reducedColors', v);

  bool get compactMode => _get('compactMode', false);

  set compactMode(bool v) => _set('compactMode', v);

  /// Show times in the region's time zone rather than the device's.
  bool get showRegionTimeZone => _get('showRegionTimeZone', false);

  set showRegionTimeZone(bool v) => _set('showRegionTimeZone', v);

  /// Region picker toggles.
  bool get showExperimentalRegions => _get('showExperimentalRegions', false);

  set showExperimentalRegions(bool v) => _set('showExperimentalRegions', v);

  bool get showInactiveRegions => _get('showInactiveRegions', false);

  set showInactiveRegions(bool v) => _set('showInactiveRegions', v);

  // -- Privacy and debugging -----------------------------------------------------

  /// Defaults to on, as on iOS.
  bool get analyticsReportingEnabled => _get('analyticsReportingEnabled', true);

  set analyticsReportingEnabled(bool v) => _set('analyticsReportingEnabled', v);

  bool get debugMode => _get('debugMode', false);

  set debugMode(bool v) => _set('debugMode', v);

  // -- Alarms -------------------------------------------------------------------

  int get defaultAlarmLeadTimeMinutes =>
      _get<int>('defaultAlarmLeadTime', defaultAlarmLeadTime).clamp(1, 120);

  set defaultAlarmLeadTimeMinutes(int v) =>
      _set('defaultAlarmLeadTime', v.clamp(1, 120));

  // -- Onboarding -----------------------------------------------------------------

  /// The version of onboarding step [step] the user last saw (0: never).
  int onboardingSeenVersion(String step) {
    final map = _store.readMap('${_p}onboardingSeenVersions');
    final v = map[step];
    return v is num ? v.toInt() : 0;
  }

  /// Whether [step] at [version] still needs showing.
  bool needsOnboardingStep(String step, int version) =>
      onboardingSeenVersion(step) < version;

  void markOnboardingStepSeen(String step, int version) {
    final map = {..._store.readMap('${_p}onboardingSeenVersions')};
    if (map[step] == version) return;
    map[step] = version;
    _store.writeJson('${_p}onboardingSeenVersions', map);
    notifyListeners();
  }

  // -- Feature flags --------------------------------------------------------------

  /// Cluster stop pins on the map (iOS `FeatureFlags.clustersStopsKey`). Off
  /// by default.
  bool get clustersStops => _get('featureFlags.clustersStops', false);

  set clustersStops(bool v) => _set('featureFlags.clustersStops', v);
}
