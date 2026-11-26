import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../platform/listenable_adapter.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'settings_page.dart' show ObaSettingSwitch;

/// Chooses the region: an "automatic" switch, the list of regions (the
/// current one marked with an icon and text), switches for experimental and
/// inactive regions, a refresh button, and custom regions with edit and
/// delete. Choosing a region by hand turns automatic selection off.
class RegionPickerPage extends StatefulWidget {
  const RegionPickerPage({super.key});

  @override
  State<RegionPickerPage> createState() => _RegionPickerPageState();
}

class _RegionPickerPageState extends State<RegionPickerPage> {
  bool _refreshFailed = false;

  ObaCoreApplication get _core => ObaScope.of(context).core;

  Future<void> _refresh() async {
    final l10n = context.obaL10n;
    try {
      await _core.regions.refreshRegions();
      if (!mounted) return;
      setState(() => _refreshFailed = false);
      obaAnnounce(context, l10n.regionPickerRefreshed);
    } catch (_) {
      if (!mounted) return;
      setState(() => _refreshFailed = true);
      obaAnnounce(context, l10n.regionPickerRefreshFailed);
    }
  }

  void _select(Region region) {
    final core = _core;
    core.regions.automaticallySelectRegion = false;
    core.regions.setCurrentRegion(region);
    core.analytics
      ..reportSetRegion(region.regionName)
      ..reportEvent(
        pageUrl: 'app://localhost/regions',
        label: AnalyticsLabels.setRegionManually,
        value: region.regionName,
      );
    obaAnnounce(
      context,
      context.obaL10n.regionPickerSelected(region.regionName),
    );
  }

  Future<void> _delete(Region region) async {
    final l10n = context.obaL10n;
    final core = _core;
    if (core.regions.currentRegion?.id == region.id) {
      obaNotify(context, l10n.regionPickerCantDeleteCurrent);
      return;
    }
    final confirmed = await obaConfirm(
      context,
      title: l10n.regionPickerDeleteTitle(region.regionName),
      message: l10n.regionPickerDeleteBody,
      confirmLabel: l10n.regionPickerDeleteConfirm,
    );
    if (confirmed) core.regions.deleteCustomRegion(region.id);
  }

  @override
  Widget build(BuildContext context) {
    final core = _core;
    final l10n = context.obaL10n;
    final nav = ObaNavigator.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([
        core.regions.listenable,
        core.settings.listenable,
      ]),
      builder: (context, _) {
        final regions = core.regions;
        final settings = core.settings;
        final current = regions.currentRegion;
        final listed = [
          for (final r in regions.visibleRegions(
            showExperimental: settings.showExperimentalRegions,
            showInactive: settings.showInactiveRegions,
          ))
            if (!r.custom) r,
        ];
        final custom = regions.customRegions;
        final failed = _refreshFailed || regions.lastRefreshFailed;
        return ObaSheetPage(
          title: l10n.titleRegionPicker,
          actions: [
            // No regions server (the host ships its own list): a refresh
            // would do nothing, and then announce "Regions updated".
            if (!regions.canRefresh)
              const SizedBox.shrink()
            else if (regions.isRefreshing)
              Semantics(
                label: l10n.commonLoading,
                liveRegion: true,
                child: const Padding(
                  padding: EdgeInsets.all(12),
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            else
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: l10n.regionPickerRefresh,
                onPressed: _refresh,
              ),
          ],
          slivers: [
            SliverList.list(
              children: [
                ObaSettingSwitch(
                  title: l10n.regionPickerAutomatic,
                  helper: l10n.regionPickerAutomaticHelp,
                  value: regions.automaticallySelectRegion,
                  onChanged: (v) {
                    regions.automaticallySelectRegion = v;
                    if (v) {
                      core.analytics.reportEvent(
                        pageUrl: 'app://localhost/regions',
                        label: AnalyticsLabels.setRegionAutomatically,
                        value: 'true',
                      );
                    }
                  },
                ),
                ObaSettingSwitch(
                  title: l10n.regionPickerShowExperimental,
                  value: settings.showExperimentalRegions,
                  onChanged: (v) => settings.showExperimentalRegions = v,
                ),
                ObaSettingSwitch(
                  title: l10n.regionPickerShowInactive,
                  value: settings.showInactiveRegions,
                  onChanged: (v) => settings.showInactiveRegions = v,
                ),
                if (failed && !regions.isRefreshing)
                  _RefreshError(onRetry: _refresh),
                ObaSectionHeader(title: l10n.regionPickerRegionsSection),
                if (listed.isEmpty)
                  ObaEmptyState(
                    icon: Icons.public_off,
                    title: l10n.regionPickerEmpty,
                    message: l10n.regionPickerEmptyBody,
                  ),
                for (final r in listed)
                  _RegionRow(
                    region: r,
                    isCurrent: r.id == current?.id,
                    onTap: () => _select(r),
                  ),
                ObaSectionHeader(title: l10n.regionPickerCustomSection),
                for (final r in custom)
                  _RegionRow(
                    region: r,
                    isCurrent: r.id == current?.id,
                    onTap: () => _select(r),
                    onEdit: () =>
                        nav.push(CustomRegionRoute(editRegionId: r.id)),
                    onDelete: () => _delete(r),
                  ),
                ObaListRow(
                  leading: const Icon(Icons.add),
                  title: l10n.regionPickerAdd,
                  onTap: () => nav.push(const CustomRegionRoute()),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _RefreshError extends StatelessWidget {
  const _RefreshError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    return Semantics(
      liveRegion: true,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          children: [
            ExcludeSemantics(
              child: Icon(Icons.error_outline, color: theme.colorScheme.error),
            ),
            Text(
              l10n.regionPickerRefreshFailed,
              style: theme.textTheme.bodyMedium,
            ),
            TextButton(onPressed: onRetry, child: Text(l10n.commonRetry)),
          ],
        ),
      ),
    );
  }
}

class _RegionRow extends StatelessWidget {
  const _RegionRow({
    required this.region,
    required this.isCurrent,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  });

  final Region region;
  final bool isCurrent;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final tags = [
      if (isCurrent) l10n.regionPickerCurrent,
      if (region.custom) l10n.regionPickerCustomTag,
      if (region.experimental) l10n.regionPickerExperimentalTag,
      if (!region.active) l10n.regionPickerInactiveTag,
    ];
    final details = tags.join(' · ');
    final row = ObaListRow(
      leading: Icon(isCurrent ? Icons.check_circle : Icons.circle_outlined),
      title: region.regionName,
      subtitle: details.isEmpty ? null : details,
      selected: isCurrent,
      semanticLabel: details.isEmpty
          ? region.regionName
          : l10n.regionPickerRowLabel(region.regionName, details),
      onTap: onTap,
    );
    if (onEdit == null && onDelete == null) return row;
    // The buttons sit beside the row, not inside it, so each stays its own
    // control for screen readers.
    return Row(
      children: [
        Expanded(child: row),
        if (onEdit != null)
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: l10n.regionPickerEdit(region.regionName),
            onPressed: onEdit,
          ),
        if (onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: l10n.regionPickerDelete(region.regionName),
            onPressed: onDelete,
          ),
      ],
    );
  }
}
