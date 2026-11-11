import '../functions/shared/sort_imports.dart';

/// The network package's abstract `ErrorInterceptor`: apps extend it (see
/// `appErrorInterceptorTemplate`) to parse their error body into an
/// `ErrorEntity` from [utilsImport].
String errorInterceptorTemplate(String utilsImport) =>
    '''
${sortImports(["import 'package:dio/dio.dart';", "import 'package:flutter/foundation.dart';", "import '$utilsImport';"])}

/// Base error interceptor: converts the backend's standard error body into an
/// [ErrorEntity] and puts it in [DioException.response] `data`.
///
/// Host apps provide the parsing by extending this class and registering it
/// in DI as [ErrorInterceptor]:
///
/// ```dart
/// @lazySingleton
/// ErrorInterceptor get errorInterceptor => AppErrorInterceptor();
/// ```
abstract class ErrorInterceptor extends Interceptor {
  /// Parses [data] into an [ErrorEntity], or returns `null` if it is not the
  /// backend's standard error format (the error is then passed on unchanged).
  @protected
  ErrorEntity? parseError(Object? data);

  /// Whether [err] should be parsed. By default, skips 401 (left to
  /// [AuthInterceptor]) and errors without a response.
  @protected
  bool shouldHandle(DioException err) {
    final statusCode = err.response?.statusCode;
    return statusCode != null && statusCode != 401;
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    if (response == null || !shouldHandle(err)) {
      handler.next(err);
      return;
    }

    final errorEntity = parseError(response.data);
    if (errorEntity == null || errorEntity.errors.isEmpty) {
      handler.next(err);
      return;
    }

    handler.next(
      err.copyWith(
        response: Response(
          requestOptions: response.requestOptions,
          data: errorEntity,
          statusCode: response.statusCode,
          statusMessage: response.statusMessage,
          headers: response.headers,
          extra: response.extra,
          isRedirect: response.isRedirect,
          redirects: response.redirects,
        ),
      ),
    );
  }
}
''';
