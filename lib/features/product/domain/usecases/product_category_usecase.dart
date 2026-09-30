import '../../../../core/network/api_result.dart';
import '../entities/product_category_entity.dart';
import '../repository/product_repository.dart';

class ProductCategoryUseCase {
  final ProductRepository _repository;

  ProductCategoryUseCase({required ProductRepository repository})
    : _repository = repository;

  Future<ApiResult<List<ProductCategoryEntity>>> call() async {
    return await _repository.getAllCategories();
  }
}
