import '../../../../core/network/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResult<UserEntity>> login(String email, String password) async {
    try {
      final userMap = {'email': email, 'password': password};

      final userModel = await _remoteDataSource.login(userMap);
      return ApiResult.success(userModel.toEntity());
    } catch (e) {
      // Catches the generic exceptions thrown by the Firebase DataSource
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<UserEntity>> signUp(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      final userMap = {
        'email': email,
        'password': password,
        'displayName': fullName,
      };

      final userModel = await _remoteDataSource.signup(userMap);
      return ApiResult.success(userModel.toEntity());
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<UserEntity>> getCurrentSession() async {
    try {
      final userModel = await _remoteDataSource.getCurrentSession();

      if (userModel != null) {
        return ApiResult.success(userModel.toEntity());
      } else {
        return ApiResult.failure(
          const ServerFailure("No active Firebase session found"),
        );
      }
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<String>> logout() async {
    try {
      await _remoteDataSource.logout();
      return const ApiResult.success("Logged out successfully from Firebase");
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}
