import 'dart:io';

import '../shared/package_configs.dart';
import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import '../../templates/app_go_router_redirect_template.dart';
import '../../templates/app_go_router_template.dart';
import '../../templates/app_module_template.dart';
import '../../templates/bootstrap_dart_template.dart';
import '../../templates/core_module_template.dart';
import '../../templates/di_container_template.dart';
import '../../templates/di_initializer_template.dart';
import '../../templates/di_keys_template.dart';
import '../../templates/init_service_template.dart';
import '../../templates/main_app_dart_template.dart';
import '../../templates/main_dart_template.dart';
import '../../templates/app_router_module_template.dart';

void generateCoreFiles(
  String packageName, {
  required PackageConfig utils,
  required PackageConfig localization,
  required PackageConfig router,
}) {
  overwriteFile('lib/main.dart', mainDartTemplate());
  writeFile('lib/app/bootstrap.dart', bootstrapDartTemplate());
  writeFile(
    'lib/app/init_service.dart',
    initServiceTemplate(utils.import, localization.import),
  );
  writeFile('lib/app/main_app.dart', mainAppDartTemplate(localization.import));
  writeFile(
    'lib/app/router/app_go_router.dart',
    appGoRouterTemplate(router.import),
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
  writeFile(
    'lib/app/di/di_initializer.dart',
    diInitializerTemplate(
      utils.import,
      '${pascalCase(utils.name)}PackageModule',
    ),
  );
  writeFile('lib/core/di/di_keys.dart', diKeysTemplate());
  writeFile('lib/app/di/app_module.dart', appModuleTemplate());
  writeFile('lib/core/di/core_module.dart', coreModuleTemplate());
  stdout.writeln();
  stdout.writeln('⚙️  Core files generated');
  stdout.writeln();
}
