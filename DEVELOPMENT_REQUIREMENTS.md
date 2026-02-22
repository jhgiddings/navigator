# Development Requirements - AVA Walk Navigator

**Project:** AVA Walk Navigator  
**Target Platforms:** iOS & Android (Mobile Only)  
**Last Updated:** 2024

---

## 🎯 Platform Focus

This app is designed for **mobile devices only**:
- ✅ iOS (iPhone/iPad)
- ✅ Android (phones/tablets)
- ❌ Windows Desktop (not needed)
- ❌ macOS Desktop (not needed)
- ❌ Linux Desktop (not needed)

**Therefore, you do NOT need Visual Studio for this project.**

---

## 💻 Development Machine Requirements

### Option 1: Windows PC (Your Current Setup)
**Can Build:** ✅ Android  
**Can Build:** ❌ iOS (requires Mac)

### Option 2: Mac
**Can Build:** ✅ Android  
**Can Build:** ✅ iOS

### Option 3: Linux
**Can Build:** ✅ Android  
**Can Build:** ❌ iOS (requires Mac)

**Reality Check:** To build iOS apps, you MUST have a Mac (or use cloud services).

---

## 📦 Required Software (Windows Development)

### 1. Flutter SDK ✅ (You Already Have This)
- **What:** Cross-platform mobile framework
- **Version:** 2.19.0-146.2.beta or higher
- **Check:** `flutter --version`
- **Status:** ✅ Installed and working

### 2. Android Studio (or Android SDK)
- **What:** Android development tools
- **Why:** Compiles Android APKs
- **Need Full IDE?** No - just the SDK tools
- **Alternative:** Command-line tools only

**Check if you have it:**
```bash
flutter doctor
```

Look for:
```
[✓] Android toolchain - develop for Android devices
```

**If Missing, Install:**
- Download: https://developer.android.com/studio
- Or just SDK: https://developer.android.com/studio#command-tools

### 3. Java Development Kit (JDK)
- **What:** Required for Android builds
- **Version:** JDK 11 or higher
- **Usually comes with Android Studio**

**Check:**
```bash
java -version
```

### 4. Git ✅ (You Already Have This)
- **What:** Version control
- **Status:** ✅ Working (you just pushed to GitHub)

### 5. Code Editor ✅ (You're Using Zed)
- **Current:** Zed (excellent choice)
- **Alternatives:** VS Code, Android Studio, IntelliJ
- **Status:** ✅ Working perfectly

---

## ❌ What You DON'T Need

### Visual Studio (Full IDE)
- **Purpose:** Windows desktop app development (C++, C#, .NET)
- **For This Project:** ❌ NOT NEEDED
- **Reason:** You're building mobile apps, not Windows apps
- **Size Saved:** ~10-20 GB

### Visual Studio Code (VS Code)
- **Purpose:** Lightweight code editor
- **For This Project:** ⚠️ Optional (you already have Zed)
- **If You Want It:** It's good for Flutter, but Zed works fine

### Xcode
- **Purpose:** iOS development
- **For This Project:** ✅ Needed BUT only on Mac
- **On Windows:** ❌ Cannot install (Mac only)

---

## 🔍 Check Your Current Setup

Run this command:
```bash
flutter doctor -v
```

### Ideal Output for Android Development:
```
[✓] Flutter (Channel beta, 2.19.0-146.2.beta)
[✓] Windows Version (Windows 10 or higher)
[✓] Android toolchain - develop for Android devices (Android SDK version 33.0.0)
[✓] Chrome - develop for the web
[✓] Android Studio (version 2023.1)
[✓] Connected device (3 available)
[✓] Network resources

[!] Xcode - develop for iOS and macOS
    ✗ Xcode not installed
    
This is NORMAL on Windows - you cannot build iOS apps on Windows
```

---

## 📱 What You CAN Build (Windows)

### ✅ Android Apps
```bash
# Build APK
flutter build apk

# Build App Bundle (for Play Store)
flutter build appbundle

# Install on connected device
flutter run
```

### ✅ Web Version (for testing)
```bash
flutter run -d chrome
```

### ❌ iOS Apps
Cannot be built on Windows. You need:
- Mac computer
- Xcode installed
- Apple Developer account ($99/year)

**Workaround Options:**
1. **Use a Mac** (borrow, buy, or rent)
2. **Cloud Mac Services:** Codemagic, Bitrise, GitHub Actions (macOS runners)
3. **Mac in Cloud:** MacStadium, AWS EC2 Mac instances
4. **Dual Boot:** Hackintosh (unsupported, complex)

---

## 🚀 Android Development Setup (Step-by-Step)

### Step 1: Verify Flutter
```bash
flutter --version
```
✅ You have this

### Step 2: Check Android Tools
```bash
flutter doctor
```

If you see ❌ for Android toolchain, install Android Studio:
1. Download: https://developer.android.com/studio
2. Run installer
3. Open Android Studio
4. Go to: More Actions → SDK Manager
5. Install: Android SDK, SDK Tools, SDK Platform-Tools

### Step 3: Accept Android Licenses
```bash
flutter doctor --android-licenses
```
Type `y` for each prompt

### Step 4: Test with Emulator
```bash
# List emulators
flutter emulators

# Launch one
flutter emulators --launch Pixel_8_Pro_API_36

# Run app
flutter run
```

### Step 5: Test with Physical Device
1. Enable Developer Options on Android phone
2. Enable USB Debugging
3. Connect phone via USB
4. Run: `flutter run`

---

## 🍎 iOS Development (When You Get a Mac)

### Required on Mac:
1. **Xcode** (from Mac App Store)
   - Size: ~15 GB
   - Free to download

2. **Xcode Command Line Tools**
   ```bash
   xcode-select --install
   ```

3. **CocoaPods** (iOS dependency manager)
   ```bash
   sudo gem install cocoapods
   ```

4. **Apple Developer Account**
   - Free for testing on your own devices
   - $99/year to publish to App Store

### Build iOS on Mac:
```bash
# Build for simulator
flutter run

# Build for physical device
flutter build ios

# Create IPA for App Store
flutter build ipa
```

---

## 📊 Disk Space Requirements

| Component | Size | Required? |
|-----------|------|-----------|
| Flutter SDK | ~2 GB | ✅ Yes (have it) |
| Android Studio | ~3 GB | ✅ Yes for Android |
| Android SDK & Emulator | ~5-10 GB | ✅ Yes for Android |
| Visual Studio | ~15-20 GB | ❌ NO (not needed) |
| Xcode (Mac only) | ~15 GB | ✅ Yes for iOS |
| Git | ~300 MB | ✅ Yes (have it) |
| Zed Editor | ~100 MB | ✅ Yes (have it) |

**Total for Android Development:** ~10-15 GB  
**You Can Skip Visual Studio:** Save 15-20 GB!

---

## 🔧 Recommended Tools (Optional)

### For Better Development Experience:

1. **Android Device Bridge (ADB)**
   - Comes with Android SDK
   - Useful for debugging
   ```bash
   adb devices
   adb logcat
   ```

2. **Flutter DevTools**
   - Built into Flutter
   - Performance profiling, debugging
   ```bash
   flutter pub global activate devtools
   flutter pub global run devtools
   ```

3. **Scrcpy** (Mirror Android Screen)
   - See emulator/device on your PC
   - Free and open source
   - https://github.com/Genymobile/scrcpy

4. **Firebase Tools** (if you add analytics/auth later)
   ```bash
   npm install -g firebase-tools
   ```

---

## ✅ Your Current Status

Based on previous commands, you have:
- ✅ Flutter SDK installed and working
- ✅ Git installed and working
- ✅ Zed editor installed and working
- ✅ 3 Android emulators configured
- ✅ Chrome/Edge for web testing
- ✅ Windows development environment
- ⚠️ Unknown: Android Studio/SDK status

**Next Step: Check Android toolchain**
```bash
flutter doctor
```

---

## 🎯 Quick Setup Verification

Run these commands to verify your setup:

```bash
# 1. Check Flutter
flutter --version

# 2. Check overall setup
flutter doctor

# 3. List devices
flutter devices

# 4. List emulators
flutter emulators

# 5. Test build (shouldn't need VS)
cd C:\Users\Jeff\Websites\navigator
flutter build apk --debug
```

If all work without errors, you're ready for Android development!

---

## 🚫 Common Misconceptions

### "I need Visual Studio for Flutter"
❌ **FALSE** - Only for Windows desktop apps

### "I need VS Code for Flutter"
⚠️ **OPTIONAL** - Any editor works (you have Zed)

### "I need a Mac for Flutter"
⚠️ **PARTIAL** - Only for iOS builds

### "I need Android Studio for Flutter"
⚠️ **PARTIAL** - You need the SDK tools, full IDE is optional

### "Flutter only works on Mac"
❌ **FALSE** - Works on Windows, Mac, Linux

---

## 📋 Development Workflow (Windows)

### Daily Development:
1. Open project in Zed
2. Start emulator: `flutter emulators --launch Pixel_8_Pro_API_36`
3. Run app: `flutter run`
4. Make changes in Zed
5. Press `r` for hot reload
6. Test on emulator

### Building Release:
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS (requires Mac)
# Cannot do on Windows
```

### Testing:
```bash
# Unit tests
flutter test

# Integration tests
flutter drive --target=test_driver/app.dart
```

---

## 🔄 Cross-Platform Build Strategy

### Option 1: Windows for Android, Cloud for iOS
1. Develop on Windows (Zed + Flutter)
2. Build Android locally
3. Use GitHub Actions for iOS builds (free for public repos)

### Option 2: Windows Primary, Mac Mini for iOS
1. Develop on Windows
2. Push to GitHub
3. Pull on Mac, build iOS
4. Return to Windows development

### Option 3: Cloud-Based (Codemagic/Bitrise)
1. Develop on Windows
2. Push to GitHub
3. Cloud service builds both Android & iOS
4. Download builds

---

## 🎓 Learning Resources

### Flutter Development:
- Docs: https://docs.flutter.dev
- Cookbook: https://docs.flutter.dev/cookbook
- YouTube: Flutter channel

### Android Specific:
- Android Developers: https://developer.android.com
- Material Design: https://material.io

### iOS Specific (when you get Mac):
- Apple Developer: https://developer.apple.com
- Human Interface Guidelines: https://developer.apple.com/design

---

## 🆘 Troubleshooting

### "Flutter doctor shows Android toolchain error"
**Solution:** Install Android Studio or SDK command-line tools

### "Cannot build APK"
**Solution:**
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

### "Emulator won't start"
**Solution:** Check Android Studio → AVD Manager → Verify emulator installed

### "USB device not detected"
**Solution:** 
- Enable USB debugging on phone
- Install phone manufacturer's USB drivers
- Check: `adb devices`

---

## ✅ Summary

**For This Project (iOS + Android Mobile Apps):**

| Software | Windows | Mac | Needed? |
|----------|---------|-----|---------|
| Flutter SDK | ✅ | ✅ | ✅ YES |
| Zed Editor | ✅ | ✅ | ✅ YES (you have it) |
| Git | ✅ | ✅ | ✅ YES (you have it) |
| Android Studio/SDK | ✅ | ✅ | ✅ YES (Android builds) |
| Xcode | ❌ | ✅ | ✅ YES (iOS builds) |
| Visual Studio | ❌ | ❌ | ❌ NO (not needed!) |
| VS Code | ⚠️ | ⚠️ | ⚠️ Optional (Zed is fine) |

**Bottom Line:**
- ✅ You have: Flutter, Git, Zed, Emulators
- ⚠️ Verify: Android SDK/toolchain
- ❌ Don't need: Visual Studio
- ⏳ For later: Mac + Xcode (iOS builds)

**Your Windows setup is perfect for Android development!**

---

**Next Action: Run `flutter doctor` to check Android toolchain status.**
