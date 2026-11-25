import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/states.dart';
import '../l10n/l10n.dart';
import '../navigation/oba_route.dart';
import '../shell/home_shell.dart';
import '../theme/oba_theme.dart';
import 'application.dart';
import 'deep_links.dart';
import 'onboarding_gate.dart';
import 'scope.dart';

/// The whole OneBusAway app: what a thin shim passes to `runApp`.
///
/// ```dart
/// final app = await ObaApplication.create(...);
/// runApp(ObaApp(application: app, initialLink: initialUri, links: uriStream));
/// ```
///
/// It builds the `MaterialApp` (brand theme unless [theme] is given, light,
/// dark and high-contrast; the SDK's localizations), the [ObaScope], the
/// onboarding gate and the [ObaHomeShell]. Hosts that only embed screens
/// don't use it.
class ObaApp extends StatefulWidget {
  const ObaApp({
    super.key,
    required this.application,
    this.initialLink,
    this.links,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.locale,
    this.onNavigate,
    this.onboardingSteps = const {
      OnboardingStep.welcome,
      OnboardingStep.location,
      OnboardingStep.region,
    },
    this.navigatorObservers = const [],
  });

  final ObaApplication application;

  /// The link the app was launched with, if any.
  final Uri? initialLink;

  /// Links received while running (from the host's app-links plugin).
  final Stream<Uri>? links;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;
  final Locale? locale;
  final ObaNavigateCallback? onNavigate;
  final Set<OnboardingStep> onboardingSteps;
  final List<NavigatorObserver> navigatorObservers;

  @override
  State<ObaApp> createState() => _ObaAppState();
}

class _ObaAppState extends State<ObaApp> {
  final GlobalKey<ObaHomeShellState> _shellKey = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> _messengerKey = GlobalKey();
  StreamSubscription<Uri>? _sub;
  final List<Uri> _pending = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialLink != null) _pending.add(widget.initialLink!);
    _sub = widget.links?.listen(_onLink);
    WidgetsBinding.instance.addPostFrameCallback((_) => _drain());
  }

  @override
  void didUpdateWidget(ObaApp old) {
    super.didUpdateWidget(old);
    if (old.links != widget.links) {
      _sub?.cancel();
      _sub = widget.links?.listen(_onLink);
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _onLink(Uri uri) {
    _pending.add(uri);
    _drain();
  }

  /// Handles queued links once the shell exists (after onboarding).
  void _drain() {
    if (!mounted || _pending.isEmpty) return;
    final shell = _shellKey.currentState;
    if (shell == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _drain());
      return;
    }
    final handler = ObaDeepLinkHandler(widget.application.core);
    for (final uri in List.of(_pending)) {
      _pending.remove(uri);
      switch (handler.resolve(uri)) {
        case OpenRouteAction(:final route, :final switchToRegion):
          if (switchToRegion != null) {
            // A manual choice, like the region picker: with automatic
            // selection left on, the next location fix would switch back
            // and the page just opened would ask the wrong server.
            final regions = widget.application.core.regions;
            regions.automaticallySelectRegion = false;
            regions.setCurrentRegion(switchToRegion);
          }
          shell.navigator.push(route);
        case UnknownRegionAction():
          final context = _messengerKey.currentContext;
          if (context != null) {
            // The messenger's own context can't find it, so this is
            // obaNotify written out.
            final message = context.obaL10n.deepLinkOtherRegion;
            _messengerKey.currentState?.showSnackBar(
              SnackBar(content: Text(message)),
            );
            obaAnnounce(context, message);
          }
        case null:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ObaScope(
      application: widget.application,
      onNavigate: widget.onNavigate,
      child: MaterialApp(
        title: widget.application.config.appName,
        scaffoldMessengerKey: _messengerKey,
        theme: widget.theme ?? ObaTheme.buildThemeData(),
        darkTheme:
            widget.darkTheme ??
            ObaTheme.buildThemeData(brightness: Brightness.dark),
        highContrastTheme:
            widget.theme ?? ObaTheme.buildThemeData(highContrast: true),
        highContrastDarkTheme:
            widget.darkTheme ??
            ObaTheme.buildThemeData(
              brightness: Brightness.dark,
              highContrast: true,
            ),
        themeMode: widget.themeMode,
        locale: widget.locale,
        localizationsDelegates: obaLocalizationsDelegates,
        supportedLocales: obaSupportedLocales,
        navigatorObservers: widget.navigatorObservers,
        home: ObaOnboardingGate(
          steps: widget.onboardingSteps,
          child: ObaHomeShell(key: _shellKey),
        ),
      ),
    );
  }
}
