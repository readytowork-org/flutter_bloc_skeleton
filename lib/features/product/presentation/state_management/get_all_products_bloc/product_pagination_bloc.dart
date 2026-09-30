import '../../../../../core/network/api_result.dart';
import '../../../../../shared/bloc/base_pagination_bloc.dart';
import '../../../../../shared/models/pagination_params.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_all_product_usecase.dart';

class ProductPaginationBloc extends BasePaginationBloc<ProductEntity> {
  final GetAllProductsUseCase _productUsecase;

  ProductPaginationBloc({required GetAllProductsUseCase productUsecase})
    : _productUsecase = productUsecase;

  @override
  Future<ApiResult<PaginatedData<ProductEntity>>> fetchItems(
    PaginationParams params,
  ) async {
    final result = await _productUsecase.call(params);

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
