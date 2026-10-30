import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

/// 14: read-only audit log. Tap an entry to see what changed.
class AuditLogSection extends StatefulWidget {
  const AuditLogSection({super.key});

  @override
  State<AuditLogSection> createState() => _AuditLogSectionState();
}

class _AuditLogSectionState extends State<AuditLogSection> {
  int? open = audit.indexWhere((a) => a.target == 'Box #6789'); // starts expanded, as in the wireframe
  String query = '';
  String filter = 'All actions';

  static const _cols = ['Timestamp', 'Employee', 'Master', 'Device', 'Action', 'Target'];
  static const _flex = [12, 9, 7, 12, 11, 12];
  static const _mono = TextStyle(fontFamily: 'monospace', fontSize: 12, height: 1.35);

  @override
  Widget build(BuildContext context) {
    final actions = ['All actions', ...{for (final a in audit) a.action}];
    final q = query.toLowerCase();
    final rows = [
      for (var i = 0; i < audit.length; i++)
        if ((filter == 'All actions' || audit[i].action == filter) &&
            (q.isEmpty ||
                [audit[i].employee, audit[i].device, audit[i].action, audit[i].target]
                    .any((s) => s.toLowerCase().contains(q))))
          i
    ];

    return SectionPage(
      title: 'Audit Log',
      sub: 'Master only. Every change, read only.',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(children: [
          Expanded(
            child: TextField(
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(
                  hintText: 'Search by employee, device, action, or target…', prefixIcon: Icon(Icons.search)),
            ),
          ),
          SizedBox(width: 8),
          SizedBox(
              width: 170,
              child: SelectBox(bold: false, value: filter, items: actions, onChanged: (v) => setState(() => filter = v))),
        ]),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.fromLTRB(6, 0, 6, 8),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: C.ink, width: 2))),
          child: Row(children: [
            for (var c = 0; c < _cols.length; c++)
              Expanded(
                  flex: _flex[c],
                  child: Text(_cols[c], style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700))),
          ]),
        ),
        for (final i in rows) _row(i),
        SizedBox(height: 10),
        Text('Tap an entry to see what changed. Entries cannot be edited or deleted.',
            style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: C.ink3)),
      ]),
    );
  }

  Widget _row(int i) {
    final a = audit[i];
    final isOpen = open == i;
    final cells = ['${a.date}\n${a.time}', a.employee, a.master, a.device, a.action, a.target];
    return InkWell(
      onTap: () => setState(() => open = isOpen ? null : i),
      child: Container(
        decoration: BoxDecoration(
          color: isOpen ? C.white : (i.isOdd ? C.zebra : null),
          border: isOpen ? Border(top: BorderSide(color: C.ink, width: 2), bottom: BorderSide(color: C.ink, width: 2)) : null,
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 9),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (var c = 0; c < cells.length; c++) Expanded(flex: _flex[c], child: Text(cells[c], style: _mono)),
            ]),
          ),
          if (isOpen)
            Container(
              margin: EdgeInsets.fromLTRB(6, 0, 6, 9),
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                  border: Border.all(color: g(0xFF9D9D9D)), borderRadius: BorderRadius.circular(8)),
              child: Text(a.diff ?? 'No field changes recorded for this action.',
                  style: _mono.copyWith(height: 1.6)),
            ),
        ]),
      ),
    );
  }
}
