import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens web pages, mail, phone and store links on behalf of the settings
/// screens. The default uses `url_launcher`. A host can install its own
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
