import 'dart:io';

import '../functions/init/add_packages_workspace.dart';
import '../functions/init/generate_clean_router_package.dart';
import '../functions/init/generate_localization_package.dart';
import '../functions/init/generate_network_package.dart';
import '../functions/init/generate_utils_package.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/init/run_flutter_pub_get.dart';
import '../functions/init/run_slang.dart';
import '../functions/init/sort_pubspec_deps.dart';
import '../functions/shared/abort.dart';
import '../functions/shared/write_file.dart';
import '../templates/analysis_options_template.dart';
import '../functions/shared/load_package_configs.dart';
import '../functions/shared/package_configs.dart';
import '../functions/shared/resolve_call_adapter_name.dart';
import '../functions/shared/resolve_localization_package.dart';
import '../functions/shared/resolve_network_module_name.dart';
import '../functions/shared/resolve_network_package.dart';
import '../functions/shared/resolve_router_package.dart';
import '../functions/shared/resolve_slang_settings.dart';
import '../functions/shared/resolve_utils_module_name.dart';
import '../functions/shared/resolve_utils_package.dart';

// Does NOT call ensurePubspec() — packages are created relative to the
// current directory (typically the workspace root), and ensurePubspec()
// would switch into a monorepo app first.

/// Generates the utils, localization and router packages described by
/// `clean-helper.packages` in `<dir>/<name>` — plus the network package when
/// `packages.network` is configured — ignoring each `create` flag,
/// and lists them under `workspace:` in `./pubspec.yaml`. [dir] defaults to
/// `packages`. A package whose folder already has a `pubspec.yaml` is skipped.
void createPackages({String? dir}) {
  if (!File('pubspec.yaml').existsSync()) {
    abort('pubspec.yaml not found. Run this tool from the workspace root.');
  }
  loadPackageConfigs();

  final parentDir = (dir == null || dir.trim().isEmpty)
      ? 'packages'
      : dir
            .trim()
            .replaceFirst(RegExp(r'^\./'), '')
            .replaceFirst(RegExp(r'/+$'), '');
  final utils = resolveUtilsPackage();
  final localization = resolveLocalizationPackage();
  final router = resolveRouterPackage();
  final slang = resolveSlangSettings();
  // Optional: only when packages.network is configured.
  final network = networkPackageConfig == null ? null : resolveNetworkPackage();

  bool exists(String name) {
    if (!File('$parentDir/$name/pubspec.yaml').existsSync()) return false;
    stdout.writeln('  ⏭  Skipped (exists): $parentDir/$name');
    return true;
  }

  stdout.writeln('🚀 Creating packages in $parentDir/');
  stdout.writeln();

  final createRouter = !exists(router.name);
  final createLocalization = !exists(localization.name);
  final createUtils = !exists(utils.name);
  final createNetwork = network != null && !exists(network.name);

  if (createRouter) generateCleanRouterPackage(router, parentDir: parentDir);
  if (createLocalization) {
    generateLocalizationPackage(localization, slang, parentDir: parentDir);
  }
  if (createUtils) {
    generateUtilsPackage(
      utils,
      localization,
      moduleName: resolveUtilsModuleName(utils),
      translateVar: slang['translate_var']!,
      callAdapterName: resolveCallAdapterName(),
      parentDir: parentDir,
    );
  }
  if (createNetwork) {
    generateNetworkPackage(
      network,
      utils,
      moduleName: resolveNetworkModuleName(network),
      auth: networkAuthInterceptorConfig,
      parentDir: parentDir,
    );
  }

  final created = [
    if (createRouter) router.name,
    if (createLocalization) localization.name,
    if (createUtils) utils.name,
    if (createNetwork) network.name,
  ];
  if (created.isEmpty) {
    stdout.writeln();
    stdout.writeln('✅ Nothing to create — every package already exists.');
    return;
  }

  // The packages include this directory's analysis_options.yaml.
  writeFile('analysis_options.yaml', analysisOptionsTemplate());
  addPackagesWorkspace([for (final name in created) '$parentDir/$name']);
  runFlutterPubGet();
  if (createLocalization) {
    runSlang(localization.name, parentDir: parentDir);
    sortPubspecDeps('$parentDir/${localization.name}/pubspec.yaml');
  }
  if (createUtils) {
    runBuildRunner(workingDirectory: '$parentDir/${utils.name}');
    sortPubspecDeps('$parentDir/${utils.name}/pubspec.yaml');
  }
  if (createNetwork) {
    runBuildRunner(workingDirectory: '$parentDir/${network.name}');
    sortPubspecDeps('$parentDir/${network.name}/pubspec.yaml');
  }
  runDartFormat();

  stdout.writeln();
  stdout.writeln('✅ Created ${created.join(', ')} in $parentDir/.');
  stdout.writeln(
    '   Set `create: false` for them in clean-helper.packages so `init` '
    "doesn't generate them again.",
  );
}
