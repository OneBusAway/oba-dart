// Calls every plural message in every supported locale with a spread of
// counts, so a translation whose plural is malformed for its language
// (a missing CLDR category, a dropped placeholder) fails here rather than
// on a rider's screen. The table below must list every plural message in
// app_en.arb; the first test fails when one is added without a row.

import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart' show Locale;
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

typedef PluralCall = String Function(ObaLocalizations l, int n);

const counts = [0, 1, 2, 3, 5, 11, 21, 100];

/// Sample values for the String placeholders: each one English shows for a
/// count must appear in the translation for that count.
final _sample = RegExp('‹[a-z]+›', caseSensitive: false);

final Map<String, PluralCall> pluralMessages = {
  'mapVisibleStopsCount': (l, n) => l.mapVisibleStopsCount(n),
  'stopPageRoutesHidden': (l, n) => l.stopPageRoutesHidden(n),
  'stopPageEarlier': (l, n) => l.stopPageEarlier(n),
  'stopPageWalkTimeLabel': (l, n) => l.stopPageWalkTimeLabel(n, '‹distance›'),
  'stopPageBikeTimeLabel': (l, n) => l.stopPageBikeTimeLabel(n, '‹distance›'),
  'stopPageAlertsCount': (l, n) => l.stopPageAlertsCount(n),
  'stopPageAlertsUnread': (l, n) => l.stopPageAlertsUnread(n),
  'stopRowA11yArrives': (l, n) => l.stopRowA11yArrives(n),
  'stopRowA11yDeparts': (l, n) => l.stopRowA11yDeparts(n),
  'stopRowA11yArrived': (l, n) => l.stopRowA11yArrived(n),
  'stopRowA11yDeparted': (l, n) => l.stopRowA11yDeparted(n),
  'stopRouteGroupLabel': (l, n) =>
      l.stopRouteGroupLabel('‹route›', '‹headsigns›', n, '‹eta›'),
  'stopAlarmLeadTime': (l, n) => l.stopAlarmLeadTime(n),
  'stopAlarmSet': (l, n) => l.stopAlarmSet(n),
  'stopTripStopsAway': (l, n) => l.stopTripStopsAway(n),
  'stopTripRunPassed': (l, n) => l.stopTripRunPassed(n),
  'stopTripRunApproaching': (l, n) => l.stopTripRunApproaching(n),
  'stopRouteStopsCount': (l, n) => l.stopRouteStopsCount(n),
  'stopSchedDepartures': (l, n) => l.stopSchedDepartures(n),
  'creditsLicenseCount': (l, n) => l.creditsLicenseCount(n),
  'recentsClearBody': (l, n) => l.recentsClearBody(n),
  'alarmsRowDetails': (l, n) => l.alarmsRowDetails(n, '‹time›'),
  'alertsUnreadCount': (l, n) => l.alertsUnreadCount(n),
  'alertsSectionMore': (l, n) => l.alertsSectionMore(n),
  'searchResultsHeading': (l, n) => l.searchResultsHeading(n, '‹query›'),
  'searchNearbyStopsCount': (l, n) => l.searchNearbyStopsCount(n),
  'searchWeatherSpokenF': (l, n) => l.searchWeatherSpokenF(n),
  'searchWeatherSpokenC': (l, n) => l.searchWeatherSpokenC(n),
  'coreDaysAgo': (l, n) => l.coreDaysAgo(n),
  'arrivalsNoArrivals': (l, n) => l.arrivalsNoArrivals(n),
  'arrivalsArrivingInMinutes': (l, n) => l.arrivalsArrivingInMinutes(n),
  'arrivalsMinutesLateSemantics': (l, n) => l.arrivalsMinutesLateSemantics(n),
  'arrivalsMinutesEarlySemantics': (l, n) => l.arrivalsMinutesEarlySemantics(n),
  'arrivalsEveryMinutesFromSemantics': (l, n) =>
      l.arrivalsEveryMinutesFromSemantics(n, '‹time›'),
  'arrivalsEveryMinutesUntilSemantics': (l, n) =>
      l.arrivalsEveryMinutesUntilSemantics(n, '‹time›'),
  'tripPlannerTransfers': (l, n) => l.tripPlannerTransfers(n),
  'tripPlannerMinutesSemantics': (l, n) => l.tripPlannerMinutesSemantics(n),
  'tripPlannerHoursSemantics': (l, n) => l.tripPlannerHoursSemantics(n),
  'tripPlannerFeetSemantics': (l, n) =>
      l.tripPlannerFeetSemantics(n, '‹value›'),
  'tripPlannerMilesSemantics': (l, n) =>
      l.tripPlannerMilesSemantics(n, '‹value›'),
  'tripPlannerMetersSemantics': (l, n) =>
      l.tripPlannerMetersSemantics(n, '‹value›'),
  'tripPlannerKilometersSemantics': (l, n) =>
      l.tripPlannerKilometersSemantics(n, '‹value›'),
  'tripPlannerStatusLateSemantics': (l, n) =>
      l.tripPlannerStatusLateSemantics(n),
  'tripPlannerStatusEarlySemantics': (l, n) =>
      l.tripPlannerStatusEarlySemantics(n),
  'tripPlannerTripsFound': (l, n) => l.tripPlannerTripsFound(n),
  'tripPlannerPlacesFound': (l, n) => l.tripPlannerPlacesFound(n),
  'tripPlannerStopCount': (l, n) => l.tripPlannerStopCount(n),
  'tripPlannerShowStops': (l, n) => l.tripPlannerShowStops(n),
  'tripPlannerHideStops': (l, n) => l.tripPlannerHideStops(n),
  'tripPlannerStepCount': (l, n) => l.tripPlannerStepCount(n),
  'tripPlannerShowSteps': (l, n) => l.tripPlannerShowSteps(n),
  'tripPlannerHideSteps': (l, n) => l.tripPlannerHideSteps(n),
};

/// Whether [text] shows [n] in Western or Arabic-Indic digits.
bool _hasNumber(String text, int n) {
  const arabic = '٠١٢٣٤٥٦٧٨٩';
  final digits = '$n';
  final eastern = String.fromCharCodes(
    digits.codeUnits.map((c) => arabic.codeUnitAt(c - 48)),
  );
  return text.contains(digits) || text.contains(eastern);
}

void main() {
  test('the table lists every plural message in app_en.arb', () {
    final template = jsonDecode(
      File('lib/src/l10n/app_en.arb').readAsStringSync(),
    ) as Map<String, dynamic>;
    final plurals = {
      for (final e in template.entries)
        if (!e.key.startsWith('@') &&
            RegExp(r',\s*(plural|select|selectordinal)\s*,')
                .hasMatch(e.value as String))
          e.key,
    };
    expect(pluralMessages.keys.toSet(), plurals);
  });

  for (final locale in obaSupportedLocales) {
    test('plurals in ${locale.toLanguageTag()}', () {
      final l10n = lookupObaLocalizations(locale);
      final english = lookupObaLocalizations(const Locale('en'));
      final problems = <String>[];
      for (final e in pluralMessages.entries) {
        for (final n in counts) {
          // The String placeholders English shows for this count.
          final expectedSamples = _sample
              .allMatches(e.value(english, n))
              .map((m) => m.group(0)!)
              .toSet();
          final String text;
          try {
            text = e.value(l10n, n);
          } catch (error) {
            problems.add('${e.key}($n) threw $error');
            continue;
          }
          if (text.trim().isEmpty) problems.add('${e.key}($n) is empty');
          if (text.contains('{') || text.contains('}')) {
            problems.add('${e.key}($n) has a raw brace: "$text"');
          }
          // A count English spells out must survive, except where a
          // language names it with a word: 1 (singular), 2 (Arabic dual)
          // and 0 (Arabic zero). Catches a `one{1 …}` branch shown for 21
          // (Russian) or 0 (French, Portuguese).
          final exempt =
              n == 1 || n == 2 || (n == 0 && locale.languageCode == 'ar');
          if (!exempt &&
              e.value(english, n).contains('$n') &&
              !_hasNumber(text, n)) {
            problems.add('${e.key}($n) loses the number: "$text"');
          }
          for (final s in expectedSamples) {
            // Arabic names exactly two with the dual ("two feet": قدمان).
            if (n == 2 && locale.languageCode == 'ar') continue;
            if (!text.contains(s)) {
              problems.add('${e.key}($n) drops $s: "$text"');
            }
          }
        }
      }
      expect(problems, isEmpty, reason: problems.join('\n'));
    });
  }
}
