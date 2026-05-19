import '../../../../core/network/api_result.dart';
import '../../../../core/utils/typedf/index.dart';
import '../entities/product_entity.dart';
import '../repository/product_repository.dart';

class AddProductUseCase {
  final ProductRepository _repository;

  AddProductUseCase({required ProductRepository repository})
    : _repository = repository;

  Future<ApiResult<ProductEntity>> call(JsonMap product) async {
    return await _repository.addProduct(product);
  }
}
