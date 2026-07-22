import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart' show TokenStorage;
import '../../../../core/utils/strings/index.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _client;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._client, this._tokenStorage);

  @override
  Future<ApiResult<UserEntity>> login(String username, String password) async {
    try {
      final response = await _client.post(
        ApiEndpoints.login,
        data: {'username': username, 'password': password, 'expiresInMins': 1},
      );
      final userModel = UserModel.fromJson(response.data);
      if (userModel.accessToken != null || userModel.refreshToken != null) {
        await _tokenStorage.saveTokens(
          accessToken: userModel.accessToken ?? emptyString,
          refreshToken: userModel.refreshToken ?? emptyString,
        );
      }
      return ApiResult.success(userModel.toEntity());
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<UserEntity>> signUp(
    String fullName,
    String email,
    String password,
  ) {
    // TODO: implement signUp
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<TokenEntity>> getCurrentSession() async {
    try {
      final tokenEntity = TokenEntity(
        accessToken: await _tokenStorage.getAccessToken(),
        refreshToken: await _tokenStorage.getRefreshToken(),
      );
      if (tokenEntity.accessToken != null || tokenEntity.refreshToken != null) {
        return ApiResult.success(tokenEntity);
      } else {
        return ApiResult.failure(ServerFailure("No active session found"));
      }
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> logout() async {
    try {
      await _tokenStorage.clearTokens();
      return ApiResult.success("Logged out successfully");
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}
