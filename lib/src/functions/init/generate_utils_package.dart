import 'dart:io';

import '../../templates/analysis_options_template.dart';
import '../../templates/app_bloc_observer_template.dart';
import '../../templates/app_logger_template.dart';
import '../../templates/debounce_template.dart';
import '../../templates/error_entity_template.dart';
import '../../templates/failure_template.dart';
import '../../templates/get_current_function_name_template.dart';
import '../../templates/list_to_model_list_template.dart';
import '../../templates/retrofit_call_adapter_template.dart';
import '../../templates/retrofit_logger_template.dart';
import '../../templates/safe_cast_template.dart';
import '../../templates/safe_execute_template.dart';
import '../../templates/type_definitions_template.dart';
import '../../templates/utils_di_initializer_template.dart';
import '../../templates/utils_lib_export_template.dart';
import '../../templates/utils_module_template.dart';
import '../../templates/utils_pubspec_tail_template.dart';
import '../shared/fvm_exec.dart';
import '../shared/pascal_case.dart';
import '../shared/run_command.dart';
import '../shared/write_file.dart';
import 'patch_package_pubspec.dart';

void generateUtilsPackage(
  String utilsPackageName,
  String localizationPackageName,
) {
  stdout.writeln('📦 Creating $utilsPackageName package...');

  runCommand([
    ...fvmExec('flutter'),
    'create',
    'packages/$utilsPackageName',
    '--template',
    'package',
  ]);

  final filesToDelete = [
    'packages/$utilsPackageName/.metadata',
    'packages/$utilsPackageName/CHANGELOG.md',
    'packages/$utilsPackageName/LICENSE',
    'packages/$utilsPackageName/README.md',
  ];
  for (final path in filesToDelete) {
    final file = File(path);
    if (file.existsSync()) file.deleteSync();
  }
  final testDir = Directory('packages/$utilsPackageName/test');
  if (testDir.existsSync()) testDir.deleteSync(recursive: true);

  overwriteFile(
    'packages/$utilsPackageName/analysis_options.yaml',
    analysisOptionsTemplate(),
  );

  patchPackagePubspec(
    'packages/$utilsPackageName',
    utilsPubspecTailTemplate(localizationPackageName),
  );

  final utilsClassName = pascalCase(utilsPackageName);

  overwriteFile(
    'packages/$utilsPackageName/lib/$utilsPackageName.dart',
    utilsLibExportTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/app_logger.dart',
    appLoggerTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/bloc_observer.dart',
    appBlocObserverTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/debouncer.dart',
    debounceTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/error_entity.dart',
    errorEntityTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/failure.dart',
    failureTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/type_definitions.dart',
    typeDefinitionsTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/functions/get_current_function_name.dart',
    getCurrentFunctionNameTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/functions/list_to_model_list.dart',
    listToModelListTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/functions/safe_cast.dart',
    safeCastTemplate(localizationPackageName),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/functions/safe_execute.dart',
    safeExecuteTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/network/retrofit_call_adapter.dart',
    retrofitCallAdapterTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/network/retrofit_logger.dart',
    retrofitLoggerTemplate(),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/di/${utilsPackageName}_module.dart',
    utilsModuleTemplate(utilsClassName),
  );
  overwriteFile(
    'packages/$utilsPackageName/lib/src/di/di_initializer.dart',
    utilsDiInitializerTemplate(),
  );

  stdout.writeln('📦 $utilsPackageName package created');
  stdout.writeln();
}
