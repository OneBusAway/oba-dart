import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:obakit/obakit.dart';

void main() {
  testWidgets('a section heading stays apart from the text below it', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: const [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ObaSectionHeader(title: 'Bookmarks'),
                  Text('Bookmarked stops appear here.'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    expect(
      tester.getSemantics(find.text('Bookmarks')),
      matchesSemantics(label: 'Bookmarks', isHeader: true),
    );
    expect(
      tester.getSemantics(find.text('Bookmarked stops appear here.')),
      matchesSemantics(label: 'Bookmarked stops appear here.'),
    );
    handle.dispose();
  });
}
