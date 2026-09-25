import '../../../../../core/network/api_result.dart';
import '../../../../../shared/bloc/base_pagination_bloc.dart';
import '../../../../../shared/models/pagination_params.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repository/product_repository.dart';

class ProductPaginationBloc extends BasePaginationBloc<ProductEntity> {
  final ProductRepository _repository;

  ProductPaginationBloc({required ProductRepository repository})
    : _repository = repository;

  @override
  Future<ApiResult<PaginatedData<ProductEntity>>> fetchItems(
    PaginationParams params,
  ) async {
    final result = await _repository.getAllProducts(params);

    return result.when(
      success: (response) {
        return ApiResult.success(
          PaginatedData<ProductEntity>(
            items: response.products,
            isEnd:
                (state.data.length + response.products.length) >=
                response.total,
          ),
        );
      },
      failure: (failure) => ApiResult.failure(failure),
    );
  }
}
