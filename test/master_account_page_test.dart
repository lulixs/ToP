import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imp_app/screens/setup/master_account_page.dart';
import 'package:imp_app/theme.dart';

void main() {
  Future<void> tapNext(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Next'));
    await tester.tap(find.text('Next'));
    await tester.pump();
  }

  testWidgets('Next with empty fields shows errors and does not continue', (tester) async {
    var continued = false;
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: MasterAccountPage(onNext: (_, _) => continued = true),
    ));

    await tapNext(tester);

    expect(find.text('Enter an email'), findsOneWidget);
    expect(find.text('Enter a password'), findsOneWidget);
    expect(continued, isFalse);
  });

  testWidgets('Email needs text before the @, between the @ and a dot, and after the dot', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: MasterAccountPage(onNext: (_, _) {}),
    ));
    final emailField = find.byType(TextFormField).at(0);

    const invalid = ['@.', 'a@.', '@b.c', 'a@.c', 'a@b.', 'a@b', 'a.b@c', 'ab.c', 'a@@b.c', 'a@b@c.d', 'a b@c.d'];
    for (final email in invalid) {
      await tester.enterText(emailField, email);
      await tapNext(tester);
      expect(find.text('Enter a valid email'), findsOneWidget, reason: '"$email" should be rejected');
    }

    const valid = ['a@b.c', 'manager@example.org', 'first.last@mail.store.org'];
    for (final email in valid) {
      await tester.enterText(emailField, email);
      await tapNext(tester);
      expect(find.text('Enter a valid email'), findsNothing, reason: '"$email" should be accepted');
    }
  });

  testWidgets('Password needs at least 8 characters', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: MasterAccountPage(onNext: (_, _) {}),
    ));
    final passwordField = find.byType(TextFormField).at(1);

    await tester.enterText(passwordField, '1234567');
    await tapNext(tester);
    expect(find.text('Use at least 8 characters'), findsOneWidget);

    await tester.enterText(passwordField, '12345678');
    await tapNext(tester);
    expect(find.text('Use at least 8 characters'), findsNothing);
  });

  testWidgets('Mismatched passwords show an error', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: MasterAccountPage(onNext: (_, _) {}),
    ));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'manager@example.org');
    await tester.enterText(fields.at(1), 'secret123');
    await tester.enterText(fields.at(2), 'secret124');
    await tapNext(tester);

    expect(find.text('Passwords do not match'), findsOneWidget);
  });

  testWidgets('Valid fields continue with the trimmed email', (tester) async {
    String? email;
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: MasterAccountPage(onNext: (e, _) => email = e),
    ));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), '  manager@example.org ');
    await tester.enterText(fields.at(1), 'secret123');
    await tester.enterText(fields.at(2), 'secret123');
    await tapNext(tester);

    expect(email, 'manager@example.org');
  });
}
