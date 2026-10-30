import 'package:flutter/material.dart';

/// Grayscale palette from the wireframe style.css.
/// Every color goes through [g], so flipping [C.dark] turns the whole app dark.
class C {
  static bool dark = false;

  static Color get ink => g(0xFF222222); // main text, dark fills
  static Color get ink2 => g(0xFF555555); // secondary text
  static Color get ink3 => g(0xFF8A8A8A); // hints, disabled text
  static Color get line => g(0xFFBDBDBD); // card borders
  static Color get line2 => g(0xFFDEDEDE); // dividers
  static Color get panel => g(0xFFE6E6E6); // sidebar, sign-in background
  static Color get soft => g(0xFFF3F3F3); // bottom bar, footer
  static Color get card => g(0xFFFFFFFF); // cards, page background
  static Color get white => g(0xFFFFFFFF); // text on dark fills
  static Color get mid => g(0xFFA8A8A8); // "Half" fill
  static Color get zebra => g(0xFFECECEC); // striped rows
}

/// A gray from the light palette. In dark mode the gray is flipped
/// (white -> near black, near black -> light gray) so contrast is kept.
Color g(int argb) {
  if (!C.dark) return Color(argb);
  final level = argb & 0xFF;
  final d = (18 + (255 - level) * 222 / 255).round();
  return Color.fromARGB(255, d, d, d);
}

/// Tells MaterialApp which mode is on.
final ValueNotifier<bool> darkMode = ValueNotifier(false);

/// Switch dark mode on or off and redraw every screen, including ones
/// underneath the current page and any open popup.
void setDarkMode(bool on) {
  C.dark = on;
  darkMode.value = on;
  void rebuild(Element e) {
    e.markNeedsBuild();
    e.visitChildren(rebuild);
  }

  WidgetsBinding.instance.rootElement?.visitChildren(rebuild);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: C.dark ? Brightness.dark : Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF222222),
      brightness: C.dark ? Brightness.dark : Brightness.light,
      primary: C.ink,
      onPrimary: C.white,
      surface: C.card,
      onSurface: C.ink,
    ),
    scaffoldBackgroundColor: C.card,
    canvasColor: C.card,
    fontFamily: 'Arial',
    iconTheme: IconThemeData(color: C.ink),
    inputDecorationTheme: InputDecorationTheme(
      isDense: true,
      filled: true,
      fillColor: C.card,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      hintStyle: TextStyle(color: C.ink3),
      prefixIconColor: C.ink2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: g(0xFF9D9D9D), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: g(0xFF9D9D9D), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: C.ink, width: 2),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: C.card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: C.ink, width: 2),
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(color: C.card, surfaceTintColor: Colors.transparent),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: C.ink,
      contentTextStyle: TextStyle(color: C.white),
      behavior: SnackBarBehavior.floating,
    ),
    appBarTheme: AppBarTheme(backgroundColor: C.panel, foregroundColor: C.ink, surfaceTintColor: Colors.transparent),
    drawerTheme: DrawerThemeData(backgroundColor: C.panel),
  );
  return base.copyWith(textTheme: base.textTheme.apply(bodyColor: C.ink, displayColor: C.ink));
}
