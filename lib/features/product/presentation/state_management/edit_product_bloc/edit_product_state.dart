part of 'edit_product_bloc.dart';

@freezed
class EditProductState with _$EditProductState {
  const factory EditProductState.initial() = EditProductInitial;
  const factory EditProductState.loading() = EditProductLoading;
  const factory EditProductState.success({required ProductEntity product}) =
      EditProductSuccess;
  const factory EditProductState.failure({required String message}) =
      EditProductFailure;
}
