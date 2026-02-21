import 'dart:async';
import 'dart:collection';
// import 'dart:io';
import 'dart:math';

// import 'package:device_info_plus/device_info_plus.dart';
//

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:wakelock/wakelock.dart';

import '../gpx_file.dart';

String publicWaypointDescription = "";

class Navigation {
  Navigation({Key? key, required this.gpxFile, required this.mapController});
  final GpxFile gpxFile;
  final MapController mapController;

  // bool _navStarted = false;
  int _waypointIndex = 0;
  // String _waypointDescription = "";
  //
  // double _distCurrentLocToWaypoint = 0.0;
  // double _distPreviousLocToWaypoint = 0.0;
  //
  // List<double> _distancesBetweenWaypoints = [];

  static const _timerDuration = 5;
  Timer timer = Timer(const Duration(seconds: _timerDuration), () {});

  // bool backgroundLocationEnabled;
  bool towardDestination = false;
  GeoPoint _currentLocation = GeoPoint(latitude: 0.0, longitude: 0.0);
  Queue<GeoPoint> _previousLocations = Queue();

  findClosestWaypoint() async {
    // Get current location then scan through all waypoints to find the closest one
    _currentLocation = await mapController.myLocation();
    double distanceClosest = 99999.9;
    int indexClosest = 0;
    for (int i = 0; i < gpxFile.wayPoints.length; i++) {
      WayPoint wpt = gpxFile.wayPoints[i];
      double dist = Geolocator.distanceBetween(_currentLocation.latitude,
          _currentLocation.longitude, wpt.latitude, wpt.longitude);
      if (dist < distanceClosest) {
        distanceClosest = dist;
        indexClosest = i;
      }
    }
    // If the index to the closest waypoint is the ending waypoint, then set it back to the beginning.
    if (indexClosest == (gpxFile.wayPoints.length - 1)) {
      indexClosest = 0;
    }

    // Now determine if we want to head to the closest waypoint or the next in the list.
    // We do this by checking the heading to the closest and the next in the list.
    double headingClosestToNext =
        gpxFile.wayPoints[indexClosest].headingToNextDegrees;
    double headingClosestToPosition = Geolocator.bearingBetween(
        gpxFile.wayPoints[indexClosest].latitude,
        gpxFile.wayPoints[indexClosest].longitude,
        _currentLocation.latitude,
        _currentLocation.longitude);
    double headingNextToPosition = Geolocator.bearingBetween(
        gpxFile.wayPoints[indexClosest + 1].latitude,
        gpxFile.wayPoints[indexClosest + 1].longitude,
        _currentLocation.latitude,
        _currentLocation.longitude);

    double angleBetweenNextAndPosition =
        (gpxFile.wayPoints[indexClosest].headingToNextDegrees -
                headingClosestToPosition) %
            360.0;
    if (angleBetweenNextAndPosition < 0.0) angleBetweenNextAndPosition += 360.0;
    double d1 = cos(angleBetweenNextAndPosition * pi / 180.0) *
        gpxFile.wayPoints[indexClosest].headingToNextDegrees;

    if (d1 < gpxFile.wayPoints[indexClosest].distanceToNext) {
      indexClosest++;
    }
    _waypointIndex = indexClosest;

  }

  _processLocationUpdate() async {
    // Get current location from map controller
    _currentLocation = await mapController.myLocation();
    _previousLocations.addFirst(_currentLocation);
    //
    // // Current waypoint
    // GeoPoint curWptLoc = GeoPoint(
    //     latitude: widget.wayPoints[_waypointIndex].latitude,
    //     longitude: widget.wayPoints[_waypointIndex].longitude);
    // _distCurrentLocToWaypoint =
    //     await _calculateDistanceBetweenPoints(_currentLocation, curWptLoc);
    // print("Current Location to Waypoint: $_distCurrentLocToWaypoint");
    //
    // // Wait until there is more than one location in the queue before calculating the distance to the waypoint
    // if (_previousLocations.length > 1) {
    //   _distPreviousLocToWaypoint = await _calculateDistanceBetweenPoints(
    //       _previousLocations.elementAt(1), curWptLoc);
    //   print("Previous Location to Waypoint: $_distPreviousLocToWaypoint");
    // }
    //
    // setState(() {
    //   _currentLocation;
    //   _previousLocations;
    //   _distCurrentLocToWaypoint;
    //   _distPreviousLocToWaypoint;
    //   double lat = double.parse((_currentLocation.latitude).toStringAsFixed(6));
    //   double lon =
    //       double.parse((_currentLocation.longitude).toStringAsFixed(6));
    //   double distCur =
    //       double.parse((_distCurrentLocToWaypoint).toStringAsFixed(2));
    //   double distPrev =
    //       double.parse((_distPreviousLocToWaypoint).toStringAsFixed(2));
    //   _positionDebug =
    //       "position: $lat, $lon\ndist cur loc to wpt: $distCur\ndist prev loc to wpt: $distPrev";
    // });
    //
    // // Check to see if walker is within specified distance of the waypoint and is walking away from
    // // the waypoint before incrementing to the next waypoint.
    // if ((_distPreviousLocToWaypoint < _distanceToWaypoint) &&
    //     (_distCurrentLocToWaypoint > _distPreviousLocToWaypoint)) {
    //   _waypointIndex++;
    //   print("increment waypoint to $_waypointIndex");
    //   _updateWaypoint();
    //   // _previousLocations.clear();
    // }
    // if (_navStarted) {
    //   timer = Timer(const Duration(seconds: _timerDuration), () {
    //     _processLocationUpdate();
    //   });
    // }
  }

  _updateWaypoint() {
    // // update the waypoint instruction area
    // WayPoint wpt = widget.wayPoints[_waypointIndex];
    // String dir = wpt.symbol.toLowerCase();
    // if (dir == "right") {
    //   _waypointIcon =
    //       const Icon(Icons.east, size: _containerHeight);
    // } else if (dir == "left") {
    //   _waypointIcon =
    //       const Icon(Icons.west, size: _containerHeight);
    // } else if (dir == "right_slight") {
    //   _waypointIcon = const Icon(Icons.north_east,
    //       size: _containerHeight);
    // } else if (dir == "left_slight") {
    //   _waypointIcon = const Icon(Icons.north_west,
    //       size: _containerHeight);
    // } else if (dir == "right_sharp") {
    //   _waypointIcon = const Icon(Icons.south_east,
    //       size: _containerHeight);
    // } else if (dir == "left_sharp") {
    //   _waypointIcon = const Icon(Icons.south_west,
    //       size: _containerHeight);
    // } else if (dir == "back") {
    //   _waypointIcon = const Icon(Icons.south,
    //       size: _containerHeight);
    // } else {
    //   _waypointIcon =
    //       const Icon(Icons.north, size: _containerHeight);
    // }
    //
    // // Update the foreground notification widget
    // publicWaypointDescription = wpt.description;
    //
    // // Update the state and cause a widget refresh
    // setState(() {
    //   _waypointIcon;
    //   _waypointDescription = wpt.description;
    // });
  }
}
