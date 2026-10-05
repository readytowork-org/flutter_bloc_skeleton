import '../../../../core/network/api_result.dart';
import '../entities/token_entity.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenUseCase {
  final AuthRepository _repository;

  RefreshTokenUseCase(this._repository);

  Future<ApiResult<TokenEntity>> call(String token) async {
    return await _repository.refreshToken(token);
  }
}
