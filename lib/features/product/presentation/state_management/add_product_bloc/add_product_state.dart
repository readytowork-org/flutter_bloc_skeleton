part of 'add_product_bloc.dart';

@freezed
class AddProductState with _$AddProductState {
  const factory AddProductState.initial() = AddProductInitial;
  const factory AddProductState.loading() = AddProductLoading;
  const factory AddProductState.success({required ProductEntity product}) =
      AddProductSuccess;
  const factory AddProductState.failure({required String message}) =
      AddProductFailure;
}
