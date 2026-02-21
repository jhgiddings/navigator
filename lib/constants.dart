import 'package:flutter/material.dart';

/// App-wide constants for consistent styling and configuration
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // ==================== Colors ====================

  /// Primary Brand Colors
  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryGreenLight = Color(0xFF60AD5E);
  static const Color primaryGreenDark = Color(0xFF005005);

  /// Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF2196F3);

  /// Navigation Colors
  static const Color routeColor = Color(0xFFD32F2F); // Red route line
  static const Color waypointColor = Color(0xFF1976D2); // Blue waypoints
  static const Color userLocationColor = Color(0xFFD32F2F); // Red user marker

  /// GPS Status Colors
  static const Color gpsGood = Color(0xFF4CAF50);
  static const Color gpsWeak = Color(0xFFFFC107);
  static const Color gpsNone = Color(0xFFD32F2F);

  /// Neutral Colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);

  // ==================== Spacing ====================

  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ==================== Map Configuration ====================

  static const double mapDefaultZoom = 15.0;
  static const double mapMinZoom = 5.0;
  static const double mapMaxZoom = 19.0;
  static const double mapZoomStep = 1.0;

  static const double routeLineWidth = 8.0;

  // ==================== UI Dimensions ====================

  static const double waypointPanelHeight = 100.0;
  static const double mapToolbarHeight = 40.0;
  static const double statusBarMinHeight = 50.0;

  /// Minimum touch target size for accessibility
  static const double minTouchTarget = 48.0;

  // ==================== Icon Sizes ====================

  static const double iconSizeSm = 16.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 48.0;
  static const double iconSizeMarker = 64.0;
  static const double iconSizeMarkerLarge = 72.0;

  // ==================== Navigation ====================

  /// Location update interval in seconds
  static const int locationUpdateInterval = 5;

  /// Distance threshold for waypoint arrival (meters)
  static const double waypointArrivalThreshold = 20.0;

  /// Minimum GPS accuracy required for reliable navigation (meters)
  static const double minGpsAccuracy = 30.0;

  /// GPS accuracy threshold for "weak" signal (meters)
  static const double weakGpsAccuracy = 20.0;

  // ==================== Typography ====================

  /// Display text (screen titles)
  static const TextStyle displayStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  /// Heading styles
  static const TextStyle h1Style = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle h2Style = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static const TextStyle h3Style = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  /// Body text styles
  static const TextStyle body1Style = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static const TextStyle body2Style = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  /// Navigation instruction styles (optimized for outdoor readability)
  static const TextStyle navDistanceStyle = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.0,
  );

  static const TextStyle navInstructionStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimary,
    height: 1.2,
  );

  /// Caption style
  static const TextStyle captionStyle = TextStyle(
    fontSize: 12,
    color: textSecondary,
  );

  // ==================== Animation Durations ====================

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  // ==================== Timeouts ====================

  static const Duration snackbarDuration = Duration(seconds: 2);
  static const Duration snackbarLongDuration = Duration(seconds: 4);
  static const Duration gpsTimeout = Duration(seconds: 30);

  // ==================== File Types ====================

  static const List<String> allowedFileExtensions = ['gpx'];

  // ==================== Walking Speed Assumptions ====================

  /// Average walking speed in km/h for time estimates
  static const double averageWalkingSpeed = 4.0;

  /// Minutes per kilometer (inverse of walking speed)
  static const double minutesPerKilometer = 15.0;

  // ==================== App Information ====================

  static const String appName = 'AVA Walk Navigator';
  static const String organizationName = 'American Volkssport Association';
  static const String copyrightYear = '2024';
  static const String copyright = '© $copyrightYear $organizationName';

  // ==================== Error Messages ====================

  static const String errorGpxParsing = 'Unable to parse GPX file. Please check the file format.';
  static const String errorFileNotFound = 'File not found. Please try again.';
  static const String errorNoGps = 'GPS signal not available. Please enable location services.';
  static const String errorPermissionDenied = 'Location permission denied. Please enable in settings.';
  static const String errorNoWaypoints = 'No waypoints found in GPX file.';
  static const String errorGeneric = 'An error occurred. Please try again.';

  // ==================== UI Text ====================

  static const String noRouteLoaded = 'No route loaded. Tap 📂 to import a GPX file.';
  static const String loadingGps = 'Acquiring GPS...';
  static const String gpsLocked = 'GPS Locked';
  static const String gpsWeak = 'Weak GPS';
  static const String gpsOff = 'No GPS Signal';
  static const String fileLoadedSuccess = 'GPX file loaded successfully!';
  static const String followRoute = 'Follow the route';
}
