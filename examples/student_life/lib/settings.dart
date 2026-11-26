import 'package:flutter/material.dart';

/// App-wide host settings: the "Show OBA embeds" overlay and the theme
/// mode. Plain [ValueNotifier]s, handed down by [SettingsScope].
class StudentLifeSettings {
  StudentLifeSettings({
    bool showObaEmbeds = false,
    ThemeMode themeMode = ThemeMode.system,
  }) : showObaEmbeds = ValueNotifier(showObaEmbeds),
       themeMode = ValueNotifier(themeMode);

  /// Draws an outline and a label around every embedded OBA widget.
  final ValueNotifier<bool> showObaEmbeds;
  final ValueNotifier<ThemeMode> themeMode;

  void dispose() {
    showObaEmbeds.dispose();
    themeMode.dispose();
  }
}

class SettingsScope extends InheritedWidget {
  const SettingsScope({
    super.key,
    required this.settings,
    required super.child,
  });

  final StudentLifeSettings settings;

  static StudentLifeSettings? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<SettingsScope>()?.settings;

  static StudentLifeSettings of(BuildContext context) => maybeOf(context)!;

  @override
  bool updateShouldNotify(SettingsScope oldWidget) =>
      !identical(oldWidget.settings, settings);
}
