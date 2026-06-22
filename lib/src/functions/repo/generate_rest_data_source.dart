import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/rest_data_source_template.dart';

void generateRestDataSource(
  String dataDir,
  String feature,
  String repoName,
  String utilsPackageName, {
  bool addSample = false,
}) {
  final featureClass = pascalCase(feature);
  final repoClass = pascalCase(repoName);
  final baseClass = '${repoClass}DataSourceBase';
  final implClass = 'Rest${repoClass}DataSource';
  final path = '$dataDir/datasources/rest_${repoName}_data_source.dart';

  writeFile(
    path,
    restDataSourceTemplate(
      featureClass,
      repoClass,
      baseClass,
      implClass,
      feature,
      repoName,
      utilsPackageName,
      addSample: addSample,
    ),
  );
  stdout.writeln('  📄 $path');
}
