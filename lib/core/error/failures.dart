import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server failure occurred']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache failure occurred']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Network connection failed']);
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure() : super('Unauthorized. Please log in again.');
}

final class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure()
    : super('Your session has expired. Please log in again.');
}

final class UnknownFailure extends Failure {
  const UnknownFailure() : super('An unexpected error occurred.');
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

String getFirebaseErrorMessage(String code) {
  switch (code) {
    case 'invalid-email':
      return 'The email address is invalid.';
    case 'user-disabled':
      return 'The user account has been disabled.';
    case 'user-not-found':
      return 'There is no user corresponding to the given email address.';
    case 'wrong-password':
      return 'The password is invalid for the given email address.';
    case 'invalid-credential':
      return 'The email and password is invalid.';
    default:
      return 'An unknown error occurred.';
  }
}

Failure handleDioError(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure('Connection timed out');
    case DioExceptionType.connectionError:
      return const NetworkFailure('No internet connection');
    case DioExceptionType.badResponse:
      return _handleStatusCode(e.response?.statusCode, e.response?.data);
    case DioExceptionType.unknown:
      if (e.error is SocketException) {
        return const NetworkFailure('No internet');
      }
      return const ServerFailure('An unexpected error occurred');
    default:
      return const ServerFailure();
  }
}

Failure _handleStatusCode(int? statusCode, dynamic data) {
  String message = 'Server error';
  if (data is Map) message = data['message'] ?? data['error'] ?? message;

  return switch (statusCode) {
    400 => ValidationFailure(message),
    401 => const ServerFailure('Unauthorized'),
    404 => const ServerFailure('Resource not found'),
    500 => const ServerFailure('Internal server error'),
    _ => ServerFailure('Error $statusCode: $message'),
  };
}
