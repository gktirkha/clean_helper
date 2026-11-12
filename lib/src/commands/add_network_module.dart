import 'dart:io';

import '../functions/add_network_module/generate_network_app_files.dart';
import '../functions/add_network_module/install_network_dependencies.dart';
import '../functions/add_network_module/patch_di_initializer.dart';
import '../functions/add_network_module/patch_dio_lens_init.dart';
import '../functions/init/add_packages_workspace.dart';
import '../functions/init/generate_network_package.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/init/sort_pubspec_deps.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/package_configs.dart';
import '../functions/shared/pascal_case.dart';
import '../functions/shared/resolve_call_adapter_name.dart';
import '../functions/shared/resolve_network_module_name.dart';
import '../functions/shared/resolve_network_package.dart';
import '../functions/shared/resolve_utils_package.dart';
import '../functions/shared/write_package_analysis_options.dart';

/// Creates the network package in `packages/<network>` (unless `create:
/// false` or it already exists) and wires the app to it: `ApiPaths`,
/// `ErrorModel`, `ApiFailure`, the call adapter, `AppAuthInterceptor` (with
/// `auth_interceptor`), `NetworkConfigModule`, the package module in
/// `di_initializer.dart`, and `DioLens.init`.
void addNetworkModule({bool runBuildRunnerAfter = true}) {
  ensurePubspec();

  stdout.writeln('🌐 Setting up network layer...');

  final network = resolveNetworkPackage();
  final auth = networkAuthInterceptorConfig;
  final packageDir = 'packages/${network.name}';

  final utils = resolveUtilsPackage();

  final createPackage =
      network.create && !File('$packageDir/pubspec.yaml').existsSync();
  if (createPackage) {
    generateNetworkPackage(
      network,
      moduleName: resolveNetworkModuleName(network),
      auth: auth,
    );
    addPackagesWorkspace([packageDir]);
  }

  writePackageAnalysisOptions([packageDir]);
  generateNetworkAppFiles(
    network.import,
    utils.import,
    callAdapterName: resolveCallAdapterName(),
    auth: auth,
  );
  installNetworkDependencies(network.name);
  patchDiInitializer(
    network.import,
    '${pascalCase(network.name)}PackageModule',
  );
  patchDioLensInit();
  if (createPackage) sortPubspecDeps('$packageDir/pubspec.yaml');
  runDartFormat();

  if (runBuildRunnerAfter) {
    if (Directory(packageDir).existsSync()) {
      runBuildRunner(workingDirectory: packageDir);
    }
    runBuildRunner();
  }

  stdout.writeln('✅ Network layer ready.');
  if (auth) {
    stdout.writeln(
      '   Fill in the TODOs in '
      'lib/core/network/interceptors/app_auth_interceptor.dart',
    );
  }
}
