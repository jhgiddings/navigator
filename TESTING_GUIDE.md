# Testing Guide for AVA Walk Navigator (Zed Editor)

**Editor:** Zed  
**Project:** AVA Walk Navigator  
**Platform:** Flutter (iOS & Android)

---

## 🚀 Quick Start - Testing in Zed

### Method 1: Run from Zed Terminal (Recommended)

1. **Open Zed Terminal**
   - In Zed: `View` → `Terminal` or press `` Ctrl+` ``
   - Or use `Terminal: Toggle` command palette

2. **Navigate to project**
   ```bash
   cd C:\Users\Jeff\Websites\navigator
   ```

3. **Run the app**
   ```bash
   # For connected device/emulator
   flutter run
   
   # For specific device
   flutter run -d <device-id>
   
   # For Chrome (web testing)
   flutter run -d chrome
   ```

---

## 📱 Testing Options

### Option 1: Android Emulator

**Start Emulator:**
```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_name>

# Then run app
flutter run
```

### Option 2: Physical Device (USB)

**Android:**
1. Enable Developer Options on phone
2. Enable USB Debugging
3. Connect via USB
4. Run: `flutter run`

**iOS:**
1. Connect iPhone via USB
2. Trust computer on device
3. Run: `flutter run`

### Option 3: Web Browser (Quick Testing)

```bash
flutter run -d chrome
```
*Note: GPS features won't work in browser, but UI can be tested*

---

## 🔍 Check Device Connection

```bash
# See all connected devices
flutter devices

# Output example:
# Chrome (web) • chrome • web-javascript • Google Chrome 120.0.6099.109
# Android SDK built for x86 (mobile) • emulator-5554 • android-x86 • Android 13 (API 33)
```

---

## 🧪 Testing the Critical Fixes

### 1. Test GPS Status Indicator

**What to Check:**
- App bar shows GPS icon (📡)
- Icon color changes based on GPS status:
  - 🟠 Orange = Acquiring GPS or Weak signal
  - 🔴 Red = No GPS signal
  - 🟢 Green = GPS locked
- Tap icon shows tooltip with accuracy in meters

**How to Test:**
```bash
flutter run
# Wait for app to load
# Check top-right of app bar for GPS indicator
# Tap it to see accuracy details
```

### 2. Test GPX File Import

**What to Check:**
- Import button works (📂 icon)
- File picker opens
- Can select .gpx files
- Success message shows: "GPX file loaded successfully!"
- Status bar shows route info: "23 waypoints • 5.2 km • ~90 min"

**How to Test:**
```bash
# You'll need a sample GPX file
# Download one from: https://www.topografix.com/fells_loop.gpx
# Save to your device's Downloads folder

flutter run
# Tap 📂 icon in app bar
# Select a GPX file
# Verify success message appears
# Check status bar shows route statistics
```

### 3. Test Error Handling

**What to Check:**
- Canceling file picker doesn't crash
- Invalid file shows error dialog
- Error dialog has "OK" and "Try Again" buttons

**How to Test:**
```bash
flutter run
# Tap 📂 icon
# Cancel file picker → Should handle gracefully
# Try to import non-GPX file → Should show error
# Try to import malformed GPX → Should show error with recovery option
```

### 4. Test Waypoint Panel Visibility

**What to Check:**
- Bottom panel is 100px tall (not 45px)
- Distance text is large (36px) and bold
- Description text is readable (24px)
- Panel has drop shadow

**How to Test:**
```bash
flutter run
# Load a GPX file
# Check bottom waypoint instruction panel
# Text should be easily readable
# Panel should be noticeably larger than before
```

### 5. Test Map Display

**What to Check:**
- Map loads and displays
- User location shows (red navigation icon)
- Waypoint markers appear after GPX load
- Route line draws in red
- No debug panel visible
- No toolbar above map (just OSM built-in controls)

**How to Test:**
```bash
flutter run
# Wait for map to load
# Verify no debug text panel
# Load GPX file
# Verify route and markers appear
```

---

## 🐛 Hot Reload (Make Changes While Running)

**In Zed Terminal while app is running:**
```bash
# After making code changes:
r = Hot reload (fast, preserves state)
R = Hot restart (slower, resets state)
q = Quit
```

**Example Workflow:**
1. Run: `flutter run`
2. Make a change in Zed (e.g., change text color)
3. Save file in Zed
4. Press `r` in terminal
5. Changes appear instantly!

---

## 📊 Run Tests

### Unit Tests
```bash
flutter test
```

### Specific Test File
```bash
flutter test test/widget_test.dart
```

### With Coverage
```bash
flutter test --coverage
```

---

## 🔧 Debugging in Zed

### Check for Errors
```bash
# Analyze code for issues
flutter analyze

# Should show: "No issues found!"
```

### View Logs
```bash
# Run with verbose logging
flutter run -v

# Or with debug info
flutter run --debug
```

### Clear Build Cache (if issues)
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📱 Testing Specific Features

### GPS Status Indicator
```bash
# Test on real device (emulator won't have GPS)
flutter run -d <device-id>

# Scenarios to test:
# 1. Start app indoors → Should show acquiring/no GPS
# 2. Go near window → Should show weak/acquiring
# 3. Go outside → Should show GPS locked with accuracy
# 4. Tap indicator → Should show snackbar with details
```

### Status Bar Information
```bash
flutter run

# Test scenarios:
# 1. No GPX loaded → Orange bar with info icon
# 2. Load GPX → Green bar with route stats
# 3. Verify waypoint count is correct
# 4. Verify distance calculation (sum of waypoint distances)
# 5. Verify time estimate (distance * 15 min/km)
```

### Error Handling
```bash
flutter run

# Create test files:
# 1. Empty file → Should show error
# 2. Text file renamed to .gpx → Should show parsing error
# 3. GPX with no waypoints → Should show "no waypoints" error
# 4. GPX with no track → Should handle gracefully
```

---

## 🎯 Testing Checklist

### Before Committing Changes
- [ ] `flutter analyze` shows no issues
- [ ] App runs without errors: `flutter run`
- [ ] GPS indicator appears and updates
- [ ] Can import valid GPX file
- [ ] Error handling works for invalid files
- [ ] Waypoint panel is readable (100px height)
- [ ] Map displays correctly
- [ ] Status bar shows route information
- [ ] No debug panels visible
- [ ] Hot reload works (`r` in terminal)

### Device-Specific Testing
- [ ] Test on Android emulator
- [ ] Test on Android physical device
- [ ] Test on iOS simulator (if on Mac)
- [ ] Test on iOS physical device (if available)
- [ ] Test GPS in real outdoor conditions

---

## 🚨 Common Issues & Solutions

### Issue: "Flutter not found"
**Solution:**
```bash
# Check Flutter installation
flutter --version

# If not found, add Flutter to PATH or use full path
C:\path\to\flutter\bin\flutter run
```

### Issue: "No devices found"
**Solution:**
```bash
# Check for devices
flutter devices

# Start an emulator
flutter emulators --launch <name>

# Or enable web
flutter run -d chrome
```

### Issue: "Gradle build failed" (Android)
**Solution:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

### Issue: "CocoaPods error" (iOS)
**Solution:**
```bash
cd ios
pod install
cd ..
flutter run
```

### Issue: Hot reload not working
**Solution:**
```bash
# Use hot restart instead
Press 'R' in terminal (capital R)

# Or full restart
q (quit)
flutter run (restart)
```

### Issue: "Location permissions denied"
**Solution:**
- **Android:** Settings → Apps → Navigator → Permissions → Location → Allow
- **iOS:** Settings → Privacy → Location Services → Navigator → While Using

---

## 📸 Visual Testing

### What to Look For:

**App Bar:**
```
☰  Walk Navigator    📡  📂
                     ↑   ↑
                     GPS Import
```

**Status Bar (No Route):**
```
┌─────────────────────────────────────┐
│ ℹ️  No route loaded. Tap 📂...      │ (Orange)
└─────────────────────────────────────┘
```

**Status Bar (Route Loaded):**
```
┌─────────────────────────────────────┐
│ trail_route.gpx                     │
│ 23 waypoints • 5.2 km • ~90 min   │ (Green)
└─────────────────────────────────────┘
```

**Waypoint Panel (New - 100px):**
```
┌──────────────────────────────────────┐
│                                      │
│  ➡️     250m        Turn right       │
│                                      │
└──────────────────────────────────────┘
```

---

## 🔬 Performance Testing

### Check Frame Rate
```bash
flutter run --profile

# In app, press 'P' to show performance overlay
# Should maintain 60fps during normal operation
```

### Check Build Size
```bash
flutter build apk --analyze-size
flutter build ios --analyze-size
```

### Check Memory Usage
```bash
# Run with DevTools
flutter run --observatory-port=8888

# Open DevTools in browser
# Monitor memory during GPX load and map interaction
```

---

## 📝 Creating Test Reports

### After Testing Session
```bash
# Generate test report
flutter test --machine > test_results.json

# Analyze results
flutter analyze > analysis_report.txt
```

### Manual Test Report Template
```markdown
## Test Report - [Date]

**Tester:** [Your Name]
**Device:** [Device Model]
**OS Version:** [Android 13 / iOS 16]

### GPS Status Indicator
- [ ] Shows on app launch
- [ ] Updates in real-time
- [ ] Tooltip shows accuracy
- [ ] Colors change appropriately

### GPX Import
- [ ] File picker opens
- [ ] Valid file imports successfully
- [ ] Success message displays
- [ ] Route stats shown correctly

### Error Handling
- [ ] Cancel handled gracefully
- [ ] Invalid file shows error
- [ ] Recovery options work

### UI/UX
- [ ] Waypoint panel readable
- [ ] Map displays correctly
- [ ] No debug panels visible
- [ ] Status bar informative

### Issues Found
[List any bugs or issues]

### Screenshots
[Attach screenshots if possible]
```

---

## 🎓 Zed-Specific Tips

### Terminal Shortcuts in Zed
- `` Ctrl+` `` - Toggle terminal
- `Ctrl+Shift+` ` - New terminal
- `Ctrl+Tab` - Switch between editor and terminal

### Run Flutter Commands from Command Palette
1. Press `Ctrl+Shift+P` (Command Palette)
2. Type "Terminal"
3. Select "Terminal: Run Command"
4. Enter Flutter commands

### Multi-Terminal Setup
1. Open terminal (`` Ctrl+` ``)
2. Split terminal or open new one
3. Terminal 1: `flutter run` (keep app running)
4. Terminal 2: `flutter analyze` or `git` commands

---

## 🚀 Quick Test Script

Save this as `test.sh` and run with `bash test.sh`:

```bash
#!/bin/bash
echo "🧪 Testing AVA Walk Navigator..."
echo ""

echo "1. Checking Flutter installation..."
flutter --version
echo ""

echo "2. Analyzing code..."
flutter analyze
echo ""

echo "3. Running tests..."
flutter test
echo ""

echo "4. Checking available devices..."
flutter devices
echo ""

echo "✅ Pre-flight checks complete!"
echo "Run 'flutter run' to start the app"
```

---

## 📚 Additional Resources

**Flutter Commands Reference:**
- `flutter doctor` - Check Flutter installation
- `flutter pub get` - Install dependencies
- `flutter clean` - Clean build files
- `flutter upgrade` - Update Flutter
- `flutter devices` - List devices
- `flutter emulators` - List emulators
- `flutter logs` - View device logs

**Documentation:**
- Flutter Docs: https://docs.flutter.dev
- Flutter Testing: https://docs.flutter.dev/testing
- Zed Editor: https://zed.dev/docs

---

## ✅ Success Criteria

Your testing session is successful when:
- ✅ App launches without errors
- ✅ GPS indicator shows and updates
- ✅ Can import GPX files successfully
- ✅ Error handling works for all scenarios
- ✅ Waypoint instructions are readable
- ✅ Map displays with route and markers
- ✅ Status bar shows correct information
- ✅ Hot reload works for quick iterations
- ✅ No console errors during normal operation

---

**Ready to test? Start with:**
```bash
cd C:\Users\Jeff\Websites\navigator
flutter run
```

**Happy Testing! 🧪**