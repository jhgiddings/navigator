import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../appbar.dart';

class AvaInformation extends StatefulWidget {
  const AvaInformation({Key? key}) : super(key: key);

  @override
  State<AvaInformation> createState() => _AvaInformationState();
}

class _AvaInformationState extends State<AvaInformation> {
  String _versionInfo = "Application Name: \nVersion: \nBuild Number: \n";

  _updateBuildInfo() {
    Timer(const Duration(milliseconds: 500), () {
      PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
        String appName = packageInfo.appName;
        String version = packageInfo.version;
        String buildNumber = packageInfo.buildNumber;

        setState(() {
          _versionInfo =
              "App Name: $appName\nVersion: $version\nBuild Number: $buildNumber\n";
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      _updateBuildInfo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        appBar: AppBar(
          backgroundColor: Colors.green,
        ),
        title: const Text("AVA Walk Navigator"),
        widgets: const [],
        key: const Key("information"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Information",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
          SizedBox(
              height: 80.0,
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(_versionInfo,
                      style: const TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 18)))),
          const SizedBox(
              height: 50.0,
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      "Copyright 2022 by American Volkssport Association",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          overflow: TextOverflow.visible)))),
          const SizedBox(
              height: 15.0,
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                      "Packages used to create this app:",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                          overflow: TextOverflow.visible)))),
          const SizedBox(
              height: 40.0,
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                      "file_picker 3.0.4 (5.2.6 available)\r\n"
                      "flutter_osm_interface 0.3.4 (was 0.3.3)\r\n"
                      "flutter_osm_plugin 0.53.1 (was 0.53.0)\r\n"
                      "flutter_osm_web 0.2.4 (was 0.2.3)\r\n"
                      "latlong2 0.8.1\r\n"
                      "package_info_plus 3.0.3\r\n"
                      "package_info_plus_platform_interface 2.0.1\r\n"
                      "xml 6.1.0 (6.2.2 available)\r\n",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
                          overflow: TextOverflow.visible)))),
        ],
      ),
    );
  }
}
