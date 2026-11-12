/// The network package's `ParseErrorLogger`. Logs through `dart:developer`
/// under [packageName], so the package doesn't depend on the utils package.
String retrofitLoggerTemplate(String packageName) =>
    '''
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

class RetrofitLogger implements ParseErrorLogger {
  @override
  void logError(
    Object error,
    StackTrace stackTrace,
    RequestOptions options, {
    Response<dynamic>? response,
  }) {
    developer.log(
      'Error While Parsing Response with data \${response?.data ?? "N/A"}',
      name: '$packageName',
      error: error,
      stackTrace: stackTrace,
      level: 1000,
    );
  }
}
''';
