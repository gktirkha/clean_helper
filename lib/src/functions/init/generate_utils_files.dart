import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/error_entity_template.dart';
import '../../templates/failure_template.dart';
import '../../templates/get_current_function_name_template.dart';
import '../../templates/safe_cast_template.dart';
import '../../templates/safe_execute_template.dart';

void generateUtilsFiles() {
  writeFile(
    'lib/core/domain/entities/error_entity.dart',
    errorEntityTemplate(),
  );
  writeFile('lib/core/domain/failures/failure.dart', failureTemplate());
  writeFile(
    'lib/core/utils/functions/get_current_function_name.dart',
    getCurrentFunctionNameTemplate(),
  );
  writeFile('lib/core/utils/functions/safe_cast.dart', safeCastTemplate());
  writeFile(
    'lib/core/utils/functions/safe_execute.dart',
    safeExecuteTemplate(),
  );

  stdout.writeln('🛠️  Utils files generated');
}
