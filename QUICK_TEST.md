# Quick Test - AVA Walk Navigator

**Last Updated:** 2024  
**For:** Zed Editor Users

---

## 🚀 Fastest Way to Test (Choose One)

### Option 1: Test in Chrome (Quickest - No GPS)
```bash
cd C:\Users\Jeff\Websites\navigator
flutter run -d chrome
```
**Time:** ~30 seconds  
**Note:** Map and UI work, but GPS features won't function in browser

---

### Option 2: Test on Android Emulator (Best for Full Testing)
```bash
cd C:\Users\Jeff\Websites\navigator

# Start emulator (choose one):
flutter emulators --launch Pixel_8_Pro_API_36   # Newest/Fastest
# OR
flutter emulators --launch Pixel_6_API_31       # Good balance
# OR
flutter emulators --launch Pixel_5_API_30       # Older but stable

# Wait for emulator to fully boot (~1 minute)

# Then run app:
flutter run
```
**Time:** ~2-3 minutes (including emulator boot)  
**Note:** GPS can be simulated via emulator controls

---

### Option 3: Test on Windows Desktop
```bash
cd C:\Users\Jeff\Websites\navigator
flutter run -d windows
```
**Time:** ~45 seconds  
**Note:** Good for UI testing, limited GPS functionality

---

## ✅ What to Test Immediately

### 1. App Launches Successfully
- App opens without errors
- Green theme visible
- Map loads (OpenStreetMap tiles)

### 2. GPS Indicator (Top-Right)
- 📡 Icon visible in app bar
- Shows color (🟠 orange/🔴 red initially)
- Tap it → Shows tooltip with GPS status

### 3. Status Bar
- Orange bar shows: "No route loaded. Tap 📂 to import a GPX file."
- Clean layout with info icon

### 4. Import GPX Button
- 📂 Icon visible in app bar
- Tap it → File picker opens
- **Note:** You'll need a GPX file to test full flow

### 5. Waypoint Panel (Bottom)
- Large panel (~100px height) at bottom
- Shows: "Follow the route" text
- Arrow icon visible
- Distance shows "0 m"

### 6. Map Display
- OpenStreetMap loads
- No debug text visible
- No toolbar above map (clean)
- OSM controls in bottom-right

---

## 🧪 Test With Sample GPX File

### Quick Test GPX (Create This File)

Save as `test_route.gpx` in your Downloads folder:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<gpx version="1.1" creator="Test">
  <trk>
    <name>Test Route</name>
    <trkseg>
      <trkpt lat="37.7749" lon="-122.4194"></trkpt>
      <trkpt lat="37.7750" lon="-122.4195"></trkpt>
      <trkpt lat="37.7751" lon="-122.4196"></trkpt>
    </trkseg>
  </trk>
  <wpt lat="37.7749" lon="-122.4194">
    <name>Start</name>
    <desc>Starting point</desc>
  </wpt>
  <wpt lat="37.7750" lon="-122.4195">
    <name>Middle</name>
    <desc>Turn right</desc>
  </wpt>
  <wpt lat="37.7751" lon="-122.4196">
    <name>End</name>
    <desc>Finish</desc>
  </wpt>
</gpx>
```

### Test Import Flow:
```bash
flutter run -d chrome  # or emulator

# In app:
1. Tap 📂 button
2. Select test_route.gpx
3. Should see: "GPX file loaded successfully!" (green snackbar)
4. Status bar changes to green showing: "test_route.gpx"
5. Second line shows: "3 waypoints • 0.0 km • ~0 min"
6. Map should show markers and route line
```

---

## 🔥 Hot Reload Testing

While app is running in terminal:

```bash
# Make a change in Zed (e.g., change text in home_screen.dart)
# Save the file
# In terminal, press:

r   # Hot reload (instant, keeps state)
R   # Hot restart (slower, resets app)
q   # Quit app
h   # Help
```

**Try this:**
1. Run: `flutter run -d chrome`
2. Open `lib/constants.dart` in Zed
3. Change `AppConstants.primaryGreen` to `Color(0xFF1976D2)` (blue)
4. Save file
5. Press `r` in terminal
6. Watch app instantly update to blue theme!

---

## 📊 Quick Health Check

Run these commands to verify everything is working:

```bash
cd C:\Users\Jeff\Websites\navigator

# Check for code issues
flutter analyze
# Should show: "No issues found!"

# Check Flutter setup
flutter doctor
# Should show all green checkmarks

# List available devices
flutter devices
# Should show: Windows, Chrome, Edge

# List emulators
flutter emulators
# Should show: Pixel 5, Pixel 6, Pixel 8 Pro
```

---

## 🎯 5-Minute Test Checklist

- [ ] Run `flutter run -d chrome`
- [ ] App opens successfully
- [ ] GPS indicator visible (📡)
- [ ] Status bar shows orange "No route loaded"
- [ ] Map displays OpenStreetMap
- [ ] No error messages in terminal
- [ ] Waypoint panel at bottom (large text)
- [ ] Press `r` for hot reload → Works
- [ ] Press `q` to quit → Exits cleanly

**If all checkmarks pass: ✅ Your modifications work!**

---

## 🐛 If Something Breaks

### App won't start:
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

### Import button doesn't work:
- Normal in Chrome (file picker has browser limitations)
- Test on emulator instead: `flutter run` (after launching emulator)

### Map doesn't load:
- Check internet connection (map tiles load from internet)
- Wait 10-15 seconds for initial load

### Hot reload stops working:
```bash
# Press 'R' (capital) for full restart
# Or quit and restart:
q
flutter run -d chrome
```

---

## 📱 Recommended Test Order

### Day 1: Basic Smoke Test (5 min)
```bash
flutter run -d chrome
# Check: App loads, no errors, UI looks correct
```

### Day 2: Full Feature Test (15 min)
```bash
flutter emulators --launch Pixel_8_Pro_API_36
# Wait for emulator...
flutter run
# Test: GPS indicator, file import, map interactions
```

### Day 3: Error Handling Test (10 min)
```bash
flutter run
# Test: Cancel file picker, invalid files, edge cases
```

### Day 4: Real Device Test (30 min)
```bash
# Connect Android phone via USB
flutter run
# Test: GPS outdoors, actual walking, battery impact
```

---

## 💡 Pro Tips for Zed

### Split Terminal View
1. Open terminal: `` Ctrl+` ``
2. Split horizontally or vertically
3. Terminal 1: `flutter run`
4. Terminal 2: `flutter analyze` or `git status`

### Quick Command Palette
1. Press `Ctrl+Shift+P`
2. Type "terminal"
3. Quick access to terminal commands

### Watch File Changes
Zed automatically saves on focus loss, perfect for hot reload workflow!

---

## 🎊 Success Indicators

You'll know the modifications work when you see:

✅ **GPS Indicator:** 📡 icon in top-right showing status  
✅ **Large Waypoint Panel:** 100px height with big text  
✅ **Enhanced Status Bar:** Route stats (waypoints • distance • time)  
✅ **No Debug Panel:** Clean map without placeholder text  
✅ **Error Handling:** Graceful dialogs instead of crashes  
✅ **Success Feedback:** Green snackbar on GPX load  

---

## 🚀 Start Testing Now!

**Quickest test (30 seconds):**
```bash
cd C:\Users\Jeff\Websites\navigator && flutter run -d chrome
```

**Best test (3 minutes):**
```bash
cd C:\Users\Jeff\Websites\navigator
flutter emulators --launch Pixel_8_Pro_API_36
# Wait for emulator boot...
flutter run
```

---

**Good luck! The modifications are solid and ready to test! 🎉**