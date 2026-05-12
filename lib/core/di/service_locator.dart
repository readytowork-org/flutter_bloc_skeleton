import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_push_notification_module/fcm_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/auth.dart';
import '../../features/cart/cart_di.dart';
import '../../features/product/product_di.dart';

import '../../features/profile/presentation/profile_di.dart';
import '../../firebase_options.dart';
import '../../shared/cubit/locale_cubit.dart';
import '../routes/app_routes.dart';
import '../storage/secure_token_storage.dart';
import '../storage/token_storage.dart';
import '../network/dio_client.dart';
import '../theme/app_theme.dart';
import '../utils/extension/bloc_extension.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  sl.registerLazySingleton(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );




  /// Token Storage
  final tokenStorage = SecureTokenStorage(sl<FlutterSecureStorage>());
  await tokenStorage.init();

  sl.registerLazySingleton<TokenStorage>(() => tokenStorage);

  sl.registerLazySingleton<FirebaseNotificationService>(
    () => FirebaseNotificationService(
      FirebaseMessaging.instance,
      FlutterLocalNotificationsPlugin(),
      defaultIcon: "@mipmap/ic_launcher",
      showToken: true,
      getToken: (token) {},
      onLocalNotificationTab: (message) {},
      onFCMNotificationTab: (message) {},
    ),
  );

  sl.registerLazySingleton(() => Dio());

  sl.registerLazySingleton(
    () => DioClient(
      dio: sl<Dio>(),
      tokenStorage: sl<TokenStorage>(),
      onSessionExpired: () async {
        await sl<TokenStorage>().clearTokens();
      },
    ),
  );

  // Core / Shared
  sl.registerLazySingleton(() => AppTheme());
  sl.registerLazySingleton(() => LocaleCubit());

  // Features registration
  initAuth();
  initCart();
  initProduct();
  initProfile();

  /// Router LAST

  sl.registerLazySingleton<AppRouter>(
    () => AppRouter(
      navigatorKey: rootNavigatorKey,
      refreshListenable: sl<AuthBloc>().asListenable(),
    ),
  );
}


Future<void> initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

}