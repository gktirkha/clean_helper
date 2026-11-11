String useCaseBaseTemplate() => '''
import 'dart:async';

import 'package:fpdart/fpdart.dart';

import 'failure.dart';

/// use Unit for no parameters, and use void for no return value
abstract class UseCaseBase<ReturnType, ParameterType> {
  FutureOr<TaskEither<Failure, ReturnType>> call(ParameterType params);
}
''';
