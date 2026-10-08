import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../theme.dart';
import '../widgets/app_shell.dart';
import '../widgets/common.dart';

/// 03a: category tiles. Tapping a tile opens Boxes for that category.
class DashboardSection extends StatelessWidget {
  final ValueChanged<String> onOpenCategory;
  const DashboardSection({super.key, required this.onOpenCategory});

  @override
  Widget build(BuildContext context) {
    return SectionPage(
      title: 'Dashboard',
      sub: '${rackedBoxes.length} racked boxes in ${categories.length} categories. Tap a category to see its boxes.',
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Wrap(spacing: 16, runSpacing: 6, crossAxisAlignment: WrapCrossAlignment.center, children: [
          _Key(C.ink, 'Full'),
          _Key(C.mid, 'Half'),
          _Key(g(0xFFF4F4F4), 'Empty'),
          Text('Unracked and deleted boxes are not counted',
              style: TextStyle(fontStyle: FontStyle.italic, color: C.ink2, fontSize: 12)),
        ]),
        SizedBox(height: 12),
        LayoutBuilder(builder: (context, c) {
          final cols = c.maxWidth > 820 ? 4 : (c.maxWidth > 480 ? 3 : 2);
          return GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: cols, mainAxisSpacing: 12, crossAxisSpacing: 12, mainAxisExtent: 190),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: [for (final cat in categories) _Tile(cat, () => onOpenCategory(cat))],
          );
        }),
      ]),
    );
  }
}

class _Key extends StatelessWidget {
  final Color color;
  final String label;
  const _Key(this.color, this.label);
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(
            width: 11,
            height: 11,
            decoration: BoxDecoration(
                color: color, border: Border.all(color: g(0xFF8A8A8A)), borderRadius: BorderRadius.circular(3))),
        SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 13)),
      ]);
}

class _Tile extends StatelessWidget {
  final String cat;
  final VoidCallback onTap;
  const _Tile(this.cat, this.onTap);

  @override
  Widget build(BuildContext context) {
    final bs = rackedBoxes.where((b) => b.category == cat).toList();
    final f = bs.where((b) => b.fullness == 'Full').length;
    final h = bs.where((b) => b.fullness == 'Half').length;
    final e = bs.where((b) => b.fullness == 'Empty').length;
    final long = bs.where((b) => b.tooLong).length;
    return CardBox(
      onTap: onTap,
      padding: EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(
          height: 44,
          child: Text(withSymbol(cat),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, height: 1.2)),
        ),
        SizedBox(height: 4),
        Text.rich(TextSpan(children: [
          TextSpan(text: '${bs.length}', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          TextSpan(text: bs.length == 1 ? ' racked box' : ' racked boxes'),
        ]), style: TextStyle(fontSize: 14, color: C.ink2)),
        Container(
          height: 10,
          margin: EdgeInsets.fromLTRB(0, 9, 0, 7),
          decoration: BoxDecoration(
              color: g(0xFFF4F4F4),
              border: Border.all(color: g(0xFF9A9A9A)),
              borderRadius: BorderRadius.circular(5)),
          clipBehavior: Clip.antiAlias,
          child: bs.isEmpty
              ? null
              : Row(children: [
                  if (f > 0) Expanded(flex: f, child: Container(color: C.ink)),
                  if (h > 0) Expanded(flex: h, child: Container(color: C.mid)),
                  if (e > 0) Expanded(flex: e, child: Container(color: g(0xFFF4F4F4))),
                ]),
        ),
        Text('$f full   $h half   $e empty', style: TextStyle(fontSize: 12, color: C.ink2)),
        Spacer(),
        long > 0
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(color: C.ink, borderRadius: BorderRadius.circular(6)),
                child: Text('$long stored too long',
                    style: TextStyle(color: C.white, fontSize: 11.5, fontWeight: FontWeight.w700)),
              )
            : Text('No alerts', style: TextStyle(color: C.ink3, fontSize: 12)),
      ]),
    );
  }
}
