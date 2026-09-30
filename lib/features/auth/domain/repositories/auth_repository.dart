import '../../../../core/network/api_result.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<ApiResult<UserEntity>> login(String username, String password);
  Future<ApiResult<UserEntity>> signUp(
    String fullName,
    String email,
    String password,
  );
  Future<ApiResult<UserEntity>> getCurrentSession();
  Future<ApiResult<String>> logout();
}
