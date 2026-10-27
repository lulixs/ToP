import 'package:flutter/material.dart';

import '../app_state.dart';
import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

const _emojiChoices = ['🌷', '🧥', '❄️', '🧤', '🎃', '🎄', '🧣', '🏊', '🧺', '🎁', '👟', '📚'];

/// 08b: add / edit category popup. Used from Categories and New box.
Future<void> showCategoryDialog(BuildContext context, {String? name}) async {
  final editing = name != null;
  final ctrl = TextEditingController(text: name ?? '');
  String? symbol = editing ? categorySymbol[name] : '🌷';
  final r = await showPopup(context,
      title: editing ? 'Edit category' : 'New category',
      body: StatefulBuilder(
        builder: (ctx, set) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          FieldLabel('Name'),
          TextField(controller: ctrl, autofocus: true, decoration: InputDecoration(hintText: 'Spring Decor')),
          Hint('Must be different from every other category'),
          SizedBox(height: 14),
          FieldLabel('Symbol', suffix: '(optional)'),
          Row(children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: Border.all(color: g(0xFF9D9D9D), width: 1.5),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(symbol ?? '', style: TextStyle(fontSize: 24)),
            ),
            SizedBox(width: 12),
            PopupMenuButton<String>(
              onSelected: (v) => set(() => symbol = v),
              itemBuilder: (_) => [
                for (final e in _emojiChoices) PopupMenuItem(value: e, child: Text(e, style: TextStyle(fontSize: 22)))
              ],
              child: IgnorePointer(child: PillButton('Choose emoji', small: true, onTap: _noop)),
            ),
            SizedBox(width: 12),
            PillButton('Clear', small: true, onTap: () => set(() => symbol = null)),
          ]),
          Hint('Shown with the category name on the dashboard and in lists'),
        ]),
      ),
      actions: ['Cancel', editing ? 'Save' : 'Add category']);
  if (r != null && r != 'Cancel' && context.mounted) {
    demoSnack(context, editing ? 'Category saved (demo only)' : 'Category added (demo only)');
  }
}

void _noop() {}

/// 08a/c: category list. + adds, Edit opens the same popup filled in.
/// Delete is Master only and permanent, and only for a category no box uses (D-123).
class CategoriesSection extends StatelessWidget {
  /// Opens the Master mode popup when the locked Delete button is tapped.
  final VoidCallback onMasterRequired;
  const CategoriesSection({super.key, required this.onMasterRequired});

  Future<void> _delete(BuildContext context, String cat) async {
    final r = await showPopup(context,
        title: 'Delete $cat permanently?',
        message: 'No boxes use this category. Deleting it is permanent and cannot be undone. '
            'The delete is recorded in the audit log.',
        actions: ['Cancel', 'Delete category']);
    if (r == 'Delete category' && context.mounted) demoSnack(context, '$cat deleted (demo only)');
  }

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: 'Categories',
      sub: '${categories.length} categories',
      onAdd: () => showCategoryDialog(context),
      child: ValueListenableBuilder<bool>(
        valueListenable: AppState.masterOn,
        builder: (context, masterOn, _) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          NoteBox('Any employee can add a category or edit its name and symbol. '
              'Only the Master account can delete a category, with Master mode on. Deleting is permanent '
              'and is blocked while any box, active or deleted, uses the category.'),
          for (final cat in categories) _row(context, cat, masterOn),
        ]),
      ),
    );
  }

  Widget _row(BuildContext context, String cat, bool masterOn) {
    final n = activeBoxes.where((b) => b.category == cat).length;
    final used = boxes.any((b) => b.category == cat);
    return Padding(
      padding: EdgeInsets.only(bottom: 7),
      child: CardBox(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(withSymbol(cat), style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700)),
              SizedBox(height: 4),
              Text('$n active boxes${masterOn && used ? ' · in use, cannot be deleted' : ''}',
                  style: TextStyle(fontSize: 13, color: C.ink2)),
            ]),
          ),
          PillButton('Edit', small: true, onTap: () => showCategoryDialog(context, name: cat)),
          SizedBox(width: 8),
          masterOn
              ? PillButton('Delete',
                  small: true, style: BtnStyle.soft, onTap: used ? null : () => _delete(context, cat))
              : PillButton('Delete',
                  small: true, style: BtnStyle.disabled, icon: Icons.lock_outline, onTap: onMasterRequired),
        ]),
      ),
    );
  }
}
