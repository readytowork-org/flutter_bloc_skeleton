part of 'get_product_category_bloc.dart';

@freezed
class GetProductCategoryEvent with _$GetProductCategoryEvent {
  const factory GetProductCategoryEvent.started() = _Started;
  const factory GetProductCategoryEvent.getProductCategoryRequested() =
      GetProductCategoryRequested;
}
