import 'dart:io' show HttpHeaders;
import 'package:dio/dio.dart';

import '../../../../core/di/service_locator.dart';
import '../../features/auth/data/datasources/auth_token_source.dart';

class DioAuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await sl<AuthTokenSource>().getValidToken();
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
}
