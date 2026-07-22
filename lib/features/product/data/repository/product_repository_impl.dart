import 'package:dio/dio.dart';

import '../../../../core/network/api_result.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/index.dart';
import '../../../../shared/models/pagination_params.dart';
import '../../domain/entities/product_category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repository/product_repository.dart';
import '../models/product_category_model.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final DioClient _client;

  ProductRepositoryImpl(this._client);

  @override
  Future<ApiResult<ProductResponseEntity>> getAllProducts(
    PaginationParams paginationParams,
  ) async {
    try {
      final skip =
          paginationParams.skip ??
          (paginationParams.page - 1) * paginationParams.pageSize;
      final filter = paginationParams.filter;
      final path = filter == null || filter.contains('All')
          ? filter?.contains('Search') == true
                ? ApiEndpoints.getProducts.addId(filter)
                : ApiEndpoints.getProducts
          : ApiEndpoints.getProducts.addId(filter);
      final response = await _client.get(
        path,
        queryParameters: {'limit': paginationParams.pageSize, 'skip': skip},
      );
      final responseM = ProductResponseM.fromJson(response.data);
      final products = responseM.data.map((m) => m.toEntity()).toList();
      return ApiResult.success(
        ProductResponseEntity(products: products, total: responseM.count),
      );
    } on DioException catch (e) {
      return ApiResult.failure(handleDioError(e));
    }
  }

  @override
  Future<ApiResult<ProductEntity>> getProductById(String id) async {
    try {
      final response = await _client.get(ApiEndpoints.getProducts.addId(id));
      final responseM = ProductM.fromJson(response.data);
      return ApiResult.success(responseM.toEntity());
    } on DioException catch (e) {
      return ApiResult.failure(handleDioError(e));
    }
  }

  @override
  Future<ApiResult<ProductEntity>> addProduct(JsonMap product) async {
    try {
      final response = await _client.post(
        ApiEndpoints.addProduct,
        data: product,
      );
      final responseM = ProductM.fromJson(response.data);
      return ApiResult.success(responseM.toEntity());
    } on DioException catch (e) {
      return ApiResult.failure(handleDioError(e));
    }
  }

  @override
  Future<ApiResult<ProductEntity>> updateProduct(
    JsonMap product, {
    required String id,
  }) async {
    try {
      final response = await _client.put(
        ApiEndpoints.getProducts.addId(id),
        data: product,
      );
      final responseM = ProductM.fromJson(response.data);
      return ApiResult.success(responseM.toEntity());
    } on DioException catch (e) {
      return ApiResult.failure(handleDioError(e));
    }
  }

  @override
  Future<ApiResult<List<ProductCategoryEntity>>> getAllCategories() async {
    try {
      final response = await _client.get(ApiEndpoints.productCategories);
      final responseM = ProductCategoryM.parseList(response.data);
      final categories = [
        ProductCategoryEntity(name: "All"),
        ...responseM.map((m) => m.toEntity()),
      ];

      return ApiResult.success(categories);
    } on DioException catch (e) {
      return ApiResult.failure(handleDioError(e));
    }
  }
}
