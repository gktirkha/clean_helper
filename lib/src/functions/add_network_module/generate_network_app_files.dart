import 'dart:io';

import '../../templates/api_failure_template.dart';
import '../../templates/app_auth_interceptor_template.dart';
import '../../templates/app_call_adapter_template.dart';
import '../../templates/core_api_paths_template.dart';
import '../../templates/error_model_template.dart';
import '../../templates/network_config_module_template.dart';
import '../shared/write_file.dart';

/// The app's side of the network package: `ApiPaths`, the backend's
/// `ErrorModel`, `ApiFailure`, the Retrofit call adapter ([callAdapterName])
/// that turns errors into failures, with [auth] the `AppAuthInterceptor`, and
/// the `NetworkConfigModule` registering `NetworkConfig` (and the auth
/// interceptor).
void generateNetworkAppFiles(
  String networkImport,
  String utilsImport, {
  required String callAdapterName,
  required bool auth,
}) {
  writeFile(
    'lib/core/network/constants/api_paths.dart',
    coreApiPathsTemplate(),
  );
  writeFile('lib/core/data/models/error_model.dart', errorModelTemplate());
  writeFile(
    'lib/core/network/failures/api_failure.dart',
    apiFailureTemplate(utilsImport),
  );
  writeFile(
    'lib/core/network/adapters/app_call_adapter.dart',
    appCallAdapterTemplate(callAdapterName, utilsImport),
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
