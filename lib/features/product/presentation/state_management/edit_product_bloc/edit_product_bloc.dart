import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/typedf/index.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repository/product_repository.dart';

part 'edit_product_event.dart';
part 'edit_product_state.dart';

class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  final ProductRepository _repository;
  EditProductBloc({required ProductRepository repository})
    : _repository = repository,
      super(EditProductState.initial()) {
    on<UpdatedProductRequested>(_onUpdatedProductRequested);
  }
  Future<void> _onUpdatedProductRequested(
    UpdatedProductRequested event,
    Emitter<EditProductState> emit,
  ) async {
    emit(const EditProductState.loading());
    final result = await _repository.updateProduct(
      event.productData,
      id: event.id,
    );
    result.when(
      success: (product) => emit(EditProductState.success(product: product)),
      failure: (failure) =>
          emit(EditProductState.failure(message: failure.message)),
    );
  }
}
