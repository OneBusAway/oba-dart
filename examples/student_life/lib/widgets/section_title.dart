import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart' show ObaHeading;

/// A heading between feed cards, marked as a header for screen readers.
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 4),
    child: ObaHeading(text, style: Theme.of(context).textTheme.titleLarge),
  );
}
