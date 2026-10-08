import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

/// 02a: pick a name, enter any 6-digit PIN. The 6th digit signs in.
class EmployeeSignInScreen extends StatefulWidget {
  const EmployeeSignInScreen({super.key});

  @override
  State<EmployeeSignInScreen> createState() => _EmployeeSignInScreenState();
}

class _EmployeeSignInScreenState extends State<EmployeeSignInScreen> {
  late String name = employees.firstWhere((e) => e.active && e.name == AppState.currentUser,
      orElse: () => employees.firstWhere((e) => e.active)).name;
  String pin = '';

  void _press(String k) {
    setState(() {
      if (k == 'del') {
        if (pin.isNotEmpty) pin = pin.substring(0, pin.length - 1);
      } else if (pin.length < 6) {
        pin += k;
      }
    });
    if (pin.length == 6) {
      AppState.currentUser = name;
      AppState.masterOn.value = false;
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (_) => AppShell()), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = employees.where((e) => e.active).map((e) => e.name).toList();
    return Scaffold(
      backgroundColor: C.panel,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: DarkModeButton(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
            child: Column(children: [
              Logo(),
              SizedBox(height: 26),
              Text('Employee sign-in', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text('Choose your name, then enter your 6-digit PIN',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: C.ink2)),
              SizedBox(height: 26),
              Container(
                constraints: BoxConstraints(maxWidth: 420),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                decoration: BoxDecoration(
                    color: C.card, border: Border.all(color: C.line), borderRadius: BorderRadius.circular(16)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  FieldLabel('Name'),
                  SelectBox(value: name, items: active, onChanged: (v) => setState(() => name = v)),
                  Hint('Active accounts only'),
                  SizedBox(height: 12),
                  FieldLabel('PIN'),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    for (var i = 0; i < 6; i++)
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: i < pin.length ? C.ink : null,
                            border: Border.all(color: C.ink, width: 2)),
                      ),
                  ]),
                  SizedBox(height: 12),
                  _Keypad(onPress: _press),
                ]),
              ),
              SizedBox(height: 16),
              Text(AppState.tabletName, style: TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic, color: C.ink3)),
            ]),
          ),
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  final ValueChanged<String> onPress;
  const _Keypad({required this.onPress});

  @override
  Widget build(BuildContext context) {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'del'];
    return Center(
      child: SizedBox(
        width: 76 * 3 + 30 * 2,
        child: Wrap(spacing: 30, runSpacing: 14, children: [
          for (final k in keys)
            k.isEmpty
                ? SizedBox(width: 76, height: 76)
                : Material(
                    color: k == 'del' ? g(0xFFE4E4E4) : C.card,
                    shape: CircleBorder(
                        side: BorderSide(color: k == 'del' ? g(0xFF9A9A9A) : C.ink2, width: 1.5)),
                    child: InkWell(
                      customBorder: CircleBorder(),
                      onTap: () => onPress(k),
                      child: SizedBox(
                        width: 76,
                        height: 76,
                        child: Center(
                          child: k == 'del'
                              ? Icon(Icons.backspace_outlined, size: 28, color: C.ink)
                              : Text(k, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ),
        ]),
      ),
    );
  }
}
