/// The call adapter in the utils package (`lib/src/network/`): adapts every
/// Retrofit call to a lazy `TaskEither<Failure, T>`.
String retrofitCallAdapterTemplate(String className) =>
    '''
import 'package:fpdart/fpdart.dart';
import 'package:retrofit/retrofit.dart';

import '../failure.dart';
import '../functions/safe_execute_task.dart';

class $className<T> extends CallAdapter<Future<T>, TaskEither<Failure, T>> {
  @override
  TaskEither<Failure, T> adapt(Future<T> Function() call) {
    return safeExecuteTask(call);
  }
}
''';
