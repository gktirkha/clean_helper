String authInterceptorTemplate() => '''
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../di/di_keys.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  AuthInterceptor({@Named(DIKeys.noAuthDio) required Dio noAuthDio})
    : _dio = noAuthDio;

  final Dio _dio;
  final String _retryKey = 'retry';
  final String _authHeaderKey = 'Authorization';
  final String _bearerKey = 'Bearer';

  bool _isRefreshing = false;
  Future<String?>? _refreshFuture;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options = await _addAuthHeader(options);
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 ||
        err.requestOptions.extra[_retryKey] == true) {
      handler.next(err);
      return;
    }

    try {
      final newToken = await _refreshToken();

      if (newToken == null) {
        handler.next(err);
        return;
      }

      final options = await _addAuthHeader(err.requestOptions, newToken);
      options.extra[_retryKey] = true;

      final response = await _dio.fetch(options);
      handler.resolve(response);
    } catch (e) {
      // TODO: clear stored tokens on refresh failure
      // Example: await _tokenStorage.clearTokens();
      handler.next(err);
    }
  }

  Future<String?>? _refreshToken() {
    if (_isRefreshing) return _refreshFuture;
    _isRefreshing = true;
    _refreshFuture = _performRefresh();
    _refreshFuture!.then((_) => _isRefreshing = false);
    return _refreshFuture;
  }

  Future<String?> _performRefresh() async {
    try {
      // TODO: Handle full token refresh flow
      // - Read refresh token from storage
      // - Call refresh API using _dio
      // - Extract new access + refresh tokens
      // - Persist tokens in storage
      // - Return new access token

      return null;
    } catch (e) {
      // TODO: On refresh failure, clear tokens & handle logout if needed
      return null;
    }
  }

  FutureOr<RequestOptions> _addAuthHeader(
    RequestOptions requestOptions, [
    String? newToken,
  ]) async {
    // TODO: Attach access token from storage (or use provided newToken)

    if (newToken != null) {
      requestOptions.headers[_authHeaderKey] = '\$_bearerKey \$newToken';
      return requestOptions;
    }

    // Example:
    // final token = await _tokenStorage.getAccessToken();
    // if (token != null) {
    //   requestOptions.headers[_authHeaderKey] = '\$_bearerKey \$token';
    // }

    return requestOptions;
  }
}
''';
