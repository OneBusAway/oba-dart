import 'package:flutter/material.dart';

import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../widgets/rows.dart';

/// The home feed's "Settings and more" section: Customize map, Settings and
/// More. A non-scrolling column, so it also works in a host's feed.
class SettingsAndMoreSection extends StatelessWidget {
  const SettingsAndMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final nav = ObaNavigator.of(context);
    Widget row(IconData icon, String title, ObaRoute route) => ObaListRow(
      leading: Icon(icon),
      title: title,
      trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
      onTap: () => nav.push(route),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ObaSectionHeader(title: l10n.homeSectionMore),
        row(
          Icons.layers_outlined,
          l10n.settingsHomeCustomizeMap,
          const MapSettingsRoute(),
        ),
        row(Icons.settings_outlined, l10n.titleSettings, const SettingsRoute()),
        row(Icons.more_horiz, l10n.titleMore, const MoreRoute()),
      ],
    );
  }
}
