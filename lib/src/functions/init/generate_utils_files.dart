import 'dart:io';

import '../../templates/debounce_template.dart';
import '../../templates/error_entity_template.dart';
import '../../templates/failure_template.dart';
import '../../templates/get_current_function_name_template.dart';
import '../../templates/list_to_model_list_template.dart';
import '../../templates/safe_cast_template.dart';
import '../../templates/safe_execute_template.dart';
import '../../templates/type_definitions_template.dart';
import '../shared/write_file.dart';

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
  writeFile(
    'lib/core/utils/functions/type_definitions.dart',
    typeDefinitionsTemplate(),
  );
  writeFile('lib/core/utils/functions/safe_cast.dart', safeCastTemplate());
  writeFile(
    'lib/core/utils/functions/safe_execute.dart',
    safeExecuteTemplate(),
  );
  writeFile(
    'lib/core/utils/functions/list_to_model_list.dart',
    listToModelListTemplate(),
  );
  writeFile(
    'lib/core/utils/functions/debounce.dart',
    debounceTemplate(),
  );

  stdout.writeln('🛠️  Utils files generated');
}
