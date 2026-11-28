import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:tapline_example/widgets/host_oba_page.dart';

import 'support/test_env.dart';

/// A host screen with one button that pushes [route] through ObaNavigator.
Widget pusher(ObaRoute route) => Builder(
  builder: (context) => Scaffold(
    appBar: AppBar(title: const Text('Home')),
    body: Center(
      child: TextButton(
        onPressed: () => ObaNavigator.of(context).push<void>(route),
        child: const Text('Open'),
      ),
    ),
  ),
);

void main() {
  late TestEnv env;
  setUp(() async => env = await TestEnv.create());

  for (final (route, title, showsHeader) in [
    (const StopRoute('MTS_24151'), 'Transit', true),
    // With a name hint the app bar carries it and the SDK header goes.
    (
      const StopRoute('MTS_24151', name: 'Eighth College'),
      'Eighth College',
      false,
    ),
    (const TripPlannerRoute(), 'Plan a trip', false),
    (const AlertsListRoute(), 'Service alerts', false),
    (const BookmarksRoute(), 'Saved stops', false),
  ]) {
    testWidgets('onNavigate opens ${route.id} under Tapline\'s app bar', (
      tester,
    ) async {
      await env.pumpApp(tester, home: pusher(route));
      await tester.tap(find.text('Open'));
      await TestEnv.settle(tester);

      final host = tester.widget<HostObaPage>(find.byType(HostObaPage));
      expect(host.title, title);
      expect(host.showsHeader, showsHeader);
      // Only Tapline's app bar: the SDK page is embedded.
      expect(find.byType(AppBar), findsOneWidget);
      final modal = ModalRoute.of(tester.element(find.byType(HostObaPage)));
      expect(modal?.settings.arguments, route);
      env.expectReadOnly();
      await env.tearDown(tester);
    });
  }

  testWidgets('a page opened from a host page opens as another host page', (
    tester,
  ) async {
    await env.pumpApp(tester, home: pusher(const StopRoute('MTS_24151')));
    await tester.tap(find.text('Open'));
    await TestEnv.settle(tester);
    expect(find.byType(StopPage), findsOneWidget);

    // From inside the embedded stop page, as an SDK row would.
    ObaNavigator.of(tester.element(find.byType(StopPage)))
        .push<void>(const AlertsListRoute());
    await TestEnv.settle(tester);
    expect(find.byType(AlertsListPage), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);

    // popToRoot pops every SDK page and stops at the host's screen.
    ObaNavigator.of(tester.element(find.byType(AlertsListPage))).popToRoot();
    await TestEnv.settle(tester);
    expect(find.text('Home'), findsOneWidget);
    expect(find.byType(HostObaPage), findsNothing);
    await env.tearDown(tester);
  });

  testWidgets('the stop page shows its name once, in the SDK header', (
    tester,
  ) async {
    await env.pumpApp(tester, home: pusher(const StopRoute('MTS_24151')));
    await tester.tap(find.text('Open'));
    await TestEnv.settle(tester);
    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Transit')),
      findsOneWidget,
    );
    // The stop's name (from the captured response) appears once, in the
    // SDK's compact header, not in the app bar too.
    expect(
      find.text('Eighth College / Theatre District (North)'),
      findsOneWidget,
    );
    await env.tearDown(tester);
  });
}
