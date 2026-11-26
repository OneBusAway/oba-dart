import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app_scope.dart';

/// The outline colour of the embed overlay.
const kEmbedFrameColor = Color(0xFF486621);

/// Wraps one embedded OneBusAway SDK widget. When the "Show OBA embeds"
/// toggle is on, draws a dashed outline around it and a chip naming the SDK
/// widget ("OBA · ObaNearbyStopsCard"). When it is off, [child] renders
/// untouched.
///
/// The chip is a visual aid for people evaluating the SDK, so it is hidden
/// from screen readers and ignores touches.
class EmbedFrame extends StatefulWidget {
  const EmbedFrame({
    super.key,
    required this.sdkWidget,
    required this.child,
    this.visible,
  });

  /// The SDK widget's class name, e.g. `ObaNearbyStopsCard`.
  final String sdkWidget;
  final Widget child;

  /// Overrides the app-wide toggle (tests, or a host without a
  /// [TaplineScope]).
  final ValueListenable<bool>? visible;

  @override
  State<EmbedFrame> createState() => _EmbedFrameState();
}

class _EmbedFrameState extends State<EmbedFrame> {
  // Keeps the SDK widget's state (its controller and data) when the
  // toggle moves it in and out of the frame.
  final _childKey = GlobalKey(debugLabel: 'embed-child');

  @override
  Widget build(BuildContext context) {
    final listenable =
        widget.visible ??
        context.getInheritedWidgetOfExactType<TaplineScope>()?.showEmbeds;
    final keyed = KeyedSubtree(key: _childKey, child: widget.child);
    if (listenable == null) return keyed;
    return ValueListenableBuilder<bool>(
      valueListenable: listenable,
      child: keyed,
      builder: (context, show, child) {
        if (!show) return child!;
        return _Framed(label: 'OBA · ${widget.sdkWidget}', child: child!);
      },
    );
  }
}

class _Framed extends StatelessWidget {
  const _Framed({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    return Stack(
      children: [
        CustomPaint(
          foregroundPainter: _DashedOutlinePainter(
            color: kEmbedFrameColor,
            // On a dark ground the green alone is under 3:1, so draw it
            // over a light halo.
            halo: dark ? Colors.white : null,
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: child,
          ),
        ),
        PositionedDirectional(
          top: 0,
          end: 8,
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: kEmbedFrameColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedOutlinePainter extends CustomPainter {
  _DashedOutlinePainter({required this.color, this.halo});

  final Color color;
  final Color? halo;

  static const _dash = 6.0;
  static const _gap = 4.0;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(1),
      const Radius.circular(8),
    );
    final path = Path()..addRRect(rect);
    final dashed = Path();
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        dashed.addPath(metric.extractPath(d, d + _dash), Offset.zero);
        d += _dash + _gap;
      }
    }
    if (halo != null) {
      canvas.drawPath(
        dashed,
        Paint()
          ..color = halo!
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4,
      );
    }
    canvas.drawPath(
      dashed,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_DashedOutlinePainter old) =>
      old.color != color || old.halo != halo;
}
