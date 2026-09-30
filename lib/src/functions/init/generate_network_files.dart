import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/core_api_paths_template.dart';
import '../../templates/error_model_template.dart';
import '../../templates/error_interceptor_template.dart';
import '../../templates/network_module_template.dart';
import 'generate_retrofit_call_adapter.dart';
import 'generate_retrofit_logger.dart';

/// [retrofitHelpersInUtils] is true for projects initialised before 1.4.4,
/// whose utils package already has `RetrofitCallAdapter` / `RetrofitLogger`;
/// generating them again under `lib/core/network/utils/` would clash.
void generateNetworkFiles(
  String utilsImport, {
  bool registerErrorLogger = true,
  bool retrofitHelpersInUtils = false,
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
  if (!retrofitHelpersInUtils) {
    generateRetrofitCallAdapter(utilsImport);
    generateRetrofitLogger(utilsImport);
  }
  writeFile(
    'lib/core/network/di/network_module.dart',
    networkModuleTemplate(
      retrofitHelpersInUtils ? utilsImport : '../utils/retrofit_logger.dart',
      registerErrorLogger: registerErrorLogger,
    ),
  );
  stdout.writeln('🌐 Network module generated');
}
