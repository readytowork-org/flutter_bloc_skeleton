import '../../../../core/network/api_result.dart';
import '../../../../core/utils/typedf/index.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository _repository;

  SignupUseCase(this._repository);

  Future<ApiResult<UserEntity>> call(JsonMap userMap) async {
    return await _repository.signUp(
      userMap['fullName'],
      userMap['email'],
      userMap['password'],
    );
  }
}
