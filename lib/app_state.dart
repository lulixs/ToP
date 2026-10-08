import 'package:flutter/foundation.dart';

/// The only "state" in the click-through: who is signed in and whether
/// Master mode is on. Swap for real auth when the backend exists.
class AppState {
  static final ValueNotifier<bool> masterOn = ValueNotifier(false);
  static String currentUser = 'Dipper';
  static String tabletName = 'Processing tablet';
}
