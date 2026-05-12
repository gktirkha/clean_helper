import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/core_api_paths_template.dart';
import '../../templates/error_model_template.dart';
import '../../templates/error_interceptor_template.dart';
import '../../templates/network_module_template.dart';
import 'generate_retrofit_logger.dart';

void generateNetworkFiles() {
  writeFile(
    'lib/core/network/constants/api_paths.dart',
    coreApiPathsTemplate(),
  );
  writeFile('lib/core/data/models/error_model.dart', errorModelTemplate());
  writeFile(
    'lib/core/network/interceptors/error_interceptor.dart',
    errorInterceptorTemplate(),
  );
  writeFile('lib/core/network/di/network_module.dart', networkModuleTemplate());
  generateRetrofitLogger();
  stdout.writeln('🌐 Network module generated');
}
