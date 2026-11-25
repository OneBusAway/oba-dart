import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../theme/oba_theme.dart';
import '../../widgets/rows.dart';

/// The home sheet's Explore row (iOS `HomeExploreRow`): round shortcuts to
/// things the lists above don't hold. Plan a trip (only where the region
/// has trip planning), Weather (only with a weather server) and Agencies.
///
/// A plain, non-scrolling widget for the Home tab or a host feed.
class ExploreSection extends StatelessWidget {
  const ExploreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final app = ObaScope.of(context);
    return ListenableBuilder(
      listenable: ObaListenableAdapter(app.core),
      builder: (context, _) {
        final l10n = context.obaL10n;
        final items = <(IconData, String, ObaRoute)>[
          if (app.core.tripPlanningStatus == FeatureStatus.running)
            (
              Icons.alt_route,
              l10n.searchExplorePlanTrip,
              const TripPlannerRoute(),
            ),
          if (app.core.obacoStatus == FeatureStatus.running)
            (
              Icons.wb_sunny_outlined,
              l10n.searchExploreWeather,
              const WeatherRoute(),
            ),
          (
            Icons.business_outlined,
            l10n.searchExploreAgencies,
            const AgenciesRoute(),
          ),
        ];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            ObaSectionHeader(title: l10n.homeSectionExplore),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 8),
              child: Wrap(
                spacing: 4,
                runSpacing: 8,
                children: [
                  for (final (icon, title, route) in items)
                    _ExploreTile(
                      icon: icon,
                      title: title,
                      onTap: () => ObaNavigator.of(context).push(route),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ExploreTile extends StatelessWidget {
  const _ExploreTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final brand = ObaTheme.of(context).brand;
    // The brand green on the tile's grey must clear 3:1; fall back to the
    // scheme's primary when a host brand doesn't.
    final circle = scheme.surfaceContainerHighest;
    final glyph = ObaContrast.ratio(brand, circle) >= 3
        ? brand
        : scheme.primary;
    return Semantics(
      button: true,
      label: title,
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 96,
            maxWidth: 140,
            minHeight: 48,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: circle,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Icon(icon, color: glyph),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
