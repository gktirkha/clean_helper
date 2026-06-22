String domainRepoTemplate(
  String className,
  String name,
  String utilsPackageName, {
  bool addSample = false,
}) => addSample
    ? '''
import 'package:fpdart/fpdart.dart';
import 'package:$utilsPackageName/$utilsPackageName.dart';

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
