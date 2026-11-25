import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart';

import '../features/settings/settings_routes.dart';
import '../navigation/oba_route.dart';
import '../platform/listenable_adapter.dart';
import 'scope.dart';

/// Shows the onboarding steps that still need showing before [child]
/// (normally the shell). Only `ObaApp` uses it: hosts embedding single
/// screens skip onboarding entirely.
class ObaOnboardingGate extends StatelessWidget {
  const ObaOnboardingGate({
    super.key,
    required this.child,
    this.steps = const {
      OnboardingStep.welcome,
      OnboardingStep.location,
      OnboardingStep.region,
    },
  });

  final Widget child;

  /// Which optional steps this app shows. The region step always shows
  /// when no region could be chosen, whatever this says.
  final Set<OnboardingStep> steps;

  /// The steps still to show, in order.
  static List<OnboardingStep> pendingSteps(
    ObaCoreApplication app, {
    Set<OnboardingStep> enabled = const {
      OnboardingStep.welcome,
      OnboardingStep.location,
      OnboardingStep.region,
    },
  }) {
    bool needs(OnboardingStep s) =>
        enabled.contains(s) &&
        app.settings.needsOnboardingStep(s.settingsKey, s.version);
    return [
      if (needs(OnboardingStep.welcome)) OnboardingStep.welcome,
      // No location step when the host gives the SDK no location.
      if (needs(OnboardingStep.location) &&
          app.isLocationAvailable &&
          !app.locationPermission.isGranted)
        OnboardingStep.location,
      if (app.regions.needsRegionSelection) OnboardingStep.region,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final app = ObaScope.of(context).core;
    return ListenableBuilder(
      listenable: Listenable.merge([
        app.settings.listenable,
        app.regions.listenable,
        app.listenable,
      ]),
      builder: (context, _) {
        final pending = pendingSteps(app, enabled: steps);
        if (pending.isEmpty) return child;
        final step = pending.first;
        return KeyedSubtree(
          key: ValueKey(step),
          child: buildOnboardingStep(
            context,
            step,
            () => app.settings.markOnboardingStepSeen(
              step.settingsKey,
              step.version,
            ),
          ),
        );
      },
    );
  }
}
