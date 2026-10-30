import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:imp_app/screens/setup/first_employee_page.dart';
import 'package:imp_app/screens/setup/first_setup_flow.dart';
import 'package:imp_app/screens/setup/master_account_page.dart';
import 'package:imp_app/screens/setup/tablet_name_page.dart';
import 'package:imp_app/theme.dart';

void main() {
  final fields = find.byType(TextFormField);

  Future<void> tapButton(WidgetTester tester, String label) async {
    await tester.ensureVisible(find.text(label));
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  Future<void> fillMasterAccount(WidgetTester tester) async {
    await tester.enterText(fields.at(0), 'store@example.org');
    await tester.enterText(fields.at(1), 'secret123');
    await tester.enterText(fields.at(2), 'secret123');
    await tapButton(tester, 'Next');
  }

  testWidgets('All three steps finish with everything that was entered', (tester) async {
    FirstSetupData? data;
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: FirstSetupFlow(onFinished: (d) => data = d),
    ));

    await fillMasterAccount(tester);
    expect(find.byType(TabletNamePage), findsOneWidget);

    await tester.enterText(fields.first, 'Front desk');
    await tapButton(tester, 'Next');
    expect(find.byType(FirstEmployeePage), findsOneWidget);

    await tester.enterText(fields.at(0), 'Mabel');
    await tester.enterText(fields.at(1), '123456');
    await tester.enterText(fields.at(2), '123456');
    await tapButton(tester, 'Finish setup');

    expect(data, isNotNull);
    expect(data!.masterEmail, 'store@example.org');
    expect(data!.masterPassword, 'secret123');
    expect(data!.tabletName, 'Front desk');
    expect(data!.employeeName, 'Mabel');
    expect(data!.employeePin, '123456');
  });

  testWidgets('Back returns to step 1 with the fields still filled in', (tester) async {
    await tester.pumpWidget(MaterialApp(
      theme: buildTheme(),
      home: FirstSetupFlow(onFinished: (_) {}),
    ));

    await fillMasterAccount(tester);
    expect(find.byType(TabletNamePage), findsOneWidget);

    // Same as pressing the tablet's back button.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.byType(MasterAccountPage), findsOneWidget);
    expect(find.text('store@example.org'), findsOneWidget);
  });
}
