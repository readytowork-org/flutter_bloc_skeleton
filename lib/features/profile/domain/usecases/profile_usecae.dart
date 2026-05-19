import '../../../../core/network/api_result.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../repository/profile_repository.dart';

class ProfileUseCase {
  final ProfileRepository _repository;

  ProfileUseCase({required ProfileRepository repository})
    : _repository = repository;

  Future<ApiResult<UserEntity>> call() async {
    return await _repository.getProfile();
  }
}
