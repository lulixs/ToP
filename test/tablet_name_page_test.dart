import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imp_app/screens/setup/tablet_name_page.dart';
import 'package:imp_app/theme.dart';

void main() {
  Future<void> tapNext(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pump();
  }

  Future<void> showPage(WidgetTester tester, void Function(String name) onNext) {
    return tester.pumpWidget(MaterialApp(theme: buildTheme(), home: TabletNamePage(onNext: onNext)));
  }

  testWidgets('Empty or blank name shows an error and does not continue', (tester) async {
    var continued = false;
    await showPage(tester, (_) => continued = true);

    await tapNext(tester);
    expect(find.text('Enter a tablet name'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), '   ');
    await tapNext(tester);
    expect(find.text('Enter a tablet name'), findsOneWidget);
    expect(continued, isFalse);
  });

  testWidgets('One character is enough, and the name is trimmed', (tester) async {
    String? name;
    await showPage(tester, (n) => name = n);

    await tester.enterText(find.byType(TextFormField), ' A ');
    await tapNext(tester);

    expect(name, 'A');
  });

  testWidgets('Spaces and special characters are allowed', (tester) async {
    String? name;
    await showPage(tester, (n) => name = n);

    await tester.enterText(find.byType(TextFormField), 'Front desk #2 (old)');
    await tapNext(tester);

    expect(name, 'Front desk #2 (old)');
  });

  testWidgets('Name is capped at 100 characters', (tester) async {
    String? name;
    await showPage(tester, (n) => name = n);

    await tester.enterText(find.byType(TextFormField), 'x' * 150);
    await tapNext(tester);

    expect(name, 'x' * 100);
  });
}
