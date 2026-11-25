import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import 'sheet_detents.dart';

/// The height of the shell's bottom sheet and its resting points.
///
/// The sheet widget owns it and keeps [maxHeight], [headerHeight] and the
/// top route's [detents] current. Screens rarely need it; when they do
/// (e.g. to expand the sheet when a search field gains focus), read it from
/// `ObaPresentationScope.maybeOf(context)?.sheet` and treat null as "not in
/// a sheet".
class ObaSheetController extends ChangeNotifier {
  ObaSheetController({required TickerProvider vsync})
    : _animation = AnimationController.unbounded(vsync: vsync) {
    _animation.addListener(_onTick);
  }

  final AnimationController _animation;

  double _height = 0;
  double _maxHeight = 0;
  double _headerHeight = 0;
  ObaSheetDetents _detents = ObaSheetDetents.home;
  bool _reduceMotion = false;

  /// Current height in logical pixels.
  double get height => _height;
  double get maxHeight => _maxHeight;
  double get headerHeight => _headerHeight;
  ObaSheetDetents get detents => _detents;

  /// Resolved resting heights, ascending.
  List<double> get snapHeights =>
      _detents.resolve(maxHeight: _maxHeight, headerHeight: _headerHeight);

  double get minHeight => snapHeights.isEmpty ? 0 : snapHeights.first;
  double get maxSnapHeight => snapHeights.isEmpty ? 0 : snapHeights.last;

  bool get canExpand =>
      ObaSheetDetents.step(snapHeights, _height, up: true) != null;
  bool get canCollapse =>
      ObaSheetDetents.step(snapHeights, _height, up: false) != null;

  /// Whether the sheet is at its tallest detent.
  bool get isFullyExpanded => _height >= maxSnapHeight - 0.5;

  /// Whether the sheet is at its collapsed (header-only) detent.
  bool get isCollapsed =>
      _detents.detents.contains(ObaSheetDetent.collapsed) &&
      _height <= minHeight + 0.5;

  /// Disables animation (from `MediaQuery.disableAnimations`).
  set reduceMotion(bool value) => _reduceMotion = value;

  /// Called by the sheet while it builds, so it never notifies.
  void updateMetrics({
    required double maxHeight,
    required double headerHeight,
  }) {
    if (maxHeight == _maxHeight && headerHeight == _headerHeight) return;
    _silent = true;
    try {
      _maxHeight = maxHeight;
      _headerHeight = headerHeight;
      _reresolve();
    } finally {
      _silent = false;
    }
  }

  bool _silent = false;

  /// The detent the sheet rests on (or is animating to); null while it is
  /// being dragged.
  ObaSheetDetent? _resting;
  ObaSheetDetent? get restingDetent => _resting;

  /// Keeps the sheet on its detent when the geometry changes (resize,
  /// text size, a new header). Mid-animation, retargets the animation.
  void _reresolve() {
    if (_maxHeight <= 0) return;
    final resting = _resting;
    if (resting == null) {
      if (_height == 0) {
        _resting = _detents.initial;
        _setHeight(_resolve(_detents.initial));
      } else {
        _setHeight(_height.clamp(minHeight, maxSnapHeight));
      }
      return;
    }
    final target = _resolve(resting);
    if (_animation.isAnimating) {
      if ((_animationTarget - target).abs() > 0.5) {
        // Retarget after this frame (we may be inside build).
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => _animateToDetent(resting),
        );
      }
      return;
    }
    _setHeight(target);
  }

  double _resolve(ObaSheetDetent d) =>
      d.resolve(maxHeight: _maxHeight, headerHeight: _headerHeight);

  /// The detent of [detents] that resolves nearest to [height].
  ObaSheetDetent _nearestDetent(double height) {
    var best = _detents.detents.first;
    for (final d in _detents.detents) {
      if ((_resolve(d) - height).abs() < (_resolve(best) - height).abs()) {
        best = d;
      }
    }
    return best;
  }

  /// Switches to a route's detents and moves to [restore] (when the route
  /// allows it: a pop back to a page that remembers where it was) or to the
  /// route's initial detent.
  void setDetents(ObaSheetDetents detents, {ObaSheetDetent? restore}) {
    _detents = detents;
    final target = restore != null && detents.detents.contains(restore)
        ? restore
        : detents.initial;
    if (_maxHeight <= 0) {
      _resting = target;
      notifyListeners();
      return;
    }
    _animateToDetent(target);
  }

  /// Asks the sheet to re-measure (the top page's header changed).
  void remeasure() => notifyListeners();

  void jumpTo(double height) {
    _animation.stop();
    _resting = _nearestDetent(height);
    _setHeight(height);
  }

  double _animationTarget = 0;

  Future<void> _animateToDetent(
    ObaSheetDetent detent, {
    double velocity = 0,
  }) async {
    _resting = detent;
    final target = _resolve(detent).clamp(0.0, _maxHeight);
    _animationTarget = target;
    if (_reduceMotion) {
      _animation.stop();
      _setHeight(target);
      return;
    }
    _animation.value = _height;
    final spring = SpringDescription.withDampingRatio(
      mass: 1,
      stiffness: 500,
      ratio: 1,
    );
    await _animation.animateWith(
      SpringSimulation(spring, _height, target, velocity),
    );
    // Land exactly on the detent, as resolved now.
    if (identical(_resting, detent)) _setHeight(_resolve(detent));
  }

  /// Animates to the detent nearest [height] (instantly with reduced
  /// motion).
  Future<void> animateTo(double height, {double velocity = 0}) =>
      _animateToDetent(_nearestDetent(height), velocity: velocity);

  /// Moves one detent up. Returns false when already at the top.
  bool expand() {
    final next = ObaSheetDetents.step(snapHeights, _height, up: true);
    if (next == null) return false;
    animateTo(next);
    return true;
  }

  /// Moves one detent down. Returns false when already at the bottom.
  bool collapse() {
    final next = ObaSheetDetents.step(snapHeights, _height, up: false);
    if (next == null) return false;
    animateTo(next);
    return true;
  }

  void expandFully() => animateTo(maxSnapHeight);

  /// Grows the sheet by [delta] pixels (negative shrinks), within its
  /// detents. Returns the amount applied.
  double dragBy(double delta) {
    _animation.stop();
    _resting = null;
    final before = _height;
    _setHeight((_height + delta).clamp(minHeight, maxSnapHeight));
    return _height - before;
  }

  /// Ends a drag: snaps to a detent given the release [velocity] (logical
  /// px/s, positive = growing).
  void settle(double velocity) {
    animateTo(
      ObaSheetDetents.snap(snapHeights, _height, velocity),
      velocity: velocity,
    );
  }

  void _onTick() => _setHeight(_animation.value);

  void _setHeight(double h) {
    if (h == _height) return;
    _height = h;
    if (!_silent) notifyListeners();
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }
}

/// A [ScrollController] whose drags move the sheet first: dragging up grows
/// the sheet until its top detent, and dragging down at the top of the
/// content shrinks it. Each page in the sheet gets its own.
class ObaSheetScrollController extends ScrollController {
  ObaSheetScrollController(this.sheet, {super.debugLabel});

  final ObaSheetController sheet;

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) => _SheetScrollPosition(
    sheet: sheet,
    physics: physics,
    context: context,
    oldPosition: oldPosition,
    debugLabel: debugLabel,
  );
}

class _SheetScrollPosition extends ScrollPositionWithSingleContext {
  _SheetScrollPosition({
    required this.sheet,
    required super.physics,
    required super.context,
    super.oldPosition,
    super.debugLabel,
  });

  final ObaSheetController sheet;
  bool _movedSheet = false;

  @override
  void applyUserOffset(double delta) {
    // delta > 0: finger moving down.
    if (delta < 0 && !sheet.isFullyExpanded) {
      final applied = sheet.dragBy(-delta);
      _movedSheet = true;
      final rest = delta + applied;
      if (rest.abs() > 0.01) super.applyUserOffset(rest);
      return;
    }
    if (delta > 0 &&
        pixels <= minScrollExtent &&
        sheet.height > sheet.minHeight + 0.5) {
      sheet.dragBy(-delta);
      _movedSheet = true;
      return;
    }
    super.applyUserOffset(delta);
  }

  @override
  void goBallistic(double velocity) {
    if (_movedSheet) {
      _movedSheet = false;
      // Scroll velocity is positive when content moves up (the sheet grows).
      sheet.settle(velocity);
      super.goBallistic(0);
      return;
    }
    super.goBallistic(velocity);
  }
}
