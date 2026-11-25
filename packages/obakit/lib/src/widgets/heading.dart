import 'package:flutter/material.dart';

/// Heading text, marked as a header for screen readers. Defaults to
/// `titleMedium`.
///
/// The heading is a semantics container of its own: otherwise it merges
/// with the text next to it (an empty state's message, a card's body) into
/// one node, and screen-reader heading navigation can't find it.
class ObaHeading extends StatelessWidget {
  const ObaHeading(this.text, {super.key, this.style, this.textAlign});

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    header: true,
    child: Text(
      text,
      style: style ?? Theme.of(context).textTheme.titleMedium,
      textAlign: textAlign,
    ),
  );
}
