import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/data_source_base_template.dart';

void generateDataSourceBase(
  String dataDir,
  String repoName, {
  bool addSample = false,
}) {
  final className = pascalCase(repoName);
  final path = '$dataDir/datasources/${repoName}_data_source_base.dart';

  writeFile(
    path,
    dataSourceBaseTemplate(className, repoName, addSample: addSample),
  );
  stdout.writeln('  📄 $path');
}
