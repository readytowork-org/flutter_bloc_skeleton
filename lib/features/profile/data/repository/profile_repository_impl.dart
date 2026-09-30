import '../../../../core/error/failures.dart';
import '../../../../core/network/api_result.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/repository/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _profileRemoteDataSource;
  ProfileRepositoryImpl(this._profileRemoteDataSource);
  @override
  Future<ApiResult<UserEntity>> getProfile() async {
    try {
      final userModel = await _profileRemoteDataSource.getProfile();
      return ApiResult.success(userModel.toEntity());
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}
