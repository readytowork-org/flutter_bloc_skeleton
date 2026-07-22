import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../shared/state/base_state.dart';
import '../../../domain/entities/product_category_entity.dart';

import '../../../domain/repository/product_repository.dart';

part 'get_product_category_event.dart';
part 'get_product_category_state.dart';

class GetProductCategoryBloc
    extends Bloc<GetProductCategoryEvent, GetProductCategoryState> {
  final ProductRepository _repository;

  GetProductCategoryBloc({required ProductRepository repository})
    : _repository = repository,
      super(GetProductCategoryState.initial()) {
    on<GetProductCategoryRequested>(_onGetProductCategoryRequested);
  }
  Future<void> _onGetProductCategoryRequested(
    GetProductCategoryRequested event,
    Emitter<GetProductCategoryState> emit,
  ) async {
    final result = await _repository.getAllCategories();

    result.when(
      success: (res) => emit(GetProductCategoryState.loaded(res: res)),
      failure: (failure) =>
          emit(GetProductCategoryState.failure(message: failure.message)),
    );
  }
}
