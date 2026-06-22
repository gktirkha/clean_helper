import 'dart:io';

import '../../templates/use_case_base_template.dart';
import '../shared/write_file.dart';

void generateUtilsFiles(String utilsPackageName) {
  writeFile(
    'lib/core/domain/use_cases/use_case_base.dart',
    useCaseBaseTemplate(utilsPackageName),
  );

  stdout.writeln('🛠️  Utils files generated');
  stdout.writeln();
}
