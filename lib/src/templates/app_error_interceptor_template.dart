import '../functions/shared/sort_imports.dart';

/// `lib/core/network/interceptors/app_error_interceptor.dart`: parses the
/// backend's error body into the app's `ErrorModel` for the network package's
/// abstract `ErrorInterceptor`.
String appErrorInterceptorTemplate(String networkImport, String utilsImport) =>
    '''
${sortImports(["import '$networkImport';", "import '$utilsImport';"])}

import '../../data/models/error_model.dart';

class AppErrorInterceptor extends ErrorInterceptor {
  @override
  ErrorEntity? parseError(Object? data) {
    // TODO: Check if it is your standard error and convert to your Error model
    final isValidErrorResponse =
        data is Map<String, dynamic> && data['errors'] is List;

    if (!isValidErrorResponse) return null;

    return ErrorModel.fromJson(data);
  }
}
''';
