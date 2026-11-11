import '../functions/shared/camel_case.dart';
import '../functions/shared/sort_imports.dart';

String getUseCaseTemplate(String className, String name, String utilsImport) =>
    '''
${sortImports(["import 'package:fpdart/fpdart.dart' show TaskEither;", "import '$utilsImport';"])}

import '../entities/${name}_entity.dart';
import '../params/get_${name}_params.dart';
import '../repositories/${name}_repository.dart';

class Get${className}UseCase implements UseCaseBase<${className}Entity, Get${className}Params> {
  Get${className}UseCase({required ${className}Repository ${camelCase(name)}Repository})
      : _${camelCase(name)}Repository = ${camelCase(name)}Repository;

  final ${className}Repository _${camelCase(name)}Repository;

  @override
  TaskEither<Failure, ${className}Entity> call(Get${className}Params params) {
    return _${camelCase(name)}Repository.get$className(params);
  }
}
''';
