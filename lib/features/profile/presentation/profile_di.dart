import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/di/service_locator.dart';
import '../data/datasources/profile_remote_datasource.dart';
import '../data/datasources/profile_remote_datasource_impl.dart';
import '../data/repository/profile_repository_impl.dart';
import '../domain/repository/profile_repository.dart';
import '../domain/usecases/profile_usecae.dart';
import 'state_management/get_profile_bloc/get_profile_bloc.dart';

void initProfile() {
  // Data sources
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(FirebaseAuth.instance),
  );
  // Repositories
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
  );

  // Use cases
  sl.registerLazySingleton(
    () => ProfileUseCase(repository: sl<ProfileRepository>()),
  );

  sl.registerFactory(
    () => GetProfileBloc(profileUseCase: sl<ProfileUseCase>()),
  );
}
