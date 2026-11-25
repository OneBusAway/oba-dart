import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../app/application.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../widgets/states.dart';
import 'link_opener.dart';

/// Support email and store links for the settings screens.
abstract final class ObaSupport {
  /// Where feedback goes when `ObaAppConfig.developerEmail` is not set.
  static const defaultDeveloperEmail = 'iphone-app@onebusaway.org';
  static const defaultAgencyEmail = 'contact@onebusaway.org';

  /// The page where a rider can review the app, or null when the config has
  /// no store id for [ObaAppConfig.operatingSystem].
  static Uri? reviewUrl(ObaAppConfig config) {
    final os = config.operatingSystem;
    if (FarePayments.isApplePlatform(os)) {
      final id = config.appStoreId;
      return id == null
          ? null
          : Uri.parse('https://apps.apple.com/app/id$id?action=write-review');
    }
    final id = config.playStoreId;
    return id == null
        ? null
        : Uri.https('play.google.com', '/store/apps/details', {'id': id});
  }

  /// Builds the support email for [target]: the address, subject, intro and
  /// (for the developers) the troubleshooting block.
  static ContactUsMessage message(
    BuildContext context,
    ObaApplication app,
    ContactTarget target,
  ) {
    final l10n = context.obaL10n;
    final core = app.core;
    if (target == ContactTarget.transitAgency) {
      final email = core.currentRegion?.contactEmail ?? '';
      return ContactUsMessage(
        target: target,
        address: email.isEmpty ? defaultAgencyEmail : email,
        subject: l10n.moreEmailAgencySubject,
        intro: l10n.moreEmailIntro,
      );
    }
    final region = core.currentRegion;
    final locale = Localizations.maybeLocaleOf(context);
    return ContactUsMessage(
      target: target,
      address: core.config.developerEmail ?? defaultDeveloperEmail,
      subject: l10n.moreEmailSubject(core.config.appName),
      intro: l10n.moreEmailIntro,
      debugIntro: l10n.moreEmailDebugIntro,
      debugInfo: [
        DebugInfoEntry(l10n.moreDebugAppVersion, core.config.appVersion),
        DebugInfoEntry(
          l10n.moreDebugOs,
          '${core.config.operatingSystem} (${defaultTargetPlatform.name})',
        ),
        DebugInfoEntry(l10n.moreDebugLocale, locale?.toLanguageTag() ?? '-'),
        DebugInfoEntry(
          l10n.moreDebugBookmarks,
          '${core.userData.bookmarks.length}',
        ),
        DebugInfoEntry(
          l10n.moreDebugLocationPermission,
          core.locationPermission.name,
        ),
        DebugInfoEntry(l10n.moreDebugRegion, region?.regionName ?? '-'),
        DebugInfoEntry(
          l10n.moreDebugRegionId,
          region == null ? '-' : '${region.id}',
        ),
        DebugInfoEntry(
          l10n.moreDebugApiUrl,
          region?.obaBaseUrl.toString() ?? '-',
        ),
        DebugInfoEntry(l10n.moreDebugUserId, core.userUuid),
      ],
    );
  }

  /// Opens the rider's mail app with [target]'s message. When no mail
  /// handler exists, shows a dialog that copies the address or the whole
  /// message (with debug info) instead. Returns true when mail opened.
  static Future<bool> compose(
    BuildContext context,
    ContactTarget target, {
    String? analyticsLabel,
    String analyticsPage = 'app://localhost/more',
    String? analyticsValue,
  }) async {
    final app = ObaScope.of(context);
    final opener = ObaLinkOpenerScope.of(context);
    final msg = message(context, app, target);
    if (analyticsLabel != null) {
      app.core.analytics.reportEvent(
        pageUrl: analyticsPage,
        label: analyticsLabel,
        value: analyticsValue,
      );
    }
    final opened = await opener.open(msg.mailto);
    if (opened || !context.mounted) return opened;
    await showDialog<void>(
      context: context,
      builder: (_) => _CantEmailDialog(message: msg),
    );
    return false;
  }
}

class _CantEmailDialog extends StatelessWidget {
  const _CantEmailDialog({required this.message});

  final ContactUsMessage message;

  Future<void> _copy(BuildContext context, String text) async {
    final l10n = context.obaL10n;
    await Clipboard.setData(ClipboardData(text: text));
    if (!context.mounted) return;
    obaAnnounce(context, l10n.moreCopied);
    ScaffoldMessenger.maybeOf(context)
        ?.showSnackBar(SnackBar(content: Text(l10n.moreCopied)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.obaL10n;
    return AlertDialog(
      title: Text(l10n.moreCantEmailTitle),
      content: SingleChildScrollView(
        child: Text(l10n.moreCantEmailBody(message.address)),
      ),
      actions: [
        TextButton(
          onPressed: () => _copy(context, message.address),
          child: Text(l10n.moreCopyEmail),
        ),
        TextButton(
          onPressed: () => _copy(context, message.clipboardText),
          child: Text(l10n.moreCopyDebug),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonClose),
        ),
      ],
    );
  }
}
