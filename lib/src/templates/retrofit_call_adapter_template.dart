String retrofitCallAdapterTemplate() => '''
import 'package:fpdart/fpdart.dart';
import 'package:retrofit/retrofit.dart';

import '../../domain/failures/failure.dart';
import '../../utils/functions/safe_execute.dart';

class RetrofitCallAdapter<T>
    extends CallAdapter<Future<T>, Future<Either<Failure, T>>> {
  @override
  Future<Either<Failure, T>> adapt(Future<T> Function() call) async {
    return await safeExecute(call());
  }
}
''';
