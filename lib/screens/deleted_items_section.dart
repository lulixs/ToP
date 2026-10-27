import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

/// 13a/b: soft-deleted boxes (Master only). Categories and buildings have no soft delete.
class DeletedItemsSection extends StatefulWidget {
  const DeletedItemsSection({super.key});

  @override
  State<DeletedItemsSection> createState() => _DeletedItemsSectionState();
}

class _DeletedItemsSectionState extends State<DeletedItemsSection> {
  Future<void> _permDelete(String label) async {
    final r = await showPopup(context,
        title: 'Permanently delete $label?',
        message: 'This removes the record for good. It cannot be restored. The delete is recorded in the audit log.',
        actions: ['Cancel', 'Delete permanently']);
    if (r == 'Delete permanently' && mounted) demoSnack(context, '$label permanently deleted (demo only)');
  }

  @override
  Widget build(BuildContext context) {
    final del = deletedBoxes;
    return SectionPage(
      title: 'Deleted Items',
      sub: 'Master only. Restore or permanently delete.',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        NoteBox('Only soft-deleted boxes appear here. Categories and buildings are deleted permanently '
            'from their own pages. Permanent delete is the second step and cannot be undone.'),
        for (final b in del)
          _row(
            title: 'Box #${b.id}',
            lines: ['${b.category} · ${b.building} · Shelf ${b.shelf}, Level ${b.level}'],
            deleted: 'Deleted ${deletedInfo[b.id]![0]} by ${deletedInfo[b.id]![1]}',
            label: 'Box #${b.id}',
          ),
      ]),
    );
  }

  Widget _row({required String title, required List<String> lines, required String deleted, required String label}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 9),
      child: CardBox(
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              for (final l in lines)
                Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(l, style: TextStyle(fontSize: 13, color: C.ink2))),
              Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(deleted, style: TextStyle(fontSize: 13, color: C.ink2, fontStyle: FontStyle.italic))),
            ]),
          ),
          IntrinsicWidth(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
            PillButton('Restore', small: true, onTap: () => demoSnack(context, '$label restored (demo only)')),
            SizedBox(height: 6),
            PillButton('Delete permanently', small: true, style: BtnStyle.soft, onTap: () => _permDelete(label)),
          ])),
        ]),
      ),
    );
  }
}
