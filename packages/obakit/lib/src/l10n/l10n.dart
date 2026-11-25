import 'package:flutter/widgets.dart';
import 'package:obakit_core/obakit_core.dart' show DistanceUnits, WeatherUnits;
import 'package:flutter_localizations/flutter_localizations.dart';

import 'generated/oba_localizations.dart';

export 'generated/oba_localizations.dart';

/// Every delegate the SDK needs: a host that builds its own `MaterialApp`
/// can pass these as `localizationsDelegates` (merged with its own). Hosts
/// that skip it still work: `ObaScope` adds [ObaLocalizations.delegate]
/// below itself when it is missing.
const List<LocalizationsDelegate<Object?>> obaLocalizationsDelegates = [
  ObaLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

/// Locales the SDK has strings for.
const List<Locale> obaSupportedLocales = ObaLocalizations.supportedLocales;

/// `context.obaL10n`: the SDK's strings, never null. Falls back to English
/// when the host's locale has no translation (or no delegate is
/// registered), so an embedded screen never crashes on a missing string.
extension ObaL10nContext on BuildContext {
  ObaLocalizations get obaL10n =>
      ObaLocalizations.of(this) ?? lookupObaLocalizations(const Locale('en'));
}

/// [text] wrapped in Unicode first-strong isolates when the ambient
/// direction is right-to-left, so a left-to-right name from the server
/// ("Washington, D.C.") keeps its punctuation at its own end instead of
/// jumping to the start of the line. Unchanged in left-to-right locales.
String obaBidiIsolate(BuildContext context, String text) =>
    Directionality.maybeOf(context) == TextDirection.rtl && text.isNotEmpty
    ? '\u2068$text\u2069'
    : text;

/// The rider's country for measurement units. The app's resolved locale
/// is often a bare language (`en`: the SDK ships no `en_US` strings), so
/// the country comes from the first device locale with that language, then
/// from the first device locale; a bare `en` with nothing else reads as US.
String? obaCountryCode(BuildContext context) {
  final locale = Localizations.maybeLocaleOf(context);
  final own = locale?.countryCode;
  if (own != null && own.isNotEmpty) return own.toUpperCase();
  final device = WidgetsBinding.instance.platformDispatcher.locales;
  for (final l in device) {
    if (l.languageCode == locale?.languageCode &&
        (l.countryCode ?? '').isNotEmpty) {
      return l.countryCode!.toUpperCase();
    }
  }
  for (final l in device) {
    if ((l.countryCode ?? '').isNotEmpty) return l.countryCode!.toUpperCase();
  }
  return (locale?.languageCode ?? 'en') == 'en' ? 'US' : null;
}

/// Feet and miles in the US, Liberia, Myanmar and the UK; metres and
/// kilometres elsewhere. One policy for every screen.
DistanceUnits obaDistanceUnits(BuildContext context) =>
    const {
      'US',
      'LR',
      'MM',
      'GB',
      'PR',
      'GU',
      'VI',
      'AS',
      'MP',
      'UM',
    }.contains(obaCountryCode(context))
    ? DistanceUnits.imperial
    : DistanceUnits.metric;

/// Temperature and wind units for the rider's country.
WeatherUnits obaWeatherUnits(BuildContext context) => WeatherUnits.forLocale(
  languageCode: Localizations.maybeLocaleOf(context)?.languageCode ?? 'en',
  countryCode: obaCountryCode(context),
);
