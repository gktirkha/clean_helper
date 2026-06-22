String postUseCaseTemplate(
  String className,
  String name,
  String utilsPackageName,
) =>
    '''
import 'dart:async';

import 'package:fpdart/fpdart.dart' show Either;
import 'package:$utilsPackageName/$utilsPackageName.dart';

import '../../../../core/domain/use_cases/use_case_base.dart';
import '../entities/${name}_entity.dart';
import '../params/post_${name}_params.dart';
import '../repositories/${name}_repository.dart';

class Post${className}UseCase implements UseCaseBase<${className}Entity, Post${className}Params> {
  Post${className}UseCase({required ${className}Repository ${name}Repository})
      : _${name}Repository = ${name}Repository;

  final ${className}Repository _${name}Repository;

  @override
  FutureOr<Either<Failure, ${className}Entity>> call(Post${className}Params params) {
    return _${name}Repository.post$className(params);
  }
}
''';
