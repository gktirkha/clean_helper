import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateDataSourceBase(String dataDir, String repoName) {
  final className = pascalCase(repoName);
  final path = '$dataDir/datasources/${repoName}_data_source_base.dart';

  writeFile(path, '''
import '../models/requests/${repoName}_request_model.dart';
import '../models/response/${repoName}_response_model.dart';

abstract interface class ${className}DataSourceBase {
  Future<${className}ResponseModel> get$className();
  Future<${className}ResponseModel> post$className(${className}RequestModel? requestModel);
}
''');
  stdout.writeln('  📄 $path');
}
