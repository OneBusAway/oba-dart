import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart';

import '../features/settings/settings_routes.dart';
import '../navigation/oba_route.dart';
import '../platform/listenable_adapter.dart';
import 'scope.dart';

/// Shows the onboarding steps that still need showing before [child]
/// (normally the shell). Only `ObaApp` uses it: hosts embedding single
/// screens skip onboarding entirely.
class ObaOnboardingGate extends StatefulWidget {
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
  State<ObaOnboardingGate> createState() => _ObaOnboardingGateState();
}

class _ObaOnboardingGateState extends State<ObaOnboardingGate> {
  /// The step the last build showed (null: the child).
  OnboardingStep? _shown;

  /// "Allow" grants the permission, which takes the location step off the
  /// pending list at once: before its page, still waiting for the first
  /// fix, can report that it is done (it is unmounted by then). Record the
  /// step here. Otherwise it would come back whenever the permission
  /// lapses, which on iOS is every launch after "Allow Once".
  void _completeGrantedLocationStep(
    ObaCoreApplication app,
    OnboardingStep? next,
  ) {
    const step = OnboardingStep.location;
    if (_shown != step || next == step) return;
    if (!app.locationPermission.isGranted) return;
    if (!app.settings.needsOnboardingStep(step.settingsKey, step.version)) {
      return;
    }
    // Marking it notifies the builder below: after this frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        app.settings.markOnboardingStepSeen(step.settingsKey, step.version);
      }
    });
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
        final pending = ObaOnboardingGate.pendingSteps(
          app,
          enabled: widget.steps,
        );
        final step = pending.firstOrNull;
        _completeGrantedLocationStep(app, step);
        _shown = step;
        if (step == null) return widget.child;
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
