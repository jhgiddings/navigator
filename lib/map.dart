import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'gpx_file.dart';
import 'navigation.dart';

class Map extends StatefulWidget {
  const Map({Key? key, required this.gpxFile, required this.mapController})
      : super(key: key);
  final GpxFile gpxFile;
  final MapController mapController;

  @override
  State<Map> createState() => MapState();
}

class MapState extends State<Map> {
  late Widget _mapWidget;
  late Widget _mapToolsAppBar;
  late Widget _debugInfoWidget;
  late Widget _waypointDistanceWidget;
  late Widget _waypointIconWidget;
  late Widget _waypointTextWidget;

  static const double _waypointPanelHeight = 100.0;
  static const double _iconSize = 64.0;
  final Color? _waypointRowColor = Colors.green[200];

  // Navigation state (updated by Navigation service callbacks)
  IconData _waypointIcon = Icons.north;
  String _waypointDescription = "";
  double _distCurrentLocToWaypoint = 0.0;
  int _currentWaypointIndex = 0;
  int _totalWaypoints = 0;


  @override
  void initState() {
    super.initState();

    setState(() {
      // Create the list of children to be placed on the Stack widget
      _mapWidget = OSMFlutter(
        controller: widget.mapController,
        osmOption: OSMOption(
          zoomOption: ZoomOption(
            initZoom: 15,
            minZoomLevel: 5,
            maxZoomLevel: 19,
            stepZoom: 1.0,
          ),
          showContributorBadgeForOSM: true,
          showDefaultInfoWindow: false,
          userTrackingOption: UserTrackingOption(
            enableTracking: true,
            unFollowUser: false,
          ),
        ),
        onMapIsReady: (bool value) async {
          if (value) {
            Future.delayed(const Duration(seconds: 1), () async {
              await widget.mapController.currentLocation();
              updateMapMarkerLayer();
            });
          }
        },
      );
      _waypointIcon = Icons.north;

      _waypointDistanceWidget = Container(
        height: _waypointPanelHeight,
        width: 120,
        color: _waypointRowColor,
        child: Center(
          child: Text(
            "${_distCurrentLocToWaypoint.toStringAsFixed(0)} m",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                height: 1.0),
          ),
        ),
      );

      _waypointIconWidget = Container(
        height: _waypointPanelHeight,
        width: _iconSize,
        color: _waypointRowColor,
        child: Icon(
          _waypointIcon,
          color: Colors.black,
          size: _iconSize,
        ),
      );

      _waypointTextWidget = Expanded(
        child: Container(
          height: _waypointPanelHeight,
          color: _waypointRowColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _waypointDescription.isEmpty
                      ? "Follow the route"
                      : _waypointDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// Handle navigation updates from Navigation service
  void handleNavigationUpdate({
    required double distance,
    required String description,
    required IconData icon,
    required int waypointIndex,
    required int totalWaypoints,
    required GeoPoint currentLocation,
  }) {
    setState(() {
      _distCurrentLocToWaypoint = distance;
      _waypointDescription = description;
      _waypointIcon = icon;
      _currentWaypointIndex = waypointIndex;
      _totalWaypoints = totalWaypoints;

      // Rebuild waypoint widgets with new data
      _waypointDistanceWidget = Container(
        height: _waypointPanelHeight,
        width: 120,
        color: _waypointRowColor,
        child: Center(
          child: Text(
            "${_distCurrentLocToWaypoint.toStringAsFixed(0)} m",
            style: const TextStyle(
                color: Colors.black,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                height: 1.0),
          ),
        ),
      );

      _waypointIconWidget = Container(
        height: _waypointPanelHeight,
        width: _iconSize,
        color: _waypointRowColor,
        child: Icon(
          _waypointIcon,
          color: Colors.black,
          size: _iconSize,
        ),
      );

      _waypointTextWidget = Expanded(
        child: Container(
          height: _waypointPanelHeight,
          color: _waypointRowColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _waypointDescription.isEmpty
                      ? "Follow the route"
                      : _waypointDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                if (_totalWaypoints > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      "Waypoint ${_currentWaypointIndex + 1} of $_totalWaypoints",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    widget.mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              _mapWidget,
              // Zoom controls
              Positioned(
                right: 16,
                top: 16,
                child: Column(
                  children: [
                    FloatingActionButton(
                      heroTag: 'zoom_in',
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        try {
                          double currentZoom = await widget.mapController.getZoom();
                          await widget.mapController.setZoom(zoomLevel: currentZoom + 1);
                        } catch (e) {
                          print("Error zooming in: $e");
                        }
                      },
                      child: const Icon(Icons.add, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'zoom_out',
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        try {
                          double currentZoom = await widget.mapController.getZoom();
                          await widget.mapController.setZoom(zoomLevel: currentZoom - 1);
                        } catch (e) {
                          print("Error zooming out: $e");
                        }
                      },
                      child: const Icon(Icons.remove, color: Colors.black),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'center_location',
                      mini: true,
                      backgroundColor: Colors.white,
                      onPressed: () async {
                        try {
                          await _centerMapOnLocation();
                        } catch (e) {
                          print("Error centering on location: $e");
                        }
                      },
                      child: const Icon(Icons.my_location, color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: _waypointRowColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _waypointIconWidget,
              _waypointDistanceWidget,
              _waypointTextWidget,
            ],
          ),
        ),
      ],
    );
  }

  _drawRoad(List<GeoPoint> points) async {
    if (points.isEmpty) return;

    try {
    // Use a bright, highly visible color for the route
    RoadOption roadOption = const RoadOption(
      roadColor: Color(0xFF6200EA), // Vibrant purple - high visibility on maps
      roadWidth: 8,
    );

    print("Drawing road with ${points.length} points");

    if (points.length >= 2) {
      await widget.mapController.drawRoad(
        points.first,
        points.last,
        roadType: RoadType.foot,
        intersectPoint: points,
        roadOption: roadOption
      );
      print("Road drawn successfully");
    }
  } catch (e) {
    print("Error drawing road: $e");
  }
  }

  _zoomToFitRoute() async {
    try {
      if (widget.gpxFile.wayPoints.isEmpty) return;

      // Calculate bounds
      double minLat = widget.gpxFile.wayPoints[0].latitude;
      double maxLat = widget.gpxFile.wayPoints[0].latitude;
      double minLon = widget.gpxFile.wayPoints[0].longitude;
      double maxLon = widget.gpxFile.wayPoints[0].longitude;

      for (var wp in widget.gpxFile.wayPoints) {
        if (wp.latitude < minLat) minLat = wp.latitude;
        if (wp.latitude > maxLat) maxLat = wp.latitude;
        if (wp.longitude < minLon) minLon = wp.longitude;
        if (wp.longitude > maxLon) maxLon = wp.longitude;
      }

      // Calculate center
      double centerLat = (minLat + maxLat) / 2;
      double centerLon = (minLon + maxLon) / 2;
      GeoPoint center = GeoPoint(latitude: centerLat, longitude: centerLon);

      // Go to center
      await widget.mapController.goToLocation(center);

      // Set appropriate zoom level based on bounds
      double latDiff = maxLat - minLat;
      double lonDiff = maxLon - minLon;
      double maxDiff = latDiff > lonDiff ? latDiff : lonDiff;

      double zoom = 15.0;
      if (maxDiff > 0.1) zoom = 12.0;
      else if (maxDiff > 0.05) zoom = 13.0;
      else if (maxDiff > 0.02) zoom = 14.0;
      else if (maxDiff > 0.01) zoom = 15.0;
      else zoom = 16.0;

      await widget.mapController.setZoom(zoomLevel: zoom);
      print("Zoomed to fit route at level $zoom");
    } catch (e) {
      print("Error zooming to fit route: $e");
    }
  }

  _centerMapOnLocation() async {
    GeoPoint loc = await widget.mapController.myLocation();
    widget.mapController.goToLocation(loc);
  }

  // _updateLocation(GeoPoint loc) {
  //   print(loc);
  //   // previousLocation = myLocation;
  //   // myLocation = loc;
  //   // // Compare current location to previous location to see if we are heading toward or away from the waypoint
  //   // double dist = await distance2point(previousLocation, myLocation);
  //   // if (dist < distanceToWaypoint) {
  //   //   switchToNextWaypoint = false;
  //   //   distanceToWaypoint = dist;
  //   // } else {
  //   //   switchToNextWaypoint = true;
  //   //   // Increment to the next waypoint
  //   //   waypointNumberToDisplay++;
  //   //   // Set the distance to the next waypoint
  //   //   distanceToWaypoint = distancesBetweenWaypoints[waypointNumberToDisplay];
  //   //   // Update the Waypoint instruction display area
  //   //   updateWaypointInstruction();
  //   // }
  // }

  updateMapMarkerLayer() async {
    if (widget.gpxFile.mapLoaded) {
      print("updateMapMarkerLayer: mapLoaded is true");
      print("Number of waypoints: ${widget.gpxFile.wayPoints.length}");
      print("Number of track points: ${widget.gpxFile.trackGeoPoints.length}");

      // Clear existing markers first
      try {
        await widget.mapController.removeMarkers(widget.gpxFile.wayGeoPoints);
      } catch (e) {
        print("Error clearing markers: $e");
      }

      // Add markers only for meaningful waypoints
      for (var i = 0; i < widget.gpxFile.wayPoints.length; i++) {
        WayPoint widgetWaypoint = widget.gpxFile.wayPoints[i];
        GeoPoint mapWaypoint = widgetWaypoint.geoPoint;

        // Only show start, end, and waypoints with descriptions (meaningful points)
        bool isStart = i == 0;
        bool isEnd = i == (widget.gpxFile.wayPoints.length - 1);
        bool hasMeaning = widgetWaypoint.description.isNotEmpty ||
                         widgetWaypoint.symbol.isNotEmpty;

        try {
          if (isStart) {
            // Start marker - larger green flag for high visibility
            await widget.mapController.addMarker(mapWaypoint,
                markerIcon: const MarkerIcon(
                    icon: Icon(
                    Icons.flag,
                    size: 56,
                    color: Color(0xFF00C853), // Vibrant green
                )));
          } else if (isEnd) {
            // End marker - larger red flag for high visibility
            await widget.mapController.addMarker(mapWaypoint,
                markerIcon: const MarkerIcon(
                    icon: Icon(
                    Icons.flag,
                    size: 56,
                    color: Color(0xFFD50000), // Vibrant red
                )));
          } else if (hasMeaning) {
            // Only show intermediate waypoints if they have descriptions/meaning
            // These represent decision points, POIs, or turn points
            await widget.mapController.addMarker(mapWaypoint,
                markerIcon: const MarkerIcon(
                    icon: Icon(
                      Icons.location_on,
                      size: 32,
                      color: Color(0xFF6200EA), // Match route color
                    )));
          }
          // Skip unmarked intermediate waypoints to reduce clutter
        } catch (e) {
          print("Error adding marker at index $i: $e");
        }
      }

      // Draw the route if we have track points
      if (widget.gpxFile.trackGeoPoints.isNotEmpty) {
        await _drawRoad(widget.gpxFile.trackGeoPoints);
      } else if (widget.gpxFile.wayPoints.length > 1) {
        // If no track points, draw line between waypoints
        List<GeoPoint> waypointGeoPoints = widget.gpxFile.wayPoints.map((wp) => wp.geoPoint).toList();
        await _drawRoad(waypointGeoPoints);
      }

      // Zoom to show all waypoints
      if (widget.gpxFile.wayPoints.isNotEmpty) {
        await _zoomToFitRoute();
      }
    } else {
      print("updateMapMarkerLayer: mapLoaded is false");
    }
  }

  Icon getDirectionArrow(double heading) {
    IconData arrow = Icons.north;
    const Color arrowColor = Colors.black;
    if (heading > 337.5 && heading <= 22.5) {
      arrow = Icons.north;
    } else if (heading > 22.5 && heading <= 67.5) {
      arrow = Icons.north_east;
    } else if (heading > 67.5 && heading <= 112.5) {
      arrow = Icons.east;
    } else if (heading > 112.5 && heading <= 157.5) {
      arrow = Icons.south_east;
    } else if (heading > 157.5 && heading <= 202.5) {
      arrow = Icons.south;
    } else if (heading > 202.5 && heading <= 247.5) {
      arrow = Icons.south_west;
    } else if (heading > 247.5 && heading <= 292.5) {
      arrow = Icons.west;
    } else if (heading > 292.5 && heading <= 337.5) {
      arrow = Icons.north_west;
    }
    return Icon(
      arrow,
      color: arrowColor,
      size: _iconSize,
    );
  }
}
