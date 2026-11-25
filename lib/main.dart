import 'package:app_links/app_links.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:obakit/obakit.dart';

import 'app_config.dart';

/// The OneBusAway app: configuration only. Everything else is `obakit`.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final links = AppLinks();
  runApp(
    await buildOneBusAwayApp(
      initialLink: await links.getInitialLink(),
      links: links.uriLinkStream,
    ),
  );
}

/// Builds the app widget with the real platform services. `main` passes
/// the platform's app links; the integration test passes its own stream.
Future<ObaApp> buildOneBusAwayApp({
  Uri? initialLink,
  Stream<Uri>? links,
}) async {
  // The regions list is the one bundled with obakit.
  final app = await ObaApplication.create(
    map: const ObaMapConfig(userAgentPackageName: obaBundleIdentifier),
    nominatimUserAgent: 'OneBusAway/$obaAppVersion ($obaBundleIdentifier)',
    config: (services) => buildObaAppConfig(
      services: services,
      operatingSystem: defaultTargetPlatform == TargetPlatform.android
          ? 'android'
          : 'ios',
    ),
  );
  return ObaApp(application: app, initialLink: initialLink, links: links);
}
