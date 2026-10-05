import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/network/api_result.dart';
import '../../core/utils/enum/index.dart';
import '../models/pagination_params.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';
part 'base_pagination_bloc.freezed.dart';

abstract class BasePaginationBloc<T>
    extends Bloc<PaginationEvent, PaginationState<T>> {
  final PaginationParams params;
  void Function(int page, List<T> data)? onPageLoaded;

  BasePaginationBloc({PaginationParams? initialParams})
    : params = initialParams ?? PaginationParams(pageSize: 20),
      super(PaginationState<T>()) {
    on<PaginationFetch>(_onPaginationFetch);
    on<PaginationRefresh>(_onPaginationRefresh);
    on<PaginationUpdateLocally>(_onPaginationUpdateLocally);
  }

  /// Fetch items from the repository. Must be implemented by subclasses.
  Future<ApiResult<PaginatedData<T>>> fetchItems(PaginationParams params);

  Future<void> _onPaginationFetch(
    PaginationFetch event,
    Emitter<PaginationState<T>> emit,
  ) async {
    // Stop if already loading or reached the end
    if (state.status == PaginationStatus.loading || state.hasReachedMax) return;

    emit(state.copyWith(status: PaginationStatus.loading));

    final result = await fetchItems(params);

    result.when(
      success: (paginatedData) {
        final List<T> allItems = [...state.data, ...paginatedData.items];
        final bool isEnd = paginatedData.isEnd || paginatedData.items.isEmpty;

        emit(
          state.copyWith(
            status: PaginationStatus.success,
            data: allItems,
            hasReachedMax: isEnd,
          ),
        );

        // Trigger external callback
        onPageLoaded?.call(params.page, paginatedData.items);

        // Prepare parameters for the next page
        params.page++;
        params.skip = allItems.length;
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: PaginationStatus.failure,
            error: failure.message,
          ),
        );
      },
    );
  }

  Future<void> _onPaginationRefresh(
    PaginationRefresh event,
    Emitter<PaginationState<T>> emit,
  ) async {
    params.page = 1;
    params.skip = 0;

    emit(
      state.copyWith(
        status: PaginationStatus.initial,
        data: [],
        hasReachedMax: false,
      ),
    );

    add(const PaginationFetch());
  }

  Future<void> _onPaginationUpdateLocally(
    PaginationUpdateLocally event,
    Emitter<PaginationState<T>> emit,
  ) async {
    if (state.status != PaginationStatus.success) return;
    final List<T> updatedData = state.data.map((item) {
      // Assuming T has an 'id' property. You may need to adjust this logic
      // based on your actual data structure.
      if ((item as dynamic)?.id == event.data?.id) {
        // Update the item locally. You can customize this logic as needed.
        return event.data as T;
      }
      return item;
    }).toList();
    emit(state.copyWith(data: updatedData));
  }
}

class PaginatedData<T> {
  final List<T> items;
  final bool isEnd;

  PaginatedData({required this.items, required this.isEnd});
}
