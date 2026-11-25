// Settings, More, regions, custom regions, credits, onboarding and the
// "Settings and more" home section. Each page lives in its own file in this
// folder; this file maps routes to pages and exports them.

import 'package:flutter/material.dart';

import '../../navigation/home_sections.dart';
import '../../navigation/oba_navigator.dart';
import '../../navigation/oba_route.dart';
import 'credits_page.dart';
import 'custom_region_page.dart';
import 'more_page.dart';
import 'onboarding_pages.dart';
import 'region_picker_page.dart';
import 'settings_home_section.dart';
import 'settings_page.dart';

export 'contact_us.dart' show ObaSupport;
export 'credits_page.dart'
    show CreditsPage, ObaLicensesPage, ObaLicensesRoute, kObaLicenseText;
export 'custom_region_page.dart' show CustomRegionPage;
export 'link_opener.dart'
    show ObaLinkOpener, ObaLinkOpenerScope, UrlLauncherLinkOpener;
export 'more_page.dart' show MorePage;
export 'onboarding_pages.dart' show OnboardingStepPage;
export 'prompt_cards.dart'
    show ObaDonationCard, ObaDonationPage, ObaDonationRoute, ObaFeedbackPrompt;
export 'region_picker_page.dart' show RegionPickerPage;
export 'settings_home_section.dart' show SettingsAndMoreSection;
export 'settings_page.dart' show SettingsPage, ObaSettingSwitch, ObaChoiceGroup;
export 'survey_card.dart'
    show ObaSurveyCard, ObaSurveyPage, ObaSurveyRoute, SurveyQuestionField;

Widget buildSettingsRoute(BuildContext context, SettingsRoute route) =>
    const SettingsPage();

Widget buildMoreRoute(BuildContext context, MoreRoute route) =>
    const MorePage();

Widget buildRegionPickerRoute(BuildContext context, RegionPickerRoute route) =>
    const RegionPickerPage();

Widget buildCustomRegionRoute(BuildContext context, CustomRegionRoute route) =>
    CustomRegionPage(prefill: route.prefill, editRegionId: route.editRegionId);

Widget buildCreditsRoute(BuildContext context, CreditsRoute route) =>
    const CreditsPage();

Widget buildOnboardingRoute(BuildContext context, OnboardingRoute route) =>
    OnboardingStepPage(
      step: route.step,
      onComplete: () => ObaNavigator.of(context).pop(),
    );

/// Builds one onboarding page for the gate. Call [onComplete] when the
/// rider finishes the step (the gate then marks it seen and moves on).
Widget buildOnboardingStep(
  BuildContext context,
  OnboardingStep step,
  VoidCallback onComplete,
) => OnboardingStepPage(step: step, onComplete: onComplete);

List<ObaHomeSection> get settingsHomeSections => [
  ObaHomeSection(
    id: 'more',
    order: 50,
    builder: (context) => const SettingsAndMoreSection(),
  ),
];
