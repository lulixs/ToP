import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'box_page_screen.dart';
import 'categories_section.dart';

/// 07: new box form. Saving opens a box page (demo: an existing sample box).
class NewBoxScreen extends StatefulWidget {
  const NewBoxScreen({super.key});

  @override
  State<NewBoxScreen> createState() => _NewBoxScreenState();
}

class _NewBoxScreenState extends State<NewBoxScreen> {
  String category = 'Coats';
  String building = pc;
  String level = '2';
  String fullness = 'Full';
  final date = TextEditingController(text: fmtDate(today));
  final shelf = TextEditingController(text: 'A');

  @override
  void dispose() {
    date.dispose();
    shelf.dispose();
    super.dispose();
  }

  void _save({bool print = false}) {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BoxPageScreen(boxId: 6801)));
    messenger.showSnackBar(SnackBar(
        content: Text(print
            ? 'Box saved (demo). Label printing is not set up yet.'
            : 'Box saved (demo). Showing a sample box page.')));
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width > 600;
    final fields = <Widget>[
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FieldLabel('Category *'),
        SelectBox(value: category, items: categories, onChanged: (v) => setState(() => category = v)),
        TextButton(
          style: TextButton.styleFrom(padding: EdgeInsets.zero, foregroundColor: C.ink),
          onPressed: () => showCategoryDialog(context),
          child: Text('+ New category', style: TextStyle(decoration: TextDecoration.underline, fontSize: 12)),
        ),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FieldLabel('In storage since *'),
        TextField(controller: date),
        Hint('Defaults to today. Set an earlier date for a box that was already in storage.'),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FieldLabel('Building *'),
        SelectBox(value: building, items: buildings, onChanged: (v) => setState(() => building = v)),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FieldLabel('Shelf letter *'),
        TextField(controller: shelf),
        Hint('One to three uppercase letters, such as A, AB, or ABC'),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FieldLabel('Shelf level *'),
        Seg(options: ['1', '2', '3'], value: level, onChanged: (v) => setState(() => level = v)),
      ]),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FieldLabel('Fullness *'),
        Seg(options: ['Empty', 'Half', 'Full'], value: fullness, onChanged: (v) => setState(() => fullness = v)),
      ]),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          TopBar(
            title: 'New box',
            onBack: () => Navigator.pop(context),
            sub: Text('The box ID and QR code are created when you save',
                style: TextStyle(fontSize: 13.5, fontStyle: FontStyle.italic, color: C.ink2)),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 26, vertical: 22),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                if (wide)
                  for (var i = 0; i < fields.length; i += 2)
                    Padding(
                      padding: EdgeInsets.only(bottom: 18),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Expanded(child: fields[i]),
                        SizedBox(width: 20),
                        Expanded(child: fields[i + 1]),
                      ]),
                    )
                else
                  for (final f in fields) Padding(padding: EdgeInsets.only(bottom: 18), child: f),
                FieldLabel('Notes', suffix: '(optional)'),
                TextField(
                    maxLines: 4,
                    minLines: 4,
                    decoration: InputDecoration(hintText: 'Anything staff should know about this box…')),
                SizedBox(height: 18),
                NoteBox('New boxes start as Racked. After saving, the box page opens, where every field can be changed.'),
              ]),
            ),
          ),
          FooterBar(children: [
            PillButton('Cancel', height: 52, onTap: () => Navigator.pop(context)),
            Expanded(flex: 10, child: PillButton('Save box', height: 52, wide: true, onTap: _save)),
            Expanded(
                flex: 13,
                child: PillButton('Save and print label',
                    style: BtnStyle.primary,
                    icon: Icons.print_outlined,
                    height: 52,
                    wide: true,
                    onTap: () => _save(print: true))),
          ]),
        ]),
      ),
    );
  }
}
