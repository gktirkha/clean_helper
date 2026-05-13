String safeExecuteTemplate() => '''
import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../../domain/failures/failure.dart';
import '../app_logger.dart';

FutureOr<Either<Failure, T>> safeExecute<T>(FutureOr<T> exec) async {
  try {
    final res = await exec;
    return Right(res);
  } catch (e, s) {
    AppLogger.error(
      'Error in Safe Execute',
      stackTrace: s,
      error: e,
      time: .now(),
    );
    return Failure.leftFromError(e);
  }
}
''';
