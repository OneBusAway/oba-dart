import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../theme.dart';

/// A fake rotating ticket token. A real fare app gets signed tokens from
/// its backend; this one is derived from the pass id and the 30-second
/// window, so it changes every 30 seconds.
int ticketToken(String passId, DateTime now) {
  final window = now.millisecondsSinceEpoch ~/ 30000;
  return Object.hash(passId, window) & 0x7fffffff;
}

/// A QR-like code drawn from a token. Not a real QR code: it only looks
/// like one. Always dark on white, whatever the theme, so a validator can
/// read it.
class TicketCode extends StatelessWidget {
  const TicketCode({super.key, required this.token, required this.label});

  final int token;

  /// What a screen reader says for the code.
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: label,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: AspectRatio(
          aspectRatio: 1,
          child: CustomPaint(painter: TicketCodePainter(token)),
        ),
      ),
    ),
  );
}

class TicketCodePainter extends CustomPainter {
  TicketCodePainter(this.token);

  final int token;
  static const _modules = 25;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.shortestSide / _modules;
    final dark = Paint()..color = TaplineColors.ink;
    final light = Paint()..color = Colors.white;
    final random = math.Random(token);

    bool inFinder(int x, int y) {
      bool near(int fx, int fy) =>
          x >= fx && x < fx + 8 && y >= fy && y < fy + 8;
      return near(0, 0) || near(_modules - 8, 0) || near(0, _modules - 8);
    }

    for (var y = 0; y < _modules; y++) {
      for (var x = 0; x < _modules; x++) {
        if (inFinder(x, y)) continue;
        if (random.nextBool()) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), dark);
        }
      }
    }
    void finder(int fx, int fy) {
      final o = Offset(fx * cell, fy * cell);
      canvas.drawRect(o & Size.square(cell * 7), dark);
      canvas.drawRect((o + Offset(cell, cell)) & Size.square(cell * 5), light);
      canvas.drawRect(
        (o + Offset(cell * 2, cell * 2)) & Size.square(cell * 3),
        dark,
      );
    }

    finder(0, 0);
    finder(_modules - 7, 0);
    finder(0, _modules - 7);
  }

  @override
  bool shouldRepaint(TicketCodePainter old) => old.token != token;
}

/// Rebuilds [builder] with a new token every 30 seconds.
class RotatingTicketToken extends StatefulWidget {
  const RotatingTicketToken({
    super.key,
    required this.passId,
    required this.now,
    required this.builder,
  });

  final String passId;
  final DateTime Function() now;
  final Widget Function(BuildContext context, int token) builder;

  @override
  State<RotatingTicketToken> createState() => _RotatingTicketTokenState();
}

class _RotatingTicketTokenState extends State<RotatingTicketToken> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scheduleNext();
  }

  // Fires at the next 30-second window boundary, so the code changes when
  // the token does, not up to 30 seconds later.
  void _scheduleNext() {
    final ms = widget.now().millisecondsSinceEpoch % 30000;
    _timer = Timer(Duration(milliseconds: 30000 - ms), () {
      if (!mounted) return;
      setState(() {});
      _scheduleNext();
    });
  }

  @override
  void didUpdateWidget(RotatingTicketToken oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.now != widget.now) {
      _timer?.cancel();
      _scheduleNext();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, ticketToken(widget.passId, widget.now()));
}

/// The "live ticket" cue: a colour band that keeps moving, so a screenshot
/// is easy to tell from the real screen. With reduce motion on, the band is
/// still; the "Live ticket" text and the clock carry the meaning either way.
class LiveTicketBand extends StatefulWidget {
  const LiveTicketBand({super.key});

  @override
  State<LiveTicketBand> createState() => _LiveTicketBandState();
}

class _LiveTicketBandState extends State<LiveTicketBand>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      height: 12,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) => DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: LinearGradient(
              colors: const [
                TaplineColors.teal,
                TaplineColors.saffron,
                TaplineColors.teal,
              ],
              stops: const [0, 0.5, 1],
              transform: _SlideGradient(_controller.value),
              tileMode: TileMode.repeated,
            ),
          ),
        ),
      ),
    ),
  );
}

class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.t);

  final double t;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * t, 0, 0);
}
