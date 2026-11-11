import 'dart:io';

import '../../templates/core_api_paths_template.dart';
import '../../templates/error_interceptor_template.dart';
import '../../templates/error_model_template.dart';
import '../../templates/network_module_template.dart';
import '../shared/write_file.dart';
import 'generate_retrofit_call_adapter.dart';
import 'generate_retrofit_logger.dart';

/// Writes the app's network layer under `lib/core/`: API paths, error model
/// and interceptor, the call adapter ([callAdapterName]) and logger, and
/// `NetworkModule`.
void generateNetworkFiles(
  String utilsImport, {
  String callAdapterName = 'RetrofitCallAdapter',
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
    'lib/core/network/interceptors/error_interceptor.dart',
    errorInterceptorTemplate(),
  );
  generateRetrofitCallAdapter(utilsImport, callAdapterName);
  generateRetrofitLogger(utilsImport);
  writeFile('lib/core/network/di/network_module.dart', networkModuleTemplate());
  stdout.writeln('🌐 Network module generated');
}
