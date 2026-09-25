part of 'get_product_by_id_bloc.dart';

sealed class GetProductByIdState extends Equatable implements BaseState {
  const GetProductByIdState();

  const factory GetProductByIdState.initial() = ProductInitial;
  const factory GetProductByIdState.loading() = ProductLoading;
  const factory GetProductByIdState.loaded({required ProductEntity res}) =
      ProductLoaded;
  const factory GetProductByIdState.failure({required String message}) =
      ProductFailure;
  const factory GetProductByIdState.empty() = ProductEmpty;

  @override
  List<Object?> get props => [];
}

final class ProductInitial extends GetProductByIdState implements BaseInitial {
  const ProductInitial();
}

final class ProductLoading extends GetProductByIdState implements BaseLoading {
  const ProductLoading();
}

final class ProductLoaded extends GetProductByIdState
    implements BaseLoaded<ProductEntity> {
  const ProductLoaded({required this.res});

  @override
  final ProductEntity res;

  @override
  List<Object?> get props => [res];
}

final class ProductFailure extends GetProductByIdState implements BaseFailure {
  const ProductFailure({required this.message});

  @override
  final String message;

  @override
  List<Object?> get props => [message];
}

final class ProductEmpty extends GetProductByIdState implements BaseEmpty {
  const ProductEmpty();
}
