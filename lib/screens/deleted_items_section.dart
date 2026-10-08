import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

/// 13a/b: soft-deleted boxes and categories (Master only).
class DeletedItemsSection extends StatefulWidget {
  const DeletedItemsSection({super.key});

  @override
  State<DeletedItemsSection> createState() => _DeletedItemsSectionState();
}

class _DeletedItemsSectionState extends State<DeletedItemsSection> {
  bool showBoxes = true;

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
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            decoration: ShapeDecoration(shape: StadiumBorder(side: BorderSide(color: C.ink, width: 1.5))),
            clipBehavior: Clip.antiAlias,
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              _tab('Boxes (${del.length})', showBoxes, () => setState(() => showBoxes = true)),
              _tab('Categories (${deletedCategories.length})', !showBoxes, () => setState(() => showBoxes = false)),
            ]),
          ),
        ),
        NoteBox('Only soft-deleted boxes and categories appear here. '
            'Permanent delete is the second step and cannot be undone.'),
        if (showBoxes)
          for (final b in del)
            _row(
              title: 'Box #${b.id}',
              lines: ['${b.category} · ${b.building} · Shelf ${b.shelf}, Level ${b.level}'],
              deleted: 'Deleted ${deletedInfo[b.id]![0]} by ${deletedInfo[b.id]![1]}',
              label: 'Box #${b.id}',
            )
        else
          for (final c in deletedCategories)
            _row(title: c, lines: ['0 active boxes'], deleted: 'Deleted 09/30/26 by Mabel', label: 'Category $c'),
      ]),
    );
  }

  Widget _tab(String text, bool on, VoidCallback onTap) => InkWell(
        onTap: onTap,
        child: Container(
          height: 38,
          padding: EdgeInsets.symmetric(horizontal: 22),
          alignment: Alignment.center,
          color: on ? C.ink : null,
          child: Text(text,
              style: TextStyle(
                  fontSize: 14, color: on ? C.white : C.ink2, fontWeight: on ? FontWeight.w700 : FontWeight.w400)),
        ),
      );

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
