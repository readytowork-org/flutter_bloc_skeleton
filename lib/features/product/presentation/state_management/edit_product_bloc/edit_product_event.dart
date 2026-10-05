part of 'edit_product_bloc.dart';

@freezed
class EditProductEvent with _$EditProductEvent {
  const factory EditProductEvent.started() = _Started;
  const factory EditProductEvent.updatedProductRequested({
    required JsonMap productData,
    required String id,
  }) = UpdatedProductRequested;
}
