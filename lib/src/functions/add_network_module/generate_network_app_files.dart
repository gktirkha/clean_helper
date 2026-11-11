import 'dart:io';

import '../../templates/app_auth_interceptor_template.dart';
import '../../templates/app_error_interceptor_template.dart';
import '../../templates/core_api_paths_template.dart';
import '../../templates/error_model_template.dart';
import '../../templates/network_config_module_template.dart';
import '../shared/write_file.dart';

/// The app's side of the network package: `ApiPaths`, `ErrorModel` and the
/// `AppErrorInterceptor` that parses into it, with [auth] the
/// `AppAuthInterceptor`, and the `NetworkConfigModule` registering
/// `NetworkConfig` and those interceptors.
void generateNetworkAppFiles(
  String networkImport,
  String utilsImport, {
  required bool auth,
}) {
  writeFile(
    'lib/core/network/constants/api_paths.dart',
    coreApiPathsTemplate(),
  );
  writeFile(
    'lib/core/data/models/error_model.dart',
    errorModelTemplate(utilsImport),
  );
  writeFile(
    'lib/core/network/interceptors/app_error_interceptor.dart',
    appErrorInterceptorTemplate(networkImport, utilsImport),
  );
  if (auth) {
    writeFile(
      'lib/core/network/interceptors/app_auth_interceptor.dart',
      appAuthInterceptorTemplate(networkImport),
    );
  }
  writeFile(
    'lib/core/network/di/network_config_module.dart',
    networkConfigModuleTemplate(networkImport, auth: auth),
  );
  stdout.writeln('🌐 App network files generated');
}
