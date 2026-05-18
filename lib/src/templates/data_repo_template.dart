import '../functions/shared/camel_case.dart';

String dataRepoTemplate(
  String className,
  String repositoryClass,
  String implClass,
  String dataSourceClass,
  String dataSourceField,
  String repoName, {
  bool addSample = false,
}) => addSample
    ? '''
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/failures/failure.dart';
import '../../domain/entities/${repoName}_entity.dart';
import '../../domain/repositories/${repoName}_repository.dart';
import '../datasources/${repoName}_data_source_base.dart';

@Singleton(as: $repositoryClass)
class $implClass implements $repositoryClass {
  $implClass({required $dataSourceClass ${camelCase(repoName)}DataSourceBase})
    : $dataSourceField = ${camelCase(repoName)}DataSourceBase;

  final $dataSourceClass $dataSourceField;

  @override
  Future<Either<Failure, ${className}Entity>> get$className() async {
    return $dataSourceField.get$className();
  }

  @override
  Future<Either<Failure, ${className}Entity>> post$className() async {
    return $dataSourceField.post$className(const .new());
  }
}
'''
    : '''
import 'package:injectable/injectable.dart';

import '../../domain/repositories/${repoName}_repository.dart';
import '../datasources/${repoName}_data_source_base.dart';

@Singleton(as: $repositoryClass)
class $implClass implements $repositoryClass {
  $implClass({required $dataSourceClass ${camelCase(repoName)}DataSourceBase})
    : $dataSourceField = ${camelCase(repoName)}DataSourceBase;

  final $dataSourceClass $dataSourceField;
}
''';
