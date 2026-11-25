import 'package:onebusaway/onebusaway.dart';

/// One stop of a trip, as the trip page lists it.
class TripStopEntry {
  const TripStopEntry({
    required this.stopId,
    required this.name,
    this.coordinate,
    this.scheduledArrival,
  });

  /// Builds the entries for [details], resolving stop names and positions
  /// from [references] (the stop id stands in for a missing name).
  static List<TripStopEntry> fromTripDetails(
    TripDetails details,
    References references,
  ) => [
    for (final t in details.stopTimes)
      TripStopEntry(
        stopId: t.stopId,
        name: references.stop(t.stopId)?.name ?? t.stopId,
        coordinate: references.stop(t.stopId)?.coordinate,
        scheduledArrival: t.arrivalDate(details.serviceDate),
      ),
  ];

  final String stopId;
  final String name;
  final Coordinate? coordinate;
  final DateTime? scheduledArrival;
}

/// A row of the trip page's stop list.
class TripStopRow {
  const TripStopRow({
    required this.index,
    required this.entry,
    required this.isPassed,
    required this.isVehicleHere,
    required this.isUserStop,
    required this.isBoardingStop,
    required this.isOutsideRide,
    required this.isTerminal,
  });

  final int index;
  final TripStopEntry entry;

  /// Before the vehicle's closest stop.
  final bool isPassed;

  /// The vehicle's closest stop.
  final bool isVehicleHere;

  /// The rider's stop (the shared destination, or the stop they came from).
  final bool isUserStop;

  /// Where the rider boards, when a shared destination is also known.
  final bool isBoardingStop;

  /// Outside the boarding-to-destination ride of a shared trip.
  final bool isOutsideRide;

  /// The last stop of the trip.
  final bool isTerminal;

  String get id => '$index-${entry.stopId}';
}

enum TripStopGroupKind { passed, approaching }

/// A run of stops shown collapsed behind one row ("12 stops").
class TripStopGroup {
  const TripStopGroup({
    required this.id,
    required this.kind,
    required this.start,
    required this.end,
    required this.rows,
  });

  final String id;
  final TripStopGroupKind kind;

  /// Row indices `[start, end)`.
  final int start;
  final int end;
  final List<TripStopRow> rows;

  bool get isPassed => kind == TripStopGroupKind.passed;

  DateTime? get firstDate =>
      rows.map((r) => r.entry.scheduledArrival).nonNulls.firstOrNull;

  DateTime? get lastDate =>
      rows.reversed.map((r) => r.entry.scheduledArrival).nonNulls.firstOrNull;
}

/// An item of the rendered stop list: a stop, or a collapsed run.
sealed class TripStopItem {
  const TripStopItem();
}

class TripStopItemStop extends TripStopItem {
  const TripStopItemStop(this.row);
  final TripStopRow row;
}

class TripStopItemGroup extends TripStopItem {
  const TripStopItemGroup(this.group, {required this.isExpanded});
  final TripStopGroup group;
  final bool isExpanded;
}

/// The trip page's stop list: which stops are passed, where the vehicle
/// is, which stop is the rider's, and which runs collapse. Port of iOS
/// `TripStopListModel`.
class TripStopList {
  const TripStopList({
    required this.rows,
    this.vehicleIndex,
    this.userIndex,
    this.boardingIndex,
  });

  /// Passed runs shorter than this stay expanded.
  static const minimumPassedRun = 2;

  /// Upcoming stops before the rider's stop collapse beyond this many.
  static const maximumApproachingStops = 3;

  /// Builds the list. [userStopId] / [userStopSequence] identify the stop
  /// the rider came from, [closestStopId] the vehicle's position, and
  /// [destinationStopId] the destination of a shared trip.
  factory TripStopList.build(
    List<TripStopEntry> entries, {
    String? userStopId,
    int? userStopSequence,
    String? closestStopId,
    String? destinationStopId,
  }) {
    int? boarding;
    int? destination;
    int? userIndex;
    int? boardingIndex;
    (int, int)? ride;
    if (userStopId != null) {
      boarding = _indexOf(entries, userStopId, userStopSequence);
      destination = _destinationIndex(entries, destinationStopId, boarding);
      userIndex = destination ?? boarding;
      boardingIndex = destination == null ? null : boarding;
      if (boarding != null && destination != null && boarding < destination) {
        ride = (boarding, destination);
      }
    } else if (destinationStopId != null) {
      userIndex = _destinationIndex(entries, destinationStopId, null);
    }
    final vehicleIndex = _vehicleIndex(
      entries,
      closestStopId,
      boarding ?? userIndex,
    );
    final rows = [
      for (var i = 0; i < entries.length; i++)
        TripStopRow(
          index: i,
          entry: entries[i],
          isPassed: vehicleIndex != null && i < vehicleIndex,
          isVehicleHere: i == vehicleIndex,
          isUserStop: i == userIndex,
          isBoardingStop: i == boardingIndex,
          isOutsideRide: ride != null && (i < ride.$1 || i > ride.$2),
          isTerminal: i == entries.length - 1,
        ),
    ];
    return TripStopList(
      rows: rows,
      vehicleIndex: vehicleIndex,
      userIndex: userIndex,
      boardingIndex: boardingIndex,
    );
  }

  final List<TripStopRow> rows;
  final int? vehicleIndex;
  final int? userIndex;
  final int? boardingIndex;

  /// The collapsible runs: passed stops (split around the rider's stops)
  /// and, when the vehicle is far, the stops it still has to pass before
  /// the rider's stop.
  List<TripStopGroup> get groups {
    final v = vehicleIndex;
    if (v == null) return const [];
    final splits = [?boardingIndex, ?userIndex].where((i) => i < v).toList()
      ..sort();
    final List<(String, int, int)> passedRuns = switch (splits.length) {
      0 => [('passed', 0, v)],
      1 => [
        ('passed-before-your-stop', 0, splits[0]),
        ('passed', splits[0] + 1, v),
      ],
      2 => [
        ('passed-before-your-stop', 0, splits[0]),
        ('passed-between-your-stops', splits[0] + 1, splits[1]),
        ('passed', splits[1] + 1, v),
      ],
      _ => const [],
    };
    final groups = [
      for (final r in passedRuns)
        if (r.$3 - r.$2 >= minimumPassedRun)
          _group(r.$1, TripStopGroupKind.passed, r.$2, r.$3),
    ];
    final b = boardingIndex;
    final u = userIndex;
    if (b != null && v < b) {
      if (b - v - 1 > maximumApproachingStops) {
        groups.add(
          _group(
            'approaching-boarding',
            TripStopGroupKind.approaching,
            v + 1,
            b,
          ),
        );
      }
      if (u != null && u - b - 1 > maximumApproachingStops) {
        groups.add(
          _group('approaching', TripStopGroupKind.approaching, b + 1, u),
        );
      }
    } else if (u != null && u - v - 1 > maximumApproachingStops) {
      groups.add(
        _group('approaching', TripStopGroupKind.approaching, v + 1, u),
      );
    }
    return groups;
  }

  /// The rows to render, with the groups in [expanded] (by id) opened.
  List<TripStopItem> items({Set<String> expanded = const {}}) {
    final out = <TripStopItem>[];
    var next = 0;
    for (final g in groups) {
      for (var i = next; i < g.start; i++) {
        out.add(TripStopItemStop(rows[i]));
      }
      final open = expanded.contains(g.id);
      out.add(TripStopItemGroup(g, isExpanded: open));
      if (open) out.addAll(g.rows.map(TripStopItemStop.new));
      next = g.end;
    }
    for (var i = next; i < rows.length; i++) {
      out.add(TripStopItemStop(rows[i]));
    }
    return out;
  }

  TripStopGroup _group(String id, TripStopGroupKind kind, int start, int end) =>
      TripStopGroup(
        id: id,
        kind: kind,
        start: start,
        end: end,
        rows: rows.sublist(start, end),
      );

  static int? _indexOf(List<TripStopEntry> entries, String stopId, int? seq) {
    if (seq != null &&
        seq >= 0 &&
        seq < entries.length &&
        entries[seq].stopId == stopId) {
      return seq;
    }
    final i = entries.indexWhere((e) => e.stopId == stopId);
    return i < 0 ? null : i;
  }

  static int? _destinationIndex(
    List<TripStopEntry> entries,
    String? destinationStopId,
    int? boardingIndex,
  ) {
    if (destinationStopId == null) return null;
    final start = boardingIndex == null
        ? 0
        : (boardingIndex + 1).clamp(0, entries.length);
    for (var i = start; i < entries.length; i++) {
      if (entries[i].stopId == destinationStopId) return i;
    }
    return null;
  }

  static int? _vehicleIndex(
    List<TripStopEntry> entries,
    String? closestStopId,
    int? userIndex,
  ) {
    if (closestStopId == null) return null;
    if (userIndex != null) {
      for (var i = userIndex; i >= 0; i--) {
        if (entries[i].stopId == closestStopId) return i;
      }
    }
    final i = entries.indexWhere((e) => e.stopId == closestStopId);
    return i < 0 ? null : i;
  }
}
