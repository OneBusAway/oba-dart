import 'package:flutter/material.dart';
import 'package:obakit_core/obakit_core.dart' hide Route;

import '../../widgets/heading.dart';
import '../../app/scope.dart';
import '../../l10n/l10n.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import '../../navigation/sheet_detents.dart';
import '../../widgets/sheet_page.dart';
import 'contact_us.dart';
import '../../widgets/link_opener.dart';

/// A card asking riders to donate. Shows nothing unless donations are on
/// (`ObaAppConfig.donations.enabled`) and `DonationPromptState.shouldRequest`
/// holds (at least three launches, not dismissed, not reminded-later).
///
/// "Donate now" opens the donation page and stops asking. "Learn more" opens
/// [ObaDonationRoute]. "Remind me later" hides the card for two weeks, "No
/// thanks" for good. Place it in a feed or on a stop page.
class ObaDonationCard extends StatefulWidget {
  const ObaDonationCard({super.key, this.onFinished});

  /// Called after the rider chose any button except "Learn more".
  final VoidCallback? onFinished;

  @override
  State<ObaDonationCard> createState() => _ObaDonationCardState();
}

class _ObaDonationCardState extends State<ObaDonationCard> {
  bool? _visible;

  bool _decide(ObaCoreApplication core) {
    final show =
        core.donationPrompt.shouldRequest && core.prompts.canShowInlineCards();
    if (show) core.prompts.noteShown(PromptKind.donationModal);
    return show;
  }

  void _done() {
    setState(() => _visible = false);
    widget.onFinished?.call();
  }

  @override
  Widget build(BuildContext context) {
    final core = ObaScope.of(context).core;
    _visible ??= _decide(core);
    if (_visible != true) return const SizedBox.shrink();
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ObaHeading(l10n.donationTitle(core.config.appName)),
              const SizedBox(height: 8),
              Text(l10n.donationBody, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: () async {
                      await donate(context);
                      if (mounted) _done();
                    },
                    child: Text(l10n.donationDonate),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      core.analytics.reportEvent(
                        pageUrl: 'app://localhost/donations',
                        label: AnalyticsLabels.donationLearnMoreShown,
                      );
                      ObaNavigator.of(context).push(const ObaDonationRoute());
                    },
                    child: Text(l10n.donationLearnMore),
                  ),
                  TextButton(
                    onPressed: () {
                      core.donationPrompt.remindLater();
                      _done();
                    },
                    child: Text(l10n.donationRemindLater),
                  ),
                  TextButton(
                    onPressed: () {
                      core.donationPrompt.dismiss();
                      _done();
                    },
                    child: Text(l10n.donationDismiss),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Opens the donation page and records it (stops the card for good).
  static Future<bool> donate(BuildContext context) async {
    final core = ObaScope.of(context).core;
    core.analytics.reportEvent(
      pageUrl: 'app://localhost/donations',
      label: AnalyticsLabels.donateButtonTapped,
    );
    final ok = await ObaLinkOpenerScope.of(context)
        .open(core.config.donations.effectiveDonateUrl);
    if (ok) core.donationPrompt.dismiss();
    return ok;
  }
}

/// Opens [ObaDonationPage].
class ObaDonationRoute extends ObaCustomRoute {
  const ObaDonationRoute();

  @override
  String get id => 'donation';

  @override
  ObaSheetDetents get detents => ObaSheetDetents.mediumLarge;

  @override
  Widget build(BuildContext context) => const ObaDonationPage();
}

/// Why donations matter, with a button to the donation page.
class ObaDonationPage extends StatelessWidget {
  const ObaDonationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final core = ObaScope.of(context).core;
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final appName = core.config.appName;
    return ObaSheetPage(
      title: l10n.titleDonation(appName),
      slivers: [
        SliverList.list(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ObaHeading(
                    l10n.donationHeader,
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l10n.donationExplanation(appName),
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => _ObaDonationCardState.donate(context),
                    child: Text(l10n.donationDonateWebsite),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// An "Enjoying the app?" prompt. Shows nothing unless
/// `ReviewPromptPolicy.isPromptPending` (enough good moments recorded with
/// `core.reviewPrompt.recordSuccess()`, within the ask limits and back-offs)
/// and `PromptCoordinator.canShowReviewPrompt`. Showing it is recorded, as
/// iOS does when its alert appears.
///
/// "Yes!" opens the store review page (or the feedback email when the
/// config has no store id for this platform). "Not really" offers to send
/// feedback by email. "Ask me later" backs off for 60 days.
class ObaFeedbackPrompt extends StatefulWidget {
  const ObaFeedbackPrompt({super.key, this.onFinished});

  final VoidCallback? onFinished;

  @override
  State<ObaFeedbackPrompt> createState() => _ObaFeedbackPromptState();
}

enum _FeedbackStage { hidden, asking, negative }

class _ObaFeedbackPromptState extends State<ObaFeedbackPrompt> {
  _FeedbackStage? _stage;

  static const _page = 'app://localhost/feedback';

  _FeedbackStage _decide(ObaCoreApplication core) {
    if (!core.reviewPrompt.isPromptPending ||
        !core.prompts.canShowReviewPrompt()) {
      return _FeedbackStage.hidden;
    }
    core.prompts.noteShown(PromptKind.review);
    core.reviewPrompt.recordPromptPresented();
    core.analytics.reportEvent(
      pageUrl: _page,
      label: AnalyticsLabels.feedbackPromptShown,
    );
    return _FeedbackStage.asking;
  }

  void _report(String label) =>
      ObaScope.of(context).core.analytics
          .reportEvent(pageUrl: _page, label: label);

  void _hide() {
    setState(() => _stage = _FeedbackStage.hidden);
    widget.onFinished?.call();
  }

  Future<void> _yes() async {
    final core = ObaScope.of(context).core;
    final opener = ObaLinkOpenerScope.of(context);
    core.reviewPrompt.recordOutcome(FeedbackPromptOutcome.positive);
    _report(AnalyticsLabels.feedbackPositive);
    final url = ObaSupport.reviewUrl(core.config);
    if (url != null) {
      _hide();
      await opener.open(url);
    } else {
      await ObaSupport.compose(
        context,
        ContactTarget.appDevelopers,
        analyticsPage: _page,
      );
      if (mounted) _hide();
    }
  }

  void _no() {
    ObaScope.of(context).core.reviewPrompt
        .recordOutcome(FeedbackPromptOutcome.negative);
    _report(AnalyticsLabels.feedbackNegative);
    setState(() => _stage = _FeedbackStage.negative);
  }

  void _later() {
    ObaScope.of(context).core.reviewPrompt
        .recordOutcome(FeedbackPromptOutcome.deferred);
    _report(AnalyticsLabels.feedbackDeferred);
    _hide();
  }

  Future<void> _sendFeedback() async {
    final opened = await ObaSupport.compose(
      context,
      ContactTarget.appDevelopers,
      analyticsPage: _page,
      analyticsLabel: AnalyticsLabels.feedbackEmailOpened,
    );
    if (!opened && mounted) _report(AnalyticsLabels.feedbackEmailUnavailable);
    if (mounted) _hide();
  }

  @override
  Widget build(BuildContext context) {
    final core = ObaScope.of(context).core;
    _stage ??= _decide(core);
    final stage = _stage!;
    if (stage == _FeedbackStage.hidden) return const SizedBox.shrink();
    final l10n = context.obaL10n;
    final theme = Theme.of(context);
    final negative = stage == _FeedbackStage.negative;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Semantics(
            liveRegion: true,
            container: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ObaHeading(
                  negative
                      ? l10n.feedbackNegativeTitle
                      : l10n.feedbackTitle(core.config.appName),
                ),
                if (negative) ...[
                  const SizedBox(height: 4),
                  Text(
                    l10n.feedbackNegativeBody,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: negative
                      ? [
                          FilledButton(
                            onPressed: _sendFeedback,
                            child: Text(l10n.feedbackSend),
                          ),
                          TextButton(
                            onPressed: _hide,
                            child: Text(l10n.feedbackDecline),
                          ),
                        ]
                      : [
                          FilledButton(
                            onPressed: _yes,
                            child: Text(l10n.feedbackYes),
                          ),
                          OutlinedButton(
                            onPressed: _no,
                            child: Text(l10n.feedbackNo),
                          ),
                          TextButton(
                            onPressed: _later,
                            child: Text(l10n.feedbackLater),
                          ),
                        ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
