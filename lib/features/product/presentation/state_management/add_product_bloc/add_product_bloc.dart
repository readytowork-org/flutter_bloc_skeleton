import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/typedf/index.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/repository/product_repository.dart';

part 'add_product_event.dart';
part 'add_product_state.dart';

class AddProductBloc extends Bloc<AddProductEvent, AddProductState> {
  final ProductRepository _repository;
  AddProductBloc({required ProductRepository repository})
    : _repository = repository,
      super(AddProductState.initial()) {
    on<AddProductRequested>(_onAddProductRequested);
  }
  Future<void> _onAddProductRequested(
    AddProductRequested event,
    Emitter<AddProductState> emit,
  ) async {
    emit(AddProductState.loading());
    final result = await _repository.addProduct(event.productData);
    result.when(
      success: (product) => emit(AddProductState.success(product: product)),
      failure: (failure) =>
          emit(AddProductState.failure(message: failure.message)),
    );
  }
}
