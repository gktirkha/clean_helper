import 'dart:io';

import '../functions/add_network_module/install_network_dependencies.dart';
import '../functions/add_network_module/patch_dio_lens_init.dart';
import '../functions/add_network_module/utils_has_retrofit_helpers.dart';
import '../functions/add_network_module/utils_registers_error_logger.dart';
import '../functions/init/generate_network_files.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/resolve_call_adapter_name.dart';
import '../functions/shared/resolve_utils_package.dart';

void addNetworkModule({bool runBuildRunnerAfter = true}) {
  ensurePubspec();

  stdout.writeln('🌐 Setting up network layer...');

  final utils = resolveUtilsPackage();
  generateNetworkFiles(
    utils.import,
    callAdapterName: resolveCallAdapterName(),
    registerErrorLogger: !utilsRegistersErrorLogger(utils.name),
    retrofitHelpersInUtils: utilsHasRetrofitHelpers(utils.name),
  );
  installNetworkDependencies();
  patchDioLensInit();
  runDartFormat();
  if (runBuildRunnerAfter) runBuildRunner();

  stdout.writeln('✅ Network layer ready.');
}
