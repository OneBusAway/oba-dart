import 'package:flutter/material.dart';
import 'package:obakit/obakit.dart';

import '../data/student.dart';
import '../settings.dart';
import '../widgets/host_page.dart';
import '../widgets/section_title.dart';
import '../widgets/student_id_card.dart';

/// The student's ID, links to saved stops and alerts, and app settings.
class MeTab extends StatelessWidget {
  const MeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = SettingsScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Me')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const StudentIdCard(student: currentStudent),
          const SectionTitle('Transit'),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: const ExcludeSemantics(
                    child: Icon(Icons.bookmark_outline),
                  ),
                  title: const Text('Saved stops'),
                  trailing: const ExcludeSemantics(
                    child: Icon(Icons.chevron_right),
                  ),
                  onTap: () => HostObaPage.push(
                    context,
                    title: 'Saved stops',
                    sdkWidget: 'BookmarksPage',
                    // OBA embed: every bookmark, grouped, with departures.
                    page: const BookmarksPage(),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const ExcludeSemantics(
                    child: Icon(Icons.warning_amber_outlined),
                  ),
                  title: const Text('Service alerts'),
                  trailing: const ExcludeSemantics(
                    child: Icon(Icons.chevron_right),
                  ),
                  onTap: () => HostObaPage.push(
                    context,
                    title: 'Service alerts',
                    sdkWidget: 'AlertsListPage',
                    // OBA embed: region-wide alerts for the student's stops.
                    page: const AlertsListPage(),
                  ),
                ),
              ],
            ),
          ),
          const SectionTitle('Settings'),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: settings.showObaEmbeds,
                  builder: (context, show, _) => SwitchListTile(
                    title: const Text('Show OBA embeds'),
                    subtitle: const Text(
                      'Outline every part of the app that comes from the '
                      'OneBusAway SDK',
                    ),
                    value: show,
                    onChanged: (v) => settings.showObaEmbeds.value = v,
                  ),
                ),
                const Divider(height: 1),
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: settings.themeMode,
                  builder: (context, mode, _) => SwitchListTile(
                    title: const Text('Dark mode'),
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (v) => settings.themeMode.value = v
                        ? ThemeMode.dark
                        : ThemeMode.light,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
