import '../../../core/di/service_locator.dart';
import '../data/repository/profile_repository_impl.dart';
import '../domain/repository/profile_repository.dart';
import 'state_management/get_profile_bloc/get_profile_bloc.dart';

void initProfile() {
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl()),
  );

  sl.registerFactory(() => GetProfileBloc(repository: sl<ProfileRepository>()));
}
