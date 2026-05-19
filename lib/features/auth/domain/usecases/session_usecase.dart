import '../../../../core/network/api_result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SessionUseCase {
  final AuthRepository _repository;

  SessionUseCase(this._repository);

  Future<ApiResult<UserEntity>> call() async {
    return await _repository.getCurrentSession();
  }
}
