part of 'edit_product_bloc.dart';

sealed class EditProductState extends Equatable {
  const EditProductState();

  const factory EditProductState.initial() = EditProductInitial;
  const factory EditProductState.loading() = EditProductLoading;
  const factory EditProductState.success({required ProductEntity product}) =
      EditProductSuccess;
  const factory EditProductState.failure({required String message}) =
      EditProductFailure;

  @override
  List<Object?> get props => [];
}

final class EditProductInitial extends EditProductState {
  const EditProductInitial();
}

final class EditProductLoading extends EditProductState {
  const EditProductLoading();
}

final class EditProductSuccess extends EditProductState {
  const EditProductSuccess({required this.product});

  final ProductEntity product;

  @override
  List<Object?> get props => [product];
}

final class EditProductFailure extends EditProductState {
  const EditProductFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
