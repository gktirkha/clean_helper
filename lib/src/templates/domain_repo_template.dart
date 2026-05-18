String domainRepoTemplate(
  String className,
  String name, {
  bool addSample = false,
}) =>
    addSample
        ? '''
import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/failures/failure.dart';
import '../entities/${name}_entity.dart';

abstract interface class ${className}Repository {
  Future<Either<Failure, ${className}Entity>> get$className();
  Future<Either<Failure, ${className}Entity>> post$className();
}
'''
        : '''
abstract interface class ${className}Repository {
}
''';
