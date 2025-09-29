# Praniti Mobile App - Setup Guide

This guide will help you set up the Praniti mobile application for development and deployment.

## Prerequisites

### Required Software

1. **Flutter SDK 3.24.5+**

   ```bash
   # Download from https://flutter.dev/docs/get-started/install
   # Add to PATH
   export PATH="$PATH:/path/to/flutter/bin"
   ```

2. **Dart SDK 3.5.4+** (included with Flutter)

3. **Android Studio** (for Android development)

   - Download from https://developer.android.com/studio
   - Install Android SDK
   - Configure Android emulator

4. **Xcode** (for iOS development - macOS only)

   - Download from Mac App Store
   - Install Xcode Command Line Tools

5. **VS Code** (recommended editor)
   - Install Flutter and Dart extensions

### System Requirements

- **Operating System**: Windows 10+, macOS 10.14+, or Linux
- **RAM**: 8GB minimum, 16GB recommended
- **Storage**: 10GB free space
- **Network**: Internet connection for dependencies

## Installation Steps

### 1. Clone the Repository

```bash
git clone <repository-url>
cd praniti_mobile_app
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Verify Flutter Installation

```bash
flutter doctor
```

Fix any issues reported by `flutter doctor`.

### 4. Configure Environment

Create a `.env` file in the project root:

```env
# API Configuration
API_BASE_URL=http://localhost:5000/api
SOCKET_URL=http://localhost:5000

# App Configuration
APP_NAME=Praniti
APP_VERSION=1.0.0
DEBUG_MODE=true

# Backend Configuration
BACKEND_URL=http://localhost:5000
MONGODB_URL=mongodb://localhost:27017/praniti
```

### 5. Backend Setup

Ensure the Praniti backend is running:

```bash
# Navigate to backend directory
cd ../AdhyayanMarg_WebStack/backend

# Install dependencies
npm install

# Start the server
npm run dev
```

The backend should be running on `http://localhost:5000`.

## Development Setup

### 1. IDE Configuration

#### VS Code Setup

1. Install Flutter extension
2. Install Dart extension
3. Configure settings:

```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.lineLength": 120,
  "editor.formatOnSave": true,
  "editor.rulers": [120]
}
```

#### Android Studio Setup

1. Install Flutter plugin
2. Install Dart plugin
3. Configure SDK paths
4. Set up Android emulator

### 2. Code Generation

Run code generation for Hive models:

```bash
flutter packages pub run build_runner build
```

### 3. Development Commands

```bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d <device-id>

# Run with hot reload
flutter run --hot

# Run tests
flutter test

# Build for release
flutter build apk --release
```

## Platform-Specific Setup

### Android Setup

1. **Install Android SDK**

   ```bash
   # Using Android Studio SDK Manager
   # Install Android SDK Platform 33+
   # Install Android SDK Build-Tools
   # Install Android SDK Platform-Tools
   ```

2. **Configure Android Emulator**

   ```bash
   # Create AVD (Android Virtual Device)
   # Recommended: Pixel 6, API 33
   ```

3. **Enable Developer Options**
   - Enable USB Debugging
   - Enable Install via USB

### iOS Setup (macOS only)

1. **Install Xcode**

   ```bash
   # From Mac App Store
   # Install Xcode Command Line Tools
   xcode-select --install
   ```

2. **Configure iOS Simulator**

   ```bash
   # Open Xcode
   # Go to Window > Devices and Simulators
   # Create new simulator
   ```

3. **Configure Signing**
   - Open project in Xcode
   - Configure team and bundle identifier
   - Set up provisioning profiles

## Running the App

### 1. Start Backend Server

```bash
cd ../AdhyayanMarg_WebStack/backend
npm run dev
```

### 2. Start Flutter App

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific platform
flutter run -d android
flutter run -d ios
```

### 3. Hot Reload

- Press `r` for hot reload
- Press `R` for hot restart
- Press `q` to quit

## Testing

### 1. Unit Tests

```bash
flutter test
```

### 2. Integration Tests

```bash
flutter test integration_test/
```

### 3. Widget Tests

```bash
flutter test test/widget_test.dart
```

### 4. Test Coverage

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Building for Production

### Android APK

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APKs by ABI
flutter build apk --split-per-abi
```

### Android App Bundle

```bash
flutter build appbundle --release
```

### iOS App

```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

## Deployment

### Google Play Store

1. **Create Keystore**

   ```bash
   keytool -genkey -v -keystore ~/praniti-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias praniti
   ```

2. **Configure Signing**

   - Create `android/key.properties`
   - Update `android/app/build.gradle`

3. **Build Release**

   ```bash
   flutter build appbundle --release
   ```

4. **Upload to Play Console**
   - Create developer account
   - Upload AAB file
   - Configure store listing

### Apple App Store

1. **Configure Signing**

   - Open project in Xcode
   - Set up team and bundle ID
   - Configure provisioning profiles

2. **Build Archive**

   ```bash
   flutter build ios --release
   # Open in Xcode and archive
   ```

3. **Upload to App Store Connect**
   - Create developer account
   - Upload via Xcode or Transporter
   - Configure store listing

## Troubleshooting

### Common Issues

1. **Flutter Doctor Issues**

   ```bash
   # Fix Android SDK issues
   flutter doctor --android-licenses

   # Fix Xcode issues
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   ```

2. **Build Errors**

   ```bash
   # Clean and rebuild
   flutter clean
   flutter pub get
   flutter run
   ```

3. **Dependency Issues**

   ```bash
   # Update dependencies
   flutter pub upgrade

   # Clear pub cache
   flutter pub cache clean
   ```

4. **Emulator Issues**

   ```bash
   # List available devices
   flutter devices

   # Start emulator manually
   emulator -avd <avd-name>
   ```

### Debug Mode

Enable debug logging:

```dart
// In main.dart
import 'package:flutter/foundation.dart';

void main() {
  if (kDebugMode) {
    // Enable debug logging
    debugPrint('Debug mode enabled');
  }
  runApp(MyApp());
}
```

### Performance Issues

1. **Memory Issues**

   - Use `flutter run --profile` for profiling
   - Check for memory leaks
   - Optimize image loading

2. **Build Time Issues**
   - Use `--no-sound-null-safety` if needed
   - Enable incremental builds
   - Use build cache

## Environment Configuration

### Development Environment

```env
# .env.development
API_BASE_URL=http://localhost:5000/api
SOCKET_URL=http://localhost:5000
DEBUG_MODE=true
LOG_LEVEL=debug
```

### Production Environment

```env
# .env.production
API_BASE_URL=https://api.praniti.com/api
SOCKET_URL=https://api.praniti.com
DEBUG_MODE=false
LOG_LEVEL=error
```

## Security Considerations

1. **API Keys**

   - Never commit API keys to version control
   - Use environment variables
   - Implement key rotation

2. **Authentication**

   - Use secure token storage
   - Implement token refresh
   - Handle logout properly

3. **Data Protection**
   - Encrypt sensitive data
   - Use secure communication (HTTPS)
   - Implement proper session management

## Monitoring and Analytics

### Crash Reporting

```dart
// Add to main.dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize crash reporting
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(MyApp());
}
```

### Performance Monitoring

```dart
// Add performance monitoring
import 'package:firebase_performance/firebase_performance.dart';

// Track custom traces
final trace = FirebasePerformance.instance.newTrace('custom_trace');
await trace.start();
// Your code here
await trace.stop();
```

## Support and Resources

### Documentation

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design](https://material.io/design)

### Community

- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [GitHub Issues](https://github.com/flutter/flutter/issues)

### Tools

- [Flutter Inspector](https://flutter.dev/docs/development/tools/flutter-inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [Flutter Performance](https://flutter.dev/docs/perf)

---

**Need Help?** Contact the development team or check the troubleshooting section above.




