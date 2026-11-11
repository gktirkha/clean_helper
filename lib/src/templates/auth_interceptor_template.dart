/// The network package's abstract `AuthInterceptor`. Apps extend it (see
/// `appAuthInterceptorTemplate`) and register the subclass in DI.
String authInterceptorTemplate() => r'''
import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Base auth interceptor: attaches the access token to every request and, on
/// an auth failure, refreshes the token once (concurrent failures share the
/// same refresh) and retries the original request.
///
/// Host apps provide the token logic by extending this class and registering
/// it in DI as [AuthInterceptor]:
///
/// ```dart
/// @lazySingleton
/// AuthInterceptor authInterceptor(
///   @Named(NetworkDIKeys.noAuthDio) Dio noAuthDio,
/// ) => AppAuthInterceptor(noAuthDio: noAuthDio);
/// ```
abstract class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.noAuthDio});

  /// [Dio] without this interceptor; use it for refresh calls and retries.
  @protected
  final Dio noAuthDio;

  static const String _retryKey = 'auth_retry';

  Future<String?>? _refreshFuture;

  /// Current access token, or `null` if the user is not authenticated.
  @protected
  FutureOr<String?> getAccessToken();

  /// Refreshes and persists tokens, returning the new access token, or
  /// `null` if refresh is not possible. Throwing is treated like `null`.
  @protected
  Future<String?> refreshAccessToken();

  /// Called when refresh fails or returns `null` (e.g. clear tokens, logout).
  @protected
  FutureOr<void> onRefreshFailed(Object? error, StackTrace? stackTrace) {}

  /// Whether [err] should trigger a token refresh. Defaults to HTTP 401.
  @protected
  bool shouldRefresh(DioException err) => err.response?.statusCode == 401;

  /// Header name the token is sent in.
  @protected
  String get authHeaderKey => 'Authorization';

  /// Formats the token as the header value.
  @protected
  String formatAuthHeader(String token) => 'Bearer $token';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await getAccessToken();
    if (token != null) _setToken(options, token);
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!shouldRefresh(err) || err.requestOptions.extra[_retryKey] == true) {
      handler.next(err);
      return;
    }

    final newToken = await _refreshOnce();
    if (newToken == null) {
      handler.next(err);
      return;
    }

    final options = _setToken(err.requestOptions, newToken)
      ..extra[_retryKey] = true;

    try {
      handler.resolve(await noAuthDio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<String?> _refreshOnce() =>
      _refreshFuture ??= _refresh().whenComplete(() => _refreshFuture = null);

  Future<String?> _refresh() async {
    try {
      final token = await refreshAccessToken();
      if (token == null) await onRefreshFailed(null, null);
      return token;
    } catch (e, s) {
      await onRefreshFailed(e, s);
      return null;
    }
  }

  RequestOptions _setToken(RequestOptions options, String token) =>
      options..headers[authHeaderKey] = formatAuthHeader(token);
}
''';
