@echo off
REM Helper script to set emulator GPS location and simulate route
REM Usage: set_emulator_location.bat

echo ==================================
echo Emulator GPS Location Helper
echo ==================================
echo.

REM Twinbrook Neighborhood starting coordinates
set LAT=39.08051807743798
set LON=-77.11149015107675

echo Setting emulator location to:
echo   Latitude:  %LAT%
echo   Longitude: %LON%
echo   (Twinbrook, Rockville, MD)
echo.

REM Check if adb is available
where adb >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Warning: adb not found in PATH
    echo Trying to use Android SDK default location...
    set ADB_PATH=%LOCALAPPDATA%\Android\Sdk\platform-tools\adb.exe
    if not exist "%ADB_PATH%" (
        echo.
        echo *** Use Extended Controls GUI instead ***
        echo 1. Click '...' on emulator toolbar
        echo 2. Go to 'Location' tab
        echo 3. Enter coordinates:
        echo    Latitude: %LAT%
        echo    Longitude: %LON%
        echo 4. Click Send
        pause
        exit /b 1
    )
) else (
    set ADB_PATH=adb
)

REM Check if emulator is running
%ADB_PATH% devices | findstr /C:"emulator" >nul
if %ERRORLEVEL% NEQ 0 (
    echo Error: No emulator detected!
    echo Please start the Pixel 8 Pro emulator first.
    echo.
    pause
    exit /b 1
)

echo [OK] Emulator detected
echo.

REM Set the GPS location
echo Sending GPS coordinates to emulator...
%ADB_PATH% emu geo fix %LON% %LAT%

if %ERRORLEVEL% EQU 0 (
    echo [OK] Location set successfully!
    echo.
    echo Next steps:
    echo 1. The emulator is now at Twinbrook location
    echo 2. Open the Navigator app
    echo 3. Load Twinbrook_Neighborhood.gpx
    echo 4. Tap the GREEN [PLAY] button to start navigation
    echo.
    echo To simulate walking the route:
    echo 1. Click '...' on emulator toolbar ^(Extended Controls^)
    echo 2. Go to 'Location' tab
    echo 3. Click 'Load GPX/KML'
    echo 4. Select: Twinbrook_Neighborhood.gpx
    echo 5. Adjust speed slider ^(1x = normal walking speed^)
    echo 6. Click [PLAY] Play Route
    echo.
    echo The app will now track your simulated walk!
) else (
    echo Error: Failed to set location
    echo.
    echo Try using the Extended Controls GUI instead:
    echo 1. Click '...' on emulator toolbar
    echo 2. Go to Location tab
    echo 3. Enter coordinates manually:
    echo    Latitude: %LAT%
    echo    Longitude: %LON%
    echo 4. Click Send
)

echo.
echo ==================================
pause
