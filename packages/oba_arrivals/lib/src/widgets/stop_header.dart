import 'package:flutter/material.dart';
import 'package:onebusaway/onebusaway.dart';

import '../display/stop_display.dart';
import '../strings.dart';

class StopHeader extends StatelessWidget {
  const StopHeader({
    super.key,
    required this.stop,
    required this.references,
    required this.isRefreshing,
    required this.onRefresh,
    required this.strings,
  });

  /// Null while the first request is loading.
  final Stop? stop;
  final References references;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final ObaArrivalsStrings strings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stop = this.stop;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 4, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: stop == null
                ? const _HeaderPlaceholder()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stop.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stopSubtitle(stop, references, strings),
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
          ),
          IconButton(
            key: const ValueKey('oba-refresh'),
            tooltip: strings.refresh,
            onPressed: isRefreshing ? null : onRefresh,
            icon: isRefreshing
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class _HeaderPlaceholder extends StatelessWidget {
  const _HeaderPlaceholder();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    Widget bar(double width, double height) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(4)),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [bar(220, 22), const SizedBox(height: 8), bar(160, 14)],
    );
  }
}
