import 'dart:io';

import '../shared/camel_case.dart';
import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/data_repo_template.dart';

void generateDataRepo(String dataDir, String repoName) {
  final className = pascalCase(repoName);
  final repositoryClass = '${className}Repository';
  final implClass = '${className}RepositoryImpl';
  final dataSourceClass = '${className}DataSourceBase';
  final dataSourceField = '_${camelCase(repoName)}DataSourceBase';
  final path = '$dataDir/repositories/${repoName}_repository_impl.dart';

  writeFile(
    path,
    dataRepoTemplate(
      className,
      repositoryClass,
      implClass,
      dataSourceClass,
      dataSourceField,
      repoName,
    ),
  );
  stdout.writeln('  📄 $path');
}
