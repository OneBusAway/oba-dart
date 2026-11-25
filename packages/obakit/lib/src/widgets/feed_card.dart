import 'package:flutter/material.dart';

/// The container the SDK's feed cards share (`ObaNearbyStopsCard`,
/// `ObaBookmarksCard`): a Material [Card] themed by the host's `CardTheme`
/// (colour, shape, elevation, margin, clip), with 8dp below the content.
/// The content starts with an `ObaSectionHeader`, the card's heading.
class ObaFeedCard extends StatelessWidget {
  const ObaFeedCard({super.key, this.margin, required this.child});

  /// Overrides `CardTheme.margin`.
  final EdgeInsetsGeometry? margin;
  final Widget child;

  @override
  Widget build(BuildContext context) => Card(
    margin: margin,
    clipBehavior: CardTheme.of(context).clipBehavior ?? Clip.antiAlias,
    child: Padding(padding: const EdgeInsets.only(bottom: 8), child: child),
  );
}
