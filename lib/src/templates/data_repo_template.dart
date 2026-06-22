import '../functions/shared/camel_case.dart';

String dataRepoTemplate(
  String className,
  String repositoryClass,
  String implClass,
  String dataSourceClass,
  String dataSourceField,
  String repoName,
  String utilsPackageName, {
  bool addSample = false,
}) => addSample
    ? '''
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:$utilsPackageName/$utilsPackageName.dart';

import '../../domain/entities/${repoName}_entity.dart';
import '../../domain/params/get_${repoName}_params.dart';
import '../../domain/params/post_${repoName}_params.dart';
import '../../domain/repositories/${repoName}_repository.dart';
import '../datasources/${repoName}_data_source_base.dart';

@Singleton(as: $repositoryClass)
class $implClass implements $repositoryClass {
  $implClass({required this.$dataSourceField});

  final $dataSourceClass $dataSourceField;

  @override
  Future<Either<Failure, ${className}Entity>> get$className(Get${className}Params params) async {
    return $dataSourceField.get$className(params.get${className}Query);
  }

  @override
  Future<Either<Failure, ${className}Entity>> post$className(Post${className}Params params) async {
    return $dataSourceField.post$className(.new(p1: params.post${className}Param1));
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
