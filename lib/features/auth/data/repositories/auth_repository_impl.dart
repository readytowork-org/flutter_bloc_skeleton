import '../../../../core/network/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/storage/token_storage.dart' show TokenStorage;
import '../../../../core/utils/strings/index.dart';
import '../../domain/entities/token_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  AuthRepositoryImpl(this._remoteDataSource, this._tokenStorage);

  @override
  Future<ApiResult<UserEntity>> login(String username, String password) async {
    try {
      final userModel = await _remoteDataSource.login(username, password);
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
  Future<ApiResult<String>> forgotPassword(String email) async {
    try {
      await _remoteDataSource.forgotPassword(email);
      return const ApiResult.success(
        'If an account exists for this email, a password reset link will be sent.',
      );
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<TokenEntity>> refreshToken(String token) async {
    try {
      final tokenEntity = await _remoteDataSource.refreshToken(token);
      return ApiResult.success(tokenEntity);
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
      final tokenEntity = await _remoteDataSource.getCurrentSession();
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
