import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imp_app/main.dart';
import 'package:imp_app/screens/box_page_screen.dart';
import 'package:imp_app/widgets/app_shell.dart';

/// The test font draws every glyph as a full square, about twice as wide as
/// Arial, so the narrow sidebar overflows in tests only. Call at the start of
/// a test body (testWidgets installs its own handler after setUp).
void ignoreOverflow() {
  final onError = FlutterError.onError;
  FlutterError.onError = (details) {
    if (details.exceptionAsString().contains('overflowed')) return;
    onError?.call(details);
  };
  addTearDown(() => FlutterError.onError = onError);
}

void main() {
  setUp(() {
    final view = TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1280, 900);
    view.devicePixelRatio = 1;
  });

  testWidgets('First-time setup runs three steps and signs in the first employee', (tester) async {
    ignoreOverflow();
    await tester.pumpWidget(const ImpApp());
    expect(find.text('Set up IMP'), findsOneWidget);
    expect(find.text('First-time setup, step 1 of 3'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('First-time setup, step 2 of 3'), findsOneWidget);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('First-time setup, step 3 of 3. Create the first employee.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Candy');
    await tester.pump();
    await tester.tap(find.text('Finish setup'));
    await tester.pumpAndSettle();
    expect(find.byType(AppShell), findsOneWidget);
    expect(find.text('Candy'), findsOneWidget);
  });

  testWidgets('Re-rack asks whether to reset the storage timer', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: BoxPageScreen(boxId: 6744)));
    expect(find.text('In storage since 04/19/26. Re-racking can reset it.'), findsOneWidget);

    await tester.tap(find.text('Re-rack box'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();
    expect(find.text('Reset the storage timer?'), findsOneWidget);
    expect(find.text('Keep 04/19/26'), findsOneWidget);

    await tester.tap(find.text('Reset to today'));
    await tester.pumpAndSettle();
    expect(find.text('In storage since 10/07/26. Re-racking can reset it.'), findsOneWidget);
    expect(find.text('Unsaved changes'), findsOneWidget);
  });

  testWidgets('Category delete is locked until Master mode is on', (tester) async {
    ignoreOverflow();
    await tester.pumpWidget(const MaterialApp(home: AppShell()));
    await tester.tap(find.text('Categories').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Delete').last);
    await tester.pumpAndSettle();
    expect(find.text('Turn on Master mode?'), findsOneWidget);
  });
}
