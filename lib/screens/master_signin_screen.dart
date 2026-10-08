import 'package:flutter/material.dart';

import '../app_state.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'employee_signin_screen.dart';

/// Shared sign-in panel for tablet setup (01a) and Master mode (01b).
/// Any email/password works in this click-through.
class _MasterPanel extends StatefulWidget {
  final bool setup;
  final VoidCallback onSignIn;
  const _MasterPanel({required this.setup, required this.onSignIn});

  @override
  State<_MasterPanel> createState() => _MasterPanelState();
}

class _MasterPanelState extends State<_MasterPanel> {
  final tablet = TextEditingController(text: AppState.tabletName);

  @override
  void dispose() {
    tablet.dispose();
    super.dispose();
  }

  void _go() {
    if (widget.setup && tablet.text.trim().isNotEmpty) AppState.tabletName = tablet.text.trim();
    widget.onSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 420),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
          color: C.card, border: Border.all(color: C.line), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (widget.setup) ...[
          FieldLabel('Tablet name'),
          TextField(controller: tablet),
          Hint('Shown in Signed-in Devices and the Audit Log'),
          SizedBox(height: 14),
        ],
        FieldLabel('Email'),
        TextField(decoration: InputDecoration(hintText: 'manager@example.org')),
        SizedBox(height: 14),
        FieldLabel('Password'),
        TextField(obscureText: true, decoration: InputDecoration(hintText: '••••••••••')),
        SizedBox(height: 14),
        PillButton(widget.setup ? 'Set up tablet' : 'Sign in', style: BtnStyle.primary, wide: true, onTap: _go),
        SizedBox(height: 14),
        Row(children: [
          Expanded(child: Divider(color: C.line)),
          Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('or', style: TextStyle(color: C.ink2))),
          Expanded(child: Divider(color: C.line)),
        ]),
        SizedBox(height: 14),
        PillButton('Continue with Google', wide: true, onTap: _go),
        SizedBox(height: 14),
        PillButton('Continue with Microsoft', wide: true, onTap: _go),
      ]),
    );
  }
}

class _SignInFrame extends StatelessWidget {
  final String title, sub;
  final Widget panel;
  final Widget? below;
  const _SignInFrame({required this.title, required this.sub, required this.panel, this.below});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: C.panel,
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: DarkModeButton(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(children: [
              Logo(),
              SizedBox(height: 26),
              Text(title, style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700)),
              SizedBox(height: 8),
              Text(sub,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: C.ink2)),
              SizedBox(height: 26),
              panel,
              if (below != null) ...[SizedBox(height: 20), below!],
            ]),
          ),
        ),
      ),
    );
  }
}

/// 01a: first-time tablet setup. Leads to employee sign-in.
class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SignInFrame(
      title: 'Set up this tablet',
      sub: 'Sign in with the Master account the first time this tablet is used',
      panel: _MasterPanel(
        setup: true,
        onSignIn: () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => EmployeeSignInScreen())),
      ),
    );
  }
}

/// 01b: Master sign-in to turn on Master mode. Pops true on sign-in.
class MasterSignInScreen extends StatelessWidget {
  const MasterSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SignInFrame(
      title: 'Turn on Master mode',
      sub: 'Sign in with the Master account to unlock Master-only pages',
      panel: _MasterPanel(setup: false, onSignIn: () => Navigator.pop(context, true)),
      below: PillButton('Cancel', icon: Icons.arrow_back, onTap: () => Navigator.pop(context, false)),
    );
  }
}
