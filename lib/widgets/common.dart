import 'package:flutter/material.dart';

import '../theme.dart';

enum BtnStyle { outline, primary, soft, disabled }

/// Rounded pill button used everywhere in the wireframes.
class PillButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final BtnStyle style;
  final bool small;
  final bool wide;
  final IconData? icon;
  final double? height;

  const PillButton(this.label,
      {super.key, this.onTap, this.style = BtnStyle.outline, this.small = false, this.wide = false, this.icon, this.height});

  @override
  Widget build(BuildContext context) {
    final s = onTap == null ? BtnStyle.disabled : style;
    final bg = switch (s) {
      BtnStyle.primary => C.ink,
      BtnStyle.soft => g(0xFFE4E4E4),
      BtnStyle.disabled => g(0xFFF1F1F1),
      BtnStyle.outline => C.card,
    };
    final fg = switch (s) {
      BtnStyle.primary => C.white,
      BtnStyle.disabled => g(0xFFA5A5A5),
      _ => C.ink,
    };
    final border = s == BtnStyle.disabled ? g(0xFFC4C4C4) : C.ink;
    final h = height ?? (small ? 34.0 : 46.0);
    return SizedBox(
      height: h,
      width: wide ? double.infinity : null,
      child: Material(
        color: bg,
        shape: StadiumBorder(side: BorderSide(color: border, width: 1.5)),
        child: InkWell(
          customBorder: StadiumBorder(),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: small ? 16 : 22),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[Icon(icon, size: 18, color: fg), SizedBox(width: 8)],
                Text(label,
                    style: TextStyle(
                        color: fg,
                        fontSize: small ? 13.5 : 15,
                        fontWeight: s == BtnStyle.outline ? FontWeight.w400 : FontWeight.w700)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Segmented control (shelf level, fullness).
class Seg extends StatelessWidget {
  final List<String> options;
  final String value;
  final ValueChanged<String> onChanged;
  const Seg({super.key, required this.options, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: ShapeDecoration(shape: StadiumBorder(side: BorderSide(color: C.ink, width: 1.5))),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(options[i]),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: options[i] == value ? C.ink : null,
                    border: i == 0 ? null : Border(left: BorderSide(color: C.ink, width: 1.5)),
                  ),
                  child: Text(options[i],
                      style: TextStyle(
                          fontSize: 14.5,
                          color: options[i] == value ? C.white : C.ink3,
                          fontWeight: options[i] == value ? FontWeight.w700 : FontWeight.w400)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final String text;
  final bool dark;
  final bool light;
  const Tag(this.text, {super.key, this.dark = false, this.light = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 21,
      padding: EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: dark ? C.ink : (light ? C.white : C.zebra),
        border: Border.all(color: dark ? C.ink : g(0xFF8F8F8F)),
        borderRadius: BorderRadius.circular(6),
      ),
      // widthFactor keeps the tag as wide as its text instead of filling the row.
      child: Center(
        widthFactor: 1,
        child: Text(text,
            style: TextStyle(
                fontSize: 11,
                fontStyle: FontStyle.normal,
                fontWeight: light ? FontWeight.w400 : FontWeight.w700,
                color: dark ? C.white : (light ? C.ink2 : C.ink))),
      ),
    );
  }
}

class CardBox extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;
  const CardBox({super.key, required this.child, this.padding = const EdgeInsets.fromLTRB(16, 14, 16, 14), this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: C.card,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14), side: BorderSide(color: C.line)),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class NoteBox extends StatelessWidget {
  final String text;
  const NoteBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: g(0xFFEFEFEF),
        border: Border.all(color: g(0xFFA9A9A9), width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: TextStyle(fontSize: 13, height: 1.45)),
    );
  }
}

/// Sign-in error (wrong password or PIN).
class ErrorBox extends StatelessWidget {
  final String text;
  const ErrorBox(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14),
      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      decoration: BoxDecoration(
        color: C.card,
        border: Border.all(color: C.ink, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(children: [
        Icon(Icons.error_outline, size: 20, color: C.ink),
        SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700))),
      ]),
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String text;
  final String? suffix;
  const FieldLabel(this.text, {super.key, this.suffix});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6),
      child: Text.rich(TextSpan(children: [
        TextSpan(text: text, style: TextStyle(fontWeight: FontWeight.w700, color: C.ink, fontSize: 13)),
        if (suffix != null) TextSpan(text: ' $suffix', style: TextStyle(color: C.ink2, fontSize: 13)),
      ])),
    );
  }
}

class Hint extends StatelessWidget {
  final String text;
  const Hint(this.text, {super.key});
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(top: 6),
        child: Text(text, style: TextStyle(fontSize: 11.5, fontStyle: FontStyle.italic, color: C.ink3)),
      );
}

/// Simple dropdown styled like the wireframe ".select".
class SelectBox extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;
  final bool bold;
  const SelectBox({super.key, required this.value, required this.items, required this.onChanged, this.bold = true});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      isExpanded: true,
      icon: Icon(Icons.arrow_drop_down, color: C.ink),
      style: TextStyle(fontSize: 14, color: C.ink, fontWeight: bold ? FontWeight.w700 : FontWeight.w400),
      items: [for (final i in items) DropdownMenuItem(value: i, child: Text(i, overflow: TextOverflow.ellipsis))],
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}

/// Fullness mini bar + label for list rows.
class FullnessMini extends StatelessWidget {
  final String fullness;
  const FullnessMini(this.fullness, {super.key});

  @override
  Widget build(BuildContext context) {
    final w = {'Full': 1.0, 'Half': 0.5, 'Empty': 0.0}[fullness]!;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(
        width: 64,
        height: 9,
        decoration: BoxDecoration(
            color: g(0xFFF4F4F4),
            border: Border.all(color: g(0xFF9A9A9A)),
            borderRadius: BorderRadius.circular(5)),
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
            widthFactor: w, child: Container(color: fullness == 'Full' ? C.ink : C.mid)),
      ),
      SizedBox(width: 8),
      Text(fullness, style: TextStyle(fontSize: 13)),
    ]);
  }
}

class BackCircle extends StatelessWidget {
  final VoidCallback onTap;
  final Color? color;
  const BackCircle({super.key, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? C.ink;
    return Material(
      color: Colors.transparent,
      shape: CircleBorder(side: BorderSide(color: color, width: 2)),
      child: InkWell(
        customBorder: CircleBorder(),
        onTap: onTap,
        child: SizedBox(width: 48, height: 48, child: Icon(Icons.arrow_back, color: color)),
      ),
    );
  }
}

/// Top bar for full-screen pages (box page, new box).
class TopBar extends StatelessWidget {
  final String title;
  final Widget? sub;
  final Widget? trailing;
  final VoidCallback onBack;
  const TopBar({super.key, required this.title, this.sub, this.trailing, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(22, 24, 22, 18),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: g(0xFFB5B5B5)))),
      child: Row(children: [
        BackCircle(onTap: onBack),
        SizedBox(width: 16),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: -0.3)),
            if (sub != null) Padding(padding: EdgeInsets.only(top: 4), child: sub!),
          ]),
        ),
        if (trailing != null) trailing!,
      ]),
    );
  }
}

class FooterBar extends StatelessWidget {
  final List<Widget> children;
  const FooterBar({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
      decoration: BoxDecoration(
          color: C.soft, border: Border(top: BorderSide(color: g(0xFFB5B5B5)))),
      child: SafeArea(top: false, child: Row(children: _gap(children))),
    );
  }

  List<Widget> _gap(List<Widget> c) {
    final out = <Widget>[];
    for (var i = 0; i < c.length; i++) {
      if (i > 0) out.add(SizedBox(width: 12));
      out.add(c[i]);
    }
    return out;
  }
}

/// A popup in the wireframe style. Returns the label of the tapped action
/// (or null if dismissed). The last action is drawn as the primary button.
Future<String?> showPopup(
  BuildContext context, {
  required String title,
  String? message,
  Widget? body,
  List<String> actions = const ['Cancel', 'OK'],
}) {
  return showDialog<String>(
    context: context,
    barrierColor: Color(0x6B1E1E1E),
    builder: (ctx) => Dialog(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 470),
        child: Padding(
          padding: EdgeInsets.fromLTRB(26, 24, 26, 22),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700)),
                if (message != null) ...[
                  SizedBox(height: 14),
                  Text(message, style: TextStyle(fontSize: 14, height: 1.5)),
                ],
                if (body != null) ...[SizedBox(height: 14), body],
                SizedBox(height: 18),
                Wrap(
                  alignment: WrapAlignment.end,
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (var i = 0; i < actions.length; i++)
                      PillButton(actions[i],
                          style: i == actions.length - 1 ? BtnStyle.primary : BtnStyle.outline,
                          onTap: () => Navigator.pop(ctx, actions[i])),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

/// Placeholder feedback for actions that need the backend.
void demoSnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text), duration: Duration(seconds: 2)));
}

class Avatar extends StatelessWidget {
  final String name;
  final double size;
  const Avatar(this.name, {super.key, this.size = 38});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          shape: BoxShape.circle, color: g(0xFFE3E3E3), border: Border.all(color: g(0xFFB9B9B9))),
      child: Text(name[0],
          style: TextStyle(fontWeight: FontWeight.w700, color: g(0xFF7A7A7A), fontSize: size * 0.42)),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 68,
      height: 68,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: C.card, border: Border.all(color: C.ink, width: 3), borderRadius: BorderRadius.circular(14)),
      child: Text('IMP', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, letterSpacing: 0.5)),
    );
  }
}

/// "Dark mode" label + switch, used in the sidebar.
class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({super.key});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () => setDarkMode(!C.dark),
      child: Padding(
        padding: EdgeInsets.fromLTRB(9, 2, 2, 2),
        child: Row(children: [
          Icon(C.dark ? Icons.dark_mode_outlined : Icons.light_mode_outlined, size: 18, color: C.ink),
          SizedBox(width: 8),
          Expanded(child: Text('Dark mode', style: TextStyle(fontSize: 14, color: C.ink))),
          Switch(value: C.dark, onChanged: setDarkMode),
        ]),
      ),
    );
  }
}

/// Round sun/moon button, used on the sign-in screens.
class DarkModeButton extends StatelessWidget {
  const DarkModeButton({super.key});
  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: C.dark ? 'Light mode' : 'Dark mode',
      onPressed: () => setDarkMode(!C.dark),
      icon: Icon(C.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined, color: C.ink),
      style: IconButton.styleFrom(side: BorderSide(color: C.ink, width: 1.5)),
    );
  }
}
