import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/network/api_result.dart';
import '../../../../../shared/state/base_state.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_product_by_id_usecase.dart';

part 'get_product_by_id_event.dart';
part 'get_product_by_id_state.dart';
part 'get_product_by_id_bloc.freezed.dart';

class GetProductByIdBloc
    extends Bloc<GetProductByIdEvent, GetProductByIdState> {
  final GetProductByIdUseCase _productUsecase;

  GetProductByIdBloc({required GetProductByIdUseCase productUsecase})
    : _productUsecase = productUsecase,
      super(GetProductByIdState.initial()) {
    on<GetProductByIdRequested>(_onGetProductByIdRequested);
    on<ProductUpdatedLocally>(_updateProductLocally);
  }
  Future<void> _onGetProductByIdRequested(
    GetProductByIdRequested event,
    Emitter<GetProductByIdState> emit,
  ) async {
    final currentState = state;
    final bool isAlreadyLoaded =
        currentState is ProductLoaded &&
        currentState.res.id.toString() == event.id;

    if (!isAlreadyLoaded) {
      emit(const GetProductByIdState.loading());
    }

    final result = await _productUsecase(event.id);

    result.when(
      success: (res) => emit(GetProductByIdState.loaded(res: res)),
      failure: (failure) =>
          emit(GetProductByIdState.failure(message: failure.message)),
    );
  }

  Future<void> _updateProductLocally(
    ProductUpdatedLocally event,
    Emitter<GetProductByIdState> emit,
  ) async {
    log(
      'GetProductByIdBloc: Updating product locally. New Title: ${event.product.title}',
    );
    emit(GetProductByIdState.loaded(res: event.product));
  }
}
