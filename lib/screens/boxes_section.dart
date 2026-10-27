import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../widgets/app_shell.dart';
import '../widgets/box_row.dart';
import '../widgets/common.dart';
import 'new_box_screen.dart';

/// 04: box list with search and filters. + opens New box.
class BoxesSection extends StatefulWidget {
  final String initialCategory;
  final bool autofocusSearch;
  const BoxesSection({super.key, required this.initialCategory, this.autofocusSearch = false});

  @override
  State<BoxesSection> createState() => _BoxesSectionState();
}

class _BoxesSectionState extends State<BoxesSection> {
  static const allCats = 'All categories';
  late String category = widget.initialCategory;
  String rack = 'Rack: All';
  String sort = 'Oldest first';
  String query = '';

  @override
  Widget build(BuildContext context) {
    var list = activeBoxes.where((b) {
      if (category != allCats && b.category != category) return false;
      if (rack == 'Racked' && !b.racked) return false;
      if (rack == 'Unracked' && b.racked) return false;
      final q = query.trim().toLowerCase();
      if (q.isNotEmpty && !b.category.toLowerCase().contains(q) && !'${b.id}'.contains(q)) return false;
      return true;
    }).toList()
      ..sort((a, b) => sort == 'Oldest first' ? a.rackedSince.compareTo(b.rackedSince) : b.rackedSince.compareTo(a.rackedSince));

    final racked = list.where((b) => b.racked).length;
    final label = category == allCats ? 'All categories' : category;

    return SectionPage(
      title: 'Boxes',
      sub: '$label: $racked racked boxes, plus ${list.length - racked} unracked',
      onAdd: () => Navigator.push(context, MaterialPageRoute(builder: (_) => NewBoxScreen())),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Wrap(spacing: 8, runSpacing: 8, children: [
          SizedBox(
            width: 240,
            child: TextField(
              autofocus: widget.autofocusSearch,
              onChanged: (v) => setState(() => query = v),
              decoration: InputDecoration(hintText: 'Category name or box ID…', prefixIcon: Icon(Icons.search)),
            ),
          ),
          SizedBox(
              width: 190,
              child: SelectBox(
                  value: category, items: [allCats, ...categories], onChanged: (v) => setState(() => category = v))),
          SizedBox(
              width: 140,
              child: SelectBox(
                  bold: false,
                  value: rack,
                  items: ['Rack: All', 'Racked', 'Unracked'],
                  onChanged: (v) => setState(() => rack = v))),
          SizedBox(
              width: 150,
              child: SelectBox(
                  bold: false,
                  value: sort,
                  items: ['Oldest first', 'Newest first'],
                  onChanged: (v) => setState(() => sort = v))),
        ]),
        SizedBox(height: 12),
        if (list.isEmpty) NoteBox('No boxes match.'),
        for (final b in list) BoxRow(b),
      ]),
    );
  }
}
