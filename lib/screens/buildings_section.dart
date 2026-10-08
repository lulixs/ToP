import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

/// 11a/b/c: buildings (Master only). Remove is blocked while boxes use it.
class BuildingsSection extends StatelessWidget {
  const BuildingsSection({super.key});

  Future<void> _add(BuildContext context) async {
    final r = await showPopup(context,
        title: 'Add building',
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          FieldLabel('Name'),
          TextField(autofocus: true, decoration: InputDecoration(hintText: 'Warehouse 2')),
          Hint('A building needs a name'),
        ]),
        actions: ['Cancel', 'Add building']);
    if (r == 'Add building' && context.mounted) demoSnack(context, 'Building added (demo only)');
  }

  Future<void> _remove(BuildContext context, String name) async {
    final using = boxes.where((b) => b.building == name).toList();
    if (using.isNotEmpty) {
      await showPopup(context,
          title: '$name cannot be removed',
          message: 'These boxes still use this building. Move the active boxes to another building, '
              'and permanently delete or restore and move the deleted ones first.',
          body: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 220),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SingleChildScrollView(child: Column(children: [
                for (var i = 0; i < using.length; i++)
                  Container(
                    color: i.isEven ? C.zebra : null,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                    child: Row(children: [
                      SizedBox(
                          width: 110,
                          child: Text('Box #${using[i].id}', style: TextStyle(fontFamily: 'monospace', fontSize: 13))),
                      Text(using[i].deleted ? 'soft-deleted' : 'active',
                          style: TextStyle(fontFamily: 'monospace', fontSize: 13)),
                    ]),
                  ),
              ])),
            ),
          ),
          actions: ['OK']);
      return;
    }
    final r = await showPopup(context,
        title: 'Remove $name?',
        message: 'No boxes use this building. Removing it is permanent and cannot be undone. '
            'The removal is recorded in the audit log.',
        actions: ['Cancel', 'Remove building']);
    if (r == 'Remove building' && context.mounted) demoSnack(context, '$name removed (demo only)');
  }

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: 'Building Management',
      sub: 'Master only. Add or remove storage buildings.',
      onAdd: () => _add(context),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        NoteBox('Removing a building is permanent. A building cannot be removed while '
            'any box, active or deleted, still uses it.'),
        for (final name in buildings) _row(context, name),
      ]),
    );
  }

  Widget _row(BuildContext context, String name) {
    final n = boxes.where((b) => b.building == name).length;
    final dn = boxes.where((b) => b.building == name && b.deleted).length;
    return Padding(
      padding: EdgeInsets.only(bottom: 9),
      child: CardBox(
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text('$n boxes${dn > 0 ? ' ($dn deleted)' : ''} · Added ${buildingAdded[name]}',
                  style: TextStyle(fontSize: 13, color: C.ink2)),
            ]),
          ),
          PillButton('Remove', small: true, style: BtnStyle.soft, onTap: () => _remove(context, name)),
        ]),
      ),
    );
  }
}
