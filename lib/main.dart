import 'package:flutter/material.dart';

import 'screens/dashboard/dashboard_page.dart';
import 'screens/setup/first_setup_flow.dart';
import 'theme.dart';

void main() => runApp(const ImpApp());

class ImpApp extends StatelessWidget {
  const ImpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMP',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(),
      // Builder gives a context below MaterialApp, which Navigator needs.
      home: Builder(
        builder: (context) => FirstSetupFlow(
          // Temporary: the setup data is not saved anywhere yet, since there is no
          // backend call. Finishing setup just opens the dashboard and clears setup
          // from the back stack, so the back button can't return to it.
          onFinished: (data) => Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const DashboardPage()),
            (_) => false,
          ),
        ),
      ),
    );
  }
}
