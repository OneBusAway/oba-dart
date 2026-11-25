import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../navigation/sheet_detents.dart';
import '../../widgets/rows.dart';
import '../../widgets/sheet_page.dart';
import '../../widgets/states.dart';
import 'link_opener.dart';

/// The license text of OneBusAway itself, from iOS `OBAKit_Credits.plist`.
/// The other plist entries credit Swift libraries that this app does not
/// use; the Flutter packages it does use appear under "Open source licenses".
const String kObaLicenseText = '''
Copyright © 2018-Present Aaron Brethorst <aaron@brethorsting.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.''';

/// The credits: who makes OneBusAway and under which license, the map data
/// attribution, and a link to the licenses of the libraries used.
class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = ObaScope.of(context);
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final tiles = app.map.standard;
    final attributionUrl = tiles.attributionUrl == null
        ? null
        : Uri.tryParse(tiles.attributionUrl!);
    return ObaSheetPage(
      title: l10n.titleCredits,
      slivers: [
        SliverList.list(
          children: [
            ObaSectionHeader(title: l10n.creditsAbout),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
              child: Text(l10n.creditsAboutBody),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
              child: Semantics(
                container: true,
                header: true,
                child: Text(
                  l10n.creditsLicenseTitle,
                  style: theme.textTheme.titleSmall,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 4, 16, 0),
              child: SelectableText(
                kObaLicenseText,
                style: theme.textTheme.bodySmall,
              ),
            ),
            ObaSectionHeader(title: l10n.creditsMapData),
            ObaListRow(
              title: l10n.mapAttribution(tiles.attribution),
              trailing: attributionUrl == null
                  ? null
                  : const ExcludeSemantics(child: Icon(Icons.open_in_new)),
              onTap: attributionUrl == null
                  ? null
                  : () => ObaLinkOpenerScope.of(context).open(attributionUrl),
            ),
            ObaSectionHeader(title: l10n.creditsLicenses),
            ObaListRow(
              title: l10n.creditsLicenses,
              subtitle: l10n.creditsLicensesHelp,
              trailing: const ExcludeSemantics(
                child: Icon(Icons.chevron_right),
              ),
              onTap: () =>
                  ObaNavigator.of(context).push(const ObaLicensesRoute()),
            ),
          ],
        ),
      ],
    );
  }
}

/// Opens [ObaLicensesPage].
class ObaLicensesRoute extends ObaCustomRoute {
  const ObaLicensesRoute();

  @override
  String get id => 'licenses';

  @override
  ObaSheetDetents get detents => ObaSheetDetents.fullOnly;

  @override
  Widget build(BuildContext context) => const ObaLicensesPage();
}

/// The licenses of every package in the app, from Flutter's
/// `LicenseRegistry`, grouped by package (the content of `showLicensePage`,
/// inside an `ObaSheetPage`).
class ObaLicensesPage extends StatefulWidget {
  const ObaLicensesPage({super.key});

  @override
  State<ObaLicensesPage> createState() => _ObaLicensesPageState();
}

class _ObaLicensesPageState extends State<ObaLicensesPage> {
  late final Future<List<_PackageLicenses>> _licenses = _load();

  static Future<List<_PackageLicenses>> _load() async {
    final byPackage = <String, List<LicenseEntry>>{};
    await for (final entry in LicenseRegistry.licenses) {
      for (final package in entry.packages) {
        byPackage.putIfAbsent(package, () => []).add(entry);
      }
    }
    final names = byPackage.keys.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return [for (final n in names) _PackageLicenses(n, byPackage[n]!)];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    return FutureBuilder<List<_PackageLicenses>>(
      future: _licenses,
      builder: (context, snapshot) {
        final data = snapshot.data;
        return ObaSheetPage(
          title: l10n.creditsLicenses,
          slivers: [
            if (data == null)
              SliverToBoxAdapter(
                child: ObaLoadingState(label: l10n.creditsLicensesLoading),
              )
            else
              SliverList.builder(
                itemCount: data.length,
                itemBuilder: (context, i) => _PackageTile(package: data[i]),
              ),
          ],
        );
      },
    );
  }
}

class _PackageLicenses {
  _PackageLicenses(this.name, this.entries);

  final String name;
  final List<LicenseEntry> entries;
}

class _PackageTile extends StatelessWidget {
  const _PackageTile({required this.package});

  final _PackageLicenses package;

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    return ExpansionTile(
      title: Text(package.name),
      subtitle: Text(l10n.creditsLicenseCount(package.entries.length)),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      childrenPadding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
      children: [
        for (final entry in package.entries)
          for (final p in entry.paragraphs)
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 8.0 * p.indent.clamp(0, 6),
                bottom: 8,
              ),
              child: Text(
                p.text,
                style: p.indent == LicenseParagraph.centeredIndent
                    ? theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      )
                    : theme.textTheme.bodySmall,
                textAlign: p.indent == LicenseParagraph.centeredIndent
                    ? TextAlign.center
                    : TextAlign.start,
              ),
            ),
      ],
    );
  }
}
