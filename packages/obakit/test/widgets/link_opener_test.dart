import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';
import 'package:obakit/src/widgets/link_opener.dart' show obaOpenLink;

import '../support/oba_test_harness.dart';

class _FakeOpener extends ObaLinkOpener {
  _FakeOpener(this.result);

  final bool result;
  final opened = <Uri>[];

  @override
  Future<bool> open(Uri uri) async {
    opened.add(uri);
    return result;
  }
}

void main() {
  final uri = Uri.parse('https://example.com');

  Future<void> pump(WidgetTester tester, ObaLinkOpener opener) async {
    final env = await ObaTestEnv.create();
    addTearDown(env.dispose);
    await env.pumpPage(
      tester,
      ObaLinkOpenerScope(
        opener: opener,
        child: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () => obaOpenLink(context, uri),
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pump();
  }

  testWidgets('links open through the host opener', (tester) async {
    final opener = _FakeOpener(true);
    await pump(tester, opener);
    expect(opener.opened, [uri]);
    expect(find.text("Couldn't open that link."), findsNothing);
  });

  testWidgets('a link that fails to open is reported', (tester) async {
    await pump(tester, _FakeOpener(false));
    expect(find.text("Couldn't open that link."), findsOneWidget);
  });
}
