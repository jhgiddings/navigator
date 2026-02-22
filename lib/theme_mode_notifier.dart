import 'dart:ui';
import 'package:flutter/foundation.dart';

class ThemeModeNotifier {
  ThemeModeNotifier(this.appBrightness);

  final ValueNotifier<Brightness> appBrightness;

  changeBrightness({required Brightness brightness}) {
    appBrightness.value = brightness;
  }
}
