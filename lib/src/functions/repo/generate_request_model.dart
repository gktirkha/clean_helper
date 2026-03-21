import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateRequestModel(String dataDir, String repoName) {
  final className = pascalCase(repoName);
  final path = '$dataDir/models/requests/${repoName}_request_model.dart';

  writeFile(path, '''
import 'package:json_annotation/json_annotation.dart';

part '${repoName}_request_model.g.dart';

@JsonSerializable()
class ${className}RequestModel {
  const ${className}RequestModel();

  factory ${className}RequestModel.fromJson(Map<String, dynamic> json) =>
      _\$${className}RequestModelFromJson(json);

  Map<String, dynamic> toJson() => _\$${className}RequestModelToJson(this);
}
''');
  stdout.writeln('  📄 $path');
}
