import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imp_app/screens/setup/first_employee_page.dart';
import 'package:imp_app/theme.dart';

void main() {
  final fields = find.byType(TextFormField);
  Finder nameField() => fields.at(0);
  Finder pinField() => fields.at(1);
  Finder confirmField() => fields.at(2);

  Future<void> tapFinish(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Finish setup'));
    await tester.tap(find.text('Finish setup'));
    await tester.pump();
  }

  Future<void> showPage(WidgetTester tester, void Function(String name, String pin) onFinish) {
    return tester.pumpWidget(MaterialApp(theme: buildTheme(), home: FirstEmployeePage(onFinish: onFinish)));
  }

  testWidgets('Empty fields show errors and do not finish', (tester) async {
    var finished = false;
    await showPage(tester, (_, _) => finished = true);

    await tapFinish(tester);

    expect(find.text('Enter a name'), findsOneWidget);
    expect(find.text('Enter 6 digits'), findsOneWidget);
    expect(finished, isFalse);
  });

  testWidgets('A blank name is rejected', (tester) async {
    await showPage(tester, (_, _) {});

    await tester.enterText(nameField(), '   ');
    await tapFinish(tester);

    expect(find.text('Enter a name'), findsOneWidget);
  });

  testWidgets('The PIN needs exactly 6 digits and ignores anything else', (tester) async {
    await showPage(tester, (_, _) {});

    await tester.enterText(pinField(), '12345');
    await tapFinish(tester);
    expect(find.text('Enter 6 digits'), findsOneWidget);

    // Letters are dropped and typing stops at 6 digits.
    await tester.enterText(pinField(), '12ab34567');
    expect(tester.widget<TextFormField>(pinField()).controller!.text, '123456');
  });

  testWidgets('Mismatched PINs show an error', (tester) async {
    await showPage(tester, (_, _) {});

    await tester.enterText(nameField(), 'Mabel');
    await tester.enterText(pinField(), '123456');
    await tester.enterText(confirmField(), '123457');
    await tapFinish(tester);

    expect(find.text('PINs do not match'), findsOneWidget);
  });

  testWidgets('Valid fields finish with the trimmed name and the PIN', (tester) async {
    String? name;
    String? pin;
    await showPage(tester, (n, p) {
      name = n;
      pin = p;
    });

    await tester.enterText(nameField(), ' Mabel ');
    await tester.enterText(pinField(), '123456');
    await tester.enterText(confirmField(), '123456');
    await tapFinish(tester);

    expect(name, 'Mabel');
    expect(pin, '123456');
  });
}
