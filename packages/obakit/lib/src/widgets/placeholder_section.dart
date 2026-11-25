import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../navigation/oba_navigator.dart';
import '../navigation/oba_route.dart';
import 'rows.dart';

/// A home section that is not built yet: a header, a "Coming soon" line,
/// and a "See all" link to [seeAll]. Feature agents replace it.
class ObaPlaceholderSection extends StatelessWidget {
  const ObaPlaceholderSection({super.key, required this.title, this.seeAll});

  final String title;
  final ObaRoute? seeAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ObaSectionHeader(
          title: title,
          actionLabel: seeAll == null ? null : l10n.commonSeeAll,
          onAction: seeAll == null
              ? null
              : () => ObaNavigator.of(context).push(seeAll!),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
          child: Text(
            l10n.commonComingSoon,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
