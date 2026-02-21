import 'package:flutter/material.dart';

import '../appbar.dart';

class AvaHelp extends StatefulWidget {
  const AvaHelp({Key? key}) : super(key: key);

  @override
  State<AvaHelp> createState() => _AvaHelpState();
}

class _AvaHelpState extends State<AvaHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(
          backgroundColor: Colors.green,
        ),
        title: const Text("AVA Walk Navigator"),
        widgets: const [],
        key: const Key("help"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Help Center",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
          Container(
              height: 40.0,
              width: double.infinity,
              color: Colors.grey[400],
              child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("Getting Started",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      "1.  Download GPX file to your smartphone to your phone's Download folder.",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18))),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("2.  Start this app.",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18))),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("3.  Tap the 'Import GPX' button",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18))),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      "4.  Select the GPX file that you just downloaded.",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18))),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      "5.  When the map and GPX route has loaded, tap the 'Start Navigation' button. This will take up to 10 seconds, so please be patient.",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18))),
              Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      "6.  When you have completed the trail (route), then tap the 'Stop Navigation' button and close this app.",
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18))),
            ],
          ),
          Container(
              height: 40.0,
              width: double.infinity,
              color: Colors.grey[400],
              child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text("How To Guides",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)))),
        ],
      ),
    );
  }
}
