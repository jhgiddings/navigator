import 'dart:ui';

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'theme_mode_notifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AvaNavigator());
}

class AvaNavigator extends StatefulWidget {
  const AvaNavigator({super.key});

  @override
  AvaNavigatorState createState() => AvaNavigatorState();
}

class AvaNavigatorState extends State<AvaNavigator>
    with WidgetsBindingObserver {
  late ThemeModeNotifier _themeModeNotifier;
  late final WidgetsBinding _widgetsBinding;
  late final FlutterWindow _window;

  @override
  void initState() {
    _widgetsBinding = WidgetsBinding.instance;
    _widgetsBinding.addObserver(this);
    _window = _widgetsBinding.window;
    _themeModeNotifier = ThemeModeNotifier(
      ValueNotifier<Brightness>(_window.platformDispatcher.platformBrightness),
    );

    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    _themeModeNotifier.changeBrightness(
        brightness: _window.platformDispatcher.platformBrightness);
    super.didChangePlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Brightness>(
      valueListenable: _themeModeNotifier.appBrightness,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.green, brightness: value),
          title: "AVA Walk Navigator",
          home: const HomeScreen(),
        );
      },
    );
  }
}
