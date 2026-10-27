import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../widgets/app_shell.dart';
import '../widgets/box_row.dart';
import '../widgets/common.dart';

/// 09: racked boxes stored longer than the threshold, oldest first.
class AlertsSection extends StatelessWidget {
  const AlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final al = alertBoxes;
    return SectionPage(
      title: 'Alerts',
      sub: '${al.length} boxes stored longer than the $alertDays-day alert threshold, oldest first',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        NoteBox('The alert threshold is the number of days a racked box can stay in storage, '
            'counted from its racked-since date, before it raises an alert. It is $alertDays days, a placeholder '
            'until Thrift on Purpose chooses the number. The Master account sets it on the Account Management page. '
            'Only racked boxes raise alerts, and the same alerts are sent as push notifications.'),
        for (final b in al) BoxRow(b),
      ]),
    );
  }
}
