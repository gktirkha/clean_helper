import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateEntityFile(String dir, String name) {
  final className = pascalCase(name);
  final path = '$dir/${name}_entity.dart';

  writeFile(path, '''
abstract class ${className}Entity {}
''');
  stdout.writeln('  📄 $path');
}
