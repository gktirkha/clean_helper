String safeExecuteTemplate() => '''
import 'dart:async';
import 'dart:developer';

import 'package:fpdart/fpdart.dart';

import '../../domain/failures/failure.dart';
import 'get_current_function_name.dart';

FutureOr<Either<Failure, T>> safeExecute<T>(FutureOr<T> exec) async {
  try {
    final res = await exec;
    return Right(res);
  } catch (e) {
    log(e.toString(), name: getCurrentFunctionName());
    return Failure.leftFromError(e);
  }
}
''';
