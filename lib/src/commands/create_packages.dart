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
import '../functions/shared/write_analysis_options.dart';
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
/// `packages`. A package whose folder already has a `pubspec.yaml` isn't
/// regenerated, but every package found there still gets the workspace
/// entry, pub get, slang and build_runner, so a rerun finishes a run that
/// stopped part-way.
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
  // Packages under parentDir, created now or by an earlier (possibly
  // interrupted) run: list them and finish their setup either way.
  bool present(String name) =>
      File('$parentDir/$name/pubspec.yaml').existsSync();
  final packages = [
    router,
    localization,
    utils,
    ?network,
  ].map((p) => p.name).where(present).toList();

  // The packages include this directory's analysis_options.yaml.
  writeAnalysisOptions('analysis_options.yaml', analysisOptionsTemplate());
  addPackagesWorkspace([for (final name in packages) '$parentDir/$name']);
  runFlutterPubGet();
  if (present(localization.name)) {
    runSlang(localization.name, parentDir: parentDir);
  }
  for (final name in [utils.name, ?network?.name]) {
    if (present(name)) runBuildRunner(workingDirectory: '$parentDir/$name');
  }
  for (final name in packages) {
    if (name != router.name) sortPubspecDeps('$parentDir/$name/pubspec.yaml');
  }
  runDartFormat();

  stdout.writeln();
  stdout.writeln(
    created.isEmpty
        ? '✅ Every package already existed in $parentDir/ — set up again.'
        : '✅ Created ${created.join(', ')} in $parentDir/.',
  );
  stdout.writeln(
    '   Set `create: false` for them in clean-helper.packages so `init` '
    "doesn't generate them again.",
  );
}
