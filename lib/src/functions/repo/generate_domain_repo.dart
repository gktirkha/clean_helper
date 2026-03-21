import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateDomainRepo(String dir, String name) {
  final className = pascalCase(name);
  final path = '$dir/${name}_repository.dart';

  writeFile(path, '''
import '../entities/${name}_entity.dart';

abstract interface class ${className}Repository {
  Future<${className}Entity> get$className();
}
''');
  stdout.writeln('  📄 $path');
}
