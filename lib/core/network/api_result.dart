import 'package:equatable/equatable.dart';

import '../error/failures.dart';

sealed class ApiResult<T> extends Equatable {
  const ApiResult();

  const factory ApiResult.success(T data) = Success<T>;
  const factory ApiResult.failure(Failure failure) = Error<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  });
}

final class Success<T> extends ApiResult<T> {
  const Success(this.data);

  final T data;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) => success(data);

  @override
  List<Object?> get props => [data];
}

final class Error<T> extends ApiResult<T> {
  const Error(this.failure);

  final Failure failure;

  @override
  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) => failure(this.failure);

  @override
  List<Object?> get props => [failure];
}
