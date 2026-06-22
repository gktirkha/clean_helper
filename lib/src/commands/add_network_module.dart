import 'dart:io';

import '../functions/add_network_module/install_network_dependencies.dart';
import '../functions/add_network_module/patch_app_go_router.dart';
import '../functions/init/add_chucker_dependency.dart';
import '../functions/init/generate_network_files.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/read_package_name.dart';

void addNetworkModule({bool runBuildRunnerAfter = true}) {
  ensurePubspec();

  stdout.writeln('🌐 Setting up network layer...');

  final utilsPackageName = '${readPackageName()}_utils';
  generateNetworkFiles(utilsPackageName);
  installNetworkDependencies();
  addChuckerDependency();
  patchAppGoRouter();
  runDartFormat();
  if (runBuildRunnerAfter) runBuildRunner();

  stdout.writeln('✅ Network layer ready.');
}
