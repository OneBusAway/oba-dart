import 'package:clock/clock.dart';
import 'package:onebusaway/onebusaway.dart';

import '../config/app_config.dart';
import '../foundation/change_notifier.dart';
import '../foundation/json.dart';
import '../platform/key_value_store.dart';
import '../platform/location.dart';

/// Loads the region list, keeps it fresh, and tracks the current region.
/// Port of iOS `RegionsService`.
///
/// The list comes from the cached copy of the last successful download, or
/// the host's bundled file when there is none, and is refreshed from the
/// regions server at most once per [refreshInterval] (or on demand).
///
/// The current region is resolved at construction in this order:
/// 1. the stored region id, unless automatic selection is on and the last
///    known location lies inside a region (then that region wins);
/// 2. location-based selection when automatic selection is on or nothing is
///    stored;
/// 3. [FixedRegionConfig] (name, then OBA base URL), which also turns
///    automatic selection off;
/// 4. the only active region, when there is exactly one;
/// 5. otherwise null: the UI shows the region picker ([needsRegionSelection]).
///
/// Notifies listeners on any change (list, custom regions, current region,
/// automatic flag, refresh state). Listen to [currentRegionListenable] for
/// current-region changes only.
class RegionsService extends ObaChangeNotifier {
  RegionsService({
    required this._store,
    required String bundledRegionsJson,
    this._client,
    ObaLocation? initialLocation,
    FixedRegionConfig? fixedRegion,
    this.refreshInterval = const Duration(days: 1),
  }) : _location = initialLocation {
    final cached = _loadCachedRegions();
    _regions = cached.isNotEmpty ? cached : _parseBundled(bundledRegionsJson);
    _customRegions = _loadCustomRegions();

    final storedId = _store.readInt(currentRegionIdKey);
    Region? current = storedId == null ? null : find(storedId);

    final autoSelect = automaticallySelectRegion || current == null;
    if (autoSelect && _location != null) {
      current = regionContaining(_location!.lat, _location!.lon) ?? current;
    }
    if (current == null && fixedRegion != null) {
      final match =
          _regions.where((r) => r.regionName == fixedRegion.name).firstOrNull ??
          (fixedRegion.obaBaseUrl == null
              ? null
              : _regions
                    .where((r) => r.obaBaseUrl == fixedRegion.obaBaseUrl)
                    .firstOrNull);
      if (match != null) {
        current = match;
        _store.writeJson(automaticallySelectRegionKey, false);
      }
    }
    if (current == null) {
      final active = _regions.where((r) => r.active).toList();
      if (active.length == 1) current = active.single;
    }
    if (current != null && current.id != storedId) {
      _store.writeJson(currentRegionIdKey, current.id);
    }
    _current = ObaValueNotifier(current);
  }

  /// Whether [store] holds a downloaded regions list (which wins over the
  /// bundled one).
  static bool hasCachedRegions(KeyValueStore store) => parseObjects(
    store.readList(cachedRegionsKey),
    Region.fromJson,
  ).isNotEmpty;

  static const currentRegionIdKey = 'oba.regions.currentRegionId';
  static const cachedRegionsKey = 'oba.regions.cachedRegions';
  static const regionsUpdatedAtKey = 'oba.regions.updatedAt';
  static const customRegionsKey = 'oba.regions.customRegions';
  static const automaticallySelectRegionKey =
      'oba.regions.automaticallySelectRegion';

  final KeyValueStore _store;
  final RegionsClient? _client;
  final Duration refreshInterval;

  late List<Region> _regions;
  late List<Region> _customRegions;
  late final ObaValueNotifier<Region?> _current;
  ObaLocation? _location;
  bool _isRefreshing = false;
  Object? _lastRefreshError;

  /// Regions from the server (or the cache / bundled file).
  List<Region> get regions => List.unmodifiable(_regions);

  /// User-defined regions.
  List<Region> get customRegions => List.unmodifiable(_customRegions);

  List<Region> get allRegions => [..._regions, ..._customRegions];

  Region? get currentRegion => _current.value;

  /// Notifies only when [currentRegion] changes.
  ObaValueListenable<Region?> get currentRegionListenable => _current;

  /// True when no region could be chosen and the user must pick one.
  bool get needsRegionSelection => currentRegion == null;

  bool get isRefreshing => _isRefreshing;

  /// The error from the most recent refresh, cleared by a successful one.
  Object? get lastRefreshError => _lastRefreshError;

  bool get lastRefreshFailed => _lastRefreshError != null;

  /// When the cached list was last downloaded, or null if never.
  DateTime? get regionsUpdatedAt =>
      DateTime.tryParse(_store.readStringValue(regionsUpdatedAtKey) ?? '');

  /// The last location this service was told about.
  ObaLocation? get location => _location;

  bool get automaticallySelectRegion =>
      _store.readBool(automaticallySelectRegionKey) ?? true;

  set automaticallySelectRegion(bool value) {
    _store.writeJson(automaticallySelectRegionKey, value);
    if (value) _selectFromLocation();
    notifyListeners();
  }

  /// The region containing the last known location, if any.
  Region? get physicallyLocatedRegion {
    final l = _location;
    return l == null ? null : regionContaining(l.lat, l.lon);
  }

  /// Makes [region] current (a manual choice). Custom regions must have been
  /// added first. No-op when it is already current.
  void setCurrentRegion(Region region) {
    if (region.id == currentRegion?.id && region == currentRegion) return;
    _store.writeJson(currentRegionIdKey, region.id);
    _current.value = region;
    notifyListeners();
  }

  Region? find(int id) =>
      _regions.where((r) => r.id == id).firstOrNull ??
      _customRegions.where((r) => r.id == id).firstOrNull;

  /// The first region (server list, then custom) whose service rect contains
  /// the point.
  Region? regionContaining(double lat, double lon) =>
      allRegions.where((r) => r.contains(lat, lon)).firstOrNull;

  /// Records a new location and, when automatic selection is on, switches to
  /// the region that contains it.
  void updateLocation(ObaLocation location) {
    _location = location;
    _selectFromLocation();
  }

  void _selectFromLocation() {
    if (_location == null || !automaticallySelectRegion) return;
    final region = physicallyLocatedRegion;
    if (region != null && region.id != currentRegion?.id) {
      setCurrentRegion(region);
    }
  }

  /// Whether the cached list is old enough to refresh.
  bool get shouldUpdateRegionList {
    final updated = regionsUpdatedAt;
    if (updated == null) return true;
    return clock.now().difference(updated).abs() >= refreshInterval;
  }

  /// Refreshes the list when it is stale (or always, with [force]). Errors
  /// are recorded in [lastRefreshError] rather than thrown.
  Future<void> updateRegionsList({bool force = false}) async {
    if (!force && !shouldUpdateRegionList) return;
    try {
      await refreshRegions();
    } catch (_) {
      // Recorded in _lastRefreshError.
    }
  }

  /// Downloads the list. Throws on failure. An empty list is ignored.
  Future<void> refreshRegions() async {
    final client = _client;
    if (client == null || _isRefreshing) return;
    _isRefreshing = true;
    notifyListeners();
    try {
      final fetched = await client.fetch();
      _lastRefreshError = null;
      if (fetched.isNotEmpty) {
        _regions = List.of(fetched);
        _store.writeJson(cachedRegionsKey, [
          for (final r in fetched) r.toJson(),
        ]);
        _store.writeJson(regionsUpdatedAtKey, isoDate(clock.now()));
        final current = currentRegion;
        if (current != null && !current.custom) {
          // Pick up server-side changes to the current region; drop it if
          // the server no longer lists it.
          final updated = find(current.id);
          _current.value = updated;
          if (updated == null) _store.writeJson(currentRegionIdKey, null);
        }
        _selectFromLocation();
      }
    } catch (e) {
      _lastRefreshError = e;
      rethrow;
    } finally {
      _isRefreshing = false;
      notifyListeners();
    }
  }

  /// Adds or replaces a custom region (its `custom` flag must be set).
  void addCustomRegion(Region region) {
    if (!region.custom) {
      throw ArgumentError.value(region, 'region', 'is not a custom region');
    }
    _customRegions = [
      for (final r in _customRegions)
        if (r.id != region.id) r,
      region,
    ];
    _saveCustomRegions();
    if (currentRegion?.id == region.id) _current.value = region;
    notifyListeners();
  }

  /// Removes a custom region. Throws [StateError] for the current region.
  void deleteCustomRegion(int id) {
    if (currentRegion?.id == id) {
      throw StateError('Cannot delete the currently selected region');
    }
    _customRegions = [
      for (final r in _customRegions)
        if (r.id != id) r,
    ];
    _saveCustomRegions();
    notifyListeners();
  }

  /// The regions a picker should list: inactive regions are hidden unless
  /// [showInactive], experimental ones unless [showExperimental]. The
  /// current region is always included. Custom regions come last.
  List<Region> visibleRegions({
    bool showExperimental = false,
    bool showInactive = false,
  }) {
    final currentId = currentRegion?.id;
    return [
      ...filterRegions(
        _regions,
        showExperimental: showExperimental,
        showInactive: showInactive,
        alwaysInclude: currentId,
      ),
      ..._customRegions,
    ];
  }

  /// Filters [regions] by the experimental/inactive toggles, keeping the
  /// region with id [alwaysInclude], sorted by name.
  static List<Region> filterRegions(
    Iterable<Region> regions, {
    bool showExperimental = false,
    bool showInactive = false,
    int? alwaysInclude,
  }) =>
      regions
          .where(
            (r) =>
                r.id == alwaysInclude ||
                ((showInactive || r.active) &&
                    (showExperimental || !r.experimental)),
          )
          .toList()
        ..sort(
          (a, b) =>
              a.regionName.toLowerCase().compareTo(b.regionName.toLowerCase()),
        );

  List<Region> _loadCachedRegions() =>
      parseObjects(_store.readList(cachedRegionsKey), Region.fromJson);

  List<Region> _loadCustomRegions() =>
      parseObjects(_store.readList(customRegionsKey), Region.fromJson);

  void _saveCustomRegions() => _store.writeJson(customRegionsKey, [
    for (final r in _customRegions) r.toJson(),
  ]);

  static List<Region> _parseBundled(String json) {
    try {
      return List.of(Region.listFromJson(json));
    } on ObaException {
      return [];
    }
  }

  @override
  void dispose() {
    _current.dispose();
    super.dispose();
  }
}
