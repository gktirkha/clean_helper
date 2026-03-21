import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateDataSourceBase(String dataDir, String repoName) {
  final className = pascalCase(repoName);
  final path = '$dataDir/datasources/${repoName}_data_source_base.dart';

  writeFile(path, '''
import 'package:retrofit/http.dart';

import '../models/requests/${repoName}_request_model.dart';
import '../models/response/${repoName}_response_model.dart';

abstract interface class ${className}DataSourceBase {
  // TODO: add method signatures
  // Example:
  // Future<${className}ResponseModel> get$className(@Body() ${className}RequestModel request);
}
''');
  stdout.writeln('  📄 $path');
}
