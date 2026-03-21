import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateDataSourceBase(String dataDir, String repoName) {
  final className = pascalCase(repoName);
  final path = '$dataDir/datasources/${repoName}_data_source_base.dart';

  writeFile(path, '''
abstract interface class ${className}DataSourceBase {}
''');
  stdout.writeln('  📄 $path');
}
