import 'package:flutter/material.dart';

import 'screens/master_signin_screen.dart';
import 'theme.dart';

/// IMP tablet app - click-through front end.
/// Flow: Tablet setup (any email/password) -> Employee sign-in (any 6-digit PIN)
/// -> Dashboard. Everything runs on fake data in lib/data/mock_data.dart.
void main() => runApp(const ImpApp());

class ImpApp extends StatelessWidget {
  const ImpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkMode,
      builder: (context, _, __) => MaterialApp(
        title: 'IMP',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(),
        home: SetupScreen(),
      ),
    );
  }
}
