import '../../../../core/network/api_result.dart' show ApiResult;
import '../entities/product_entity.dart' show ProductEntity;
import '../repository/product_repository.dart' show ProductRepository;

class GetProductByIdUseCase {
  final ProductRepository _repository;

  GetProductByIdUseCase({required ProductRepository repository})
    : _repository = repository;

  Future<ApiResult<ProductEntity>> call(String id) {
    return _repository.getProductById(id);
  }
}
