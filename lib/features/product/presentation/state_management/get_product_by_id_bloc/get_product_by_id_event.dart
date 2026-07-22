part of 'get_product_by_id_bloc.dart';

sealed class GetProductByIdEvent extends Equatable {
  const GetProductByIdEvent();

  const factory GetProductByIdEvent.started() = _Started;
  const factory GetProductByIdEvent.getProductByIdRequested({
    required String id,
  }) = GetProductByIdRequested;

  /// Update local state only
  const factory GetProductByIdEvent.productUpdatedLocally({
    required ProductEntity product,
  }) = ProductUpdatedLocally;

  @override
  List<Object?> get props => [];
}

final class _Started extends GetProductByIdEvent {
  const _Started();
}

final class GetProductByIdRequested extends GetProductByIdEvent {
  const GetProductByIdRequested({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}

final class ProductUpdatedLocally extends GetProductByIdEvent {
  const ProductUpdatedLocally({required this.product});

  final ProductEntity product;

  @override
  List<Object?> get props => [product];
}
