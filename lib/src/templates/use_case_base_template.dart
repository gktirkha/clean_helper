String useCaseBaseTemplate(String utilsPackageName) =>
    '''
import 'package:fpdart/fpdart.dart';
import 'package:$utilsPackageName/$utilsPackageName.dart';

/// use Unit for no parameters, and use void for no return value
abstract class UseCaseBase<ReturnType, ParameterType> {
  TaskEither<Failure, ReturnType> call(ParameterType params);
}
''';
