import 'dart:io';

import '../functions/add_network_module/install_network_dependencies.dart';
import '../functions/init/add_chucker_dependency.dart';
import '../functions/init/generate_network_files.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/shared/ensure_pubspec.dart';

void addNetwork() {
  ensurePubspec();

  stdout.writeln('🌐 Setting up network layer...');
  stdout.writeln();

  generateNetworkFiles();
  installNetworkDependencies();
  addChuckerDependency();
  runBuildRunner();
  runDartFormat();

  stdout.writeln();
  stdout.writeln('✅ Network layer ready.');
}
