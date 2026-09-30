import '../functions/shared/camel_case.dart';
import '../functions/shared/sort_imports.dart';

String getUseCaseTemplate(
  String className,
  String name,
  String utilsImport, {
  bool importUseCaseBase = true,
  bool taskEither = true,
}) =>
    '''
${taskEither ? '' : "import 'dart:async';\n\n"}${sortImports(["import 'package:fpdart/fpdart.dart' show ${taskEither ? 'TaskEither' : 'Either'};", "import '$utilsImport';"])}

${importUseCaseBase ? "import '../../../../core/domain/use_cases/use_case_base.dart';\n" : ''}import '../entities/${name}_entity.dart';
import '../params/get_${name}_params.dart';
import '../repositories/${name}_repository.dart';

class Get${className}UseCase implements UseCaseBase<${className}Entity, Get${className}Params> {
  Get${className}UseCase({required ${className}Repository ${camelCase(name)}Repository})
      : _${camelCase(name)}Repository = ${camelCase(name)}Repository;

  final ${className}Repository _${camelCase(name)}Repository;

  @override
  ${taskEither ? 'TaskEither<Failure, ${className}Entity>' : 'FutureOr<Either<Failure, ${className}Entity>>'} call(Get${className}Params params) {
    return _${camelCase(name)}Repository.get$className(params);
  }
}
''';
