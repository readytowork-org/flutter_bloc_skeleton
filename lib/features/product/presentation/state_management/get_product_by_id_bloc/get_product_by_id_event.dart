part of 'get_product_by_id_bloc.dart';

@freezed
class GetProductByIdEvent with _$GetProductByIdEvent {
  const factory GetProductByIdEvent.started() = _Started;
  const factory GetProductByIdEvent.getProductByIdRequested({
    required String id,
  }) = GetProductByIdRequested;

  /// Update local state only
  const factory GetProductByIdEvent.productUpdatedLocally({
    required ProductEntity product,
  }) = ProductUpdatedLocally;
}
