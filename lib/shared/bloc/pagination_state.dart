part of 'base_pagination_bloc.dart';

@Freezed(genericArgumentFactories: true)
abstract class PaginationState<T> with _$PaginationState<T> {
  const factory PaginationState({
    @Default([]) List<T> data,
    @Default(PaginationStatus.initial) PaginationStatus status,
    String? error,
    @Default(false) bool hasReachedMax,
  }) = _PaginationState;
}
