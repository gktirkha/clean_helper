import '../functions/shared/sort_imports.dart';

String useCaseBaseTemplate(String utilsPackageName) =>
    '''
import 'dart:async';

${sortImports(["import 'package:fpdart/fpdart.dart';", "import 'package:$utilsPackageName/$utilsPackageName.dart';"])}

/// use Unit for no parameters, and use void for no return value
abstract class UseCaseBase<ReturnType, ParameterType> {
  FutureOr<TaskEither<Failure, ReturnType>> call(ParameterType params);
}
''';
