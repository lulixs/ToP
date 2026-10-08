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
      sub: '${al.length} boxes stored longer than $alertDays days, oldest first',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        NoteBox('Thrift on Purpose sets the number of days. 180 is a placeholder. '
            'Only racked boxes raise alerts, and the same alerts are sent as push notifications.'),
        for (final b in al) BoxRow(b),
      ]),
    );
  }
}
