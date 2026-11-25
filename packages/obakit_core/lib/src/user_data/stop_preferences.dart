import '../foundation/json.dart';

/// How a stop page orders its departures.
enum StopSort {
  time,
  route;

  static StopSort parse(String? v) =>
      StopSort.values.firstWhere((s) => s.name == v, orElse: () => time);
}

/// Which departures to show, by real-time availability.
enum ArrivalDepartureFilter {
  all,
  estimatedOnly,
  scheduledOnly;

  /// Unknown or missing values become [all], as on iOS.
  static ArrivalDepartureFilter parse(String? v) => ArrivalDepartureFilter
      .values
      .firstWhere((f) => f.name == v, orElse: () => all);
}

/// Per-stop preferences: sort order and hidden routes.
class StopPreferences {
  const StopPreferences({
    this.sortType = StopSort.time,
    this.hiddenRoutes = const [],
  });

  factory StopPreferences.fromJson(JsonObject json) => StopPreferences(
    sortType: StopSort.parse(jString(json, 'sortType')),
    hiddenRoutes: jStringList(json, 'hiddenRoutes'),
  );

  final StopSort sortType;
  final List<String> hiddenRoutes;

  bool get hasHiddenRoutes => hiddenRoutes.isNotEmpty;

  bool isRouteHidden(String routeId) => hiddenRoutes.contains(routeId);

  /// A copy with [routeId] hidden if it was visible, and vice versa.
  StopPreferences toggleRouteHidden(String routeId) => copyWith(
    hiddenRoutes: isRouteHidden(routeId)
        ? [
            for (final r in hiddenRoutes)
              if (r != routeId) r,
          ]
        : [...hiddenRoutes, routeId],
  );

  StopPreferences copyWith({StopSort? sortType, List<String>? hiddenRoutes}) =>
      StopPreferences(
        sortType: sortType ?? this.sortType,
        hiddenRoutes: hiddenRoutes ?? this.hiddenRoutes,
      );

  JsonObject toJson() => {
    'sortType': sortType.name,
    'hiddenRoutes': hiddenRoutes,
  };

  @override
  bool operator ==(Object other) =>
      other is StopPreferences &&
      other.sortType == sortType &&
      _listEq(other.hiddenRoutes, hiddenRoutes);

  @override
  int get hashCode => Object.hash(sortType, Object.hashAll(hiddenRoutes));
}

bool _listEq(List<String> a, List<String> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
