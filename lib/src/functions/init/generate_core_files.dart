import 'dart:io';

import '../feature/build_router_module.dart';
import '../shared/package_configs.dart';
import '../shared/app_router_module_path.dart';
import '../shared/pascal_case.dart';
import '../shared/read_package_name.dart';
import '../shared/write_file.dart';
import '../../templates/app_go_router_redirect_template.dart';
import '../../templates/app_go_router_template.dart';
import '../../templates/app_module_template.dart';
import '../../templates/bootstrap_dart_template.dart';
import '../../templates/core_module_template.dart';
import '../../templates/di_container_template.dart';
import '../../templates/di_initializer_template.dart';
import '../../templates/init_service_template.dart';
import '../../templates/main_app_dart_template.dart';
import '../../templates/main_dart_template.dart';

void generateCoreFiles({
  required PackageConfig utils,
  required PackageConfig localization,
  required PackageConfig router,
}) {
  final appName = readPackageName();

  overwriteFile('lib/main.dart', mainDartTemplate());
  writeFile('lib/app/bootstrap.dart', bootstrapDartTemplate());
  writeFile(
    'lib/app/init_service.dart',
    initServiceTemplate(utils.import, localization.import),
  );
  writeFile(
    'lib/app/main_app.dart',
    mainAppDartTemplate(appName, localization.import),
  );
  writeFile(
    'lib/app/router/${appName}_router.dart',
    appGoRouterTemplate(appName, router.import, pascalCase(router.name)),
  );
  writeFile(
    'lib/app/router/${appName}_router_redirect.dart',
    appGoRouterRedirectTemplate(appName, pascalCase(router.name)),
  );
  writeFile(appRouterModulePath(), buildRouterModule(['home']));
  writeFile('lib/app/di/di_container.dart', diContainerTemplate());
  writeFile(
    'lib/app/di/di_initializer.dart',
    diInitializerTemplate(
      utils.import,
      '${pascalCase(utils.name)}PackageModule',
    ),
  );
  writeFile('lib/app/di/app_module.dart', appModuleTemplate());
  writeFile('lib/core/di/core_module.dart', coreModuleTemplate());
  stdout.writeln();
  stdout.writeln('⚙️  Core files generated');
  stdout.writeln();
}
