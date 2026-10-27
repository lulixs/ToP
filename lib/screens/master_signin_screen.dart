import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';
import 'employee_signin_screen.dart';

/// White card that holds the fields on every sign-in and setup screen.
class _Panel extends StatelessWidget {
  final List<Widget> children;
  const _Panel(this.children);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 420),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      decoration: BoxDecoration(
          color: C.card, border: Border.all(color: C.line), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );
  }
}

/// Shared sign-in panel for tablet setup (01a) and Master mode (01b).
/// Any email/password works in this click-through. A blank field shows the 01b error.
class _MasterPanel extends StatefulWidget {
  final bool setup;
  final VoidCallback onSignIn;
  const _MasterPanel({required this.setup, required this.onSignIn});

  @override
  State<_MasterPanel> createState() => _MasterPanelState();
}

class _MasterPanelState extends State<_MasterPanel> {
  final tablet = TextEditingController(text: AppState.tabletName);
  final email = TextEditingController();
  final password = TextEditingController();
  bool error = false;

  @override
  void dispose() {
    tablet.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void _go() {
    if (email.text.trim().isEmpty || password.text.isEmpty) {
      setState(() => error = true);
      return;
    }
    if (widget.setup && tablet.text.trim().isNotEmpty) AppState.tabletName = tablet.text.trim();
    widget.onSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return _Panel([
      if (error) ErrorBox('Incorrect email or password. Try again.'),
      if (widget.setup) ...[
        FieldLabel('Tablet name'),
        TextField(controller: tablet),
        Hint('Shown in Signed-in Devices and the Audit Log'),
        SizedBox(height: 14),
      ],
      FieldLabel('Email'),
      TextField(controller: email, decoration: InputDecoration(hintText: 'manager@example.org')),
      SizedBox(height: 14),
      FieldLabel('Password'),
      TextField(controller: password, obscureText: true, decoration: InputDecoration(hintText: '••••••••••')),
      SizedBox(height: 14),
      PillButton(widget.setup ? 'Set up tablet' : 'Sign in', style: BtnStyle.primary, wide: true, onTap: _go),
    ]);
  }
}

class _SignInFrame extends StatelessWidget {
  final String title, sub;
  final Widget? header;
  final Widget panel;
  final Widget? below;
  const _SignInFrame({required this.title, required this.sub, this.header, required this.panel, this.below});

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
              if (header != null) ...[SizedBox(height: 18), header!],
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

/// 01c/d/e: first-time setup on a new install (D-133). Creates the Master
/// account, names the tablet, then creates the first employee, who is signed
/// in when setup is done. Later tablets use [SetupScreen].
class FirstSetupScreen extends StatefulWidget {
  const FirstSetupScreen({super.key});

  @override
  State<FirstSetupScreen> createState() => _FirstSetupScreenState();
}

class _FirstSetupScreenState extends State<FirstSetupScreen> {
  static const _steps = ['Master account', 'Tablet name', 'First employee'];
  int step = 1;
  final tablet = TextEditingController(text: AppState.tabletName);
  final name = TextEditingController();

  @override
  void dispose() {
    tablet.dispose();
    name.dispose();
    super.dispose();
  }

  void _finish() {
    final n = name.text.trim();
    if (tablet.text.trim().isNotEmpty) AppState.tabletName = tablet.text.trim();
    if (!employees.any((e) => e.name == n)) employees.add(Employee(n, true, fmtDate(today)));
    AppState.currentUser = n;
    AppState.masterOn.value = false;
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => AppShell()), (_) => false);
  }

  List<Widget> _fields() {
    switch (step) {
      case 1:
        return [
          NoteBox('This is the first time IMP has been opened. Create the Master account for Thrift on Purpose. '
              'It is the store-wide account for Master mode and is not tied to one person.'),
          SizedBox(height: 4),
          FieldLabel('Email'),
          TextField(decoration: InputDecoration(hintText: 'manager@example.org')),
          SizedBox(height: 14),
          FieldLabel('Password'),
          TextField(obscureText: true, decoration: InputDecoration(hintText: '••••••••••')),
          SizedBox(height: 14),
          FieldLabel('Confirm password'),
          TextField(obscureText: true, decoration: InputDecoration(hintText: '••••••••••')),
          SizedBox(height: 14),
          PillButton('Next', style: BtnStyle.primary, wide: true, onTap: () => setState(() => step = 2)),
        ];
      case 2:
        return [
          FieldLabel('Tablet name'),
          TextField(controller: tablet),
          Hint('Shown in Signed-in Devices and the Audit Log'),
          SizedBox(height: 14),
          PillButton('Next', style: BtnStyle.primary, wide: true, onTap: () => setState(() => step = 3)),
        ];
      default:
        final n = name.text.trim();
        return [
          NoteBox('Setup cannot be finished without an employee account. '
              '${n.isEmpty ? 'The new employee' : n} is signed in when setup is done, '
              'and the new account is recorded in the audit log.'),
          SizedBox(height: 4),
          FieldLabel('Employee name'),
          TextField(
              controller: name,
              autofocus: true,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: 'Mabel')),
          Hint('Shown in the sign-in dropdown'),
          SizedBox(height: 14),
          Row(children: [
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              FieldLabel('6-digit PIN'),
              TextField(obscureText: true, maxLength: 6, keyboardType: TextInputType.number),
            ])),
            SizedBox(width: 12),
            Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              FieldLabel('Confirm PIN'),
              TextField(obscureText: true, maxLength: 6, keyboardType: TextInputType.number),
            ])),
          ]),
          SizedBox(height: 4),
          PillButton('Finish setup', style: BtnStyle.primary, wide: true, onTap: n.isEmpty ? null : _finish),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: step == 1,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => step--);
      },
      child: _SignInFrame(
        title: 'Set up IMP',
        sub: step == 3 ? 'First-time setup, step 3 of 3. Create the first employee.' : 'First-time setup, step $step of 3',
        header: Wrap(spacing: 22, runSpacing: 6, alignment: WrapAlignment.center, children: [
          for (var i = 1; i <= _steps.length; i++)
            Text('$i. ${_steps[i - 1]}',
                style: TextStyle(
                    fontSize: 13.5,
                    color: i == step ? C.ink : C.ink2,
                    fontWeight: i == step ? FontWeight.w700 : FontWeight.w400)),
        ]),
        panel: _Panel(_fields()),
        // Not in the wireframes: lets the click-through reach 01a.
        below: step == 1
            ? TextButton(
                style: TextButton.styleFrom(foregroundColor: C.ink2),
                onPressed: () =>
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SetupScreen())),
                child: Text('Demo: IMP is already set up, add this tablet instead',
                    style: TextStyle(fontSize: 12.5, decoration: TextDecoration.underline)),
              )
            : null,
      ),
    );
  }
}

/// 01a: set up another tablet with the Master account. Leads to employee sign-in.
class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _SignInFrame(
      title: 'Set up this tablet',
      sub: 'Sign in with the Master account to add this tablet. The first tablet is set up during first-time setup.',
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
