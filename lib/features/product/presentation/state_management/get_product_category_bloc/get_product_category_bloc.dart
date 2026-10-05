import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../../core/network/api_result.dart';
import '../../../../../shared/state/base_state.dart';
import '../../../domain/entities/product_category_entity.dart';

import '../../../domain/usecases/product_category_usecase.dart';

part 'get_product_category_event.dart';
part 'get_product_category_state.dart';
part 'get_product_category_bloc.freezed.dart';

class GetProductCategoryBloc
    extends Bloc<GetProductCategoryEvent, GetProductCategoryState> {
  final ProductCategoryUseCase _productCategoryUseCase;

  GetProductCategoryBloc({
    required ProductCategoryUseCase productCategoryUseCase,
  }) : _productCategoryUseCase = productCategoryUseCase,
       super(GetProductCategoryState.initial()) {
    on<GetProductCategoryRequested>(_onGetProductCategoryRequested);
  }
  Future<void> _onGetProductCategoryRequested(
    GetProductCategoryRequested event,
    Emitter<GetProductCategoryState> emit,
  ) async {
    final result = await _productCategoryUseCase();

    result.when(
      success: (res) => emit(GetProductCategoryState.loaded(res: res)),
      failure: (failure) =>
          emit(GetProductCategoryState.failure(message: failure.message)),
    );
  }
}
