import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

import '../../config.dart';
import '../storage/token_storage.dart';
import '../error/exceptions.dart';

import 'api_endpoints.dart';

/// Callback invoked when the refresh token has expired.
/// Use this to trigger logout and navigate to the login screen.
typedef OnSessionExpired = Future<void> Function();

/// Handles JWT access token attachment, automatic refresh on 401,
/// and session expiry notification via [OnSessionExpired] callback.
///
/// Design:
///  - Single-flight refresh: only one refresh request runs at a time.
///  - Queue: concurrent 401s are queued and replayed after refresh.
///  - Guard: if /auth/refresh itself returns 401, session is expired.
final class JwtInterceptor extends Interceptor {
  final Dio _dio;
  final TokenStorage _tokenStorage;
  final OnSessionExpired onSessionExpired;

  bool _isRefreshing = false;
  final List<_PendingRequest> _pendingQueue = [];

  JwtInterceptor({
    required Dio dio,
    required TokenStorage tokenStorage,
    required this.onSessionExpired,
  }) : _dio = dio,
       _tokenStorage = tokenStorage;

  // ── Step 1: Attach access token ───────────────────────────────────────────
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStorage.getAccessToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  // ── Step 2: Handle 401 ────────────────────────────────────────────────────
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Guard: the refresh call itself returned 401 → refresh token expired
    if (_isRefreshEndpoint(err.requestOptions)) {
      await _handleSessionExpired();
      return handler.reject(err);
    }

    // Queue if a refresh is already running
    if (_isRefreshing) {
      return _enqueueAndWait(err, handler);
    }

    await _startRefreshFlow(err, handler);
  }

  // ── Refresh flow ──────────────────────────────────────────────────────────
  Future<void> _startRefreshFlow(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _isRefreshing = true;

    try {
      await _refreshAccessToken();
      _flushQueue();

      final response = await _retry(err.requestOptions);
      handler.resolve(response);
    } on RefreshTokenExpiredException {
      _rejectQueue(err);
      await _handleSessionExpired();
      handler.reject(err);
    } catch (_) {
      _rejectQueue(err);
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  // ── POST /auth/refresh ─────────────────────────────────────────────────────
  Future<void> _refreshAccessToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();
    log('Retrying request 1 to $refreshToken with new access token');

    if (refreshToken == null) {
      throw const RefreshTokenExpiredException();
    }

    try {
      // Use a plain Dio instance (no interceptors) to avoid recursive loops
      final response = await Dio(BaseOptions(baseUrl: Config.baseUrl)).post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken, 'expiresInMins': 1},
      );

      await _tokenStorage.saveTokens(
        accessToken: response.data['accessToken'] as String,
        refreshToken: response.data['refreshToken'] as String,
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw const RefreshTokenExpiredException();
      }
      rethrow;
    }
  }

  // ── Retry original request with new token ─────────────────────────────────
  Future<Response<dynamic>> _retry(RequestOptions options) async {
    final newToken = await _tokenStorage.getAccessToken();
    log('Retrying request 2 to ${options.path} with new access token');

    return _dio.request<dynamic>(
      options.path,
      data: options.data,
      queryParameters: options.queryParameters,
      options: Options(
        method: options.method,
        headers: {...options.headers, 'Authorization': 'Bearer $newToken'},
      ),
    );
  }

  // ── Queue management ──────────────────────────────────────────────────────
  Future<void> _enqueueAndWait(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final completer = Completer<Response<dynamic>>();
    _pendingQueue.add(_PendingRequest(err.requestOptions, completer));

    try {
      final response = await completer.future;
      handler.resolve(response);
    } catch (_) {
      handler.next(err);
    }
  }

  void _flushQueue() {
    for (final pending in _pendingQueue) {
      _retry(pending.options)
          .then(pending.completer.complete)
          .catchError(pending.completer.completeError);
    }
    _pendingQueue.clear();
  }

  void _rejectQueue(DioException err) {
    for (final pending in _pendingQueue) {
      pending.completer.completeError(err);
    }
    _pendingQueue.clear();
  }

  // ── Session expired ───────────────────────────────────────────────────────
  Future<void> _handleSessionExpired() async {
    await _tokenStorage.clearTokens();
    await onSessionExpired(); // 👈 fires your logout / navigation callback
  }

  bool _isRefreshEndpoint(RequestOptions options) =>
      options.path.contains(ApiEndpoints.refreshToken);
}

// ── Internal ──────────────────────────────────────────────────────────────────
final class _PendingRequest {
  final RequestOptions options;
  final Completer<Response<dynamic>> completer;

  const _PendingRequest(this.options, this.completer);
}
