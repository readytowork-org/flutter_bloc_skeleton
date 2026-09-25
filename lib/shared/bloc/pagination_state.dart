part of 'base_pagination_bloc.dart';

final class PaginationState<T> extends Equatable {
  const PaginationState({
    this.data = const [],
    this.status = PaginationStatus.initial,
    this.error,
    this.hasReachedMax = false,
  });

  final List<T> data;
  final PaginationStatus status;
  final String? error;
  final bool hasReachedMax;

  PaginationState<T> copyWith({
    List<T>? data,
    PaginationStatus? status,
    String? error,
    bool? hasReachedMax,
  }) {
    return PaginationState<T>(
      data: data ?? this.data,
      status: status ?? this.status,
      error: error ?? this.error,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [data, status, error, hasReachedMax];
}
