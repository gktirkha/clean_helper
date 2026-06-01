import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/get_use_case_params_template.dart';
import '../../templates/get_use_case_template.dart';
import '../../templates/post_use_case_params_template.dart';
import '../../templates/post_use_case_template.dart';

void generateUseCases(String feature, String name) {
  final className = pascalCase(name);
  final paramsDir = 'lib/features/$feature/domain/params';
  final useCasesDir = 'lib/features/$feature/domain/use_cases';
  writeFile('$paramsDir/get_${name}_params.dart', getUseCaseParamsTemplate(className));
  writeFile('$paramsDir/post_${name}_params.dart', postUseCaseParamsTemplate(className));
  writeFile('$useCasesDir/get_${name}_use_case.dart', getUseCaseTemplate(className, name));
  writeFile('$useCasesDir/post_${name}_use_case.dart', postUseCaseTemplate(className, name));
  stdout.writeln('  📄 $paramsDir/get_${name}_params.dart');
  stdout.writeln('  📄 $paramsDir/post_${name}_params.dart');
  stdout.writeln('  📄 $useCasesDir/get_${name}_use_case.dart');
  stdout.writeln('  📄 $useCasesDir/post_${name}_use_case.dart');
}
