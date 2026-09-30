import '../../../../core/network/api_result.dart';
import '../../../../core/utils/typedf/index.dart';
import '../entities/product_entity.dart';
import '../repository/product_repository.dart';

class EditProductUseCase {
  final ProductRepository _repository;

  EditProductUseCase({required ProductRepository repository})
    : _repository = repository;

  Future<ApiResult<ProductEntity>> call(
    JsonMap product, {
    required String id,
  }) async {
    return await _repository.updateProduct(product, id: id);
  }
}
