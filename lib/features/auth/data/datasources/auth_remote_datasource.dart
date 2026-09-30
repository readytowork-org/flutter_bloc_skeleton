import '../../../../core/utils/typedf/index.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(JsonMap user);
  Future<UserModel> signup(JsonMap user);
  Future<UserModel?> getCurrentSession();
  Future<void> logout();
}
