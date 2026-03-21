import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void generateDataRepo(String dir, String name, String domainImport) {
  final className = pascalCase(name);
  final path = '$dir/${name}_repository_impl.dart';

  writeFile(path, '''
import 'package:injectable/injectable.dart';

import '$domainImport';

@LazySingleton(as: ${className}Repository)
class ${className}RepositoryImpl implements ${className}Repository {}
''');
  stdout.writeln('  📄 $path');
}
