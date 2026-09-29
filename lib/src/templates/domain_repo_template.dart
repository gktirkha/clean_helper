import '../functions/shared/sort_imports.dart';

String domainRepoTemplate(
  String className,
  String name,
  String utilsImport, {
  bool addSample = false,
}) => addSample
    ? '''
${sortImports(["import 'package:fpdart/fpdart.dart';", "import '$utilsImport';"])}

import '../entities/${name}_entity.dart';
import '../params/get_${name}_params.dart';
import '../params/post_${name}_params.dart';

abstract interface class ${className}Repository {
  Future<Either<Failure, ${className}Entity>> get$className(Get${className}Params params);
  Future<Either<Failure, ${className}Entity>> post$className(Post${className}Params params);
}
'''
    : '''
abstract interface class ${className}Repository {
}
''';
