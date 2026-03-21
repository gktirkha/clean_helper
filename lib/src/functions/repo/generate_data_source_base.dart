import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateDataSourceBase(String dataDir, String repoName) {
  final className = pascalCase(repoName);
  final path = '$dataDir/datasources/${repoName}_data_source_base.dart';

  writeFile(path, '''
import '../models/response/${repoName}_response_model.dart';

abstract interface class ${className}DataSourceBase {
  Future<${className}ResponseModel> get$className();
}
''');
  stdout.writeln('  📄 $path');
}
