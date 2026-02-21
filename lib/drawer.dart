import 'package:flutter/material.dart';

import 'screens/help.dart';
import 'screens/information.dart';
import 'screens/settings.dart';

class AvaDrawer extends StatelessWidget {
  const AvaDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Text("Menu",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AvaSettings()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("Help"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AvaHelp()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text("Information"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AvaInformation()),
              );
            },
          ),
        ],
      ),
    );
  }
}
