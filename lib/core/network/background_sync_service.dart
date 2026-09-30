import 'dart:developer' as dev;
import 'package:workmanager/workmanager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    dev.log("Background Task Triggered: $task");

    // Check connectivity inside the task
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity.contains(ConnectivityResult.wifi) ||
        connectivity.contains(ConnectivityResult.ethernet)) {
      dev.log("Device is on Wi-Fi. Starting background auto-downloads...");

      // MOCK: In a real app, you would fetch a list of resources to download
      // and use Dio with CacheInterceptor to save them.
      // Example:
      // final dio = Dio();
      // await dio.get('https://example.com/large-image.jpg');

      await Future.delayed(const Duration(seconds: 2)); // Simulate work
      dev.log("Background auto-downloads completed.");
      return Future.value(true);
    } else {
      dev.log("Device is NOT on Wi-Fi. Skipping background sync.");
      return Future.value(true); // Task finished successfully (skipped)
    }
  });
}

class BackgroundSyncService {
  static const String taskName = "com.example.app.backgroundSync";

  static Future<void> init() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> schedulePeriodicSync() async {
    await Workmanager().registerPeriodicTask(
      "periodic-sync-task",
      taskName,
      frequency: const Duration(hours: 1), // Minimum 15 mins for Android
      constraints: Constraints(
        networkType: NetworkType
            .connected, // WorkManager handles some level of connectivity
        requiresBatteryNotLow: true,
      ),
    );
  }

  static Future<void> cancelAll() async {
    await Workmanager().cancelAll();
  }
}
