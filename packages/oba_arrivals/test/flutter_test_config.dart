import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Largest pixel difference, as a fraction, that a golden may show and still
/// pass. Text anti-aliasing differs slightly between macOS versions (about
/// 0.3% of the panel goldens), so CI runners need not match the machine that
/// generated them. Layout, color, and content changes exceed this easily.
const double goldenTolerance = 0.005;

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final comparator = goldenFileComparator;
  if (comparator is LocalFileComparator) {
    goldenFileComparator = _TolerantComparator(
      // LocalFileComparator resolves goldens against the test file's
      // directory; any file name in that directory works.
      comparator.basedir.resolve('test.dart'),
    );
  }
  await testMain();
}

class _TolerantComparator extends LocalFileComparator {
  _TolerantComparator(super.testFile);

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= goldenTolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}
