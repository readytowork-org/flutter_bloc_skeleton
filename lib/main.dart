import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_push_notification_module/fcm_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart'
    show debugPrint, runApp, WidgetsFlutterBinding;

import 'app.dart' show App;
import 'core/di/service_locator.dart' as di;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message ${message.messageId}');
}

Future<void> _initializeNotifications() async {
  final messaging = FirebaseMessaging.instance;

  try {
    if (!kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.macOS)) {
      await messaging.requestPermission();

      String? apnsToken;
      for (var attempt = 0; attempt < 20; attempt++) {
        apnsToken = await messaging.getAPNSToken();
        if (apnsToken != null) break;
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }

      if (apnsToken == null) {
        debugPrint('Skipping push notifications: APNs token is unavailable.');
        return;
      }
    }

    await di.sl<FirebaseNotificationService>().initialize();
    await messaging.subscribeToTopic('all');
  } catch (error) {
    debugPrint('Push notification setup failed: $error');
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const App());
  unawaited(_initializeNotifications());
}
