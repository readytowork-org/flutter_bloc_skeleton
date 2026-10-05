import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/di/service_locator.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/token_storage.dart';
import 'data/datasources/auth_remote_datasource.dart';
import 'data/datasources/auth_remote_datasource_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/forgot_password_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/refresh_token_usecase.dart';
import 'domain/usecases/session_usecase.dart';
import 'domain/usecases/signup_usecase.dart';
import 'presentation/state_management/auth_bloc.dart';

void initAuth() {
  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<DioClient>(), sl<FlutterSecureStorage>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AuthRemoteDataSource>(), sl<TokenStorage>()),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignupUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SessionUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => LogoutUseCase(sl<AuthRepository>()));

  sl.registerLazySingleton(() => RefreshTokenUseCase(sl<AuthRepository>()));

  // Blocs
  sl.registerLazySingleton(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
      signupUseCase: sl<SignupUseCase>(),
      sessionUseCase: sl<SessionUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
    ),
  );
}
