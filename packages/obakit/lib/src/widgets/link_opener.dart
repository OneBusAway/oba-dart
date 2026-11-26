import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';
import 'states.dart';

/// Opens web pages, mail, phone, maps and store links for every SDK
/// screen. The default uses `url_launcher`. A host can install its own
/// with [ObaLinkOpenerScope] (to open links in an in-app browser, say), and
/// tests install a fake.
abstract class ObaLinkOpener {
  const ObaLinkOpener();

  /// Opens [uri] outside the app. Completes with false when nothing could
  /// handle it.
  Future<bool> open(Uri uri);
}

/// The default [ObaLinkOpener].
class UrlLauncherLinkOpener extends ObaLinkOpener {
  const UrlLauncherLinkOpener();

  @override
  Future<bool> open(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }
}

/// Supplies the [ObaLinkOpener] for the screens below it.
class ObaLinkOpenerScope extends InheritedWidget {
  const ObaLinkOpenerScope({
    super.key,
    required this.opener,
    required super.child,
  });

  final ObaLinkOpener opener;

  /// The nearest opener, or the `url_launcher` default.
  static ObaLinkOpener of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ObaLinkOpenerScope>()?.opener ??
      const UrlLauncherLinkOpener();

  @override
  bool updateShouldNotify(ObaLinkOpenerScope old) => old.opener != opener;
}

/// Opens [uri] outside the app; true when it launched. A page's `urlOpener`
/// parameter takes one to override [ObaLinkOpenerScope] for that page.
typedef ObaUrlOpener = Future<bool> Function(Uri uri);

/// Opens [uri] with [opener] (default: the nearest [ObaLinkOpenerScope])
/// and, when nothing could open it, tells the rider with a snack bar and a
/// screen-reader announcement ([failureMessage], default "Couldn't open
/// that link."). Completes with whether it opened.
Future<bool> obaOpenLink(
  BuildContext context,
  Uri uri, {
  ObaUrlOpener? opener,
  String? failureMessage,
}) async {
  final open = opener ?? ObaLinkOpenerScope.of(context).open;
  final ok = await open(uri);
  if (!ok && context.mounted) {
    obaNotify(context, failureMessage ?? context.obaL10n.commonCantOpenLink);
  }
  return ok;
}

/// Whether [uri] is a web link (http or https): the only kind an alert may
/// open (iOS `isValidAlertURL`).
bool isWebUri(Uri uri) {
  final scheme = uri.scheme.toLowerCase();
  return scheme == 'http' || scheme == 'https';
}
