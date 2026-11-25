import 'package:flutter/material.dart';
import 'package:onebusaway/onebusaway.dart';

import '../display/stop_display.dart';
import '../strings.dart';
import '../surface.dart';
import 'panel_states.dart';

class StopHeader extends StatelessWidget {
  const StopHeader({
    super.key,
    required this.stop,
    required this.stopId,
    required this.isLoading,
    required this.references,
    required this.isRefreshing,
    required this.onRefresh,
    required this.strings,
  });

  /// Null until a response names the stop.
  final Stop? stop;

  /// The requested stop id; titles the header when [stop] is null and the
  /// panel is not loading (an error, or a response without the stop).
  final String stopId;

  /// True while the first request is in flight; shows a placeholder.
  final bool isLoading;
  final References references;
  final bool isRefreshing;
  final VoidCallback onRefresh;
  final ObaArrivalsStrings strings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final stop = this.stop;
    final titleStyle = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w700,
    );
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: readableOnSurface(context, theme.colorScheme.onSurfaceVariant),
    );
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 4, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: stop == null
                ? isLoading
                      ? const ExcludeSemantics(
                          child: _HeaderPlaceholder(
                            key: ValueKey('oba-header-placeholder'),
                          ),
                        )
                      : Semantics(
                          container: true,
                          header: true,
                          child: Text(
                            strings.stopNumber(stripAgencyPrefix(stopId)),
                            style: titleStyle,
                          ),
                        )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Semantics(
                        container: true,
                        header: true,
                        child: Text(stop.name, style: titleStyle),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        stopSubtitle(stop, references, strings),
                        // Read the " · " separators as pauses.
                        semanticsLabel: stopSubtitle(
                          stop,
                          references,
                          strings,
                        ).replaceAll(' · ', ', '),
                        style: subtitleStyle,
                      ),
                    ],
                  ),
          ),
          IconButton(
            key: const ValueKey('oba-refresh'),
            tooltip: strings.refresh,
            onPressed: isRefreshing ? null : onRefresh,
            icon: isRefreshing
                ? SizedBox.square(
                    dimension: 20,
                    child: ObaProgressIndicator(
                      semanticsLabel: strings.refreshing,
                    ),
                  )
                : const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}

class _HeaderPlaceholder extends StatelessWidget {
  const _HeaderPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        PlaceholderBox(220, 22),
        SizedBox(height: 8),
        PlaceholderBox(160, 14),
      ],
    );
  }
}
