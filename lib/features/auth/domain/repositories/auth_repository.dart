import '../../../../core/network/api_result.dart';
import '../entities/token_entity.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<ApiResult<UserEntity>> login(String username, String password);
  Future<ApiResult<String>> forgotPassword(String email);
  Future<ApiResult<UserEntity>> signUp(
    String fullName,
    String email,
    String password,
  );
  Future<ApiResult<TokenEntity>> refreshToken(String token);
  Future<ApiResult<TokenEntity>> getCurrentSession();
  Future<ApiResult<String>> logout();
}
