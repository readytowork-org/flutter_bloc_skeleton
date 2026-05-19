part of 'get_product_by_id_bloc.dart';

@freezed
class GetProductByIdState with _$GetProductByIdState implements BaseState {
  @Implements<BaseInitial>()
  const factory GetProductByIdState.initial() = ProductInitial;

  @Implements<BaseLoading>()
  const factory GetProductByIdState.loading() = ProductLoading;

  @Implements<BaseLoaded<ProductEntity>>()
  const factory GetProductByIdState.loaded({required ProductEntity res}) =
      ProductLoaded;

  @Implements<BaseFailure>()
  const factory GetProductByIdState.failure({required String message}) =
      ProductFailure;

  @Implements<BaseEmpty>()
  const factory GetProductByIdState.empty() = ProductEmpty;
}
