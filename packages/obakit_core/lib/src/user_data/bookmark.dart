import 'package:clock/clock.dart';
import 'package:onebusaway/onebusaway.dart';

import '../foundation/json.dart';
import '../foundation/uuid.dart';
import '../search/searchable.dart';
import 'stored_stop.dart';

/// A saved stop, or a saved route + headsign at a stop (a trip bookmark).
/// Immutable; the [UserDataStore] owns ordering and grouping.
class Bookmark {
  const Bookmark({
    required this.id,
    required this.name,
    required this.regionId,
    required this.stop,
    required this.dateCreated,
    this.groupId,
    this.isPinned = false,
    this.sortOrder = 0,
    this.routeShortName,
    this.tripHeadsign,
    this.routeId,
    this.destinationStopId,
    this.destinationStopName,
  });

  /// A stop bookmark.
  factory Bookmark.forStop({
    required String name,
    required int regionId,
    required StoredStop stop,
  }) => Bookmark(
    id: generateUuid(),
    name: name,
    regionId: regionId,
    stop: stop,
    dateCreated: clock.now().toUtc(),
  );

  /// A trip bookmark for the route and headsign of [arrival] at [stop].
  /// [routeShortName] falls back to the arrival's, then to its route id.
  factory Bookmark.forTrip({
    required String name,
    required int regionId,
    required StoredStop stop,
    required ArrivalAndDeparture arrival,
    String? routeShortName,
    StoredStop? destinationStop,
  }) => Bookmark(
    id: generateUuid(),
    name: name,
    regionId: regionId,
    stop: stop,
    dateCreated: clock.now().toUtc(),
    routeShortName: routeShortName ?? arrival.routeShortName ?? arrival.routeId,
    tripHeadsign: arrival.tripHeadsign ?? '',
    routeId: arrival.routeId,
    destinationStopId: destinationStop?.id,
    destinationStopName: destinationStop?.name,
  );

  /// Throws [FormatException] when required fields are missing.
  factory Bookmark.fromJson(JsonObject j) {
    final stopJson = jObject(j, 'stop');
    if (stopJson == null) throw const FormatException('bookmark stop');
    final stop = StoredStop.fromJson(stopJson);
    return Bookmark(
      id: jString(j, 'id') ?? (throw const FormatException('bookmark id')),
      name: jString(j, 'name') ?? stop.name,
      regionId:
          jInt(j, 'regionId') ?? (throw const FormatException('regionId')),
      stop: stop,
      dateCreated:
          jDate(j, 'dateCreated') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      groupId: jString(j, 'groupId'),
      isPinned: jBool(j, 'isPinned') ?? false,
      sortOrder: jInt(j, 'sortOrder') ?? 0,
      routeShortName: jString(j, 'routeShortName'),
      tripHeadsign: jString(j, 'tripHeadsign'),
      routeId: jString(j, 'routeId'),
      destinationStopId: jString(j, 'destinationStopId'),
      destinationStopName: jString(j, 'destinationStopName'),
    );
  }

  final String id;
  final String name;
  final int regionId;
  final StoredStop stop;
  final DateTime dateCreated;
  final String? groupId;
  final bool isPinned;
  final int sortOrder;
  final String? routeShortName;
  final String? tripHeadsign;
  final String? routeId;
  final String? destinationStopId;
  final String? destinationStopName;

  String get stopId => stop.id;

  bool get isTripBookmark =>
      routeShortName != null && routeId != null && tripHeadsign != null;

  bool get hasDestination => isTripBookmark && destinationStopId != null;

  /// The key that matches this bookmark to arrivals; null for stop
  /// bookmarks.
  TripBookmarkKey? get tripKey => isTripBookmark
      ? TripBookmarkKey(
          stopId: stopId,
          routeShortName: routeShortName!,
          routeId: routeId!,
          tripHeadsign: tripHeadsign!,
        )
      : null;

  /// Same user-visible content, ignoring id, group and order (iOS
  /// `isEqualish`). Used to reject duplicates.
  bool isEquivalentTo(Bookmark other) =>
      name == other.name &&
      regionId == other.regionId &&
      stopId == other.stopId &&
      routeShortName == other.routeShortName &&
      tripHeadsign == other.tripHeadsign &&
      routeId == other.routeId &&
      destinationStopId == other.destinationStopId;

  /// Case-insensitive match on route short name, headsign, or the stop.
  bool matchesQuery(String? query) {
    if (query == null) return true;
    final q = query.toLowerCase();
    if (routeShortName?.toLowerCase().contains(q) ?? false) return true;
    if (tripHeadsign?.toLowerCase().contains(q) ?? false) return true;
    return stopMatchesQuery(stop, query);
  }

  Bookmark copyWith({
    String? name,
    StoredStop? stop,
    String? Function()? groupId,
    bool? isPinned,
    int? sortOrder,
  }) => Bookmark(
    id: id,
    name: name ?? this.name,
    regionId: regionId,
    stop: stop ?? this.stop,
    dateCreated: dateCreated,
    groupId: groupId == null ? this.groupId : groupId(),
    isPinned: isPinned ?? this.isPinned,
    sortOrder: sortOrder ?? this.sortOrder,
    routeShortName: routeShortName,
    tripHeadsign: tripHeadsign,
    routeId: routeId,
    destinationStopId: destinationStopId,
    destinationStopName: destinationStopName,
  );

  JsonObject toJson() => {
    'id': id,
    'name': name,
    'regionId': regionId,
    'stop': stop.toJson(),
    'dateCreated': isoDate(dateCreated),
    'groupId': ?groupId,
    'isPinned': isPinned,
    'sortOrder': sortOrder,
    'routeShortName': ?routeShortName,
    'tripHeadsign': ?tripHeadsign,
    'routeId': ?routeId,
    'destinationStopId': ?destinationStopId,
    'destinationStopName': ?destinationStopName,
  };

  @override
  bool operator ==(Object other) =>
      other is Bookmark &&
      other.id == id &&
      other.groupId == groupId &&
      other.sortOrder == sortOrder &&
      other.stop == stop &&
      other.isPinned == isPinned &&
      other.destinationStopName == destinationStopName &&
      other.dateCreated.isAtSameMomentAs(dateCreated) &&
      isEquivalentTo(other);

  @override
  int get hashCode => Object.hash(id, groupId, sortOrder, name, stop);

  @override
  String toString() => 'Bookmark($name, $stopId, group: $groupId)';
}

/// A named, ordered group of bookmarks.
class BookmarkGroup {
  const BookmarkGroup({
    required this.id,
    required this.name,
    required this.sortOrder,
  });

  factory BookmarkGroup.create({required String name, int sortOrder = 0}) =>
      BookmarkGroup(id: generateUuid(), name: name, sortOrder: sortOrder);

  factory BookmarkGroup.fromJson(JsonObject j) => BookmarkGroup(
    id: jString(j, 'id') ?? (throw const FormatException('group id')),
    name: jString(j, 'name') ?? '',
    sortOrder: jInt(j, 'sortOrder') ?? 0,
  );

  final String id;
  final String name;
  final int sortOrder;

  BookmarkGroup copyWith({String? name, int? sortOrder}) => BookmarkGroup(
    id: id,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
  );

  JsonObject toJson() => {'id': id, 'name': name, 'sortOrder': sortOrder};

  @override
  bool operator ==(Object other) =>
      other is BookmarkGroup &&
      other.id == id &&
      other.name == name &&
      other.sortOrder == sortOrder;

  @override
  int get hashCode => Object.hash(id, name, sortOrder);

  @override
  String toString() => 'BookmarkGroup($name)';
}

/// Identifies "this route and headsign at this stop", which is how trip
/// bookmarks find their arrivals.
class TripBookmarkKey {
  const TripBookmarkKey({
    required this.stopId,
    required this.routeShortName,
    required this.routeId,
    required this.tripHeadsign,
  });

  /// The key for [arrival]. [routeShortName] falls back to the arrival's,
  /// then the route id; a missing headsign becomes `''`, as on iOS.
  factory TripBookmarkKey.fromArrival(
    ArrivalAndDeparture arrival, {
    String? routeShortName,
  }) => TripBookmarkKey(
    stopId: arrival.stopId,
    routeShortName: routeShortName ?? arrival.routeShortName ?? arrival.routeId,
    routeId: arrival.routeId,
    tripHeadsign: arrival.tripHeadsign ?? '',
  );

  final String stopId;
  final String routeShortName;
  final String routeId;
  final String tripHeadsign;

  String get routeAndHeadsign => '$routeShortName - $tripHeadsign';

  @override
  bool operator ==(Object other) =>
      other is TripBookmarkKey &&
      other.stopId == stopId &&
      other.routeShortName == routeShortName &&
      other.routeId == routeId &&
      other.tripHeadsign == tripHeadsign;

  @override
  int get hashCode =>
      Object.hash(stopId, routeShortName, routeId, tripHeadsign);

  @override
  String toString() => 'TripBookmarkKey($stopId, $routeAndHeadsign)';
}
