import 'dart:ui';

class ThemeModeNotifier {
  ThemeModeNotifier(this.appBrightness);

  final ValueNotifier<Brightness> appBrightness;

  changeBrightness({required Brightness brightness}) {
    appBrightness.value = brightness;
  }
}
