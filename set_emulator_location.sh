#!/bin/bash
# Helper script to set emulator GPS location and simulate route
# Usage: ./set_emulator_location.sh

echo "=================================="
echo "Emulator GPS Location Helper"
echo "=================================="
echo ""

# Twinbrook Neighborhood starting coordinates
LAT="39.08051807743798"
LON="-77.11149015107675"

echo "Setting emulator location to:"
echo "  Latitude:  $LAT"
echo "  Longitude: $LON"
echo "  (Twinbrook, Rockville, MD)"
echo ""

# Check if emulator is running
if ! adb devices | grep -q "emulator"; then
    echo "❌ Error: No emulator detected!"
    echo "Please start the Pixel 8 Pro emulator first."
    exit 1
fi

echo "✓ Emulator detected"
echo ""

# Set the GPS location
echo "Sending GPS coordinates to emulator..."
adb emu geo fix $LON $LAT

if [ $? -eq 0 ]; then
    echo "✓ Location set successfully!"
    echo ""
    echo "Next steps:"
    echo "1. The emulator is now at Twinbrook location"
    echo "2. Open the Navigator app"
    echo "3. Load Twinbrook_Neighborhood.gpx"
    echo "4. Tap the GREEN ▶ PLAY button to start navigation"
    echo ""
    echo "To simulate walking the route:"
    echo "1. Click '...' on emulator toolbar (Extended Controls)"
    echo "2. Go to 'Location' tab"
    echo "3. Click 'Load GPX/KML'"
    echo "4. Select: Twinbrook_Neighborhood.gpx"
    echo "5. Adjust speed slider (1x = normal walking speed)"
    echo "6. Click ▶ Play Route"
    echo ""
    echo "The app will now track your simulated walk!"
else
    echo "❌ Error: Failed to set location"
    echo "Try using the Extended Controls GUI instead:"
    echo "1. Click '...' on emulator toolbar"
    echo "2. Go to Location tab"
    echo "3. Enter coordinates manually"
    echo "   Latitude: $LAT"
    echo "   Longitude: $LON"
    echo "4. Click Send"
fi

echo ""
echo "=================================="
