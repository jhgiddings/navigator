import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

import 'gpx_file.dart';

// Global variable for foreground notification (legacy support)
String publicWaypointDescription = "";

/// Callback type for navigation updates
typedef NavigationUpdateCallback = void Function({
  required double distance,
  required String description,
  required IconData icon,
  required int waypointIndex,
  required int totalWaypoints,
  required GeoPoint currentLocation,
});

/// Callback type for navigation state changes
typedef NavigationStateCallback = void Function(NavigationState state);

/// Navigation state enum
enum NavigationState {
  stopped,
  starting,
  active,
  paused,
  completed,
}

/// Navigation service - Handles real-time location tracking and waypoint progression
///
/// This class contains the PROVEN algorithm that successfully guided users
/// through walking routes 2 years ago. The core logic has been restored
/// from commented code and modernized with callbacks for UI updates.
class Navigation {
  final GpxFile gpxFile;
  final MapController mapController;
  final NavigationUpdateCallback? onNavigationUpdate;
  final NavigationStateCallback? onStateChanged;

  // Navigation state
  NavigationState _state = NavigationState.stopped;
  bool _navStarted = false;
  int _waypointIndex = 0;

  // Distance tracking (RESTORED from working code)
  double _distCurrentLocToWaypoint = 0.0;
  double _distPreviousLocToWaypoint = 0.0;
  static const double _distanceToWaypoint = 10.0; // Threshold in meters (proven value)

  // Location tracking
  GeoPoint _currentLocation = GeoPoint(latitude: 0.0, longitude: 0.0);
  Queue<GeoPoint> _previousLocations = Queue();
  static const int _maxLocationHistory = 10;

  // Timer configuration (RESTORED from working code)
  static const int _timerDuration = 5; // seconds (proven value)
  Timer? _timer;

  // Legacy support
  bool towardDestination = false;

  Navigation({
    required this.gpxFile,
    required this.mapController,
    this.onNavigationUpdate,
    this.onStateChanged,
  });

  // Public getters
  NavigationState get state => _state;
  int get currentWaypointIndex => _waypointIndex;
  double get distanceToWaypoint => _distCurrentLocToWaypoint;
  GeoPoint get currentLocation => _currentLocation;
  bool get isNavigating => _navStarted;

  /// Start navigation from closest waypoint
  Future<void> startNavigation() async {
    if (_navStarted) return;

    _setState(NavigationState.starting);

    try {
      // Find the best starting waypoint
      await findClosestWaypoint();

      _navStarted = true;
      _setState(NavigationState.active);

      // Start the location update loop
      await _processLocationUpdate();

      print("Navigation started at waypoint $_waypointIndex");
    } catch (e) {
      print("Error starting navigation: $e");
      _setState(NavigationState.stopped);
    }
  }

  /// Pause navigation (stops updates but preserves state)
  void pauseNavigation() {
    if (!_navStarted) return;

    _navStarted = false;
    _timer?.cancel();
    _setState(NavigationState.paused);
    print("Navigation paused");
  }

  /// Resume navigation from paused state
  Future<void> resumeNavigation() async {
    if (_state != NavigationState.paused) return;

    _navStarted = true;
    _setState(NavigationState.active);
    await _processLocationUpdate();
    print("Navigation resumed");
  }

  /// Stop navigation completely
  void stopNavigation() {
    _navStarted = false;
    _timer?.cancel();
    _previousLocations.clear();
    _setState(NavigationState.stopped);
    print("Navigation stopped");
  }

  /// Set navigation state and notify listeners
  void _setState(NavigationState newState) {
    _state = newState;
    onStateChanged?.call(newState);
  }

  /// RESTORED: Find closest waypoint to start navigation
  /// This is the PROVEN algorithm from the working version
  Future<void> findClosestWaypoint() async {
    if (gpxFile.wayPoints.isEmpty) {
      throw Exception("No waypoints in GPX file");
    }

    // Get current location
    _currentLocation = await mapController.myLocation();

    // Find closest waypoint
    double distanceClosest = 99999.9;
    int indexClosest = 0;

    for (int i = 0; i < gpxFile.wayPoints.length; i++) {
      WayPoint wpt = gpxFile.wayPoints[i];
      double dist = Geolocator.distanceBetween(
        _currentLocation.latitude,
        _currentLocation.longitude,
        wpt.latitude,
        wpt.longitude,
      );

      if (dist < distanceClosest) {
        distanceClosest = dist;
        indexClosest = i;
      }
    }

    // If the closest waypoint is the ending waypoint, start from beginning
    if (indexClosest == (gpxFile.wayPoints.length - 1)) {
      indexClosest = 0;
    }

    // PROVEN LOGIC: Determine if we should head to closest or next waypoint
    // This uses bearing calculations to determine if user is ahead of or behind the waypoint
    if (indexClosest < gpxFile.wayPoints.length - 1) {
      double angleBetweenNextAndPosition =
          (gpxFile.wayPoints[indexClosest].headingToNextDegrees -
                  Geolocator.bearingBetween(
                    gpxFile.wayPoints[indexClosest].latitude,
                    gpxFile.wayPoints[indexClosest].longitude,
                    _currentLocation.latitude,
                    _currentLocation.longitude,
                  )) %
              360.0;

      if (angleBetweenNextAndPosition < 0.0) {
        angleBetweenNextAndPosition += 360.0;
      }

      double d1 = cos(angleBetweenNextAndPosition * pi / 180.0) *
          gpxFile.wayPoints[indexClosest].headingToNextDegrees;

      if (d1 < gpxFile.wayPoints[indexClosest].distanceToNext) {
        indexClosest++;
      }
    }

    _waypointIndex = indexClosest;
    print("Starting at waypoint $_waypointIndex (closest: $distanceClosest m)");
  }

  /// RESTORED: Process location update - Core navigation loop
  /// This is the PROVEN algorithm from the working version
  Future<void> _processLocationUpdate() async {
    if (!_navStarted) return;

    try {
      // Get current location from map controller
      _currentLocation = await mapController.myLocation();
      _previousLocations.addFirst(_currentLocation);

      // Trim location history to prevent memory growth
      while (_previousLocations.length > _maxLocationHistory) {
        _previousLocations.removeLast();
      }

      // Get current waypoint
      if (_waypointIndex >= gpxFile.wayPoints.length) {
        // Route completed
        await _completeNavigation();
        return;
      }

      WayPoint currentWaypoint = gpxFile.wayPoints[_waypointIndex];
      GeoPoint curWptLoc = currentWaypoint.geoPoint;

      // RESTORED: Calculate distance to current waypoint
      _distCurrentLocToWaypoint = Geolocator.distanceBetween(
        _currentLocation.latitude,
        _currentLocation.longitude,
        curWptLoc.latitude,
        curWptLoc.longitude,
      );

      print("Current Location to Waypoint: ${_distCurrentLocToWaypoint.toStringAsFixed(1)} m");

      // Wait until there is more than one location in the queue
      if (_previousLocations.length > 1) {
        GeoPoint prevLoc = _previousLocations.elementAt(1);
        _distPreviousLocToWaypoint = Geolocator.distanceBetween(
          prevLoc.latitude,
          prevLoc.longitude,
          curWptLoc.latitude,
          curWptLoc.longitude,
        );

        print("Previous Location to Waypoint: ${_distPreviousLocToWaypoint.toStringAsFixed(1)} m");
      }

      // Update UI via callback
      _notifyNavigationUpdate();

      // RESTORED: Check if waypoint should advance (PROVEN ALGORITHM)
      // User must be within threshold AND walking away from waypoint
      if (_previousLocations.length > 1 &&
          (_distPreviousLocToWaypoint < _distanceToWaypoint) &&
          (_distCurrentLocToWaypoint > _distPreviousLocToWaypoint)) {

        _waypointIndex++;
        print("✓ Waypoint passed! Advancing to waypoint $_waypointIndex");

        await _updateWaypoint();
      }

      // Restart timer if navigation is active (RESTORED from working code)
      if (_navStarted) {
        _timer = Timer(const Duration(seconds: _timerDuration), () {
          _processLocationUpdate();
        });
      }
    } catch (e) {
      print("Error in location update: $e");
      // Continue navigation despite errors
      if (_navStarted) {
        _timer = Timer(const Duration(seconds: _timerDuration), () {
          _processLocationUpdate();
        });
      }
    }
  }

  /// RESTORED: Update waypoint instruction
  /// This is the PROVEN algorithm from the working version
  Future<void> _updateWaypoint() async {
    if (_waypointIndex >= gpxFile.wayPoints.length) {
      // Route completed
      await _completeNavigation();
      return;
    }

    WayPoint wpt = gpxFile.wayPoints[_waypointIndex];

    // Update foreground notification (legacy support)
    publicWaypointDescription = wpt.description;

    // Notify UI of waypoint change
    _notifyNavigationUpdate();

    print("Updated to waypoint $_waypointIndex: ${wpt.description}");
  }

  /// Complete navigation when final waypoint reached
  Future<void> _completeNavigation() async {
    _navStarted = false;
    _timer?.cancel();
    _setState(NavigationState.completed);

    print("🎉 Route completed!");

    // Final UI update
    onNavigationUpdate?.call(
      distance: 0.0,
      description: "Route completed!",
      icon: Icons.flag,
      waypointIndex: gpxFile.wayPoints.length,
      totalWaypoints: gpxFile.wayPoints.length,
      currentLocation: _currentLocation,
    );
  }

  /// Notify UI of navigation update
  void _notifyNavigationUpdate() {
    if (_waypointIndex >= gpxFile.wayPoints.length) return;

    WayPoint currentWaypoint = gpxFile.wayPoints[_waypointIndex];

    print("📢 Navigation calling UI update callback:");
    print("   Distance: ${_distCurrentLocToWaypoint.toStringAsFixed(1)} m");
    print("   Waypoint: ${_waypointIndex + 1} of ${gpxFile.wayPoints.length}");
    print("   Description: ${currentWaypoint.description}");
    print("   Symbol: ${currentWaypoint.symbol}");

    onNavigationUpdate?.call(
      distance: _distCurrentLocToWaypoint,
      description: currentWaypoint.description,
      icon: _getDirectionIcon(currentWaypoint.symbol),
      waypointIndex: _waypointIndex,
      totalWaypoints: gpxFile.wayPoints.length,
      currentLocation: _currentLocation,
    );
  }

  /// RESTORED: Get direction icon from waypoint symbol
  /// This is the PROVEN mapping from the working version
  IconData _getDirectionIcon(String symbol) {
    String dir = symbol.toLowerCase();

    if (dir == "right") {
      return Icons.east;
    } else if (dir == "left") {
      return Icons.west;
    } else if (dir == "right_slight" || dir.contains("slight") && dir.contains("right")) {
      return Icons.north_east;
    } else if (dir == "left_slight" || dir.contains("slight") && dir.contains("left")) {
      return Icons.north_west;
    } else if (dir == "right_sharp" || dir.contains("sharp") && dir.contains("right")) {
      return Icons.south_east;
    } else if (dir == "left_sharp" || dir.contains("sharp") && dir.contains("left")) {
      return Icons.south_west;
    } else if (dir == "back" || dir.contains("u-turn")) {
      return Icons.south;
    } else {
      // Default: straight ahead
      return Icons.north;
    }
  }

  /// Clean up resources
  void dispose() {
    stopNavigation();
  }
}
