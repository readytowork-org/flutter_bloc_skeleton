import '../../../../core/network/api_result.dart';
import '../../../../shared/models/pagination_params.dart';
import '../entities/product_entity.dart';
import '../repository/product_repository.dart';

class GetAllProductsUseCase {
  final ProductRepository _repository;

  GetAllProductsUseCase({required ProductRepository repository})
    : _repository = repository;

  Future<ApiResult<ProductResponseEntity>> call(PaginationParams params) async {
    return await _repository.getAllProducts(params);
  }
}
