import 'dart:io';

import '../../templates/app_bloc_observer_template.dart';
import '../../templates/app_logger_template.dart';
import '../../templates/context_utils_template.dart';
import '../../templates/debounce_template.dart';
import '../../templates/di_container_template.dart';
import '../../templates/error_entity_template.dart';
import '../../templates/failure_template.dart';
import '../../templates/get_current_function_name_template.dart';
import '../../templates/list_to_model_list_template.dart';
import '../../templates/safe_cast_template.dart';
import '../../templates/safe_execute_task_template.dart';
import '../../templates/safe_execute_template.dart';
import '../../templates/type_definitions_template.dart';
import '../../templates/use_case_base_template.dart';
import '../../templates/micro_package_di_initializer_template.dart';
import '../../templates/retrofit_call_adapter_template.dart';
import '../../templates/utils_lib_export_template.dart';
import '../../templates/utils_module_template.dart';
import '../../templates/utils_pubspec_tail_template.dart';
import '../shared/package_barrel_path.dart';
import '../shared/package_barrel_prefix.dart';
import '../shared/package_configs.dart';
import '../shared/write_file.dart';
import 'patch_package_pubspec.dart';
import 'scaffold_package.dart';

/// Creates `<parentDir>/<name>` from [package]. [localization] is the package
/// it depends on (for `safeCast`'s message), [translateVar] its slang
/// `translate_var`, [moduleName] the `@module` class registering
/// `BlocObserver`, and [callAdapterName] the Retrofit call adapter class.
void generateUtilsPackage(
  PackageConfig package,
  PackageConfig localization, {
  required String moduleName,
  required String translateVar,
  required String callAdapterName,
  String parentDir = 'packages',
}) {
  final utilsPackageName = package.name;
  stdout.writeln('📦 Creating $utilsPackageName package...');

  scaffoldPackage(package, parentDir: parentDir);

  patchPackagePubspec(
    '$parentDir/$utilsPackageName',
    utilsPubspecTailTemplate(localization.name),
  );

  overwriteFile(
    packageBarrelPath(package, parentDir),
    utilsLibExportTemplate(packageBarrelPrefix(package)),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/app_logger.dart',
    appLoggerTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/bloc_observer.dart',
    appBlocObserverTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/debouncer.dart',
    debounceTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/error_entity.dart',
    errorEntityTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/failure.dart',
    failureTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/type_definitions.dart',
    typeDefinitionsTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/network/retrofit_call_adapter.dart',
    retrofitCallAdapterTemplate(callAdapterName),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/use_case_base.dart',
    useCaseBaseTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/functions/get_current_function_name.dart',
    getCurrentFunctionNameTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/functions/list_to_model_list.dart',
    listToModelListTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/functions/safe_cast.dart',
    safeCastTemplate(localization.import, translateVar),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/functions/safe_execute.dart',
    safeExecuteTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/functions/safe_execute_task.dart',
    safeExecuteTaskTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/di/${utilsPackageName}_module.dart',
    utilsModuleTemplate(moduleName),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/di/di_initializer.dart',
    microPackageDiInitializerTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/di/di_container.dart',
    diContainerTemplate(),
  );
  overwriteFile(
    '$parentDir/$utilsPackageName/lib/src/context_utils.dart',
    contextUtilsTemplate(),
  );

  stdout.writeln('📦 $utilsPackageName package created');
  stdout.writeln();
}
