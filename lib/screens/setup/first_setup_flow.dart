import 'package:flutter/material.dart';

import 'first_employee_page.dart';
import 'master_account_page.dart';
import 'tablet_name_page.dart';

/// Everything entered during first-time setup. Nothing is saved until the last
/// step, so a setup abandoned halfway leaves nothing behind.
class FirstSetupData {
  final String masterEmail;
  final String masterPassword;
  final String tabletName;
  final String employeeName;
  final String employeePin;

  const FirstSetupData({
    required this.masterEmail,
    required this.masterPassword,
    required this.tabletName,
    required this.employeeName,
    required this.employeePin,
  });
}

/// First-time setup on a new install (D-133): Master account, then tablet name,
/// then first employee. Each step opens on top of the last, so the tablet's back
/// button returns to the previous step with its fields still filled in.
class FirstSetupFlow extends StatelessWidget {
  /// Called once the last step is valid, with what every step entered.
  final void Function(FirstSetupData data) onFinished;

  const FirstSetupFlow({super.key, required this.onFinished});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    return MasterAccountPage(
      onNext: (email, password) => _open(
        context,
        TabletNamePage(
          onNext: (tabletName) => _open(
            context,
            FirstEmployeePage(
              onFinish: (employeeName, pin) => onFinished(FirstSetupData(
                masterEmail: email,
                masterPassword: password,
                tabletName: tabletName,
                employeeName: employeeName,
                employeePin: pin,
              )),
            ),
          ),
        ),
      ),
    );
  }
}
