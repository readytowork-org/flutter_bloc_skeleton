import 'package:flutter/foundation.dart';
import 'package:no_screenshot/no_screenshot.dart';

class SecurityService {
  // We set this to true by default so that screenshot/screen record protection
  // works out-of-the-box on your emulators and test devices during development!
  // Note: If you test on an iOS Simulator, set this to false to avoid the blank/white screen.
  static bool enableInDebug = true;

  static final _noScreenshot = NoScreenshot.instance;

  static Future<void> enable() async {
    // if (kDebugMode && !enableInDebug) return;

    try {
      bool isoff = await _noScreenshot.screenshotOff();
      debugPrint("Screenshot off: $isoff");
    } catch (e) {
      debugPrint("Security error: $e");
    }
  }

  static Future<void> disable() async {
    if (kDebugMode && !enableInDebug) return;

    try {
      await _noScreenshot.screenshotOn();
    } catch (e) {
      debugPrint("Disable error: $e");
    }
  }
}
