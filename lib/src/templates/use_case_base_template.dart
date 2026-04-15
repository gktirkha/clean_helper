String useCaseBaseTemplate() => '''
import 'dart:async';

import 'package:fpdart/fpdart.dart';

import '../failures/failure.dart';

/// use Unit for no parameters, and use void for no return value
abstract class UseCaseBase<ReturnType, ParameterType> {
  FutureOr<Either<Failure, ReturnType>> call(ParameterType params);
}
''';
