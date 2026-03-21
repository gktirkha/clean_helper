import 'dart:io';

import '../functions/add_network_module/install_network_dependencies.dart';
import '../functions/add_network_module/patch_app_go_router.dart';
import '../functions/init/add_chucker_dependency.dart';
import '../functions/init/generate_network_files.dart';
import '../functions/shared/ensure_pubspec.dart';

void addNetworkModule() {
  ensurePubspec();

  stdout.writeln('🌐 Setting up network layer...');
  stdout.writeln();

  generateNetworkFiles();
  installNetworkDependencies();
  addChuckerDependency();
  patchAppGoRouter();

  stdout.writeln();
  stdout.writeln('✅ Network layer ready.');
}
