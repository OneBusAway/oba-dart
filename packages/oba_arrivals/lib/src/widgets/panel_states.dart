import 'package:flutter/material.dart';

import '../surface.dart';

/// A rounded block in the theme's placeholder color, used while loading.
class PlaceholderBox extends StatelessWidget {
  const PlaceholderBox(this.width, this.height, {super.key, this.radius = 4});

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) => Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

class SkeletonRow extends StatelessWidget {
  const SkeletonRow({super.key});

  @override
  Widget build(BuildContext context) {
    // The identifying key is nested (not on this widget itself) because the
    // panel places three instances as direct siblings in a Column; Flutter
    // requires unique keys among direct siblings, but tests find all three
    // by the same semantic key.
    return KeyedSubtree(
      key: const ValueKey('oba-skeleton-row'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const PlaceholderBox(64, 56, radius: 8),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  PlaceholderBox(140, 18),
                  SizedBox(height: 8),
                  PlaceholderBox(100, 14),
                ],
              ),
            ),
            const PlaceholderBox(36, 22),
          ],
        ),
      ),
    );
  }
}

/// Placeholder rows for the first load, read once as [label] (they are
/// otherwise invisible to screen readers).
class LoadingRows extends StatelessWidget {
  const LoadingRows({super.key, required this.label, this.count = 3});

  final String label;
  final int count;

  @override
  Widget build(BuildContext context) => Semantics(
    container: true,
    liveRegion: true,
    label: label,
    child: ExcludeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [for (var i = 0; i < count; i++) const SkeletonRow()],
      ),
    ),
  );
}

/// A small progress indicator that stands still when the platform asks for
/// reduced motion (`MediaQuery.disableAnimationsOf`).
class ObaProgressIndicator extends StatelessWidget {
  const ObaProgressIndicator({super.key, this.semanticsLabel});

  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.maybeDisableAnimationsOf(context) ?? false) {
      return Semantics(
        label: semanticsLabel,
        child: Icon(
          Icons.hourglass_empty,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    return CircularProgressIndicator(
      strokeWidth: 2,
      semanticsLabel: semanticsLabel,
    );
  }
}

/// An empty or error message. It is a polite live region, so screen readers
/// read it when it appears.
class PanelMessage extends StatelessWidget {
  const PanelMessage({super.key, required this.message, this.action});

  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          Semantics(
            container: true,
            liveRegion: true,
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: readableOnSurface(
                  context,
                  theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          if (action != null) ...[const SizedBox(height: 8), action!],
        ],
      ),
    );
  }
}

class StaleNotice extends StatelessWidget {
  const StaleNotice({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Semantics(
        liveRegion: true,
        container: true,
        child: Row(
          children: [
            ExcludeSemantics(
              child: Icon(
                Icons.cloud_off,
                size: scaledIconSize(context, 16),
                color: readableOnSurface(
                  context,
                  theme.colorScheme.error,
                  minRatio: 3,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                message,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: readableOnSurface(context, theme.colorScheme.error),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
