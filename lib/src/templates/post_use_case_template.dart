import '../functions/shared/camel_case.dart';
import '../functions/shared/sort_imports.dart';

String postUseCaseTemplate(String className, String name, String utilsImport) =>
    '''
${sortImports(["import 'package:fpdart/fpdart.dart' show TaskEither;", "import '$utilsImport';"])}

import '../entities/${name}_entity.dart';
import '../params/post_${name}_params.dart';
import '../repositories/${name}_repository.dart';

class Post${className}UseCase implements UseCaseBase<${className}Entity, Post${className}Params> {
  Post${className}UseCase({required this._${camelCase(name)}Repository});

  final ${className}Repository _${camelCase(name)}Repository;

  @override
  TaskEither<Failure, ${className}Entity> call(Post${className}Params params) {
    return _${camelCase(name)}Repository.post$className(params);
  }
}
''';
