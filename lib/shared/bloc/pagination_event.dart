part of 'base_pagination_bloc.dart';

@freezed
class PaginationEvent<T> with _$PaginationEvent<T> {
  const factory PaginationEvent.fetch() = PaginationFetch<T>;
  const factory PaginationEvent.refresh() = PaginationRefresh<T>;
  const factory PaginationEvent.updateLocally({required T data}) =
      PaginationUpdateLocally<T>;
}
