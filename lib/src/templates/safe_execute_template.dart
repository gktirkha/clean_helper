String safeExecuteTemplate() => '''
import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../domain/failures/failure.dart';
import 'get_current_function_name.dart';
import 'app_logger.dart';

FutureOr<Either<Failure, T>> safeExecute<T>(FutureOr<T> exec) async {
  try {
    final res = await exec;
    return Right(res);
  } catch (e, s) {
    AppLogger.error(
      getCurrentFunctionName(),
      stackTrace: s,
      error: e,
      time: DateTime.now(),
    );
    return Failure.leftFromError(e);
  }
}
''';
