import 'dart:io' show HttpHeaders;
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../features/auth/domain/usecases/refresh_token_usecase.dart';
import '../utils/enum/index.dart';
import 'api_endpoints.dart';
import 'api_result.dart';
import 'dio_client.dart';

class DioAuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await sl<FlutterSecureStorage>().read(
        key: SecureStorageKey.bearerToken.name,
      );
      if (token != null) {
        options.headers.addAll({
          HttpHeaders.authorizationHeader: "Bearer $token",
        });
      }
      handler.next(options);
    } catch (_) {
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.requestOptions.path == ApiEndpoints.login ||
        response.requestOptions.path == ApiEndpoints.refreshToken) {
      final data = response.data;
      if (data != null) {
        await Future.wait([
          sl<FlutterSecureStorage>().write(
            key: SecureStorageKey.bearerToken.name,
            value: data['accessToken'],
          ),
          sl<FlutterSecureStorage>().write(
            key: SecureStorageKey.refreshToken.name,
            value: data['refreshToken'],
          ),
        ]);
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final accessToken = await sl<FlutterSecureStorage>().read(
      key: SecureStorageKey.bearerToken.name,
    );

    if (err.response?.statusCode == 401 && accessToken != null) {
      final refreshToken = await sl<FlutterSecureStorage>().read(
        key: SecureStorageKey.refreshToken.name,
      );

      if (refreshToken != null) {
        final result = await sl<RefreshTokenUseCase>().call(refreshToken);

        await result.when(
          success: (tokenEntity) async {
            // New tokens are already saved by onResponse of the refresh call,
            // but we can manually ensure they are here too if needed.
            // OnResponse will handle it for ApiEndpoints.refreshToken.

            err.requestOptions.headers[HttpHeaders.authorizationHeader] =
                "Bearer ${tokenEntity.accessToken}";

            // Retry the original request
            final response = await sl<DioClient>().fetch(err.requestOptions);
            return handler.resolve(response);
          },
          failure: (failure) async {
            // If refresh fails, we should probably logout
            // For now, just forward the error
            handler.next(err);
          },
        );
        return;
      }
    }
    handler.next(err);
  }
}
