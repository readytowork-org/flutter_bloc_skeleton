import '../../../../core/network/api_result.dart';
import '../entities/token_entity.dart';
import '../repositories/auth_repository.dart';

class SessionUseCase {
  final AuthRepository _repository;

  SessionUseCase(this._repository);

  Future<ApiResult<TokenEntity>> call() async {
    return await _repository.getCurrentSession();
  }
}
