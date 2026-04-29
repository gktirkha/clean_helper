String domainRepoTemplate(String className, String name) =>
    '''
import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/failures/failure.dart';
import '../entities/${name}_entity.dart';

abstract interface class ${className}Repository {
  Future<Either<Failure, ${className}Entity>> get$className();
  Future<Either<Failure, ${className}Entity>> post$className();
}
''';
