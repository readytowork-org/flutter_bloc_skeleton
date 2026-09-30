import '../../../../core/network/api_result.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  Future<ApiResult<String>> call(String email) {
    return _repository.forgotPassword(email);
  }
}
