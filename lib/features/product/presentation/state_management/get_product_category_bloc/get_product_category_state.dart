part of 'get_product_category_bloc.dart';

@freezed
class GetProductCategoryState
    with _$GetProductCategoryState
    implements BaseState {
  @Implements<BaseInitial>()
  const factory GetProductCategoryState.initial() = ProductCategoryInitial;

  @Implements<BaseLoading>()
  const factory GetProductCategoryState.loading() = ProductCategoryLoading;

  @Implements<BaseLoaded<List<ProductCategoryEntity>>>()
  const factory GetProductCategoryState.loaded({
    required List<ProductCategoryEntity> res,
  }) = ProductCategoryLoaded;

  @Implements<BaseFailure>()
  const factory GetProductCategoryState.failure({required String message}) =
      ProductCategoryFailure;

  @Implements<BaseEmpty>()
  const factory GetProductCategoryState.empty() = ProductCategoryEmpty;
}
