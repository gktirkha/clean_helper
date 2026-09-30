import '../functions/shared/sort_imports.dart';

String retrofitLoggerTemplate(String utilsImport) =>
    '''
${sortImports(["import 'package:dio/dio.dart';", "import 'package:retrofit/retrofit.dart';", "import '$utilsImport';"])}

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
