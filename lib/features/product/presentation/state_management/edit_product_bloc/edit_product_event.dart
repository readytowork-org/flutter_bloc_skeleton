part of 'edit_product_bloc.dart';

sealed class EditProductEvent extends Equatable {
  const EditProductEvent();

  const factory EditProductEvent.started() = _Started;
  const factory EditProductEvent.updatedProductRequested({
    required JsonMap productData,
    required String id,
  }) = UpdatedProductRequested;

  @override
  List<Object?> get props => [];
}

final class _Started extends EditProductEvent {
  const _Started();
}

final class UpdatedProductRequested extends EditProductEvent {
  const UpdatedProductRequested({required this.productData, required this.id});

  final JsonMap productData;
  final String id;

  @override
  List<Object?> get props => [productData, id];
}
