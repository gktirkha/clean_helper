import '../functions/shared/camel_case.dart';

String dataRepoTemplate(
  String className,
  String repositoryClass,
  String implClass,
  String dataSourceClass,
  String dataSourceField,
  String repoName,
) =>
    '''
import 'package:injectable/injectable.dart';

import '../../domain/entities/${repoName}_entity.dart';
import '../../domain/repositories/${repoName}_repository.dart';
import '../datasources/${repoName}_data_source_base.dart';
import '../models/requests/${repoName}_request_model.dart';

@Singleton(as: $repositoryClass)
class $implClass implements $repositoryClass {
  $implClass({required $dataSourceClass ${camelCase(repoName)}DataSourceBase})
    : $dataSourceField = ${camelCase(repoName)}DataSourceBase;

  final $dataSourceClass $dataSourceField;

  @override
  Future<${className}Entity> get$className() => $dataSourceField.get$className();

  //TODO: Pass Params in $repositoryClass
  @override
  Future<${className}Entity> post$className() => $dataSourceField.post$className(const ${className}RequestModel());
}
''';
