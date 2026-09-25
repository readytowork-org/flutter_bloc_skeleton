part of 'get_product_category_bloc.dart';

sealed class GetProductCategoryEvent extends Equatable {
  const GetProductCategoryEvent();

  const factory GetProductCategoryEvent.started() = _Started;
  const factory GetProductCategoryEvent.getProductCategoryRequested() =
      GetProductCategoryRequested;

  @override
  List<Object?> get props => [];
}

final class _Started extends GetProductCategoryEvent {
  const _Started();
}

final class GetProductCategoryRequested extends GetProductCategoryEvent {
  const GetProductCategoryRequested();
}
