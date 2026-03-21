import '../functions/init/add_chucker_dependency.dart';
import '../functions/init/add_flutter_assets_to_pubspec.dart';
import '../functions/init/create_directories.dart';
import '../functions/init/generate_core_files.dart';
import '../functions/init/generate_flutter_gen_files.dart';
import '../functions/init/generate_home_feature.dart';
import '../functions/init/generate_localization_files.dart';
import '../functions/init/generate_network_files.dart';
import '../functions/init/install_dependencies.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/init/run_slang.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/log.dart';
import '../functions/shared/read_package_name.dart';

void runInit() {
  ensurePubspec();

  final packageName = readPackageName();

  log('Initializing architecture for: $packageName');
  log('');

  createDirectories();
  generateLocalizationFiles();
  generateFlutterGenFiles();
  generateCoreFiles(packageName);
  generateNetworkFiles();
  generateHomeFeature(packageName);
  installDependencies();
  addChuckerDependency();
  addFlutterAssetsToPubSpec();
  runSlang();
  runBuildRunner();
  runDartFormat();

  log('');
  log('✅ Done! Project is ready.');
  log('');
  log('Next steps:');
  log('  • Add a feature:     dart run tools/generate_feature.dart <name>');
  log('  • Add a route:       /new-route <name>  (Claude Code skill)');
  log('  • Register routers:  lib/app/router/router_module.dart');
}
