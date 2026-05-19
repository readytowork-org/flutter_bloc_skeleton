import '../../../../core/network/api_result.dart';
import '../../../../core/utils/typedf/index.dart';
import '../../../../shared/models/pagination_params.dart';
import '../entities/product_category_entity.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<ApiResult<ProductResponseEntity>> getAllProducts(
    PaginationParams paginationParams,
  );
  Future<ApiResult<ProductEntity>> getProductById(String id);
  Future<ApiResult<ProductEntity>> addProduct(JsonMap product);
  Future<ApiResult<ProductEntity>> updateProduct(
    JsonMap product, {
    required String id,
  });
  Future<ApiResult<List<ProductCategoryEntity>>> getAllCategories();
}
