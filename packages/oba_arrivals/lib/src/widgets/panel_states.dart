import 'package:flutter/material.dart';

class SkeletonRow extends StatelessWidget {
  const SkeletonRow({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    Widget box(double w, double h, [double r = 4]) => Container(
          width: w,
          height: h,
          decoration:
              BoxDecoration(color: color, borderRadius: BorderRadius.circular(r)),
        );
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
            box(64, 56, 8),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [box(140, 18), const SizedBox(height: 8), box(100, 14)],
              ),
            ),
            box(36, 22),
          ],
        ),
      ),
    );
  }
}

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
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
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
      child: Row(
        children: [
          Icon(Icons.cloud_off, size: 16, color: theme.colorScheme.error),
          const SizedBox(width: 6),
          Expanded(
            child: Text(message,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.error)),
          ),
        ],
      ),
    );
  }
}
