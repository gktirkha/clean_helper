import 'dart:io';

import '../../clean_helper.dart';
import '../functions/agent_context/generate_agent_context.dart';
import '../functions/feature/create_feature_structure.dart';
import '../functions/init/add_packages_workspace.dart';
import '../functions/init/add_flutter_assets_to_pubspec.dart';
import '../functions/init/generate_analysis_options.dart';
import '../functions/init/create_directories.dart';
import '../functions/init/generate_clean_router_package.dart';
import '../functions/init/generate_core_files.dart';
import '../functions/init/generate_flutter_gen_files.dart';
import '../functions/init/generate_localization_package.dart';
import '../functions/init/generate_theme_package.dart';
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
import '../functions/shared/tool_version.dart';
import '../functions/shared/read_package_name.dart';
import '../functions/shared/resolve_packages_dir.dart';
import '../functions/shared/resolve_localization_package.dart';
import '../functions/shared/resolve_network_package.dart';
import '../functions/shared/resolve_router_package.dart';
import '../functions/shared/resolve_slang_settings.dart';
import '../functions/shared/resolve_theme_package.dart';
import '../functions/shared/resolve_utils_module_name.dart';
import '../functions/shared/resolve_utils_package.dart';
import '../functions/shared/write_package_analysis_options.dart';

/// Scaffolds the project. The network package and home DI module are
/// generated unless switched off (`--skip-network`, `--skip-di`); `tools/`
/// only with `--tools`; `.agents/` AI context only with `--agent-context`.
Future<void> runInit({
  bool withNetwork = true,
  bool withDi = true,
  bool withTools = false,
  bool withAgentContext = false,
}) async {
  ensurePubspec();

  final packageName = readPackageName();
  final utils = resolveUtilsPackage();
  final localization = resolveLocalizationPackage();
  final router = resolveRouterPackage();
  final theme = resolveThemePackage();
  final slang = resolveSlangSettings();
  final packagesDir = resolvePackagesDir();
  final created = [router, localization, utils, theme].where((p) => p.create);

  stdout.writeln('Initializing architecture for: $packageName');
  stdout.writeln();

  await fvmUse();
  generateAnalysisOptions();
  runFlutterPubGet();
  createDirectories();
  generateFlutterGenFiles();
  if (router.create) {
    generateCleanRouterPackage(router, parentDir: packagesDir);
  }
  if (theme.create) generateThemePackage(theme, parentDir: packagesDir);
  if (localization.create) {
    generateLocalizationPackage(localization, slang, parentDir: packagesDir);
  }
  if (utils.create) {
    generateUtilsPackage(
      utils,
      moduleName: resolveUtilsModuleName(utils),
      parentDir: packagesDir,
    );
  }
  addPackagesWorkspace([for (final p in created) '$packagesDir/${p.name}']);
  generateCoreFiles(
    utils: utils,
    localization: localization,
    router: router,
    theme: theme,
  );
  createFeatureStructure(
    'lib/features/home',
    'home',
    utils.import,
    router,
    withDi: withDi,
  );
  installDependencies([router.name, localization.name, utils.name, theme.name]);
  updateGitignore();
  addFlutterAssetsToPubSpec();
  if (withNetwork) addNetworkModule(runBuildRunnerAfter: false);
  // Every package under packages/, created now or earlier, shares the rules.
  writePackageAnalysisOptions([
    for (final p in [
      router,
      localization,
      utils,
      theme,
      resolveNetworkPackage(),
    ])
      '$packagesDir/${p.name}',
  ]);
  // After the network package, so tools/bootstrap.dart includes it.
  if (withTools) generateToolsFiles();
  if (localization.create) {
    runSlang(localization.name, parentDir: packagesDir);
  }
  stdout.writeln();
  // Package micro-modules first: the app's DI config references them.
  for (final dir in [
    if (utils.create) '$packagesDir/${utils.name}',
    if (withNetwork) '$packagesDir/${resolveNetworkPackage().name}',
  ]) {
    if (Directory(dir).existsSync()) runBuildRunner(workingDirectory: dir);
  }
  runBuildRunner();
  runDartFormat();
  sortPubspecDeps();
  for (final p in created) {
    if (p != router) sortPubspecDeps('$packagesDir/${p.name}/pubspec.yaml');
  }
  // A monorepo app follows the root's version (see syncAppToolVersion).
  writeToolVersion(
    monoRepoAppPath == null
        ? toolVersion
        : rootToolVersionConfig ?? toolVersion,
  );
  if (withAgentContext) _generateAgentContextAtRoot();

  stdout.writeln();
  stdout.writeln('✅ Done! Project is ready.');
  stdout.writeln();
  stdout.writeln('Next steps:');
  stdout.writeln('  • Add a feature:     clean-helper add-feature <name>');
}

/// The AI context describes the whole project, so in a monorepo app it is
/// written at the workspace root, not in the app.
void _generateAgentContextAtRoot() {
  final appDir = Directory.current;
  final app = monoRepoAppPath;
  if (app != null) {
    Directory.current = List.filled(app.split('/').length, '..').join('/');
  }
  stdout.writeln();
  generateAgentContext();
  Directory.current = appDir;
}
