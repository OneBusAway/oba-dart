import 'package:flutter/material.dart';

import '../data/student.dart';
import '../theme.dart';

/// The student's ID card: name, PID and a scannable-looking barcode.
///
/// Screen readers hear the card as one sentence, and the barcode as an
/// image with a label.
class StudentIdCard extends StatelessWidget {
  const StudentIdCard({super.key, required this.student});

  final Student student;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const onNavy = Colors.white;
    return Card(
      color: Brand.navy,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(height: 8, color: Brand.gold),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  container: true,
                  header: true,
                  child: Text(
                    'Student ID',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: Brand.gold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  student.fullName,
                  style: theme.textTheme.headlineSmall?.copyWith(color: onNavy),
                ),
                Text(
                  student.program,
                  style: theme.textTheme.bodyMedium?.copyWith(color: onNavy),
                ),
                const SizedBox(height: 4),
                Text(
                  'PID ${student.pid}',
                  style: theme.textTheme.titleMedium?.copyWith(color: onNavy),
                ),
                const SizedBox(height: 16),
                Semantics(
                  container: true,
                  image: true,
                  label: 'Barcode for student ID ${student.pid}',
                  child: ExcludeSemantics(
                    child: Container(
                      // Always black on white, so scanners can read it in
                      // dark mode too.
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: SizedBox(
                        height: 64,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: BarcodePainter(student.pid),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws a barcode-like pattern from [data]. Decorative in this demo: a
/// real app would render a proper symbology (Code 128, PDF417) for its
/// card readers.
class BarcodePainter extends CustomPainter {
  const BarcodePainter(this.data);

  final String data;

  /// Bar widths in modules, alternating bar and space, for every
  /// character.
  List<int> get _modules {
    final out = <int>[2, 1, 1, 2]; // start guard
    for (final unit in data.codeUnits) {
      for (var i = 0; i < 3; i++) {
        out
          ..add(1 + (unit >> (i * 2)) % 3)
          ..add(1 + (unit >> (i + 1)) % 2);
      }
    }
    return out..addAll(const [2, 1, 1, 2]); // stop guard
  }

  @override
  void paint(Canvas canvas, Size size) {
    final modules = _modules;
    final total = modules.fold<int>(0, (a, b) => a + b);
    final unit = size.width / total;
    final paint = Paint()..color = Colors.black;
    var x = 0.0;
    for (var i = 0; i < modules.length; i++) {
      final w = modules[i] * unit;
      if (i.isEven) canvas.drawRect(Rect.fromLTWH(x, 0, w, size.height), paint);
      x += w;
    }
  }

  @override
  bool shouldRepaint(BarcodePainter oldDelegate) => oldDelegate.data != data;
}
