import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../screens/box_page_screen.dart';
import '../theme.dart';
import 'common.dart';

/// One box in a list (Boxes, Alerts). Tapping opens the box page.
class BoxRow extends StatelessWidget {
  final Box box;
  const BoxRow(this.box, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 9),
      child: CardBox(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BoxPageScreen(boxId: box.id))),
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Wrap(spacing: 8, runSpacing: 4, crossAxisAlignment: WrapCrossAlignment.center, children: [
                Text('Box #${box.id}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                Text(box.category, style: TextStyle(fontSize: 14.5)),
                if (!box.racked) Tag('Unracked'),
              ]),
              SizedBox(height: 4),
              Text('${box.building} · Shelf ${box.shelf}, Level ${box.level}',
                  style: TextStyle(fontSize: 13, color: C.ink2)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: '${box.daysStored}',
                  style: TextStyle(fontSize: 18, color: C.ink, fontWeight: FontWeight.w700)),
              TextSpan(text: ' days stored'),
            ]), style: TextStyle(fontSize: 12.5, color: C.ink2)),
            SizedBox(height: 6),
            FullnessMini(box.fullness),
          ]),
        ]),
      ),
    );
  }
}
