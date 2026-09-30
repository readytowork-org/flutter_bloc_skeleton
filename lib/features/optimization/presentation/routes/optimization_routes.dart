import 'package:go_router/go_router.dart';
import '../pages/optimization_settings_page.dart';
import '../pages/auto_download_demo_page.dart';

class OptimizationRoutes {
  static const String optimizationSettings = '/optimization-settings';
  static const String autoDownloadDemo = '/auto-download-demo';

  static List<RouteBase> get routes => [
    GoRoute(
      path: optimizationSettings,
      builder: (context, state) => const OptimizationSettingsPage(),
    ),
    GoRoute(
      path: autoDownloadDemo,
      builder: (context, state) => const AutoDownloadDemoPage(),
    ),
  ];
}
