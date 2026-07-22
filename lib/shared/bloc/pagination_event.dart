part of 'base_pagination_bloc.dart';

sealed class PaginationEvent<T> extends Equatable {
  const PaginationEvent();

  const factory PaginationEvent.fetch() = PaginationFetch<T>;
  const factory PaginationEvent.refresh() = PaginationRefresh<T>;
  const factory PaginationEvent.updateLocally({required T data}) =
      PaginationUpdateLocally<T>;

  @override
  List<Object?> get props => [];
}

final class PaginationFetch<T> extends PaginationEvent<T> {
  const PaginationFetch();
}

final class PaginationRefresh<T> extends PaginationEvent<T> {
  const PaginationRefresh();
}

final class PaginationUpdateLocally<T> extends PaginationEvent<T> {
  const PaginationUpdateLocally({required this.data});

  final T data;

  @override
  List<Object?> get props => [data];
}
