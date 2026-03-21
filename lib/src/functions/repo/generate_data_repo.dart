import 'dart:io';

import '../shared/camel_case.dart';
import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateDataRepo(
  String dataDir,
  String feature,
  String repoName,
  String packageName,
) {
  final className = pascalCase(repoName);
  final repositoryClass = '${className}Repository';
  final implClass = '${className}RepositoryImpl';
  final dataSourceClass = '${className}DataSourceBase';
  final dataSourceField = '_${camelCase(repoName)}DataSourceBase';
  final path = '$dataDir/repositories/${repoName}_repository_impl.dart';

  writeFile(path, '''
import 'package:injectable/injectable.dart';

import 'package:$packageName/features/$feature/domain/repositories/${repoName}_repository.dart';
import '../datasources/${repoName}_data_source_base.dart';

@Singleton(as: $repositoryClass)
class $implClass implements $repositoryClass {
  $implClass({required $dataSourceClass ${camelCase(repoName)}DataSourceBase})
      : $dataSourceField = ${camelCase(repoName)}DataSourceBase;

  final $dataSourceClass $dataSourceField;
}
''');
  stdout.writeln('  📄 $path');
}
