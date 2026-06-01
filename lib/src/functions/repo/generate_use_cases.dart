import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/get_use_case_template.dart';
import '../../templates/post_use_case_template.dart';

void generateUseCases(String feature, String name) {
  final className = pascalCase(name);
  final dir = 'lib/features/$feature/domain/use_cases';
  writeFile('$dir/get_${name}_use_case.dart', getUseCaseTemplate(className, name));
  writeFile('$dir/post_${name}_use_case.dart', postUseCaseTemplate(className, name));
  stdout.writeln('  📄 $dir/get_${name}_use_case.dart');
  stdout.writeln('  📄 $dir/post_${name}_use_case.dart');
}
