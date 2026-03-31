String errorInterceptorTemplate() => '''
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/error_model.dart';

@lazySingleton
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final response = err.response;
    final statusCode = response?.statusCode;

    if (statusCode == null || statusCode == 401 || response == null) {
      handler.next(err);
      return;
    }

    final data = response.data;

    // TODO: Add Check if it is your standard error or not and convert to your Error model
    final isValidErrorResponse =
        data is Map<String, dynamic> &&
        data.containsKey('errors') &&
        data['errors'] is List;

    if (!isValidErrorResponse) {
      handler.next(err);
      return;
    }

    final errorModel = ErrorModel.fromJson(data);

    if (errorModel.errors.isEmpty) {
      handler.next(err);
      return;
    }

    handler.next(
      err.copyWith(
        response: Response(
          requestOptions: response.requestOptions,
          data: errorModel,
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
