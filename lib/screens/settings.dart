import 'package:flutter/material.dart';
import '../appbar.dart';

class AvaSettings extends StatefulWidget {
  const AvaSettings({Key? key}) : super(key: key);

  @override
  State<AvaSettings> createState() => _AvaSettingsState();
}

class _AvaSettingsState extends State<AvaSettings> {
  bool _useDarkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(
          appBar: AppBar(
            backgroundColor: Colors.green,
          ),
          title: const Text("AVA Walk Navigator"),
          widgets: const [],
          key: const Key("settings"),
        ),
        body: Column(
          children: [
            const Text("Settings",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Enable Dark Mode:", style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Switch(
                    value: _useDarkTheme,
                    onChanged: (val) {
                      setState(() {
                        _useDarkTheme = val;
                      });
                    }),
              ],
            ),
          ],
        ));
  }
}
