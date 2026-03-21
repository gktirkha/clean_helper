import 'dart:io';

import '../functions/init/add_flutter_assets_to_pubspec.dart';
import '../functions/init/create_directories.dart';
import '../functions/init/generate_core_files.dart';
import '../functions/init/generate_flutter_gen_files.dart';
import '../functions/init/generate_home_feature.dart';
import '../functions/init/generate_localization_files.dart';
import '../functions/init/install_dependencies.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/init/run_slang.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/read_package_name.dart';

void runInit() {
  ensurePubspec();

  final packageName = readPackageName();

  stdout.writeln('Initializing architecture for: $packageName');
  stdout.writeln();

  createDirectories();
  generateLocalizationFiles();
  generateFlutterGenFiles();
  generateCoreFiles(packageName);
  generateHomeFeature(packageName);
  installDependencies();
  addFlutterAssetsToPubSpec();
  runSlang();
  runBuildRunner();
  runDartFormat();

  stdout.writeln();
  stdout.writeln('✅ Done! Project is ready.');
  stdout.writeln();
  stdout.writeln('Next steps:');
  stdout.writeln('  • Add a feature:     dart run tools/generate_feature.dart <name>');
  stdout.writeln('  • Add a route:       /new-route <name>  (Claude Code skill)');
  stdout.writeln('  • Register routers:  lib/app/router/router_module.dart');
}
