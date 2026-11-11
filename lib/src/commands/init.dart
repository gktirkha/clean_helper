import 'dart:io';

import '../../clean_helper.dart';
import '../functions/init/add_packages_workspace.dart';
import '../functions/init/add_flutter_assets_to_pubspec.dart';
import '../functions/init/generate_analysis_options.dart';
import '../functions/init/create_directories.dart';
import '../functions/init/generate_clean_router_package.dart';
import '../functions/init/generate_core_files.dart';
import '../functions/init/generate_flutter_gen_files.dart';
import '../functions/init/generate_home_feature.dart';
import '../functions/init/generate_localization_files.dart';
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
import '../functions/shared/package_configs.dart';
import '../functions/shared/pascal_case.dart';
import '../functions/shared/read_package_name.dart';
import '../functions/shared/resolve_localization_package.dart';
import '../functions/shared/resolve_router_package.dart';
import '../functions/shared/resolve_slang_settings.dart';
import '../functions/shared/resolve_utils_package.dart';

Future<void> runInit({
  bool withNetwork = false,
  bool withDi = false,
  bool withAuthInterceptor = false,
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
  generateLocalizationFiles();
  generateFlutterGenFiles();
  if (router.create) generateCleanRouterPackage(router);
  if (localization.create) generateLocalizationPackage(localization, slang);
  if (utils.create) {
    generateUtilsPackage(
      utils,
      localization,
      moduleName: utilsModuleNameConfig ?? '${pascalCase(utils.name)}Module',
      translateVar: slang['translate_var']!,
    );
  }
  addPackagesWorkspace([for (final p in created) p.name]);
  generateCoreFiles(
    packageName,
    utils: utils,
    localization: localization,
    router: router,
  );
  generateHomeFeature(utils.import, router.import, withDi: withDi);
  if (withTools) generateToolsFiles();
  installDependencies([router.name, localization.name, utils.name]);
  updateGitignore();
  addVscodeConfig();
  addFlutterAssetsToPubSpec();
  if (withNetwork || withAuthInterceptor) {
    addNetworkModule(runBuildRunnerAfter: false);
  }
  if (withAuthInterceptor) {
    addAuthInterceptor(runBuildRunnerAfter: false, showNextSteps: false);
  }
  if (localization.create) runSlang(localization.name);
  stdout.writeln();
  if (utils.create) {
    runBuildRunner(workingDirectory: 'packages/${utils.name}');
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
