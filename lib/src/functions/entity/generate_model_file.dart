import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/model_template.dart';

void generateModelFile(String dir, String name, String entityImport) {
  final className = pascalCase(name);
  final path = '$dir/${name}_model.dart';

  writeFile(path, modelTemplate(className, name, entityImport));
  stdout.writeln('  📄 $path');
}
