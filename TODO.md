# AVA Walk Navigator - TODO List

**Last Updated:** 2024  
**Project Status:** Functional MVP - Navigation Features Incomplete  
**Priority System:** 🔴 Critical | 🟠 High | 🟡 Medium | 🟢 Low

---

## 🔴 CRITICAL - Must Fix Before Production

### Code Quality & Stability

- [ ] **Remove Duplicate WayPoint Class**
  - **Files:** `lib/waypoint.dart` and `lib/gpx_file.dart`
  - **Action:** Delete `lib/waypoint.dart`, use only the complete implementation in `gpx_file.dart`
  - **Impact:** Prevents confusion and potential bugs from using wrong class
  - **Effort:** 5 minutes

- [ ] **Add Error Handling for File Import**
  - **Location:** `lib/gpx_file.dart` - `importGpxFile()` method
  - **Cases to Handle:**
    - User cancels file picker (currently has empty else block)
    - File read fails (permissions, missing file)
    - XML parsing fails (malformed GPX)
    - Empty waypoint or track point lists
  - **Example:**
    ```dart
    try {
      parseGpxFile(fileContents);
    } catch (e) {
      // Show error dialog to user
      callback(false);
      return;
    }
    ```
  - **Effort:** 2 hours

- [ ] **Fix XML Parsing String Manipulation**
  - **Location:** `lib/gpx_file.dart` - `saveWaypoints()` method
  - **Current Issue:** Using toString() and replaceAll() to extract XML content
  - **Solution:** Use proper XML traversal methods
  ```dart
  // Replace this:
  var desc = node.findElements("desc").toString();
  desc = desc.replaceAll("(<desc>", "");
  
  // With this:
  final descElement = node.getElement("desc");
  final desc = descElement?.innerText ?? "";
  ```
  - **Effort:** 30 minutes

- [ ] **Add Null Safety Guards**
  - **Location:** `lib/home_screen.dart` - line 126
  - **Issue:** Force unwrapping: `_mapKey.currentState!.updateMapMarkerLayer()`
  - **Action:** Add null check or provide fallback
  - **Effort:** 15 minutes

- [ ] **Fix Type Annotations**
  - **Location:** `lib/theme_mode_notifier.dart`
  - **Issue:** `final appBrightness;` has no type
  - **Solution:** Add `ValueNotifier<Brightness>` type
  - **Effort:** 5 minutes

---

## 🟠 HIGH PRIORITY - Core Features

### Complete Navigation System

- [ ] **Implement Location Update Loop**
  - **Location:** `lib/navigation.dart` - `_processLocationUpdate()` method
  - **Tasks:**
    - Uncomment location tracking timer
    - Test GPS update frequency (currently 5 seconds)
    - Implement distance-to-waypoint calculations
    - Add waypoint progression logic
    - Update debug info widget with real data
  - **Dependencies:** Geolocator permissions must be configured
  - **Effort:** 8-12 hours

- [ ] **Complete Waypoint Progression Algorithm**
  - **Location:** `lib/navigation.dart`
  - **Requirements:**
    - Detect when user passes waypoint (distance threshold)
    - Auto-advance to next waypoint
    - Update UI with new instruction
    - Handle last waypoint (route completion)
  - **Algorithm:**
    ```dart
    if (prevDistance < THRESHOLD && currentDistance > prevDistance) {
      // User passed waypoint
      _waypointIndex++;
      if (_waypointIndex >= waypoints.length) {
        // Route completed
      } else {
        _updateWaypoint();
      }
    }
    ```
  - **Effort:** 4-6 hours

- [ ] **Implement Waypoint Instruction Updates**
  - **Location:** `lib/navigation.dart` - `_updateWaypoint()` method
  - **Tasks:**
    - Uncomment and complete icon selection logic
    - Update map state with new waypoint info
    - Trigger UI refresh
    - Update `publicWaypointDescription` for foreground service
  - **Effort:** 2-3 hours

- [ ] **Connect Map State to Navigation Updates**
  - **Location:** `lib/map.dart`
  - **Tasks:**
    - Create method to update waypoint instruction widgets
    - Update `_distCurrentLocToWaypoint` with real data
    - Update `_waypointIcon`, `_waypointDescription`
    - Refresh debug info panel
  - **Effort:** 2-4 hours

### Audio Navigation

- [ ] **Implement Text-to-Speech**
  - **Package:** Add `flutter_tts` to `pubspec.yaml`
  - **Location:** New file `lib/audio_guidance.dart`
  - **Features:**
    - Distance callouts (500m, 200m, 100m, 50m)
    - Turn announcements at waypoints
    - Volume control
    - Language selection
  - **UI Connection:** Connect to audio toggle button in `home_screen.dart`
  - **Effort:** 6-8 hours

- [ ] **Add Audio Preferences**
  - **Location:** `lib/screens/settings.dart`
  - **Options:**
    - Enable/disable audio
    - Distance units (meters/feet)
    - Announcement frequency
    - Voice selection
  - **Persistence:** Use `shared_preferences` package
  - **Effort:** 3-4 hours

### Build Out Instruction View

- [ ] **Create Instruction List Widget**
  - **Location:** New file `lib/instruction_list.dart`
  - **Replace:** Placeholder text in `home_screen.dart` TabBarView
  - **Features:**
    - ListView of all waypoints
    - Show distance to each
    - Highlight current target
    - Tap to preview waypoint on map
    - Show direction icon for each turn
  - **Effort:** 4-6 hours

---

## 🟠 HIGH PRIORITY - UI/UX Improvements

### Critical User Experience Issues

- [ ] **Fix Non-Functional UI Elements**
  - **Problem:** Buttons suggest functionality that doesn't exist (audio, navigation start)
  - **Impact:** Violates user trust, creates confusion
  - **Solution Options:**
    1. Remove buttons until features are implemented
    2. Disable buttons with tooltip explaining "Coming Soon"
    3. Implement basic functionality
  - **Location:** `lib/home_screen.dart` - AppBar actions
  - **Effort:** 1 hour (disable) or implement per feature

- [ ] **Add GPS Status Indicator**
  - **Problem:** Users can't see if GPS is working or signal quality
  - **Solution:** Add status icon in AppBar showing:
    - 🔴 No GPS signal
    - 🟡 Acquiring GPS
    - 🟢 GPS locked (with accuracy indicator)
  - **Location:** `lib/home_screen.dart` - AppBar
  - **Implementation:**
    ```dart
    StreamBuilder<Position>(
      stream: Geolocator.getPositionStream(),
      builder: (context, snapshot) {
        return Icon(
          snapshot.hasData ? Icons.gps_fixed : Icons.gps_not_fixed,
          color: snapshot.hasData ? Colors.green : Colors.red,
        );
      },
    )
    ```
  - **Effort:** 2-3 hours

- [ ] **Improve Waypoint Instruction Visibility**
  - **Problem:** Bottom panel is small (45px), hard to read while walking
  - **Solution:** Make instruction panel larger and more prominent
    - Increase height to 80-100px
    - Larger text (24-28px for distance, 18-20px for description)
    - High contrast colors
    - Consider card with elevation/shadow
  - **Location:** `lib/map.dart` - waypoint widgets
  - **Effort:** 2 hours

- [ ] **Add Visual Progress Indicator**
  - **Problem:** Users don't know how far through route they are
  - **Solution:** Add progress bar showing:
    - Current waypoint / Total waypoints
    - Percentage complete
    - Distance remaining
  - **Location:** Status bar in `lib/home_screen.dart`
  - **Mockup:**
    ```
    ┌────────────────────────────────┐
    │ Waypoint 5 of 23 (22%)         │
    │ [████████░░░░░░░░░░░░░░░░] 2.3km│
    └────────────────────────────────┘
    ```
  - **Effort:** 3-4 hours

### Navigation & Information Architecture

- [ ] **Redesign Tab Structure**
  - **Problem:** Two tabs but second is empty, unclear purpose
  - **Solution:** Either:
    1. Remove tabs, use FAB for instruction list
    2. Make second tab useful (list view, stats, POIs)
    3. Add third tab for statistics/progress
  - **Recommendation:** Option 1 (cleaner) or Option 2 (more features)
  - **Effort:** 2-3 hours

- [ ] **Add Onboarding Flow**
  - **Problem:** New users don't know how to get started
  - **Solution:** First-time user tutorial showing:
    - Where to get GPX files
    - How to import
    - How to start navigation
    - Key features overview
  - **Package:** `introduction_screen` or custom PageView
  - **Location:** New file `lib/onboarding.dart`
  - **Effort:** 6-8 hours

- [ ] **Improve File Import UX**
  - **Problem:** File picker doesn't show GPX files prominently
  - **Solution:** 
    - Filter to show only .gpx files
    - Show file metadata (waypoint count, distance)
    - Recent files list
    - Sample route to try
  - **Location:** `lib/gpx_file.dart`
  - **Effort:** 4-6 hours

### Visual Design & Branding

- [ ] **Create Consistent Color Palette**
  - **Current:** Using default Colors.green, Colors.red inconsistently
  - **Solution:** Define theme colors in MaterialApp
    ```dart
    theme: ThemeData(
      primaryColor: Color(0xFF2E7D32), // AVA green
      secondaryColor: Color(0xFF66BB6A),
      errorColor: Color(0xFFD32F2F),
      backgroundColor: Color(0xFFF5F5F5),
      // ... semantic colors for GPS states, waypoints, etc.
    )
    ```
  - **Also define:** Success, warning, info colors
  - **Location:** `lib/main.dart`
  - **Effort:** 2-3 hours

- [ ] **Improve Status Bar Colors**
  - **Problem:** Pure red for "no file" is too aggressive, low contrast text
  - **Solution:**
    - Use warning orange/yellow instead of red
    - Ensure WCAG AA contrast (4.5:1 minimum)
    - Add icon to reinforce message
    - Consider dismissible banner instead of fixed bar
  - **Location:** `lib/home_screen.dart`
  - **Effort:** 1 hour

- [ ] **Add Empty State Illustrations**
  - **Problem:** When no GPX is loaded, just shows red bar
  - **Solution:** Show friendly empty state:
    - Illustration or icon
    - "No route loaded" heading
    - "Tap the 📂 icon to import a GPX file" instruction
    - "Need help?" link to documentation
  - **Package:** Use `flutter_svg` for illustrations
  - **Effort:** 3-4 hours

- [ ] **Redesign Waypoint Markers**
  - **Problem:** Black arrows on map hard to see, no differentiation
  - **Solution:**
    - Use color-coded markers (start=green, middle=blue, end=red)
    - Larger icons (72-80px instead of 64px)
    - Add drop shadow for visibility
    - Number markers (1, 2, 3...) for clarity
  - **Location:** `lib/map.dart` - `updateMapMarkerLayer()`
  - **Effort:** 4-5 hours

### Map Interaction & Usability

- [ ] **Add Map Legend**
  - **Problem:** Users don't know what markers/colors mean
  - **Solution:** Floating legend card showing:
    - Red arrow = Your location
    - Blue arrows = Waypoints
    - Red line = Route path
    - Collapsible to save space
  - **Location:** `lib/map.dart` - Stack overlay
  - **Effort:** 2-3 hours

- [ ] **Implement Map Gesture Improvements**
  - **Problem:** Map controls may conflict with OSM default controls
  - **Solution:**
    - Remove redundant toolbar buttons
    - Use floating action buttons for key actions
    - Add zoom level indicator
    - Add compass rose
    - Enable rotation gesture
  - **Effort:** 3-4 hours

- [ ] **Add "Recenter on Location" Auto-follow**
  - **Problem:** Map doesn't stay centered during navigation
  - **Solution:**
    - Toggle button for "follow mode"
    - Auto-center when navigation starts
    - Rotate map to heading direction
    - Disable when user manually pans
  - **Effort:** 4-5 hours

- [ ] **Add Distance Markers on Route**
  - **Problem:** No sense of scale on map
  - **Solution:** 
    - Show distance markers every 0.5km
    - Add elevation profile (if available in GPX)
    - Show estimated time markers
  - **Effort:** 6-8 hours

### Accessibility

- [ ] **Add Semantic Labels for Screen Readers**
  - **Problem:** Not accessible to visually impaired users
  - **Solution:** Add Semantics widgets wrapping:
    - All buttons (with clear labels)
    - Status indicators
    - Distance/direction info
  - **Test:** With TalkBack (Android) and VoiceOver (iOS)
  - **Effort:** 3-4 hours

- [ ] **Implement Minimum Touch Targets**
  - **Problem:** Some buttons may be too small (< 48dp)
  - **Solution:** Ensure all interactive elements are 48x48dp minimum
  - **Check:** AppBar icons, map controls, waypoint tap areas
  - **Effort:** 2 hours

- [ ] **Add High Contrast Mode Support**
  - **Problem:** Low contrast in bright sunlight
  - **Solution:**
    - Detect system high contrast setting
    - Provide manual toggle in settings
    - Increase all contrast ratios
    - Bolder borders and separators
  - **Effort:** 4-5 hours

- [ ] **Support Dynamic Text Sizing**
  - **Problem:** Fixed font sizes don't respect user accessibility settings
  - **Solution:** Use `MediaQuery.of(context).textScaleFactor`
  - **Test:** With device text size set to largest
  - **Effort:** 2-3 hours

---

## 🟡 MEDIUM PRIORITY - Polish & UX

### Code Cleanup

- [ ] **Remove Commented Code**
  - **Files:**
    - `lib/navigation.dart` (~100 lines)
    - `lib/map.dart` (~50 lines)
    - `lib/background.dart` (entire file is commented)
  - **Decision Required:** Determine if background service is planned
    - If YES: Move to feature branch
    - If NO: Delete the file
  - **Effort:** 1-2 hours

- [ ] **Extract Magic Numbers to Constants**
  - **Create:** `lib/constants.dart`
  - **Move:**
    ```dart
    // Map Configuration
    const double kDefaultZoom = 15.0;
    const double kMinZoom = 5.0;
    const double kMaxZoom = 19.0;
    const double kZoomStep = 1.0;
    
    // UI Dimensions
    const double kWaypointContainerHeight = 45.0;
    const double kMapToolbarHeight = 40.0;
    
    // Navigation
    const int kLocationUpdateInterval = 5; // seconds
    const double kWaypointArrivalThreshold = 20.0; // meters
    
    // Colors
    const Color kPrimaryGreen = Colors.green;
    const Color kRouteColor = Colors.red;
    const double kRouteWidth = 8.0;
    ```
  - **Effort:** 1 hour

- [ ] **Extract Strings for Localization**
  - **Create:** `lib/strings.dart` or use `flutter_localizations`
  - **Extract:** All user-facing strings
  - **Benefit:** Easier to add multiple languages later
  - **Effort:** 2-3 hours

- [ ] **Remove Unused Imports and Variables**
  - **Scan for:**
    - `import 'dart:ui'` (unused in several files)
    - `publicWaypointDescription` global variable
    - `towardDestination` boolean in Navigation
    - `_audioOn` in HomeScreen (if not implementing audio)
  - **Tool:** Use IDE warnings or `dart analyze`
  - **Effort:** 30 minutes

### Error Handling & Edge Cases

- [ ] **Add Loading Indicators**
  - **Locations:**
    - During GPX file parsing
    - During map initialization
    - During waypoint calculation
  - **Implementation:** Use CircularProgressIndicator with overlay
  - **Effort:** 2 hours

- [ ] **Handle Empty Waypoint Lists**
  - **Location:** `lib/navigation.dart` - `findClosestWaypoint()`
  - **Add Check:**
    ```dart
    if (gpxFile.wayPoints.isEmpty) {
      // Show error: "No waypoints found in GPX file"
      return;
    }
    ```
  - **Effort:** 30 minutes

- [ ] **Add Location Permission Handling**
  - **Check:** Permissions before starting navigation
  - **Handle:**
    - Permission denied
    - Location services disabled
    - Permission permanently denied
  - **UI:** Show helpful error messages with instructions
  - **Effort:** 2-3 hours

- [ ] **Handle GPS Signal Loss**
  - **Detect:** No location updates for X seconds
  - **UI:** Show warning banner
  - **Behavior:** Maintain last known waypoint
  - **Effort:** 2 hours

### User Experience Improvements

- [ ] **Add Route Summary Before Starting**
  - **Show:**
    - Total distance
    - Number of waypoints
    - Estimated duration (based on walking speed)
    - Starting point
  - **Location:** Dialog after GPX loads
  - **Effort:** 3-4 hours

- [ ] **Improve Status Bar Feedback**
  - **Current:** Shows filename or "Load GPX file" message
  - **Enhance:** 
    - Show current waypoint number (e.g., "Waypoint 5 of 23")
    - Show distance remaining
    - Show progress percentage
  - **Effort:** 2 hours

- [ ] **Add "My Location" Button Functionality**
  - **Location:** `lib/map.dart` - Map tools AppBar
  - **Current:** Button exists but does nothing
  - **Action:** Center map on user's current location
  - **Effort:** 30 minutes

- [ ] **Implement Route Completion Celebration**
  - **Trigger:** When user reaches final waypoint
  - **Show:**
    - Completion dialog with stats
    - Total time
    - Total distance
    - Average pace
  - **Offer:** Share achievement, save GPX of actual route
  - **Effort:** 4-5 hours

### Settings Screen Enhancements

- [ ] **Expand Settings with Navigation Preferences**
  - **Current:** Only dark mode toggle (non-functional)
  - **Add Sections:**
    - **Units:** Metric/Imperial toggle
    - **Navigation:** 
      - Waypoint arrival distance (10m, 20m, 50m)
      - Auto-advance waypoints (on/off)
      - Keep screen on during navigation
    - **Audio:**
      - Enable/disable voice guidance
      - Voice gender/language selection
      - Announcement frequency
    - **Map:**
      - Map style (standard, satellite, terrain)
      - Show POIs on/off
      - Auto-follow mode default
    - **Privacy:**
      - Save location history (on/off)
      - Anonymous usage statistics
  - **Design:** Group settings with section headers and dividers
  - **Location:** `lib/screens/settings.dart`
  - **Effort:** 8-10 hours

- [ ] **Add Settings Search/Filter**
  - **For:** When settings list grows
  - **Implementation:** TextField at top filtering setting titles
  - **Effort:** 2-3 hours

### Help Screen Improvements

- [ ] **Add Visual Aids to Help Content**
  - **Problem:** Text-only instructions are hard to follow
  - **Solution:**
    - Add screenshots for each step
    - Annotate images with arrows/callouts
    - Video tutorial links (if available)
    - Interactive demo mode
  - **Location:** `lib/screens/help.dart`
  - **Effort:** 6-8 hours

- [ ] **Make Help Content Collapsible**
  - **Problem:** Long scrolling list, hard to find specific topics
  - **Solution:** Use ExpansionTile widgets for each section
  - **Sections:**
    - Getting Started (expanded by default)
    - Importing GPX Files
    - During Navigation
    - Troubleshooting
    - FAQ
  - **Effort:** 2-3 hours

- [ ] **Add Context-Sensitive Help**
  - **Feature:** "?" button on each screen linking to relevant help section
  - **Implementation:** Deep links into help screen
  - **Effort:** 3-4 hours

### Information Screen Updates

- [ ] **Make Package List Dynamic**
  - **Problem:** Hardcoded and outdated package versions
  - **Solution:** 
    - Read from pubspec.yaml programmatically
    - Show licenses (required by Flutter)
    - Link to package documentation
  - **Package:** Use built-in `LicensePage` or `showLicensePage()`
  - **Effort:** 2-3 hours

- [ ] **Add Support & Feedback Links**
  - **Add:**
    - Website URL (AVA organization)
    - Support email
    - Report bug link
    - Feature request link
    - Privacy policy link
    - Terms of service
  - **Implementation:** Use `url_launcher` package
  - **Effort:** 2 hours

### Drawer Menu Refinements

- [ ] **Improve Menu Icons**
  - **Current:** Generic icons (settings, help, info)
  - **Solution:**
    - More specific icons (tune for settings, help_outline for help)
    - Add dividers between sections
    - Add user profile section (if accounts added)
  - **Effort:** 1 hour

- [ ] **Add Quick Actions to Drawer**
  - **Add:**
    - Recent routes (last 3-5 loaded GPX files)
    - Quick settings toggles (units, audio)
    - "Rate this app" link
  - **Location:** `lib/drawer.dart`
  - **Effort:** 4-5 hours

### Feedback & Confirmation Patterns

- [ ] **Add Haptic Feedback**
  - **Use Cases:**
    - Button presses
    - Waypoint arrival
    - Route completion
    - Errors/warnings
  - **Package:** Use `HapticFeedback` from Flutter
  - **Implementation:**
    ```dart
    HapticFeedback.lightImpact(); // For button taps
    HapticFeedback.heavyImpact(); // For waypoint arrival
    ```
  - **Settings:** Add toggle to disable
  - **Effort:** 2-3 hours

- [ ] **Implement Snackbar Notifications**
  - **Current:** No user feedback for many actions
  - **Add for:**
    - GPX file loaded successfully
    - Navigation started/stopped
    - Waypoint reached
    - GPS signal acquired/lost
    - Errors (with action buttons)
  - **Design:** Use Material Design snackbar patterns
  - **Effort:** 2-3 hours

- [ ] **Add Confirmation Dialogs**
  - **For destructive actions:**
    - Loading new GPX (if one already loaded)
    - Stopping navigation mid-route
    - Clearing saved preferences
  - **Follow:** Material Design dialog patterns
  - **Effort:** 2 hours

### Animation & Transitions

- [ ] **Add Loading Animations**
  - **Replace:** Static CircularProgressIndicator
  - **With:** 
    - Skeleton screens for map loading
    - Progress animation for GPX parsing
    - Animated route drawing on map
  - **Package:** `shimmer` for skeleton screens
  - **Effort:** 4-5 hours

- [ ] **Animate Waypoint Transitions**
  - **Feature:** Smooth animation when advancing waypoints
  - **Include:**
    - Fade out old instruction
    - Slide in new instruction
    - Map camera pan to next waypoint
    - Celebration micro-animation
  - **Effort:** 3-4 hours

- [ ] **Add Pull-to-Refresh**
  - **Location:** Map screen
  - **Action:** Reload current GPS position, recalculate closest waypoint
  - **Effort:** 1-2 hours

### Typography & Readability

- [ ] **Implement Typography Scale**
  - **Problem:** Inconsistent text sizes and weights
  - **Solution:** Define clear hierarchy
    ```dart
    headline1: 32sp, bold (screen titles)
    headline2: 24sp, bold (section headers)
    body1: 16sp, regular (body text)
    body2: 14sp, regular (secondary text)
    caption: 12sp, regular (labels)
    ```
  - **Apply:** Consistently across all screens
  - **Effort:** 3-4 hours

- [ ] **Optimize for Outdoor Readability**
  - **Problem:** Hard to read in bright sunlight
  - **Solution:**
    - Use extra bold fonts for critical info
    - High contrast color combinations
    - Larger text for map instructions
    - Optional "outdoor mode" with maximum contrast
  - **Effort:** 4-5 hours

### Layout & Spacing

- [ ] **Implement Consistent Padding/Margins**
  - **Define:** Spacing scale (4, 8, 16, 24, 32, 48)
  - **Use:** Consistently throughout app
  - **Create:** `lib/constants.dart` with spacing constants
  - **Effort:** 2-3 hours

- [ ] **Add Responsive Layouts**
  - **Problem:** May not look good on tablets or landscape
  - **Solution:**
    - Use LayoutBuilder for responsive breakpoints
    - Different layouts for portrait/landscape
    - Utilize tablet screen space better
  - **Effort:** 6-8 hours

---

## 🟢 LOW PRIORITY - Nice to Have

### Performance Optimization

- [ ] **Implement Marker Culling**
  - **Problem:** All waypoints rendered even if off-screen
  - **Solution:** Only render markers in viewport + buffer
  - **Location:** `lib/map.dart` - `updateMapMarkerLayer()`
  - **Benefit:** Better performance for 100+ waypoint routes
  - **Effort:** 4-6 hours

- [ ] **Move GPX Parsing to Isolate**
  - **Problem:** Large files block UI thread
  - **Solution:** Use `compute()` or Isolate for parsing
  - **Location:** `lib/gpx_file.dart`
  - **Benefit:** Smooth UI during file load
  - **Effort:** 3-4 hours

- [ ] **Implement Progressive Loading**
  - **For:** Very long routes (1000+ points)
  - **Strategy:** Load waypoints first, then stream track points
  - **UI:** Show progress indicator
  - **Effort:** 6-8 hours

### Feature Enhancements

- [ ] **Add Route Library**
  - **Feature:** Save and manage multiple GPX files
  - **Storage:** SQLite or Hive database
  - **UI:** List screen to browse saved routes
  - **Effort:** 12-16 hours

- [ ] **Offline Map Caching**
  - **Package:** Research OSM tile caching options
  - **Feature:** Download map tiles for offline use
  - **UI:** Settings to manage cache size
  - **Effort:** 16-20 hours

- [ ] **Record Actual Route**
  - **Feature:** Track user's actual path
  - **Output:** Generate GPX file of completed walk
  - **Comparison:** Show deviation from planned route
  - **Effort:** 8-12 hours

- [ ] **Points of Interest**
  - **Feature:** Show landmarks/POIs on map
  - **Data:** Parse GPX `<wpt>` descriptions
  - **UI:** Tap marker to see info
  - **Effort:** 6-8 hours

- [ ] **Dark Mode Full Implementation**
  - **Current:** Toggle exists in settings but doesn't work
  - **Fix:** Connect to ThemeModeNotifier
  - **Add:** Manual override (Light/Dark/Auto)
  - **Design:** Optimize dark theme specifically for outdoor use
  - **Effort:** 2-3 hours

- [ ] **Connect Settings to App Behavior**
  - **Current:** Settings are saved but not applied
  - **Add:** Persistent storage with `shared_preferences`
  - **Apply:** Load settings on app startup
  - **Effort:** 3-4 hours

### Advanced UI Features

- [ ] **Add Map Style Picker**
  - **Options:**
    - Standard (current)
    - Satellite
    - Terrain
    - High contrast
  - **UI:** FAB with menu or bottom sheet selector
  - **Effort:** 4-6 hours

- [ ] **Implement 3D View Mode**
  - **Feature:** Tilt map to show 3D perspective
  - **Useful for:** Understanding terrain and elevation
  - **Requirements:** Check OSM plugin capabilities
  - **Effort:** 8-12 hours (if supported)

- [ ] **Add Weather Overlay**
  - **Show:** Current weather conditions on map
  - **API:** OpenWeatherMap or similar
  - **Display:** Temperature, precipitation, wind
  - **Effort:** 8-10 hours

- [ ] **Create Widget for Home Screen**
  - **Platform:** Android (iOS via WidgetKit)
  - **Show:** 
    - Next upcoming walk/event
    - Quick start last route
    - Walk statistics
  - **Effort:** 12-16 hours

### Gamification & Motivation

- [ ] **Add Achievement System**
  - **Achievements:**
    - First walk completed
    - 10 walks completed
    - 100km total distance
    - Night owl (walk after 8pm)
    - Early bird (walk before 7am)
  - **Display:** Badge collection screen
  - **Effort:** 10-12 hours

- [ ] **Create Statistics Dashboard**
  - **Show:**
    - Total walks completed
    - Total distance walked
    - Total time active
    - Longest walk
    - Most challenging route
    - Charts and graphs
  - **New screen:** Statistics tab or separate screen
  - **Effort:** 12-16 hours

- [ ] **Add Walking Streaks**
  - **Feature:** Track consecutive days/weeks of walking
  - **Motivation:** "Don't break the streak!" notifications
  - **Effort:** 6-8 hours

### Testing

- [ ] **Write Unit Tests**
  - **Coverage:**
    - GPX parsing logic (happy path and errors)
    - Distance calculations
    - Bearing calculations
    - Waypoint selection algorithm
    - Coordinate conversions
  - **Goal:** 70%+ code coverage
  - **Effort:** 12-16 hours

- [ ] **Write Widget Tests**
  - **Test:**
    - HomeScreen initialization
    - Map marker rendering
    - Theme switching
    - Drawer navigation
    - Settings toggles
  - **Effort:** 8-12 hours

- [ ] **Create Integration Tests**
  - **Scenarios:**
    - Complete GPX import flow
    - Full navigation session
    - Error recovery
  - **Effort:** 8-12 hours

- [ ] **Field Testing**
  - **Requirements:**
    - Test on actual walking trails
    - Multiple GPX file formats
    - Various route lengths (short, medium, long)
    - Different devices (Android/iOS, various screen sizes)
  - **Document:** Bugs and UX issues
  - **Effort:** 20+ hours

---

## 📋 Pre-Launch Checklist

### Code Quality
- [ ] All commented code removed or documented
- [ ] No lint warnings or errors
- [ ] All TODOs in code addressed
- [ ] Duplicate code eliminated
- [ ] Proper error handling throughout

### Features
- [ ] GPX import works reliably
- [ ] Navigation loop functional
- [ ] Waypoint progression tested
- [ ] Audio guidance working (if implemented)
- [ ] Settings persist correctly

### Testing
- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Field tested on real routes
- [ ] Tested with 10+ waypoint routes
- [ ] Tested with 100+ waypoint routes
- [ ] Tested with malformed GPX files
- [ ] Tested location permission scenarios
- [ ] Tested GPS signal loss scenarios
- [ ] Tested low battery scenarios
- [ ] Tested background/foreground transitions

### Assets & Branding
- [ ] App icon created (all sizes)
- [ ] Splash screen designed
- [ ] Screenshots for app stores captured
- [ ] Marketing description written
- [ ] Privacy policy created (if needed)

### Platform Configuration
- [ ] Android signing keys configured
- [ ] iOS certificates configured
- [ ] App Store metadata complete
- [ ] Google Play metadata complete
- [ ] Required permissions documented
- [ ] Age rating determined

### Analytics & Monitoring
- [ ] Crash reporting configured (Firebase Crashlytics?)
- [ ] Analytics configured (optional)
- [ ] Error logging strategy defined

---

## 🎯 Recommended Implementation Order

### Phase 1: Stabilization (Week 1)
1. Remove duplicate WayPoint class
2. Fix XML parsing
3. Add error handling for file import
4. Remove commented code
5. Extract constants and strings

**Deliverable:** Clean, stable codebase

### Phase 2: Core Navigation (Week 2-3)
1. Implement location update loop
2. Complete waypoint progression
3. Connect navigation to map UI
4. Add loading indicators
5. Field test basic navigation

**Deliverable:** Working turn-by-turn navigation

### Phase 3: Polish (Week 4)
1. Build instruction list view
2. Add route summary
3. Implement completion celebration
4. Improve status bar
5. Add location permission handling

**Deliverable:** Production-ready MVP

### Phase 4: Enhancements (Post-Launch)
1. Audio guidance (high user value)
2. Route library
3. Performance optimizations
4. Advanced features

**Deliverable:** Feature-complete v2.0

---

## 📊 Effort Estimates

### Critical Issues
- **Total:** 4-6 hours
- **Impact:** Prevent crashes and data loss

### Core Navigation Features  
- **Total:** 30-40 hours
- **Impact:** Makes app actually useful

### Polish & UX
- **Total:** 20-30 hours  
- **Impact:** Professional user experience

### Testing
- **Total:** 30-40 hours
- **Impact:** Confidence in reliability

### **Grand Total: 84-116 hours (2-3 weeks full-time)**

---

## 🐛 Known Bugs

1. **Settings dark mode toggle doesn't work**
   - Toggle state changes but theme doesn't update
   - Need to connect to ThemeModeNotifier

2. **Audio button shows state but does nothing**
   - Visual feedback without functionality confuses users
   - Either implement or remove

3. **Navigation button shows state but does nothing**
   - Same issue as audio button
   - Remove or implement

4. **Debug info panel always shows placeholder**
   - Should show real GPS data
   - Currently hardcoded string

5. **Second tab is empty**
   - Shows "Instruction View" placeholder
   - Should show waypoint list

---

## 💡 Future Considerations

### Monetization (If Applicable)
- Premium features (offline maps, advanced stats)
- Ad-supported free version
- One-time purchase vs subscription

### Social Features
- Share routes with friends
- Community route library
- Completed walks tracking
- Achievements/badges

### Wearable Support
- Apple Watch app
- Wear OS app
- Haptic feedback for turns

### Accessibility
- VoiceOver support
- TalkBack support
- High contrast mode
- Larger text options
- Haptic feedback for visual alternatives

### International Support
- Multiple languages
- Metric/Imperial units
- Different map styles
- Regional walking event integration

---

## 📝 Notes

- **Development Environment:** Ensure Flutter SDK is up to date
- **Testing Devices:** Need both Android and iOS devices for testing
- **AVA Coordination:** May need input from AVA on desired features
- **Beta Testing:** Consider TestFlight (iOS) and Play Store beta (Android)
- **Documentation:** Update README with actual usage instructions

---

## 🎨 UI/UX Design System Checklist

### Visual Design Foundation
- [ ] Define complete color palette with semantic colors
- [ ] Create typography scale and apply consistently
- [ ] Define spacing/padding system (4, 8, 16, 24, 32, 48)
- [ ] Design icon set (custom or from single family)
- [ ] Create loading states for all async operations
- [ ] Design error states with helpful messages and actions
- [ ] Design empty states with illustrations and CTAs

### Component Library
- [ ] Standardize button styles (primary, secondary, text)
- [ ] Standardize card components
- [ ] Standardize dialog patterns
- [ ] Standardize form inputs
- [ ] Create reusable bottom sheets
- [ ] Create reusable app bars with consistent structure

### Interaction Patterns
- [ ] Define haptic feedback strategy
- [ ] Define animation durations and curves
- [ ] Define loading patterns (skeleton, spinner, progress)
- [ ] Define transition patterns between screens
- [ ] Define gesture patterns (swipe, long-press)

### Accessibility Standards
- [ ] All interactive elements ≥48x48dp
- [ ] All text contrast ratio ≥4.5:1 (WCAG AA)
- [ ] All images have semantic descriptions
- [ ] All screens navigable via keyboard/screen reader
- [ ] All time-based content has alternatives
- [ ] Color is never sole means of conveying information

### User Testing Scenarios
- [ ] First-time user completes full flow (GPX import → navigation)
- [ ] User navigates route in bright sunlight (readability test)
- [ ] User navigates route while walking (usability test)
- [ ] User recovers from errors (GPS loss, wrong turn)
- [ ] User accesses help when confused
- [ ] Power user tests advanced features
- [ ] Accessibility user tests with screen reader

---

## 📊 Updated Effort Estimates

### Critical Issues
- **Total:** 4-6 hours (unchanged)
- **Impact:** Prevent crashes and data loss

### Core Navigation Features  
- **Total:** 30-40 hours (unchanged)
- **Impact:** Makes app actually useful

### UI/UX Improvements (NEW)
- **High Priority:** 60-80 hours
- **Medium Priority:** 40-60 hours
- **Low Priority:** 60-80 hours
- **Impact:** Professional, usable, delightful experience

### Polish & UX (Original)
- **Total:** 20-30 hours  
- **Impact:** Professional user experience

### Testing
- **Total:** 30-40 hours
- **Impact:** Confidence in reliability

### **New Grand Total: 244-336 hours (6-8 weeks full-time)**

**Note:** Original estimate was 84-116 hours. Adding comprehensive UI/UX improvements roughly triples the effort but results in a significantly better product.

### Recommended Phased Approach:

**Phase 1: MVP Stability (Week 1-2)** - 40-50 hours
- Code cleanup
- Core navigation
- Critical UI fixes (GPS indicator, non-functional buttons)

**Phase 2: Usable Product (Week 3-4)** - 60-80 hours  
- High priority UI/UX improvements
- Essential accessibility features
- Key user feedback mechanisms

**Phase 3: Professional Release (Week 5-6)** - 60-80 hours
- Medium priority polish
- Complete settings functionality
- Help content with visuals
- Field testing and refinement

**Phase 4: Enhanced Experience (Post-launch)** - 80-120 hours
- Low priority features
- Advanced UI features
- Gamification
- Platform-specific optimizations

---

**Status Legend:**
- ✅ Complete
- 🚧 In Progress  
- ⏸️ Blocked
- ❌ Not Started

**Priority can shift based on:**
- User feedback
- AVA requirements
- Technical discoveries
- Time constraints
- Usability testing results
- Accessibility audit findings