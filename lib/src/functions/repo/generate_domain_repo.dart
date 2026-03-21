import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateDomainRepo(String dir, String name) {
  final className = pascalCase(name);
  final path = '$dir/${name}_repository.dart';

  writeFile(path, '''
abstract interface class ${className}Repository {}
''');
  stdout.writeln('  📄 $path');
}
