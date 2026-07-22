import '../../core/di/service_locator.dart';
import '../../core/network/dio_client.dart';
import '../../core/storage/token_storage.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/state_management/auth_bloc.dart';

void initAuth() {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<DioClient>(), sl<TokenStorage>()),
  );

  sl.registerLazySingleton(() => AuthBloc(repository: sl<AuthRepository>()));
}
