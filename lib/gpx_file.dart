import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_osm_interface/flutter_osm_interface.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_math/vector_math.dart';
import 'package:xml/xml.dart';

class GpxFile {
  GpxFile({required this.callback, this.onError});
  final void Function(bool) callback;
  final void Function(String)? onError;

  bool mapLoaded = false;
  String gpxName = "";
  String trkName = "";
  String errorMessage = "";

  List<TrackPoint> trackPoints = [];
  List<GeoPoint> trackGeoPoints = [];
  List<WayPoint> wayPoints = [];
  List<GeoPoint> wayGeoPoints = [];

  Future<void> importGpxFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['gpx'],
      );

      if (result == null) {
        // User cancelled the picker
        errorMessage = "File selection cancelled";
        callback(false);
        return;
      }

      if (result.files.single.path == null) {
        errorMessage = "Invalid file path";
        onError?.call(errorMessage);
        callback(false);
        return;
      }

      File file = File(result.files.single.path!);

      if (!file.existsSync()) {
        errorMessage = "File does not exist";
        onError?.call(errorMessage);
        callback(false);
        return;
      }

      String fileContents = readGpxFile(file.path);
      gpxName = file.path.split('/').last;

      bool success = parseGpxFile(fileContents);

      if (!success) {
        onError?.call(errorMessage);
        callback(false);
        return;
      }

      if (wayPoints.isEmpty && trackPoints.isEmpty) {
        errorMessage = "No waypoints or track points found in GPX file";
        onError?.call(errorMessage);
        callback(false);
        return;
      }

      mapLoaded = true;
      callback(true);
    } catch (e) {
      errorMessage = "Error importing GPX file: ${e.toString()}";
      onError?.call(errorMessage);
      callback(false);
    }
  }

  bool parseGpxFile(String gpxString) {
    try {
      final document = XmlDocument.parse(gpxString);
      final gpxElements = document.findElements("gpx");

      if (gpxElements.isEmpty) {
        errorMessage = "Invalid GPX file: No GPX root element found";
        return false;
      }

      final gpxNode = gpxElements.first;
      final wptNodes = gpxNode.findElements("wpt");
      if (wptNodes.isNotEmpty) {
        saveWaypoints(wptNodes);
      }

      final trkNodes = gpxNode.findElements("trk");
      if (trkNodes.isNotEmpty) {
        final trkNode = trkNodes.first;
        final trkNameElement = trkNode.getElement("name");
        trkName = trkNameElement?.innerText ?? "Unnamed Track";

        final trkSegNodes = trkNode.findElements("trkseg");
        if (trkSegNodes.isNotEmpty) {
          final trkSegNode = trkSegNodes.first;
          final trkPts = trkSegNode.findElements("trkpt");
          if (trkPts.isNotEmpty) {
            saveTrackPoints(trkPts);
          }
        }
      }

      return true;
    } catch (e) {
      errorMessage = "Error parsing GPX file: ${e.toString()}";
      return false;
    }
  }

  String readGpxFile(String filePath) {
    try {
      String contents = File(filePath).readAsStringSync();
      return contents;
    } catch (e) {
      errorMessage = "Error reading file: ${e.toString()}";
      throw Exception(errorMessage);
    }
  }

  saveTrackPoints(Iterable<XmlElement> nodes) {
    try {
      if (nodes.isEmpty) return;

      // Parse though the xml nodes and get info want, eliminating any duplicates
      XmlElement prevNode = nodes.first;
      for (final node in nodes) {
        final String? prevLatStr = prevNode.getAttribute("lat");
        final String? prevLonStr = prevNode.getAttribute("lon");
        final String? curLatStr = node.getAttribute("lat");
        final String? curLonStr = node.getAttribute("lon");

        if (prevLatStr == null || prevLonStr == null ||
            curLatStr == null || curLonStr == null) {
          continue; // Skip invalid nodes
        }

        final double prevLat = double.parse(prevLatStr);
        final double prevLon = double.parse(prevLonStr);
        final double curLat = double.parse(curLatStr);
        final double curLon = double.parse(curLonStr);

        if ((prevLat != curLat) || (prevLon != curLon)) {
          TrackPoint pt = TrackPoint(latitude: curLat, longitude: curLon);
          trackPoints.add(pt);
          GeoPoint geoPt = GeoPoint(latitude: curLat, longitude: curLon);
          trackGeoPoints.add(geoPt);
        }
        prevNode = node;
      }

      // Calculate headings between points
      for (int i = 1; i < trackPoints.length; i++) {
        double prevLat = trackPoints[i - 1].latitude;
        double prevLon = trackPoints[i - 1].longitude;
        double curLat = trackPoints[i].latitude;
        double curLon = trackPoints[i].longitude;
        trackPoints[i].headingToNextDegrees =
            Geolocator.bearingBetween(prevLat, prevLon, curLat, curLon);
      }
    } catch (e) {
      errorMessage = "Error saving track points: ${e.toString()}";
    }
  }

  saveWaypoints(Iterable<XmlElement> nodes) {
    try {
      List<WayPoint> points = [];

      // Parse though the xml nodes and get info want
      for (final node in nodes) {
        final String? latStr = node.getAttribute("lat");
        final String? lonStr = node.getAttribute("lon");

        if (latStr == null || lonStr == null) {
          continue; // Skip invalid nodes
        }

        // Fix XML parsing - use proper XML traversal
        final descElement = node.getElement("desc");
        final String desc = descElement?.innerText ?? "";

        final symElement = node.getElement("sym");
        final String sym = symElement?.innerText ?? "";

        double lat = double.parse(latStr);
        double lon = double.parse(lonStr);

        WayPoint wpt = WayPoint(latitude: lat, longitude: lon);
        wpt.description = desc;
        wpt.symbol = sym;
        points.add(wpt);
      }

      if (points.isEmpty) {
        return;
      }

      // Calculate heading angle between points
      for (int i = 0; i < points.length - 1; i++) {
        points[i].distanceToNext = Geolocator.distanceBetween(
            points[i].latitude,
            points[i].longitude,
            points[i + 1].latitude,
            points[i + 1].longitude);
        points[i].headingToNextDegrees = Geolocator.bearingBetween(
            points[i].latitude,
            points[i].longitude,
            points[i + 1].latitude,
            points[i + 1].longitude);
        points[i].headingToNextRadians = radians(points[i].headingToNextDegrees);
      }

      wayPoints = points;
    } catch (e) {
      errorMessage = "Error saving waypoints: ${e.toString()}";
    }
  }
}

class TrackPoint {
  double latitude = 0.0;
  double longitude = 0.0;
  double headingToNextDegrees = 0.0;
  double headingToNextRadians = 0.0;
  LatLng latLng = LatLng(0.0, 0.0);
  GeoPoint geoPoint = GeoPoint(latitude: 0.0, longitude: 0.0);

  TrackPoint({required this.latitude, required this.longitude}) {
    latLng = LatLng(latitude, longitude);
    geoPoint = GeoPoint(latitude: latitude, longitude: longitude);
  }
}

class WayPoint {
  String description = "";
  String symbol = "";
  double distanceToNext = 0.0;
  double headingToNextDegrees = 0.0;
  double headingToNextRadians = 0.0;
  double latitude = 0.0;
  double longitude = 0.0;
  LatLng latLng = LatLng(0.0, 0.0);
  GeoPoint geoPoint = GeoPoint(latitude: 0.0, longitude: 0.0);
  WayPoint({required this.latitude, required this.longitude}) {
    latLng = LatLng(latitude, longitude);
    geoPoint = GeoPoint(latitude: latitude, longitude: longitude);
  }
}
