import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

void main() {
  Future<(String?, DistanceUnits)> resolve(
    WidgetTester tester, {
    required Locale appLocale,
    required List<Locale> device,
  }) async {
    tester.platformDispatcher.localesTestValue = device;
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    late (String?, DistanceUnits) out;
    await tester.pumpWidget(
      Localizations(
        locale: appLocale,
        delegates: const [DefaultWidgetsLocalizations.delegate],
        child: Builder(
          builder: (context) {
            out = (obaCountryCode(context), obaDistanceUnits(context));
            return const SizedBox();
          },
        ),
      ),
    );
    return out;
  }

  testWidgets('a bare app locale takes the country from the device', (
    tester,
  ) async {
    // The SDK resolves to plain "en"; a US rider still gets feet and miles.
    expect(
      await resolve(
        tester,
        appLocale: const Locale('en'),
        device: const [Locale('en', 'US')],
      ),
      ('US', DistanceUnits.imperial),
    );
    expect(
      await resolve(
        tester,
        appLocale: const Locale('en'),
        device: const [Locale('en', 'AU')],
      ),
      ('AU', DistanceUnits.metric),
    );
    expect(
      await resolve(
        tester,
        appLocale: const Locale('de', 'DE'),
        device: const [Locale('en', 'US')],
      ),
      ('DE', DistanceUnits.metric),
    );
  });
}
