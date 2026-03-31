import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/response_model_template.dart';

void generateResponseModel(String dataDir, String repoName) {
  final className = pascalCase(repoName);
  final path = '$dataDir/models/response/${repoName}_response_model.dart';

  writeFile(path, responseModelTemplate(className, repoName));
  stdout.writeln('  📄 $path');
}
