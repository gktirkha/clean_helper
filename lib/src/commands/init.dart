import 'dart:io';

import '../../clean_helper.dart';
import '../functions/init/add_clean_router_workspace.dart';
import '../functions/init/add_flutter_assets_to_pubspec.dart';
import '../functions/init/generate_analysis_options.dart';
import '../functions/init/create_directories.dart';
import '../functions/init/generate_clean_router_package.dart';
import '../functions/init/generate_core_files.dart';
import '../functions/init/generate_flutter_gen_files.dart';
import '../functions/init/generate_home_feature.dart';
import '../functions/init/generate_localization_files.dart';
import '../functions/init/generate_tools_files.dart';
import '../functions/init/generate_utils_files.dart';
import '../functions/init/install_dependencies.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/update_gitignore.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/init/run_flutter_pub_get.dart';
import '../functions/init/run_slang.dart';
import '../functions/init/sort_pubspec_deps.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/fvm_use.dart';
import '../functions/shared/read_package_name.dart';

Future<void> runInit({
  bool withNetwork = false,
  bool withDi = false,
  bool withAuthInterceptor = false,
  bool withTools = false,
}) async {
  ensurePubspec();

  final packageName = readPackageName();

  stdout.writeln('Initializing architecture for: $packageName');
  stdout.writeln();

  await fvmUse();
  generateAnalysisOptions();
  runFlutterPubGet();
  createDirectories();
  generateLocalizationFiles();
  generateFlutterGenFiles();
  generateCleanRouterPackage();
  addCleanRouterWorkspace();
  generateCoreFiles(packageName);
  generateUtilsFiles();
  generateHomeFeature(packageName, withDi: withDi);
  if (withTools) generateToolsFiles();
  installDependencies();
  updateGitignore();
  addVscodeConfig();
  addFlutterAssetsToPubSpec();
  if (withNetwork || withAuthInterceptor) {
    addNetworkModule(runBuildRunnerAfter: false);
  }
  if (withAuthInterceptor) {
    addAuthInterceptor(runBuildRunnerAfter: false, showNextSteps: false);
  }
  sortPubspecDeps();
  runSlang();
  stdout.writeln();
  runBuildRunner();
  runDartFormat();

  stdout.writeln();
  stdout.writeln('✅ Done! Project is ready.');
  stdout.writeln();
  stdout.writeln('Next steps:');
  stdout.writeln('  • Add a feature:     clean-helper add-feature <name>');
}
