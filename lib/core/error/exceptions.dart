sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  const NetworkException(super.message);
}

final class RefreshTokenExpiredException extends AppException {
  const RefreshTokenExpiredException()
    : super('Refresh token has expired. User must log in again.');
}

final class ServerException extends AppException {
  final int? statusCode;
  const ServerException(super.message, {this.statusCode});
}

final class UnauthorizedException extends AppException {
  const UnauthorizedException() : super('Unauthorized access.');
}

final class StorageException extends AppException {
  const StorageException(super.message);
}
