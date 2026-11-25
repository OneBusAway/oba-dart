import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/rows.dart';
import '../../widgets/states.dart';

/// One onboarding page: welcome, the location explanation (allow or not
/// now), or region selection (the region found from the location, then the
/// list). [onComplete] is called when the rider finishes the step; the
/// onboarding gate then records it with `ObaSettings.markOnboardingStepSeen`
/// (using `OnboardingStep.version`, so a step can be shown again after the
/// version is raised) and moves on.
///
/// Only `ObaApp` shows onboarding. A host embedding single screens never
/// builds this page.
class OnboardingStepPage extends StatelessWidget {
  const OnboardingStepPage({
    super.key,
    required this.step,
    required this.onComplete,
  });

  final OnboardingStep step;
  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: switch (step) {
              OnboardingStep.welcome => _WelcomeStep(onComplete: onComplete),
              OnboardingStep.location => _LocationStep(onComplete: onComplete),
              OnboardingStep.region => _RegionStep(onComplete: onComplete),
            },
          ),
        ),
      ),
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.icon, required this.title, this.body});

  final IconData icon;
  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(
          child: Icon(icon, size: 56, color: theme.colorScheme.primary),
        ),
        const SizedBox(height: 16),
        Semantics(
          container: true,
          header: true,
          child: Text(title, style: theme.textTheme.headlineMedium),
        ),
        if (body != null) ...[
          const SizedBox(height: 12),
          Text(body!, style: theme.textTheme.bodyLarge),
        ],
      ],
    );
  }
}

class _Footnote extends StatelessWidget {
  const _Footnote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onComplete});

  final VoidCallback onComplete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final app = ObaScope.of(context);
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _StepHeader(
          icon: Icons.directions_bus_filled,
          title: l10n.onboardingWelcomeTitle(app.config.appName),
          body: l10n.onboardingWelcomeBody,
        ),
        const SizedBox(height: 24),
        FilledButton(onPressed: onComplete, child: Text(l10n.commonContinue)),
        _Footnote(l10n.onboardingWelcomeFootnote),
      ],
    );
  }
}

class _LocationStep extends StatefulWidget {
  const _LocationStep({required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<_LocationStep> createState() => _LocationStepState();
}

class _LocationStepState extends State<_LocationStep> {
  bool _asking = false;

  Future<void> _allow() async {
    if (_asking) return;
    setState(() => _asking = true);
    await ObaScope.of(context).core.requestLocationPermission();
    if (!mounted) return;
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final core = ObaScope.of(context).core;
    final theme = Theme.of(context);
    final denied = switch (core.locationPermission) {
      LocationPermissionStatus.denied ||
      LocationPermissionStatus.deniedForever ||
      LocationPermissionStatus.serviceDisabled => true,
      _ => false,
    };
    Widget benefit(IconData icon, String title, String body) => MergeSemantics(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.titleSmall),
                  Text(body, style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _StepHeader(
          icon: Icons.near_me,
          title: l10n.onboardingLocationTitle,
          body: l10n.onboardingLocationBody,
        ),
        const SizedBox(height: 16),
        benefit(
          Icons.directions_bus,
          l10n.onboardingBenefitNearbyTitle,
          l10n.onboardingBenefitNearbyBody,
        ),
        benefit(
          Icons.my_location,
          l10n.onboardingBenefitMapTitle,
          l10n.onboardingBenefitMapBody,
        ),
        if (denied)
          Semantics(
            liveRegion: true,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(l10n.onboardingLocationDenied),
            ),
          ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: _asking ? null : _allow,
          child: Text(l10n.onboardingAllowLocation),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: widget.onComplete,
          child: Text(l10n.commonNotNow),
        ),
        _Footnote(l10n.onboardingLocationFootnote(core.config.appName)),
      ],
    );
  }
}

class _RegionStep extends StatefulWidget {
  const _RegionStep({required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<_RegionStep> createState() => _RegionStepState();
}

class _RegionStepState extends State<_RegionStep> {
  bool _retrying = false;

  void _choose(Region region, {required bool automatic}) {
    final core = ObaScope.of(context).core;
    if (!automatic) core.regions.automaticallySelectRegion = false;
    core.regions.setCurrentRegion(region);
    core.analytics
      ..reportSetRegion(region.regionName)
      ..reportEvent(
        pageUrl: 'app://localhost/onboarding',
        label: automatic
            ? AnalyticsLabels.setRegionAutomatically
            : AnalyticsLabels.setRegionManually,
        value: region.regionName,
      );
    widget.onComplete();
  }

  Future<void> _retry() async {
    setState(() => _retrying = true);
    try {
      await ObaScope.of(context).core.regions.refreshRegions();
    } catch (_) {
      // The list stays empty; the button remains available.
    }
    if (mounted) setState(() => _retrying = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final core = ObaScope.of(context).core;
    final theme = Theme.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([core.regions.listenable, core.listenable]),
      builder: (context, _) {
        final suggested = core.regions.physicallyLocatedRegion;
        final regions = [
          for (final r in core.regions.visibleRegions())
            if (r.id != suggested?.id) r,
        ];
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _StepHeader(
              icon: Icons.public,
              title: l10n.onboardingRegionTitle,
              body: l10n.onboardingRegionBody,
            ),
            const SizedBox(height: 16),
            if (suggested != null) ...[
              Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.onboardingRegionDetected,
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        suggested.regionName,
                        style: theme.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () => _choose(suggested, automatic: true),
                        child: Text(
                          l10n.onboardingRegionUse(suggested.regionName),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            if (regions.isEmpty && suggested == null)
              ObaEmptyState(
                icon: Icons.public_off,
                title: l10n.regionPickerEmpty,
                message: l10n.onboardingRegionEmpty,
                action: FilledButton.tonal(
                  onPressed: _retrying ? null : _retry,
                  child: Text(l10n.commonRetry),
                ),
              )
            else if (regions.isNotEmpty) ...[
              if (suggested != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Semantics(
                    container: true,
                    header: true,
                    child: Text(
                      l10n.onboardingRegionOthers,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                ),
              for (final r in regions)
                ObaListRow(
                  title: r.regionName,
                  onTap: () => _choose(r, automatic: false),
                ),
            ],
          ],
        );
      },
    );
  }
}
