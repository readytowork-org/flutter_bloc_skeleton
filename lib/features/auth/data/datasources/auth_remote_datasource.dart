import '../../domain/entities/token_entity.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
  Future<void> forgotPassword(String email);
  Future<TokenEntity> refreshToken(String token);
  Future<TokenEntity> getCurrentSession();
}
