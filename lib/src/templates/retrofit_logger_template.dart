String retrofitLoggerTemplate() => '''
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';

import '../utils/app_logger.dart';

@LazySingleton(as: ParseErrorLogger)
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
      time: .now(),
    );
  }
}
''';
