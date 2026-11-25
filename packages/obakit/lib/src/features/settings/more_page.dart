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
import 'contact_us.dart';
import '../../widgets/link_opener.dart';

/// The More screen: support text, donations, alerts, region and fare
/// payment, agencies, contact links, volunteer links, agency resources and
/// "about". Driven by `ObaAppConfig.moreTab`, and rows appear only when the
/// feature is available (donations on, a payment app for the region, ...).
class MorePage extends StatelessWidget {
  const MorePage({super.key});

  @override
  Widget build(BuildContext context) {
    final core = ObaScope.of(context).core;
    return ListenableBuilder(
      listenable: Listenable.merge([core.regions.listenable, core.listenable]),
      builder: (context, _) => ObaSheetPage(
        title: context.obaL10n.titleMore,
        slivers: [SliverList.list(children: _rows(context, core))],
      ),
    );
  }

  List<Widget> _rows(BuildContext context, ObaCoreApplication core) {
    final l10n = context.obaL10n;
    final config = core.config;
    final more = config.moreTab;
    final region = core.currentRegion;
    final nav = ObaNavigator.of(context);
    final appName = config.appName;
    final reviewUrl = ObaSupport.reviewUrl(config);

    Widget link(String title, Uri url) => _LinkRow(title: title, url: url);

    return [
      _Header(text: more.headerSupportText ?? l10n.moreHeaderSupport),

      if (config.donations.enabled) ...[
        ObaSectionHeader(title: l10n.moreSectionDonate),
        _LinkRow(
          title: l10n.moreDonate(appName),
          url: config.donations.effectiveDonateUrl,
          analytics: (
            page: 'app://localhost/donations',
            label: AnalyticsLabels.donateButtonTapped,
          ),
          onOpened: core.donationPrompt.dismiss,
        ),
        if (config.donations.managementPortal != null)
          link(l10n.moreManageDonations, config.donations.managementPortal!),
      ],

      ObaSectionHeader(title: l10n.moreSectionUpdates),
      ObaListRow(
        title: l10n.moreAlerts,
        trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
        onTap: () => nav.push(const AlertsListRoute()),
      ),

      ObaSectionHeader(title: l10n.moreSectionLocation),
      ObaListRow(
        title: l10n.moreRegion,
        subtitle: region?.regionName ?? l10n.moreRegionNone,
        trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
        onTap: () => nav.push(const RegionPickerRoute()),
      ),
      if (region != null &&
          FarePayments.isSupported(region, config.operatingSystem))
        ObaListRow(
          title: l10n.morePayFare,
          trailing: const ExcludeSemantics(child: Icon(Icons.open_in_new)),
          onTap: () => payMyFare(context),
        ),
      ObaListRow(
        title: l10n.moreAgencies,
        trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
        onTap: () => nav.push(const AgenciesRoute()),
      ),

      if (more.tutorialUrl != null ||
          more.phoneUrl != null ||
          more.textUrl != null) ...[
        ObaSectionHeader(title: l10n.moreSectionContact),
        if (more.tutorialUrl != null)
          link(l10n.moreTutorials, more.tutorialUrl!),
        if (more.phoneUrl != null) link(l10n.moreCallAgency, more.phoneUrl!),
        if (more.textUrl != null) link(l10n.moreTextAgency, more.textUrl!),
      ],

      if (more.showHelpOutSection &&
          (more.translateUrl != null || more.developUrl != null)) ...[
        ObaSectionHeader(title: l10n.moreSectionHelpOut),
        if (more.translateUrl != null)
          link(l10n.moreTranslate, more.translateUrl!),
        if (more.developUrl != null) link(l10n.moreDevelop, more.developUrl!),
      ],

      if (more.customLinks.isNotEmpty) ...[
        ObaSectionHeader(title: l10n.moreSectionResources),
        for (final l in more.customLinks) link(l.title, l.url),
      ],

      ObaSectionHeader(title: l10n.moreSectionAbout),
      if (reviewUrl != null)
        _LinkRow(
          title: l10n.moreRateApp(appName),
          url: reviewUrl,
          analytics: (
            page: 'app://localhost/feedback',
            label: AnalyticsLabels.rateAppRowTapped,
          ),
        ),
      ObaListRow(
        title: l10n.moreContactUs,
        trailing: const ExcludeSemantics(child: Icon(Icons.mail_outline)),
        onTap: () => contactUs(context),
      ),
      if (config.privacyPolicyUrl != null)
        link(l10n.morePrivacy, config.privacyPolicyUrl!),
      ObaListRow(
        title: l10n.moreCredits,
        trailing: const ExcludeSemantics(child: Icon(Icons.chevron_right)),
        onTap: () => nav.push(const CreditsRoute()),
      ),
      _VersionLine(text: l10n.moreVersion(appName, config.appVersion)),
    ];
  }

  /// "Contact us": asks whether the message is for the app developers or
  /// the transit agency, then opens the mail app (see [ObaSupport.compose]).
  static Future<void> contactUs(BuildContext context) async {
    final l10n = context.obaL10n;
    final target = await showDialog<ContactTarget>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.moreContactTitle),
        children: [
          SimpleDialogOption(
            onPressed: () =>
                Navigator.of(context).pop(ContactTarget.appDevelopers),
            child: Text(l10n.moreContactDevelopers),
          ),
          SimpleDialogOption(
            onPressed: () =>
                Navigator.of(context).pop(ContactTarget.transitAgency),
            child: Text(l10n.moreContactAgency),
          ),
        ],
      ),
    );
    if (target == null || !context.mounted) return;
    await ObaSupport.compose(
      context,
      target,
      analyticsLabel: AnalyticsLabels.reportProblem,
      analyticsValue: target == ContactTarget.appDevelopers
          ? 'feedback_app_feedback_email'
          : 'feedback_customer_service',
    );
  }

  /// Pay My Fare: shows the region's warning once (when it has one), then
  /// opens the payment app, or its store page when it is not installed.
  static Future<void> payMyFare(BuildContext context) async {
    final app = ObaScope.of(context);
    final core = app.core;
    final region = core.currentRegion;
    if (region == null) return;
    final l10n = context.obaL10n;
    final opener = ObaLinkOpenerScope.of(context);

    if (core.farePayments.shouldShowWarning(region)) {
      final choice = await showDialog<_FareChoice>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(region.paymentWarningTitle ?? ''),
          content: SingleChildScrollView(
            child: Text(region.paymentWarningBody ?? ''),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.of(context).pop(_FareChoice.continueAlways),
              child: Text(l10n.moreFareDontShowAgain),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(_FareChoice.proceed),
              child: Text(l10n.moreFareContinue),
            ),
          ],
        ),
      );
      if (choice == null) return;
      if (choice == _FareChoice.continueAlways) {
        core.farePayments.suppressWarning(region);
      }
    }

    final target = FarePayments.targetFor(region, core.config.operatingSystem);
    const page = 'app://localhost/fare-payments';
    var opened = false;
    if (target.appUri != null && await opener.open(target.appUri!)) {
      opened = true;
      core.analytics.reportEvent(
        pageUrl: page,
        label: AnalyticsLabels.farePayment,
        value: 'open_app',
      );
    }
    if (!opened) {
      core.analytics.reportEvent(
        pageUrl: page,
        label: AnalyticsLabels.farePayment,
        value: 'download_app',
      );
      if (target.storeUri != null) opened = await opener.open(target.storeUri!);
    }
    if (!opened && context.mounted) {
      obaNotify(context, l10n.commonCantOpenLink);
    }
  }
}

enum _FareChoice { proceed, continueAlways }

class _Header extends StatelessWidget {
  const _Header({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(
              Icons.volunteer_activism,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}

class _VersionLine extends StatelessWidget {
  const _VersionLine({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 8),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// A row that opens [url] outside the app.
class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.title,
    required this.url,
    this.analytics,
    this.onOpened,
  });

  final String title;
  final Uri url;
  final ({String page, String label})? analytics;
  final VoidCallback? onOpened;

  @override
  Widget build(BuildContext context) => ObaListRow(
    title: title,
    trailing: const ExcludeSemantics(child: Icon(Icons.open_in_new)),
    onTap: () async {
      final core = ObaScope.of(context).core;
      final a = analytics;
      if (a != null) {
        core.analytics.reportEvent(pageUrl: a.page, label: a.label);
      }
      if (await obaOpenLink(context, url)) onOpened?.call();
    },
  );
}
