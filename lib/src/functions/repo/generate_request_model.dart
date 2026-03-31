import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/request_model_template.dart';

void generateRequestModel(String dataDir, String repoName) {
  final className = pascalCase(repoName);
  final path = '$dataDir/models/requests/${repoName}_request_model.dart';

  writeFile(path, requestModelTemplate(className, repoName));
  stdout.writeln('  📄 $path');
}
