import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../widgets/heading.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';

/// App settings, all backed by `ObaSettings`: map, walking directions,
/// departures, accessibility, walking and bike speed, surveys, privacy and
/// (in debug builds) developer options. Pushed by `SettingsRoute`, and also
/// usable on its own in a host's settings screen.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = ObaScope.of(context);
    final core = app.core;
    final settings = core.settings;
    return ListenableBuilder(
      listenable: Listenable.merge([
        settings.listenable,
        core.regions.listenable,
      ]),
      builder: (context, _) => ObaSheetPage(
        title: context.obaL10n.titleSettings,
        slivers: [SliverList.list(children: _sections(context, core))],
      ),
    );
  }

  List<Widget> _sections(BuildContext context, ObaCoreApplication core) {
    final l10n = context.obaL10n;
    final settings = core.settings;

    String directionsLabel(WalkingDirectionsProvider p) => switch (p) {
      WalkingDirectionsProvider.askEveryTime => l10n.settingsDirectionsAsk,
      WalkingDirectionsProvider.appleMaps => l10n.settingsDirectionsAppleMaps,
      WalkingDirectionsProvider.googleMaps => l10n.settingsDirectionsGoogleMaps,
    };
    final providers = [
      WalkingDirectionsProvider.askEveryTime,
      if (supportsAppleMaps) WalkingDirectionsProvider.appleMaps,
      WalkingDirectionsProvider.googleMaps,
    ];
    // A stored Apple Maps choice on a platform without it still shows.
    final directionsGroup =
        providers.contains(settings.walkingDirectionsProvider)
        ? settings.walkingDirectionsProvider
        : null;

    String filterLabel(ArrivalDepartureFilter f) => switch (f) {
      ArrivalDepartureFilter.all => l10n.settingsFilterAll,
      ArrivalDepartureFilter.estimatedOnly => l10n.settingsFilterRealtime,
      ArrivalDepartureFilter.scheduledOnly => l10n.settingsFilterScheduled,
    };
    String speedLabel(WalkingSpeedPreset p) => switch (p) {
      WalkingSpeedPreset.slow => l10n.settingsSpeedSlow,
      WalkingSpeedPreset.average => l10n.settingsSpeedAverage,
      WalkingSpeedPreset.fast => l10n.settingsSpeedFast,
    };

    final region = core.regions.currentRegion;
    final showDebug = kDebugMode || settings.debugMode;

    return [
      // Map
      ObaSectionHeader(title: l10n.settingsSectionMap),
      ObaListRow(
        title: l10n.settingsMapTypeRow,
        subtitle: l10n.settingsMapTypeHelp,
        trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
        onTap: () => ObaNavigator.of(context).push(const MapSettingsRoute()),
      ),
      ObaSettingSwitch(
        title: l10n.mapShowHeading,
        helper: l10n.settingsHeadingHelp,
        value: settings.mapShowsHeading,
        onChanged: (v) => settings.mapShowsHeading = v,
      ),
      ObaChoiceGroup<WalkingDirectionsProvider>(
        title: l10n.settingsWalkingDirections,
        helper: l10n.settingsWalkingDirectionsHelp,
        values: providers,
        value: directionsGroup,
        labelOf: directionsLabel,
        onChanged: (v) => settings.walkingDirectionsProvider = v,
      ),

      // Departures
      ObaSectionHeader(title: l10n.settingsSectionDepartures),
      ObaChoiceGroup<ArrivalDepartureFilter>(
        title: l10n.settingsDepartureFilter,
        helper: l10n.settingsDepartureFilterHelp,
        values: ArrivalDepartureFilter.values,
        value: settings.arrivalDepartureFilter,
        labelOf: filterLabel,
        onChanged: (v) => settings.arrivalDepartureFilter = v,
      ),

      // Accessibility
      ObaSectionHeader(title: l10n.settingsSectionAccessibility),
      ObaSettingSwitch(
        title: l10n.settingsReducedColors,
        helper: l10n.settingsReducedColorsHelp,
        value: settings.reducedColors,
        onChanged: (v) => settings.reducedColors = v,
      ),

      // Walking speed and bike mode
      ObaSectionHeader(title: l10n.settingsSectionWalking),
      ObaChoiceGroup<WalkingSpeedPreset>(
        title: l10n.settingsWalkingSpeed,
        helper: l10n.settingsWalkingSpeedHelp,
        values: WalkingSpeedPreset.values,
        value: settings.walkingSpeedPreset,
        labelOf: speedLabel,
        onChanged: (v) => settings.walkingSpeedPreset = v,
        extra: settings.walkingSpeedPreset == null
            ? l10n.settingsSpeedCustom(
                settings.walkingSpeedMetersPerSecond.toStringAsFixed(1),
              )
            : null,
      ),
      ObaSectionHeader(title: l10n.settingsSectionBike),
      ObaSettingSwitch(
        title: l10n.settingsBikeMode,
        helper: l10n.settingsBikeModeHelp,
        value: settings.bikeModeEnabled,
        onChanged: (v) => settings.bikeModeEnabled = v,
      ),

      // Trip planner (per region)
      if (region != null && region.supportsOtp) ...[
        ObaSectionHeader(title: l10n.settingsSectionTripPlanner),
        _TripPlannerSwitch(core: core, region: region),
      ],

      // Surveys
      ObaSectionHeader(title: l10n.settingsSectionSurveys),
      _SurveySwitches(core: core),

      // Privacy: only when the host supplied analytics.
      if (core.config.analytics != null) ...[
        ObaSectionHeader(title: l10n.settingsSectionPrivacy),
        ObaSettingSwitch(
          title: l10n.settingsAnalytics,
          helper: l10n.settingsAnalyticsHelp,
          value: settings.analyticsReportingEnabled,
          onChanged: (v) => settings.analyticsReportingEnabled = v,
        ),
      ],

      // Debug
      if (showDebug) ...[
        ObaSectionHeader(title: l10n.settingsSectionDebug),
        ObaSettingSwitch(
          title: l10n.settingsDebugMode,
          value: settings.debugMode,
          onChanged: (v) => settings.debugMode = v,
        ),
        if (settings.debugMode) _DebugControls(core: core),
      ],
    ];
  }

  /// Whether Apple Maps can be offered as the walking directions app.
  @visibleForTesting
  static bool get supportsAppleMaps =>
      defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS;
}

class _TripPlannerSwitch extends StatefulWidget {
  const _TripPlannerSwitch({required this.core, required this.region});

  final ObaCoreApplication core;
  final Region region;

  @override
  State<_TripPlannerSwitch> createState() => _TripPlannerSwitchState();
}

class _TripPlannerSwitchState extends State<_TripPlannerSwitch> {
  @override
  Widget build(BuildContext context) {
    final data = widget.core.userData;
    return ObaSettingSwitch(
      title: context.obaL10n.regionPickerTripPlanner,
      value: data.isTripPlanningEnabled(widget.region.id),
      onChanged: (v) =>
          setState(() => data.setTripPlanningEnabled(widget.region.id, v)),
    );
  }
}

/// Survey switches. They read `UserDataStore`, which has its own listeners,
/// so they keep local state.
class _SurveySwitches extends StatefulWidget {
  const _SurveySwitches({required this.core});

  final ObaCoreApplication core;

  @override
  State<_SurveySwitches> createState() => _SurveySwitchesState();
}

class _SurveySwitchesState extends State<_SurveySwitches> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final data = widget.core.userData;
    return Column(
      children: [
        ObaSettingSwitch(
          title: l10n.settingsSurveysEnabled,
          value: data.isSurveyEnabled,
          onChanged: (v) => setState(() => data.isSurveyEnabled = v),
        ),
        ObaSettingSwitch(
          title: l10n.settingsSurveysAlways,
          value: data.alwaysShowSurveysOnStops,
          onChanged: data.isSurveyEnabled
              ? (v) => setState(() => data.alwaysShowSurveysOnStops = v)
              : null,
        ),
      ],
    );
  }
}

class _DebugControls extends StatefulWidget {
  const _DebugControls({required this.core});

  final ObaCoreApplication core;

  @override
  State<_DebugControls> createState() => _DebugControlsState();
}

class _DebugControlsState extends State<_DebugControls> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final review = widget.core.reviewPrompt;
    return Column(
      children: [
        ObaSettingSwitch(
          title: l10n.settingsDebugAlwaysFeedback,
          value: review.alwaysShow,
          onChanged: (v) => setState(() => review.alwaysShow = v),
        ),
        ObaListRow(
          title: l10n.settingsDebugResetFeedback,
          onTap: () {
            review.reset();
            widget.core.prompts.reset();
            obaAnnounce(context, l10n.settingsDebugResetDone);
          },
        ),
        ObaListRow(
          title: l10n.settingsDebugResetDonation,
          onTap: () {
            widget.core.donationPrompt.reset();
            obaAnnounce(context, l10n.settingsDebugResetDone);
          },
        ),
      ],
    );
  }
}

/// A switch row with an optional helper sentence. Reads as one control:
/// "Title, helper, switch, on".
class ObaSettingSwitch extends StatelessWidget {
  const ObaSettingSwitch({
    super.key,
    required this.title,
    this.helper,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? helper;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) => SwitchListTile(
    title: Text(title),
    subtitle: helper == null ? null : Text(helper!),
    value: value,
    onChanged: onChanged,
    contentPadding: const EdgeInsetsDirectional.only(start: 16, end: 12),
  );
}

/// A labelled single choice shown as radio rows (every option visible, all
/// reachable by keyboard and screen reader), with an optional helper
/// sentence and an [extra] line for a value that is not one of the options.
class ObaChoiceGroup<T> extends StatelessWidget {
  const ObaChoiceGroup({
    super.key,
    required this.title,
    this.helper,
    required this.values,
    required this.value,
    required this.labelOf,
    required this.onChanged,
    this.extra,
  });

  final String title;
  final String? helper;
  final List<T> values;
  final T? value;
  final String Function(T) labelOf;
  final ValueChanged<T> onChanged;
  final String? extra;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
          // Its own node: otherwise the helper sentence merges into the
          // heading.
          child: ObaHeading(title, style: theme.textTheme.titleSmall),
        ),
        if (helper != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 2, 16, 0),
            child: Text(
              helper!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        RadioGroup<T>(
          groupValue: value,
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
          child: Column(
            children: [
              for (final v in values)
                RadioListTile<T>(
                  value: v,
                  title: Text(labelOf(v)),
                  contentPadding: const EdgeInsetsDirectional.only(
                    start: 16,
                    end: 12,
                  ),
                ),
            ],
          ),
        ),
        if (extra != null)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
            child: Text(extra!, style: theme.textTheme.bodyMedium),
          ),
      ],
    );
  }
}
