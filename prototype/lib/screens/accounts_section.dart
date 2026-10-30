import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

/// 10a/b/c: employee accounts and the alert threshold (Master only).
class AccountsSection extends StatefulWidget {
  const AccountsSection({super.key});

  @override
  State<AccountsSection> createState() => _AccountsSectionState();
}

class _AccountsSectionState extends State<AccountsSection> {
  Future<void> _dialog({Employee? e}) async {
    final r = await showPopup(context,
        title: e == null ? 'Add employee' : 'Edit ${e.name}',
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          FieldLabel('Name'),
          TextField(
              autofocus: true,
              controller: TextEditingController(text: e?.name ?? ''),
              decoration: InputDecoration(hintText: 'Candy')),
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
        ]),
        actions: ['Cancel', e == null ? 'Add employee' : 'Save']);
    if (r != null && r != 'Cancel' && mounted) {
      demoSnack(context, e == null ? 'Employee added (demo only)' : 'Employee saved (demo only)');
    }
  }

  static const _thresholdMeaning = 'The number of days a racked box can stay in storage, '
      'counted from its racked-since date, before it raises a storage alert';

  Future<void> _thresholdDialog() async {
    final r = await showPopup(context,
        title: 'Change alert threshold',
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          FieldLabel('Days'),
          TextField(
              autofocus: true,
              controller: TextEditingController(text: '$alertDays'),
              keyboardType: TextInputType.number),
          Hint(_thresholdMeaning),
          SizedBox(height: 14),
          Hint('The new threshold applies to every tablet and is recorded in the audit log.'),
        ]),
        actions: ['Cancel', 'Save']);
    if (r == 'Save' && mounted) demoSnack(context, 'Alert threshold saved (demo only)');
  }

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: 'Account Management',
      sub: 'Master only. Manage employee accounts and the alert threshold.',
      onAdd: () => _dialog(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: CardBox(
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Alert threshold', style: TextStyle(fontSize: 12.5, color: C.ink2)),
                  SizedBox(height: 2),
                  Text('$alertDays days', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                  Hint('$_thresholdMeaning. 180 is a placeholder until Thrift on Purpose chooses the number.'),
                ]),
              ),
              SizedBox(width: 16),
              PillButton('Change', small: true, onTap: _thresholdDialog),
            ]),
          ),
        ),
        NoteBox('Every employee account has the same access. Accounts are deactivated, '
            'not deleted. Edit changes the name or PIN.'),
        for (final e in employees)
          Padding(
            padding: EdgeInsets.only(bottom: 9),
            child: CardBox(
              child: Row(children: [
                Avatar(e.name, size: 48),
                SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(e.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Row(children: [
                      Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: e.active ? C.ink : g(0xFFC6C6C6))),
                      SizedBox(width: 6),
                      Flexible(
                        child: Text('${e.active ? 'Activated' : 'Deactivated'} · Last sign-in ${e.lastSignIn}',
                            style: TextStyle(fontSize: 13, color: C.ink2)),
                      ),
                    ]),
                  ]),
                ),
                IntrinsicWidth(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
                  PillButton('Edit', small: true, onTap: () => _dialog(e: e)),
                  SizedBox(height: 6),
                  PillButton(e.active ? 'Deactivate' : 'Reactivate',
                      small: true, style: BtnStyle.soft, onTap: () => setState(() => e.active = !e.active)),
                ])),
              ]),
            ),
          ),
      ]),
    );
  }
}
