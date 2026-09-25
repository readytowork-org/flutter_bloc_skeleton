part of 'add_product_bloc.dart';

sealed class AddProductEvent extends Equatable {
  const AddProductEvent();

  const factory AddProductEvent.started() = _Started;
  const factory AddProductEvent.addProductRequested({
    required JsonMap productData,
  }) = AddProductRequested;

  @override
  List<Object?> get props => [];
}

final class _Started extends AddProductEvent {
  const _Started();
}

final class AddProductRequested extends AddProductEvent {
  const AddProductRequested({required this.productData});

  final JsonMap productData;

  @override
  List<Object?> get props => [productData];
}
