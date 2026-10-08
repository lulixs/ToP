import 'dart:math';

import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/common.dart';

/// 06a-e: box page. Edits stay on screen only (no backend).
class BoxPageScreen extends StatefulWidget {
  final int boxId;
  const BoxPageScreen({super.key, required this.boxId});

  @override
  State<BoxPageScreen> createState() => _BoxPageScreenState();
}

class _BoxPageScreenState extends State<BoxPageScreen> {
  late final Box box = boxById(widget.boxId);
  late String building = box.building;
  late String category = box.category;
  late String level = '${box.level}';
  late String fullness = box.fullness;
  late bool racked = box.racked;
  late final shelf = TextEditingController(text: box.shelf);
  late final notes = TextEditingController(
      text: box.id == 6789
          ? 'Mostly adult sizes. Check zippers before putting out.'
          : 'Kids sizes. Moved to the sales floor for the fall push.');
  bool dirty = false;

  void _change(VoidCallback f) => setState(() {
        f();
        dirty = true;
      });

  @override
  void dispose() {
    shelf.dispose();
    notes.dispose();
    super.dispose();
  }

  void _save() {
    setState(() => dirty = false);
    demoSnack(context, 'Saved Box #${box.id} (demo only, nothing is stored yet)');
  }

  Future<void> _leave() async {
    if (!dirty) {
      Navigator.pop(context);
      return;
    }
    final r = await showPopup(context,
        title: 'Save changes to Box #${box.id}?',
        message: 'You changed this box but did not save. If you leave now, the changes are lost.',
        actions: ['Discard', 'Keep editing', 'Save']);
    if (!mounted) return;
    if (r == 'Discard') {
      setState(() => dirty = false);
      Navigator.pop(context);
    } else if (r == 'Save') {
      _save();
      Navigator.pop(context);
    }
  }

  Future<void> _delete() async {
    final r = await showPopup(context,
        title: 'Delete Box #${box.id}?',
        message:
            'The box is hidden from search, the dashboard, and alerts. Only the Master account can restore it or delete it permanently from Deleted Items.',
        actions: ['Cancel', 'Delete box']);
    if (r == 'Delete box' && mounted) {
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(SnackBar(content: Text('Box #${box.id} deleted (demo only)')));
    }
  }

  Future<void> _rerack() async {
    var b = building;
    var lvl = level;
    final sh = TextEditingController(text: shelf.text);
    final r = await showPopup(context,
        title: 'Re-rack Box #${box.id}',
        message: 'Confirm where the box is going. These are filled in from its last location.',
        body: StatefulBuilder(
          builder: (ctx, set) => Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            FieldLabel('Building'),
            SelectBox(value: b, items: buildings, onChanged: (v) => set(() => b = v)),
            SizedBox(height: 14),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                  width: 120,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    FieldLabel('Shelf letter'),
                    TextField(controller: sh),
                  ])),
              SizedBox(width: 12),
              Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                FieldLabel('Shelf level'),
                Seg(options: ['1', '2', '3'], value: lvl, onChanged: (v) => set(() => lvl = v)),
              ])),
            ]),
            Hint('The change is kept when you tap Save changes on the box page.'),
          ]),
        ),
        actions: ['Cancel', 'Re-rack']);
    if (r == 'Re-rack') {
      _change(() {
        racked = true;
        building = b;
        level = lvl;
        shelf.text = sh.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final rec = boxRecord[box.id] ?? [fmtDate(box.created), 'Mabel', '10/02/26', 'Dipper'];
    final wide = MediaQuery.sizeOf(context).width > 600;
    final cards = <Widget>[
      CardBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const _Label('Location'),
          SelectBox(value: building, items: buildings, onChanged: (v) => _change(() => building = v)),
          SizedBox(height: 10),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              width: 96,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Shelf letter', style: TextStyle(fontSize: 13, color: C.ink2)),
                SizedBox(height: 6),
                TextField(controller: shelf, onChanged: (_) => _change(() {})),
              ]),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Shelf level', style: TextStyle(fontSize: 13, color: C.ink2)),
                SizedBox(height: 6),
                Seg(options: ['1', '2', '3'], value: level, onChanged: (v) => _change(() => level = v)),
              ]),
            ),
          ]),
        ]),
      ),
      CardBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const _Label('Category'),
          SelectBox(value: category, items: categories, onChanged: (v) => _change(() => category = v)),
          SizedBox(height: 14),
          const _Label('Days stored'),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text('${box.daysStored}', style: TextStyle(fontSize: 46, fontWeight: FontWeight.w700, height: 1)),
            SizedBox(width: 10),
            if (box.daysStored > alertDays && racked) Tag('Stored too long', dark: true),
          ]),
          Hint('Since ${fmtDate(box.created)}. The creation date cannot be changed.'),
        ]),
      ),
      CardBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const _Label('Fullness'),
          Seg(options: ['Empty', 'Half', 'Full'], value: fullness, onChanged: (v) => _change(() => fullness = v)),
        ]),
      ),
      CardBox(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          const _Label('Rack status'),
          Text(racked ? 'Racked' : 'Unracked', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          if (!racked) Hint('Not counted on the dashboard or in alerts'),
          SizedBox(height: 10),
          racked
              ? PillButton('Unrack box', style: BtnStyle.soft, wide: true, onTap: () => _change(() => racked = false))
              : PillButton('Re-rack box', style: BtnStyle.soft, wide: true, onTap: _rerack),
        ]),
      ),
    ];

    return PopScope(
      canPop: !dirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _leave();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(children: [
            TopBar(
              title: 'Box #${box.id}',
              onBack: _leave,
              sub: Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text('$category ·', style: TextStyle(fontSize: 13.5, fontStyle: FontStyle.italic, color: C.ink2)),
                racked ? Tag('Racked', dark: true) : Tag('Unracked'),
                if (dirty) Tag('Unsaved changes', light: true),
              ]),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                PillButton('Print label',
                    small: true,
                    icon: Icons.print_outlined,
                    onTap: () => demoSnack(context, 'Label printing is not set up yet')),
                if (wide) ...[SizedBox(width: 14), _QrCard(box.id)],
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                  if (wide) ...[
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: cards[0]), SizedBox(width: 12), Expanded(child: cards[1]),
                    ]),
                    SizedBox(height: 12),
                    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: cards[2]), SizedBox(width: 12), Expanded(child: cards[3]),
                    ]),
                  ] else
                    for (final c in cards) Padding(padding: EdgeInsets.only(bottom: 12), child: c),
                  SizedBox(height: 12),
                  CardBox(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      const _Label('Notes'),
                      TextField(controller: notes, maxLines: 3, minLines: 2, onChanged: (_) => _change(() {})),
                    ]),
                  ),
                  SizedBox(height: 14),
                  Text('Record', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  SizedBox(height: 7),
                  Container(height: 2, color: C.ink),
                  Container(
                      color: C.zebra,
                      padding: EdgeInsets.all(10),
                      child: Text('Created ${rec[0]} by ${rec[1]}', style: TextStyle(fontSize: 13))),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Text('Last edited ${rec[2]} by ${rec[3]}', style: TextStyle(fontSize: 13))),
                ]),
              ),
            ),
            FooterBar(children: [
              PillButton('Delete box', style: BtnStyle.soft, height: 52, onTap: _delete),
              Expanded(
                  child: PillButton('Save changes',
                      style: BtnStyle.primary, height: 52, wide: true, onTap: dirty ? _save : null)),
            ]),
          ]),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.only(bottom: 8), child: Text(text, style: TextStyle(fontSize: 12.5, color: C.ink2)));
}

/// Fake QR code (random pattern seeded by box ID) - the real one comes from the backend.
class _QrCard extends StatelessWidget {
  final int id;
  const _QrCard(this.id);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 104,
      padding: EdgeInsets.fromLTRB(8, 8, 8, 4),
      decoration: BoxDecoration(border: Border.all(color: C.line), borderRadius: BorderRadius.circular(12)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        SizedBox(width: 86, height: 86, child: CustomPaint(painter: _QrPainter(id))),
        SizedBox(height: 3),
        Text('#$id', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class _QrPainter extends CustomPainter {
  final int seed;
  _QrPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    const n = 21;
    final c = size.width / n;
    final p = Paint()..color = C.ink;
    final r = Random(seed);
    bool inFinder(int i, int j) => (i < 8 && j < 8) || (i > 12 && j < 8) || (i < 8 && j > 12);
    void finder(int x, int y) {
      for (var i = 0; i < 7; i++) {
        for (var j = 0; j < 7; j++) {
          if (i == 0 || i == 6 || j == 0 || j == 6 || (i >= 2 && i <= 4 && j >= 2 && j <= 4)) {
            canvas.drawRect(Rect.fromLTWH((x + i) * c, (y + j) * c, c + .3, c + .3), p);
          }
        }
      }
    }

    finder(0, 0);
    finder(14, 0);
    finder(0, 14);
    for (var i = 0; i < n; i++) {
      for (var j = 0; j < n; j++) {
        if (!inFinder(i, j) && r.nextDouble() < 0.48) {
          canvas.drawRect(Rect.fromLTWH(i * c, j * c, c + .3, c + .3), p);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true; // redraw when dark mode flips
}
