String retrofitCallAdapterTemplate() => '''
import 'package:fpdart/fpdart.dart';
import 'package:retrofit/retrofit.dart';

import '../failure.dart';
import '../functions/safe_execute_task.dart';

class RetrofitCallAdapter<T>
    extends CallAdapter<Future<T>, TaskEither<Failure, T>> {
  @override
  TaskEither<Failure, T> adapt(Future<T> Function() call) {
    return safeExecuteTask(call);
  }
}
''';
