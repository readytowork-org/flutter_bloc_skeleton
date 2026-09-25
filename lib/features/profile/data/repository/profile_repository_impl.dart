import '../../../../core/error/failures.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../../auth/data/models/user_model.dart';
import '../../domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final DioClient _client;

  ProfileRepositoryImpl(this._client);

  @override
  Future<ApiResult<UserEntity>> getProfile() async {
    try {
      final response = await _client.get(ApiEndpoints.profile);
      final userModel = UserModel.fromJson(response.data);
      return ApiResult.success(userModel.toEntity());
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}
