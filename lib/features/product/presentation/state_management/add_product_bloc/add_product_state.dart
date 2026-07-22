part of 'add_product_bloc.dart';

sealed class AddProductState extends Equatable {
  const AddProductState();

  const factory AddProductState.initial() = AddProductInitial;
  const factory AddProductState.loading() = AddProductLoading;
  const factory AddProductState.success({required ProductEntity product}) =
      AddProductSuccess;
  const factory AddProductState.failure({required String message}) =
      AddProductFailure;

  @override
  List<Object?> get props => [];
}

final class AddProductInitial extends AddProductState {
  const AddProductInitial();
}

final class AddProductLoading extends AddProductState {
  const AddProductLoading();
}

final class AddProductSuccess extends AddProductState {
  const AddProductSuccess({required this.product});

  final ProductEntity product;

  @override
  List<Object?> get props => [product];
}

final class AddProductFailure extends AddProductState {
  const AddProductFailure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
