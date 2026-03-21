import 'dart:io';

import '../shared/write_file.dart';
import 'templates/analysis_options_template.dart';
import 'templates/app_go_router_template.dart';
import 'templates/bootstrap_dart_template.dart';
import 'templates/core_module_template.dart';
import 'templates/di_container_template.dart';
import 'templates/di_initializer_template.dart';
import 'templates/di_keys_template.dart';
import 'templates/main_app_dart_template.dart';
import 'templates/main_dart_template.dart';
import 'templates/router_base_template.dart';
import 'templates/router_module_template.dart';
import 'templates/router_refresh_template.dart';

void generateCoreFiles(String packageName) {
  overwriteFile('analysis_options.yaml', analysisOptionsTemplate());
  overwriteFile('lib/main.dart', mainDartTemplate());
  writeFile('lib/app/bootstrap.dart', bootstrapDartTemplate(packageName));
  writeFile('lib/app/main_app.dart', mainAppDartTemplate(packageName));
  writeFile(
    'lib/app/router/app_go_router.dart',
    appGoRouterTemplate(packageName),
  );
  writeFile(
    'lib/app/router/router_module.dart',
    routerModuleTemplate(packageName),
  );
  writeFile('lib/core/di/di_container.dart', diContainerTemplate());
  writeFile('lib/core/di/core_module.dart', coreModuleTemplate());
  writeFile('lib/core/di/di_initializer.dart', diInitializerTemplate());
  writeFile('lib/core/router/router_base.dart', routerBaseTemplate());
  writeFile('lib/core/router/router_refresh.dart', routerRefreshTemplate());
  writeFile('lib/core/di/di_keys.dart', diKeysTemplate());
  stdout.writeln('⚙️  Core files generated');
}
