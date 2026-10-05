import '../../../../core/network/api_result.dart';
import '../../../../core/utils/typedf/index.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;

  LoginUseCase(this._repository);

  Future<ApiResult<UserEntity>> call(JsonMap userMap) async {
    return await _repository.login(userMap['username'], userMap['password']);
  }
}
