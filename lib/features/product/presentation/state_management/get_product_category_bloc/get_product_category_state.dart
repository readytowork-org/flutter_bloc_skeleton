part of 'get_product_category_bloc.dart';

sealed class GetProductCategoryState extends Equatable implements BaseState {
  const GetProductCategoryState();

  const factory GetProductCategoryState.initial() = ProductCategoryInitial;
  const factory GetProductCategoryState.loading() = ProductCategoryLoading;
  const factory GetProductCategoryState.loaded({
    required List<ProductCategoryEntity> res,
  }) = ProductCategoryLoaded;
  const factory GetProductCategoryState.failure({required String message}) =
      ProductCategoryFailure;
  const factory GetProductCategoryState.empty() = ProductCategoryEmpty;

  @override
  List<Object?> get props => [];
}

final class ProductCategoryInitial extends GetProductCategoryState
    implements BaseInitial {
  const ProductCategoryInitial();
}

final class ProductCategoryLoading extends GetProductCategoryState
    implements BaseLoading {
  const ProductCategoryLoading();
}

final class ProductCategoryLoaded extends GetProductCategoryState
    implements BaseLoaded<List<ProductCategoryEntity>> {
  const ProductCategoryLoaded({required this.res});

  @override
  final List<ProductCategoryEntity> res;

  @override
  List<Object?> get props => [res];
}

final class ProductCategoryFailure extends GetProductCategoryState
    implements BaseFailure {
  const ProductCategoryFailure({required this.message});

  @override
  final String message;

  @override
  List<Object?> get props => [message];
}

final class ProductCategoryEmpty extends GetProductCategoryState
    implements BaseEmpty {
  const ProductCategoryEmpty();
}
