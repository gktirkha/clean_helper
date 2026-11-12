import '../functions/shared/sort_imports.dart';

/// `lib/core/network/adapters/app_call_adapter.dart`: turns every Retrofit
/// call into a lazy `TaskEither<Failure, T>`. HTTP errors become `ApiFailure`
/// carrying the backend's `ErrorModel`. [className] comes from
/// `packages.network.call_adapter_name`.
String appCallAdapterTemplate(String className, String utilsImport) =>
    '''
${sortImports(["import 'package:dio/dio.dart';", "import '$utilsImport';", "import 'package:fpdart/fpdart.dart';", "import 'package:retrofit/retrofit.dart';"])}

import '../../data/models/error_model.dart';
import '../failures/api_failure.dart';

/// Converts every Retrofit call into a `TaskEither<Failure, T>`; HTTP errors
/// become [ApiFailure] with the backend's [ErrorModel].
class $className<T> extends CallAdapter<Future<T>, TaskEither<Failure, T>> {
  @override
  TaskEither<Failure, T> adapt(Future<T> Function() call) {
    return TaskEither.tryCatch(call, (e, s) {
      AppLogger.error('API call failed', error: e, stackTrace: s);
      return _toFailure(e);
    });
  }

  Failure _toFailure(Object e) {
    if (e is Failure) return e;
    if (e is! DioException) return Failure(message: e.toString());

    final error = ErrorModel.tryParse(e.response?.data);
    return ApiFailure(
      message: error?.errors.firstOrNull ?? e.message,
      statusCode: e.response?.statusCode,
      error: error,
    );
  }
}
''';
