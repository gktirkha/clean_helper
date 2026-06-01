String postUseCaseTemplate(String className, String name) => '''
import 'dart:async';

import 'package:fpdart/fpdart.dart' show Either, Unit;

import '../../../../core/domain/failures/failure.dart';
import '../../../../core/domain/use_cases/use_case_base.dart';
import '../entities/${name}_entity.dart';
import '../repositories/${name}_repository.dart';

class Post${className}UseCase implements UseCaseBase<${className}Entity, Unit> {
  Post${className}UseCase({required ${className}Repository ${name}Repository})
      : _${name}Repository = ${name}Repository;

  final ${className}Repository _${name}Repository;

  @override
  FutureOr<Either<Failure, ${className}Entity>> call(Unit params) {
    return _${name}Repository.post$className();
  }
}
''';
