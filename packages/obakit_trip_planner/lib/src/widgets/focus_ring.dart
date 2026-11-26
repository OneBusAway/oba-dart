import 'package:flutter/material.dart';

/// An [InkWell] that draws a 2dp `colorScheme.primary` outline while it has
/// keyboard focus, so focus stays visible (WCAG 2.4.7, and 3:1 against the
/// surface for 1.4.11) instead of relying on the faint default highlight.
/// Enter and Space activate it, as with any [InkWell].
class FocusRingInkWell extends StatefulWidget {
  const FocusRingInkWell({
    super.key,
    required this.onTap,
    required this.child,
    this.borderRadius = BorderRadius.zero,
  });

  final VoidCallback? onTap;
  final Widget child;
  final BorderRadius borderRadius;

  @override
  State<FocusRingInkWell> createState() => _FocusRingInkWellState();
}

class _FocusRingInkWellState extends State<FocusRingInkWell> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: widget.onTap,
      borderRadius: widget.borderRadius,
      onFocusChange: (focused) => setState(() => _focused = focused),
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          border: _focused ? Border.all(color: scheme.primary, width: 2) : null,
        ),
        child: widget.child,
      ),
    );
  }
}
