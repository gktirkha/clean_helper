import 'dart:io';

import '../../clean_helper.dart';
import '../functions/feature/create_feature_structure.dart';
import '../functions/init/add_packages_workspace.dart';
import '../functions/init/add_flutter_assets_to_pubspec.dart';
import '../functions/init/generate_analysis_options.dart';
import '../functions/init/create_directories.dart';
import '../functions/init/generate_clean_router_package.dart';
import '../functions/init/generate_core_files.dart';
import '../functions/init/generate_flutter_gen_files.dart';
import '../functions/init/generate_localization_package.dart';
import '../functions/init/generate_tools_files.dart';
import '../functions/init/generate_utils_package.dart';
import '../functions/init/install_dependencies.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/init/write_tool_version.dart';
import '../functions/init/run_flutter_pub_get.dart';
import '../functions/init/run_slang.dart';
import '../functions/init/sort_pubspec_deps.dart';
import '../functions/init/update_gitignore.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/fvm_use.dart';
import '../functions/shared/read_package_name.dart';
import '../functions/shared/resolve_call_adapter_name.dart';
import '../functions/shared/resolve_localization_package.dart';
import '../functions/shared/resolve_network_package.dart';
import '../functions/shared/resolve_router_package.dart';
import '../functions/shared/resolve_slang_settings.dart';
import '../functions/shared/resolve_utils_module_name.dart';
import '../functions/shared/resolve_utils_package.dart';

Future<void> runInit({
  bool withNetwork = false,
  bool withDi = false,
  bool withTools = false,
}) async {
  ensurePubspec();

  final packageName = readPackageName();
  final utils = resolveUtilsPackage();
  final localization = resolveLocalizationPackage();
  final router = resolveRouterPackage();
  final slang = resolveSlangSettings();
  final created = [router, localization, utils].where((p) => p.create);

  stdout.writeln('Initializing architecture for: $packageName');
  stdout.writeln();

  await fvmUse();
  generateAnalysisOptions();
  runFlutterPubGet();
  createDirectories();
  generateFlutterGenFiles();
  if (router.create) generateCleanRouterPackage(router);
  if (localization.create) generateLocalizationPackage(localization, slang);
  if (utils.create) {
    generateUtilsPackage(
      utils,
      localization,
      moduleName: resolveUtilsModuleName(utils),
      translateVar: slang['translate_var']!,
      callAdapterName: resolveCallAdapterName(),
    );
  }
  addPackagesWorkspace([for (final p in created) 'packages/${p.name}']);
  generateCoreFiles(utils: utils, localization: localization, router: router);
  createFeatureStructure(
    'lib/features/home',
    'home',
    utils.import,
    router.import,
    withDi: withDi,
  );
  installDependencies([router.name, localization.name, utils.name]);
  updateGitignore();
  addFlutterAssetsToPubSpec();
  if (withNetwork) addNetworkModule(runBuildRunnerAfter: false);
  // After the network package, so tools/bootstrap.dart includes it.
  if (withTools) generateToolsFiles();
  if (localization.create) runSlang(localization.name);
  stdout.writeln();
  // Package micro-modules first: the app's DI config references them.
  for (final dir in [
    if (utils.create) 'packages/${utils.name}',
    if (withNetwork) 'packages/${resolveNetworkPackage().name}',
  ]) {
    if (Directory(dir).existsSync()) runBuildRunner(workingDirectory: dir);
  }
  runBuildRunner();
  runDartFormat();
  sortPubspecDeps();
  for (final p in created) {
    if (p != router) sortPubspecDeps('packages/${p.name}/pubspec.yaml');
  }
  writeToolVersion();

  stdout.writeln();
  stdout.writeln('✅ Done! Project is ready.');
  stdout.writeln();
  stdout.writeln('Next steps:');
  stdout.writeln('  • Add a feature:     clean-helper add-feature <name>');
}
