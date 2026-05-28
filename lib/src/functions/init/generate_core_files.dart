import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/app_bloc_observer_template.dart';
import '../../templates/app_go_router_redirect_template.dart';
import '../../templates/app_go_router_template.dart';
import '../../templates/app_module_template.dart';
import '../../templates/bootstrap_dart_template.dart';
import '../../templates/core_module_template.dart';
import '../../templates/di_container_template.dart';
import '../../templates/di_initializer_template.dart';
import '../../templates/di_keys_template.dart';
import '../../templates/main_app_dart_template.dart';
import '../../templates/main_dart_template.dart';
import '../../templates/app_router_module_template.dart';
import '../../templates/string_extension_template.dart';

void generateCoreFiles(String packageName) {
  overwriteFile('lib/main.dart', mainDartTemplate());
  writeFile('lib/app/bootstrap.dart', bootstrapDartTemplate(packageName));
  writeFile('lib/app/main_app.dart', mainAppDartTemplate(packageName));
  writeFile(
    'lib/app/router/app_go_router.dart',
    appGoRouterTemplate(packageName),
  );
  writeFile(
    'lib/app/router/app_go_router_redirect.dart',
    appGoRouterRedirectTemplate(),
  );
  writeFile(
    'lib/app/router/app_router_module.dart',
    appRouterModuleTemplate(packageName),
  );
  writeFile('lib/app/di/di_container.dart', diContainerTemplate());
  writeFile('lib/app/di/di_initializer.dart', diInitializerTemplate());
  writeFile('lib/core/di/di_keys.dart', diKeysTemplate());
  writeFile('lib/app/utils/app_bloc_observer.dart', appBlocObserverTemplate());
  writeFile('lib/app/di/app_module.dart', appModuleTemplate());
  writeFile('lib/core/di/core_module.dart', coreModuleTemplate());
  writeFile(
    'lib/core/utils/extensions/string_extension.dart',
    stringExtensionTemplate(),
  );
  stdout.writeln();
  stdout.writeln('⚙️  Core files generated');
  stdout.writeln();
}
