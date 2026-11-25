import 'package:flutter/foundation.dart';

/// One resting height of the sheet.
@immutable
sealed class ObaSheetDetent {
  const ObaSheetDetent();

  /// Just the top page's header (drag handle, title or search field and
  /// tabs), measured at the current text size, so it never clips.
  static const collapsed = CollapsedDetent();

  /// Half the available height.
  static const medium = FractionDetent(0.5);

  /// The whole available height (a sliver of map stays visible above it).
  static const large = FractionDetent(1);

  /// Resolves to logical pixels. [maxHeight] is the tallest the sheet may
  /// be; [headerHeight] the measured header of the top page.
  double resolve({required double maxHeight, required double headerHeight});
}

final class FractionDetent extends ObaSheetDetent {
  const FractionDetent(this.fraction) : assert(fraction > 0 && fraction <= 1);
  final double fraction;
  @override
  double resolve({required double maxHeight, required double headerHeight}) =>
      maxHeight * fraction;
  @override
  bool operator ==(Object other) =>
      other is FractionDetent && other.fraction == fraction;
  @override
  int get hashCode => fraction.hashCode;
}

final class HeightDetent extends ObaSheetDetent {
  const HeightDetent(this.height);
  final double height;
  @override
  double resolve({required double maxHeight, required double headerHeight}) =>
      height.clamp(0, maxHeight);
  @override
  bool operator ==(Object other) =>
      other is HeightDetent && other.height == height;
  @override
  int get hashCode => height.hashCode;
}

final class CollapsedDetent extends ObaSheetDetent {
  const CollapsedDetent();
  @override
  double resolve({required double maxHeight, required double headerHeight}) =>
      headerHeight.clamp(0, maxHeight);
  @override
  bool operator ==(Object other) => other is CollapsedDetent;
  @override
  int get hashCode => 0;
}

/// The detents a route allows and the one it opens at (iOS
/// `SheetDetentConfiguration`).
@immutable
class ObaSheetDetents {
  const ObaSheetDetents(this.detents, {required this.initial});

  final List<ObaSheetDetent> detents;
  final ObaSheetDetent initial;

  /// Home: collapsed to the search field and tabs, medium, large.
  static const home = ObaSheetDetents([
    ObaSheetDetent.collapsed,
    ObaSheetDetent.medium,
    ObaSheetDetent.large,
  ], initial: ObaSheetDetent.collapsed);

  /// Stop page: opens at medium so the map shows the stop; can collapse to
  /// its header rather than closing.
  static const stop = ObaSheetDetents([
    ObaSheetDetent.collapsed,
    ObaSheetDetent.medium,
    ObaSheetDetent.large,
  ], initial: ObaSheetDetent.medium);

  /// Trip planner: a header-only tip rung, medium, large; opens at medium.
  static const tripPlanner = stop;

  static const fullOnly = ObaSheetDetents([
    ObaSheetDetent.large,
  ], initial: ObaSheetDetent.large);

  static const mediumLarge = ObaSheetDetents([
    ObaSheetDetent.medium,
    ObaSheetDetent.large,
  ], initial: ObaSheetDetent.medium);

  static const mediumLargeOpenLarge = ObaSheetDetents([
    ObaSheetDetent.medium,
    ObaSheetDetent.large,
  ], initial: ObaSheetDetent.large);

  static const mediumOnly = ObaSheetDetents([
    ObaSheetDetent.medium,
  ], initial: ObaSheetDetent.medium);

  /// Resolved heights, ascending and de-duplicated.
  List<double> resolve({
    required double maxHeight,
    required double headerHeight,
  }) {
    final out = <double>{
      for (final d in detents)
        d.resolve(maxHeight: maxHeight, headerHeight: headerHeight),
    }.toList()..sort();
    return out;
  }

  /// The resolved height to snap to after a drag ends at [height] with
  /// vertical [velocity] (logical px/s, positive = growing). A fling past
  /// [flingVelocity] moves one detent in its direction; otherwise the
  /// nearest detent wins.
  static double snap(
    List<double> heights,
    double height,
    double velocity, {
    double flingVelocity = 700,
  }) {
    if (heights.isEmpty) return height;
    if (velocity.abs() >= flingVelocity) {
      if (velocity > 0) {
        return heights.firstWhere(
          (h) => h > height + 1,
          orElse: () => heights.last,
        );
      }
      return heights.lastWhere(
        (h) => h < height - 1,
        orElse: () => heights.first,
      );
    }
    var best = heights.first;
    for (final h in heights) {
      if ((h - height).abs() < (best - height).abs()) best = h;
    }
    return best;
  }

  /// The next detent above (or below, with [up] false) [height], or null.
  static double? step(List<double> heights, double height, {required bool up}) {
    if (up) {
      for (final h in heights) {
        if (h > height + 1) return h;
      }
      return null;
    }
    for (final h in heights.reversed) {
      if (h < height - 1) return h;
    }
    return null;
  }
}
