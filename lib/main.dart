import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeModeNotifier = ThemeModeNotifier(
      ValueNotifier<Brightness>(
        WidgetsBinding.instance.platformDispatcher.platformBrightness,
      ),
    );

  }

  @override
  void didChangePlatformBrightness() {
    _themeModeNotifier.changeBrightness(
      brightness: WidgetsBinding.instance.platformDispatcher.platformBrightness,
    );
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
