import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

import 'gpx_file.dart';

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
  late IconData _waypointIcon;

  static const double _waypointPanelHeight = 100.0;
  static const double _iconSize = 64.0;
  final Color? _waypointRowColor = Colors.green[200];
  final String _waypointDescription = "";

  double _distCurrentLocToWaypoint = 0.0;


  @override
  void initState() {
    super.initState();

    setState(() {
      // Create the list of children to be placed on the Stack widget
      _mapWidget = OSMFlutter(
        controller: widget.mapController,
        initZoom: 15,
        minZoomLevel: 5,
        maxZoomLevel: 19,
        // onLocationChanged: _updateLocation,
        stepZoom: 1.0,
        showContributorBadgeForOSM: true,
        showZoomController: true,
        trackMyPosition: true,
        userLocationMarker: UserLocationMaker(
          personMarker: const MarkerIcon(
            icon: Icon(
              Icons.navigation,
              color: Colors.red,
              size: 64,
            ),
          ),
          directionArrowMarker: const MarkerIcon(
            icon: Icon(
              color: Colors.red,
              Icons.navigation,
              size: 64,
            ),
          ),
        ),
        roadConfiguration: const RoadOption(
          roadColor: Colors.red,
          roadWidth: 8,
        ),
        markerOption: MarkerOption(
            defaultMarker: const MarkerIcon(
          icon: Icon(
            Icons.north,
            color: Colors.orange,
            size: 56,
          ),
        )),
        onMapIsReady: (bool value) async {
          if (value) {
            Future.delayed(const Duration(seconds: 1), () async {
              await widget.mapController.myLocation();
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
          child: _mapWidget,
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
    RoadOption roadOption = const RoadOption(
      roadColor: Colors.red,
      roadWidth: 8,
    );

    // for (var i = 0; i < points.length; i++) {
    //   List<GeoPoint> segment = [];
    //   segment.add(points.first);
    //   segment.add(points.last);
    //   await widget.mapController.drawRoad(points[i], points[i + 1],
    //       roadType: RoadType.foot, intersectPoint: segment, roadOption: roadOption);
    // }
    await widget.mapController.drawRoad(points.first, points.last,
        roadType: RoadType.foot,
        intersectPoint: points,
        roadOption: roadOption);
    await widget.mapController.setZoom(zoomLevel: 12);
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
      for (var i = 0; i < widget.gpxFile.wayPoints.length; i++) {
        WayPoint widgetWaypoint = widget.gpxFile.wayPoints[i];
        GeoPoint mapWaypoint = widgetWaypoint.geoPoint;
        // if (i == 0) {
        //   await widget.mapController.addMarker(waypoints[i],
        //       markerIcon: const MarkerIcon(
        //           icon: Icon(
        //           Icons.flag,
        //           size: 64,
        //           color: Colors.red,
        //       )));
        // } else {
        //   if (i == (waypoints.length - 1)) {
        //     await widget.mapController.addMarker(waypoints[i],
        //         markerIcon: const MarkerIcon(
        //             icon: Icon(
        //             Icons.flag,
        //             size: 64,
        //             color: Colors.green,
        //         )));
        //   } else {
        await widget.mapController.addMarker(mapWaypoint,
            markerIcon: const MarkerIcon(
                icon: Icon(Icons.north, size: 64, color: Colors.black)),
            angle: widgetWaypoint.headingToNextRadians);
        //   }
        // }
      }
      _drawRoad(widget.gpxFile.trackGeoPoints);
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
      size: _containerSize,
    );
  }
}
