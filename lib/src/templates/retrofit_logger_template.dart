String retrofitLoggerTemplate() => '''
import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';

import '../app_logger.dart';

class RetrofitLogger implements ParseErrorLogger {
  @override
  void logError(
    Object error,
    StackTrace stackTrace,
    RequestOptions options, {
    Response<dynamic>? response,
  }) {
    AppLogger.error(
      'Error While Parsing Response with data \${response?.data ?? "N/A"}',
      stackTrace: stackTrace,
      error: error,
      time: DateTime.now(),
    );
  }
}
''';
