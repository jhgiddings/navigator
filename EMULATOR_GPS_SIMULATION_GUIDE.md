# Emulator GPS Simulation Guide

**Purpose:** Simulate GPS movement on Android emulator to test navigation features  
**Target:** Twinbrook Neighborhood route testing  
**Date:** December 2024

---

## 🎯 Quick Start

### **Fastest Method: Use Extended Controls GUI**

1. **Open Extended Controls**
   - Click **"..."** (three dots) on emulator toolbar
   - Or press **Ctrl+Shift+P** (Windows) / **Cmd+Shift+P** (Mac)

2. **Set Starting Location**
   - Click **"Location"** in left sidebar
   - Enter coordinates:
     - **Latitude:** `39.08051807743798`
     - **Longitude:** `-77.11149015107675`
   - Click **"Send"** button

3. **Load and Play Route**
   - Scroll down to **"Route"** section (bottom of Location tab)
   - Click **"Load GPX/KML"** button
   - Navigate to: `C:\Users\Jeff\Websites\navigator\Twinbrook_Neighborhood.gpx`
   - Adjust **Speed** slider to `1.0x` (normal walking speed)
   - Click **▶ Play Route** button

4. **In the Navigator App**
   - Make sure Twinbrook GPX is loaded
   - Tap **GREEN ▶ PLAY** button to start navigation
   - Watch as distance updates while route plays!

---

## 📍 Location Information

### **Twinbrook Neighborhood (Starting Point)**
- **Latitude:** 39.08051807743798
- **Longitude:** -77.11149015107675
- **Location:** Twinbrook, Rockville, Maryland, USA
- **Why:** This is the actual location of the Twinbrook_Neighborhood.gpx route

### **Emulator Default Location**
- **Latitude:** 37.4220
- **Longitude:** -122.0841
- **Location:** Mountain View, California (Google HQ)
- **Note:** If you don't set location, navigation will think you're in California!

---

## 🎮 Method 1: Extended Controls (GUI - Recommended)

### **Opening Extended Controls**

**Option A: Click Button**
- Look for **"..."** (three dots) on the right side of emulator toolbar
- Click it to open Extended Controls window

**Option B: Keyboard Shortcut**
- **Windows:** `Ctrl + Shift + P`
- **Mac:** `Cmd + Shift + P`
- **Linux:** `Ctrl + Shift + P`

### **Setting Single GPS Location**

1. **Navigate to Location Tab**
   - In Extended Controls, click **"Location"** in left sidebar
   - You'll see a map and coordinate input fields

2. **Enter Twinbrook Coordinates**
   - **Latitude field:** `39.08051807743798`
   - **Longitude field:** `--77.11149015107675`
   - **Altitude (optional):** Leave default or set to `100`

3. **Send Location**
   - Click **"Send"** button
   - Emulator will immediately update GPS to this location
   - Your app will receive this as the current location

### **Loading and Playing GPX Route**

1. **Scroll to Route Section**
   - At the bottom of the Location tab
   - You'll see "Route" section with file picker and playback controls

2. **Load GPX File**
   - Click **"Load GPX/KML"** button
   - File browser opens
   - Navigate to: `C:\Users\Jeff\Websites\navigator\`
   - Select: `Twinbrook_Neighborhood.gpx`
   - Click **"Open"**

3. **Configure Playback**
   - **Speed slider:** 
     - `0.5x` = Half walking speed (slower, easier to test)
     - `1.0x` = Normal walking speed (~5 km/h)
     - `2.0x` = Double speed (faster testing)
   - **Repeat:** Check box to loop the route
   - **Interpolation:** Keep enabled for smooth movement

4. **Play Route**
   - Click **▶ Play Route** button
   - GPS coordinates will update along the route path
   - Watch your app track the simulated movement!

5. **Playback Controls**
   - **▶ Play** - Start playback
   - **⏸ Pause** - Pause at current position
   - **⏹ Stop** - Stop and reset to start
   - **Speed slider** - Adjust while playing

---

## 💻 Method 2: Command Line (ADB)

### **Prerequisites**
- Android SDK Platform Tools installed
- `adb` in your system PATH
- Emulator must be running

### **Setting Single Location**

**Command Format:**
```bash
adb emu geo fix <longitude> <latitude> [altitude]
```

**For Twinbrook:**
```bash
adb emu geo fix -77.11149015107675 39.08051807743798
```

**Note:** Longitude comes FIRST, then latitude (opposite of GPS convention!)

### **Using the Helper Script**

**Windows (PowerShell or Command Prompt):**
```cmd
cd C:\Users\Jeff\Websites\navigator
set_emulator_location.bat
```

**Windows (Git Bash) or Linux/Mac:**
```bash
cd ~/Websites/navigator
./set_emulator_location.sh
```

**What the script does:**
1. Checks if emulator is running
2. Sets GPS to Twinbrook coordinates
3. Provides next-step instructions
4. Gives GUI fallback if ADB fails

---

## 🧪 Method 3: Telnet Console (Advanced)

### **Connecting to Emulator Console**

1. **Find Emulator Port**
   ```bash
   adb devices
   ```
   Output: `emulator-5554` (5554 is the port)

2. **Connect via Telnet**
   ```bash
   telnet localhost 5554
   ```

3. **Set GPS Location**
   ```
   geo fix -77.11149015107675 39.08051807743798
   ```

4. **Verify**
   ```
   geo fix
   ```

5. **Exit**
   ```
   quit
   ```

---

## 📱 Testing Navigation with Simulated GPS

### **Complete Test Procedure**

#### **Step 1: Prepare Emulator**
1. Start Pixel 8 Pro emulator
2. Wait for full boot (home screen visible)
3. Verify GPS is enabled in emulator settings

#### **Step 2: Set Starting Location**
1. Open Extended Controls (...)
2. Go to Location tab
3. Set Twinbrook coordinates (39.0805, -77.1114)
4. Click Send

#### **Step 3: Start Navigator App**
1. Launch Walk Navigator app
2. Wait for GPS indicator to turn green
3. Load Twinbrook_Neighborhood.gpx if not already loaded
4. Verify purple route line is visible

#### **Step 4: Start Navigation**
1. Tap GREEN ▶ PLAY button in app bar
2. Button should turn RED ⏹ (indicating active)
3. Bottom panel should show:
   - Distance to first waypoint
   - Turn instruction
   - "Waypoint 1 of 46"

#### **Step 5: Start Route Simulation**
1. In Extended Controls, scroll to Route section
2. Click "Load GPX/KML"
3. Select Twinbrook_Neighborhood.gpx
4. Set speed to 1.0x
5. Click ▶ Play Route

#### **Step 6: Observe Navigation**
Watch for these behaviors:
- ✅ Distance counts down as route plays
- ✅ Waypoint automatically advances when passed
- ✅ Turn instruction updates
- ✅ Progress indicator updates ("Waypoint 2 of 46", etc.)
- ✅ Route completion dialog appears at end

---

## 🐛 Troubleshooting

### **Problem: "No emulator detected"**

**Solution:**
- Verify emulator is running: `adb devices`
- If no devices listed, restart emulator
- Try reconnecting: `adb kill-server` then `adb start-server`

### **Problem: Location not updating in app**

**Checklist:**
- ✅ GPS permissions granted to Navigator app
- ✅ Location services enabled in emulator
- ✅ Coordinates sent successfully (check Extended Controls)
- ✅ App is using MapController.myLocation() (not cached)

**Debug:**
1. Check console output for GPS updates
2. Verify emulator settings → Location → Location is ON
3. Try toggling GPS off/on in emulator

### **Problem: Route playback not working**

**Checklist:**
- ✅ GPX file loaded successfully (no error message)
- ✅ Play button clicked (should change to pause icon)
- ✅ Speed slider not at 0
- ✅ Route file is valid GPX format

**Try:**
1. Stop and reload GPX file
2. Try with sample_route.gpx first (simpler)
3. Check that GPX has track points (not just waypoints)

### **Problem: Waypoints not advancing**

**Possible Causes:**
1. **Threshold not met** - Need to be within 10m
2. **Not walking away** - Distance must increase after being close
3. **GPS accuracy poor** - Simulated GPS should have good accuracy

**Debug:**
1. Check console logs for "Current Location to Waypoint: X m"
2. Verify waypoint detection conditions in code
3. Try slower playback speed (0.5x) for easier debugging

### **Problem: Navigation started but no updates**

**Check:**
1. Is timer running? (Check console for update messages every 5 seconds)
2. Is navigation state "active"? (Button should be red)
3. Are callbacks firing? (Add console logs)

**Solution:**
1. Stop and restart navigation
2. Reload GPX file
3. Check that Navigation service was initialized with callbacks

---

## 📊 Expected Behavior

### **During Route Playback**

**Every 5 seconds you should see:**

**Console Output:**
```
Current Location to Waypoint: 245.3 m
Previous Location to Waypoint: 250.1 m
```

**UI Updates:**
- Distance number decreases
- Progress percentage increases
- Map centers on current position (blue dot)

**When Waypoint Passed:**
```
✓ Waypoint passed! Advancing to waypoint 2
Updated to waypoint 2: Turn left on Oak Street
```

**UI Updates:**
- Waypoint number increments
- New turn instruction appears
- New distance to next waypoint
- Direction icon changes

### **Route Completion**

**When last waypoint reached:**
- ✅ Navigation stops automatically
- ✅ Celebration dialog appears: "Route Completed! 🎉"
- ✅ Button returns to GREEN ▶

---

## 🎯 Test Scenarios

### **Scenario 1: Basic Navigation Test**
**Duration:** 5-10 minutes (fast playback)

1. Set location to Twinbrook start
2. Load Twinbrook GPX in app
3. Start navigation in app
4. Play route at 2.0x speed
5. **Verify:** All 46 waypoints are traversed
6. **Verify:** Route completes successfully

### **Scenario 2: Realistic Walking Test**
**Duration:** 45-60 minutes (real-time)

1. Set location to Twinbrook start
2. Start navigation in app
3. Play route at 1.0x speed (normal walking)
4. **Verify:** Distance updates feel natural
5. **Verify:** Waypoints advance at right time
6. **Verify:** No false positives (early advances)

### **Scenario 3: Mid-Route Start**
**Duration:** 5 minutes

1. Set location to middle of route (waypoint 20)
2. Start navigation in app
3. **Verify:** App finds closest waypoint (should be 20 or 21)
4. **Verify:** Continues from there to end

### **Scenario 4: Stop and Resume**
**Duration:** 5 minutes

1. Start navigation normally
2. Let route play through 10 waypoints
3. Tap RED ⏹ STOP button
4. Pause route playback in Extended Controls
5. Tap GREEN ▶ PLAY again
6. Resume route playback
7. **Verify:** Navigation resumes correctly

---

## 📝 Testing Checklist

### **Pre-Test Setup**
- [ ] Emulator is running (Pixel 8 Pro API 36)
- [ ] GPS enabled in emulator settings
- [ ] Navigator app installed and running
- [ ] Twinbrook GPX file available on emulator
- [ ] Extended Controls window open

### **GPS Location Test**
- [ ] Set Twinbrook coordinates
- [ ] Verify GPS indicator in app turns green
- [ ] Check console logs show correct coordinates
- [ ] Map centers on Twinbrook area

### **Route Loading Test**
- [ ] Load Twinbrook GPX in Extended Controls
- [ ] Route appears in Route section
- [ ] Play button becomes enabled
- [ ] Speed slider is functional

### **Navigation Functionality**
- [ ] Start navigation with GREEN ▶ button
- [ ] Button turns RED ⏹ when active
- [ ] Distance displays correctly
- [ ] Waypoint instruction appears
- [ ] Progress shows "Waypoint 1 of 46"

### **Route Playback Test**
- [ ] Play route in Extended Controls
- [ ] Distance counts down
- [ ] Waypoints auto-advance
- [ ] Turn instructions update
- [ ] Console shows debug output

### **Edge Cases**
- [ ] Route completion dialog appears
- [ ] Stop navigation mid-route works
- [ ] Restart navigation works
- [ ] Multiple route replays work
- [ ] App handles GPS loss gracefully

---

## 💡 Pro Tips

### **Faster Testing**
- Use 2x or 4x speed for quick validation
- Use sample_route.gpx (7 waypoints) for rapid iteration
- Keep Extended Controls open on second monitor

### **Better Debugging**
- Watch console output AND UI simultaneously
- Take screenshots at waypoint transitions
- Record video of full route playback
- Compare expected vs actual waypoint advances

### **Realistic Testing**
- Test at 1x speed for final validation
- Test with phone tilted/rotated
- Test with other apps running
- Test with low battery mode

### **Common Settings**
- **Quick test:** 4x speed, sample_route.gpx
- **Feature test:** 2x speed, Twinbrook GPX
- **Realistic test:** 1x speed, Twinbrook GPX
- **Stress test:** 0.5x speed, watch every detail

---

## 🔗 Related Files

**GPX Files:**
- `Twinbrook_Neighborhood.gpx` - Full 46-waypoint route
- `sample_route.gpx` - Simple 7-waypoint test route

**Helper Scripts:**
- `set_emulator_location.bat` - Windows batch file
- `set_emulator_location.sh` - Linux/Mac shell script

**Documentation:**
- `NAVIGATION_RESTORED.md` - Navigation feature details
- `TODO.md` - Project status and next steps
- `SESSION_SUMMARY_DEC_2024.md` - Development session notes

---

## 📚 Additional Resources

### **Android Emulator Documentation**
- [Emulator GPS Simulation](https://developer.android.com/studio/run/emulator#extended)
- [ADB Commands](https://developer.android.com/studio/command-line/adb)
- [Location Settings](https://developer.android.com/training/location)

### **GPX Format**
- [GPX 1.1 Schema](https://www.topografix.com/GPX/1/1/)
- [Creating GPX Files](https://www.gpxeditor.co.uk/)

### **Flutter Geolocator**
- [Package Documentation](https://pub.dev/packages/geolocator)
- [Location Permissions](https://pub.dev/packages/geolocator#setup)

---

## ✅ Success Criteria

**You'll know GPS simulation is working when:**

1. ✅ Emulator shows correct location on Extended Controls map
2. ✅ App GPS indicator turns GREEN
3. ✅ Console logs show coordinates updating
4. ✅ Distance in app counts down as route plays
5. ✅ Waypoints advance automatically at right time
6. ✅ All 46 waypoints are successfully traversed
7. ✅ Route completion dialog appears at end

**Perfect test run looks like:**
- Start at waypoint 1: "245 m - Turn right on Oak Street"
- Route plays smoothly
- Every 5 seconds: distance updates, console logs appear
- Waypoint advances: "✓ Waypoint passed! Advancing to waypoint 2"
- New instruction: "180 m - Turn left on Elm Street"
- ...continues through all 46 waypoints
- Final waypoint: "0 m - End point"
- Dialog: "🎉 Route Completed!"

---

## 🎉 Ready to Test!

**Your navigation system is fully functional and ready for GPS simulation testing.**

Use this guide to validate that the restored navigation algorithm works exactly as it did 2 years ago when you successfully walked the Twinbrook route.

**Happy Testing! 🚀**

---

**Last Updated:** December 2024  
**Status:** ✅ Complete - Ready for GPS simulation testing  
**Next:** Field test with real device for final validation