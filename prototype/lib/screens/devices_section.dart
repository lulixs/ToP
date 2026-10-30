import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

/// 12: signed-in tablets (Master only, view only).
class DevicesSection extends StatelessWidget {
  const DevicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: 'Signed-in Devices',
      sub: 'Master only. ${devices.length} tablets are signed in.',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (final d in devices)
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: CardBox(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Row(children: [
                  Expanded(
                    child: Row(children: [
                      Flexible(child: Text(d.name, style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700))),
                      if (d.thisTablet) ...[SizedBox(width: 8), Tag('This tablet', light: true)],
                    ]),
                  ),
                  d.masterOn ? Tag('Master on', dark: true) : Tag('Master off', light: true),
                ]),
                SizedBox(height: 12),
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(
                      child: _cell('Active employee',
                          Text(d.employee, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700)))),
                  Expanded(child: _cell('Last activity', Text(d.lastActivity, style: TextStyle(fontSize: 13.5)))),
                ]),
              ]),
            ),
          ),
        SizedBox(height: 2),
        Text(
            'This page is view only. Tablets with no one signed in are not listed. '
            'Switch user signs the employee out and turns Master mode off.',
            style: TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic, color: C.ink3)),
      ]),
    );
  }

  Widget _cell(String label, Widget value) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: TextStyle(fontSize: 12.5, color: C.ink2)),
        SizedBox(height: 6),
        value,
      ]);
}
