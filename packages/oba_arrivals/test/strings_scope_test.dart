import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oba_arrivals/oba_arrivals.dart';

import 'support/fixtures.dart';

class _ScopeStrings extends ObaArrivalsStrings {
  const _ScopeStrings(this.prefix);

  final String prefix;

  @override
  String get refresh => '$prefix refresh';

  @override
  String stopNumber(String code) => '$prefix stop $code';
}

class _HostStrings extends ObaArrivalsStrings {
  const _HostStrings();

  @override
  String stopNumber(String code) => 'Host stop $code';
}

ObaArrivalsStrings _byLocale(BuildContext context) =>
    _ScopeStrings(Localizations.localeOf(context).toLanguageTag());

Widget _app(Widget panel, {Locale locale = const Locale('en', 'US')}) =>
    ObaArrivalsStringsScope(
      resolve: _byLocale,
      child: MaterialApp(
        locale: locale,
        supportedLocales: const [Locale('en', 'US'), Locale('en', 'GB')],
        home: Scaffold(body: SingleChildScrollView(child: panel)),
      ),
    );

void main() {
  testWidgets('a panel with default strings uses the scope at its context', (
    tester,
  ) async {
    final client = fakeClient((_) async => okResponse());
    final panel = ObaArrivalsPanel(client: client, stopId: 'MTS_24151');
    await tester.pumpWidget(_app(panel));
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('en-US stop 24151'), findsOneWidget);
    expect(find.byTooltip('en-US refresh'), findsOneWidget);

    // The panel follows a locale change below the scope.
    await tester.pumpWidget(_app(panel, locale: const Locale('en', 'GB')));
    await tester.pump();
    expect(find.textContaining('en-GB stop 24151'), findsOneWidget);
    expect(find.byTooltip('en-GB refresh'), findsOneWidget);
  });

  testWidgets('strings passed to the panel win over the scope', (tester) async {
    await tester.pumpWidget(
      _app(
        ObaArrivalsPanel(
          client: fakeClient((_) async => okResponse()),
          stopId: 'MTS_24151',
          strings: const _HostStrings(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('Host stop 24151'), findsOneWidget);
    expect(find.textContaining('en-US stop'), findsNothing);
  });

  testWidgets('without a scope the panel stays English', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: ObaArrivalsPanel(
              client: fakeClient((_) async => okResponse()),
              stopId: 'MTS_24151',
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('Stop #24151'), findsOneWidget);
    expect(find.byTooltip('Refresh arrivals'), findsOneWidget);
  });
}
