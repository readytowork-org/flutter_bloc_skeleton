import '../../../../core/utils/typedf/index.dart';
import '../../../../shared/models/pagination_params.dart';
import '../models/product_category_model.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductResponseM> getAllProducts(PaginationParams paginationParams);
  Future<ProductM> getProductById(String id);
  Future<ProductM> addProduct(JsonMap product);
  Future<ProductM> updateProduct(JsonMap product, {required String id});
  Future<List<ProductCategoryM>> getAllCategories();
}
