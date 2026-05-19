import 'package:dio/dio.dart';

import '../../../../core/network/api_result.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/utils/index.dart';
import '../../../../shared/models/pagination_params.dart';
import '../../domain/entities/product_category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repository/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _productApiService;

  ProductRepositoryImpl(ProductRemoteDataSource productApiService)
    : _productApiService = productApiService;

  @override
  Future<ApiResult<ProductResponseEntity>> getAllProducts(
    PaginationParams paginationParams,
  ) async {
    try {
      final responseM = await _productApiService.getAllProducts(
        paginationParams,
      );
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
      final responseM = await _productApiService.getProductById(id);
      return ApiResult.success(responseM.toEntity());
    } on DioException catch (e) {
      return ApiResult.failure(handleDioError(e));
    }
  }

  @override
  Future<ApiResult<ProductEntity>> addProduct(JsonMap product) async {
    try {
      final responseM = await _productApiService.addProduct(product);
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
      final responseM = await _productApiService.updateProduct(product, id: id);
      return ApiResult.success(responseM.toEntity());
    } on DioException catch (e) {
      return ApiResult.failure(handleDioError(e));
    }
  }

  @override
  Future<ApiResult<List<ProductCategoryEntity>>> getAllCategories() async {
    try {
      final responseM = await _productApiService.getAllCategories();
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
