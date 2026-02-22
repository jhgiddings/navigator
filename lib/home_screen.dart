import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geolocator/geolocator.dart';

import 'appbar.dart';
import 'drawer.dart';
import 'gpx_file.dart';
import 'map.dart';
import 'navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<MapState> _mapKey = GlobalKey();

  final scaffoldKey = GlobalKey();
  final AvaDrawer _drawer = const AvaDrawer();
  final MapController _mapController = MapController(
    initPosition: GeoPoint(latitude: 47.4358055, longitude: 8.4737324),
  );

  late GpxFile _gpxFile;
  late Map _map;
  late Navigation _navigation;

  bool _gpxLoaded = false;
  bool _isLoadingGps = true;
  double _gpsAccuracy = 0.0;
  String _errorMessage = "";

  @override
  void initState() {
    super.initState();
    _gpxFile = GpxFile(
      callback: (gpxLoaded) {
        onGpxFileLoaded(gpxLoaded);
      },
      onError: (error) {
        _showErrorDialog(error);
      },
    );
    _map = Map(
      key: _mapKey,
      gpxFile: _gpxFile,
      mapController: _mapController,
    );
    _navigation = Navigation(
      gpxFile: _gpxFile,
      mapController: _mapController,
    );
    _checkGpsStatus();
  }

  void _checkGpsStatus() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingGps = false;
          _gpsAccuracy = 0.0;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoadingGps = false;
            _gpsAccuracy = 0.0;
          });
          return;
        }
      }

      // Start listening to position updates
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      ).listen((Position position) {
        setState(() {
          _isLoadingGps = false;
          _gpsAccuracy = position.accuracy;
        });
      });
    } catch (e) {
      setState(() {
        _isLoadingGps = false;
        _gpsAccuracy = 0.0;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error Loading GPX File'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _gpxFile.importGpxFile();
              },
              child: const Text('Try Again'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGpsIndicator() {
    IconData icon;
    Color color;
    String tooltip;

    if (_isLoadingGps) {
      icon = Icons.gps_not_fixed;
      color = Colors.orange;
      tooltip = 'Acquiring GPS...';
    } else if (_gpsAccuracy == 0.0) {
      icon = Icons.gps_off;
      color = Colors.red;
      tooltip = 'No GPS Signal';
    } else if (_gpsAccuracy > 20) {
      icon = Icons.gps_not_fixed;
      color = Colors.orange;
      tooltip = 'Weak GPS (${_gpsAccuracy.toStringAsFixed(0)}m)';
    } else {
      icon = Icons.gps_fixed;
      color = Colors.green;
      tooltip = 'GPS Locked (${_gpsAccuracy.toStringAsFixed(0)}m)';
    }

    return IconButton(
      icon: Icon(icon),
      color: color,
      tooltip: tooltip,
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tooltip),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: BaseAppBar(
          key: const Key("map"),
          appBar: AppBar(),
          title: const Text("Walk Navigator"),
          widgets: [
            _buildGpsIndicator(),
            IconButton(
              icon: const Icon(Icons.file_open_outlined),
              tooltip: 'Import GPX File',
              onPressed: () {
                _gpxFile.importGpxFile();
              },
            ),
          ],
        ),
        drawer: _drawer,
        body: Column(
          children: [
            _buildStatusBar(),
            Expanded(
              child: _map,
            ),
          ],
        ),
    );
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  Widget _buildStatusBar() {
    if (_gpxFile.gpxName.isEmpty) {
      return Container(
        width: double.infinity,
        color: const Color(0xFFFFE082), // Warm amber for info state
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: const [
              Icon(Icons.info_outline, size: 20, color: Color(0xFF795548)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'No route loaded. Tap 📂 to import a GPX file.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF795548),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Calculate route stats
    int waypointCount = _gpxFile.wayPoints.length;
    double totalDistance = 0.0;
    for (var wpt in _gpxFile.wayPoints) {
      totalDistance += wpt.distanceToNext;
    }
    double distanceKm = totalDistance / 1000;
    int estimatedMinutes = (distanceKm * 15).round(); // Assume 4 km/h walking speed

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFB2FF59), // Bright green
            const Color(0xFF69F0AE), // Cyan-green
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _gpxFile.gpxName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20), // Dark green for contrast
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '$waypointCount waypoints • ${distanceKm.toStringAsFixed(1)} km • ~$estimatedMinutes min',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF2E7D32), // Medium green for contrast
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onGpxFileLoaded(bool fileLoaded) {
    setState(() {
      _gpxLoaded = fileLoaded;
    });

    if (fileLoaded) {
      // Add null safety check
      final mapState = _mapKey.currentState;
      if (mapState != null) {
        mapState.updateMapMarkerLayer();
      }
      _navigation.findClosestWaypoint();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('GPX file loaded successfully!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
