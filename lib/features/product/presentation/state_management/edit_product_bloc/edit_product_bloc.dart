import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/network/api_result.dart';
import '../../../../../core/utils/typedf/index.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/edit_product_usecase.dart';

part 'edit_product_event.dart';
part 'edit_product_state.dart';
part 'edit_product_bloc.freezed.dart';

class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  final EditProductUseCase _editProductUseCase;
  EditProductBloc({required EditProductUseCase editProductUseCase})
    : _editProductUseCase = editProductUseCase,
      super(EditProductState.initial()) {
    on<UpdatedProductRequested>(_onUpdatedProductRequested);
  }
  Future<void> _onUpdatedProductRequested(
    UpdatedProductRequested event,
    Emitter<EditProductState> emit,
  ) async {
    emit(const EditProductState.loading());
    final result = await _editProductUseCase(event.productData, id: event.id);
    result.when(
      success: (product) => emit(EditProductState.success(product: product)),
      failure: (failure) =>
          emit(EditProductState.failure(message: failure.message)),
    );
  }
}
