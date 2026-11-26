import 'package:flutter/material.dart';

import '../settings.dart';

/// Marks one embedded OneBusAway SDK widget.
///
/// With "Show OBA embeds" off (the default) it returns [child] untouched.
/// With it on, it draws a dashed outline around the child and a label chip
/// naming the SDK widget ("OBA · ObaStopDeparturesCard"), so a reviewer can
/// see which parts of a screen come from the SDK. The chip is a visual aid
/// only and is hidden from screen readers.
///
/// Toggling keeps the SDK widget's state (a [GlobalKey] moves it into and
/// out of the frame), so it never reloads or restarts polling.
class EmbedFrame extends StatefulWidget {
  const EmbedFrame({
    super.key,
    required this.sdkWidget,
    required this.child,
    this.fills = false,
  });

  /// The SDK widget's class name, shown in the chip.
  final String sdkWidget;
  final Widget child;

  /// Whether [child] fills a bounded space (a page, the map) rather than
  /// sizing to its content (a card or section in a feed).
  final bool fills;

  static const color = Color(0xFF486621);

  @override
  State<EmbedFrame> createState() => _EmbedFrameState();
}

class _EmbedFrameState extends State<EmbedFrame> {
  final _childKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final show = SettingsScope.maybeOf(context)?.showObaEmbeds;
    if (show == null) return widget.child;
    final fills = widget.fills;
    return ValueListenableBuilder<bool>(
      valueListenable: show,
      child: KeyedSubtree(key: _childKey, child: widget.child),
      builder: (context, visible, child) {
        if (!visible) return child!;
        return CustomPaint(
          foregroundPainter: const _DashedOutlinePainter(
            color: EmbedFrame.color,
          ),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: fills ? MainAxisSize.max : MainAxisSize.min,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ExcludeSemantics(
                    child: _Chip(label: widget.sdkWidget),
                  ),
                ),
                if (fills) Expanded(child: child!) else child!,
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => DecoratedBox(
    key: const ValueKey('embed-frame-chip'),
    decoration: BoxDecoration(
      color: EmbedFrame.color,
      borderRadius: BorderRadius.circular(4),
    ),
    child: Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 6,
        vertical: 2,
      ),
      child: Text(
        'OBA · $label',
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: Colors.white),
      ),
    ),
  );
}

class _DashedOutlinePainter extends CustomPainter {
  const _DashedOutlinePainter({required this.color});

  final Color color;
  static const _dash = 6.0;
  static const _gap = 4.0;
  static const _stroke = 2.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _stroke
      ..style = PaintingStyle.stroke;
    final rect = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(_stroke / 2),
      const Radius.circular(8),
    );
    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + _dash).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += _dash + _gap;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedOutlinePainter oldDelegate) =>
      oldDelegate.color != color;
}
