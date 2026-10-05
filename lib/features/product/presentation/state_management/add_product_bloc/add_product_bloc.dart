import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/network/api_result.dart';
import '../../../../../core/utils/typedf/index.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/add_product_usecase.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';
part 'add_product_bloc.freezed.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final AddProductUseCase _addProductUseCase;
  AddProductBloc({required AddProductUseCase addProductUseCase})
    : _addProductUseCase = addProductUseCase,
      super(AddProductState.initial()) {
    on<AddProductRequested>(_onAddProductRequested);
  }
  Future<void> _onAddProductRequested(
    AddProductRequested event,
    Emitter<AddProductState> emit,
  ) async {
    emit(AddProductState.loading());
    final result = await _addProductUseCase(event.productData);
    result.when(
      success: (product) => emit(AddProductState.success(product: product)),
      failure: (failure) =>
          emit(AddProductState.failure(message: failure.message)),
    );
  }
}
