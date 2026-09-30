String safeExecuteTaskTemplate() => '''
import 'package:fpdart/fpdart.dart';

import '../app_logger.dart';
import '../failure.dart';

/// Lazy counterpart of [safeExecute]: [exec] only runs when the returned
/// [TaskEither] is invoked with `.run()`.
TaskEither<Failure, T> safeExecuteTask<T>(Future<T> Function() exec) =>
    TaskEither.tryCatch(exec, (e, s) {
      AppLogger.error(
        'Error in Safe Execute Task',
        stackTrace: s,
        error: e,
        time: DateTime.now(),
      );
      return e is Failure ? e : Failure(message: e.toString());
    });
''';
