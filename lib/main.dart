import 'package:flutter/material.dart';

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
      // Temporary: there is no backend call or dashboard yet, so finishing setup
      // only prints to the terminal. Passwords and PINs are never printed.
      home: FirstSetupFlow(
        onFinished: (data) => debugPrint(
          'Setup finished: Master ${data.masterEmail}, tablet "${data.tabletName}", '
          'employee "${data.employeeName}"',
        ),
      ),
    );
  }
}
