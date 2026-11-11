import 'dart:io';

import '../functions/feature/create_feature_structure.dart';
import '../functions/feature/patch_router_module.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/shared/abort.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/resolve_router_package.dart';
import '../functions/shared/resolve_utils_package.dart';

void addFeature(
  List<String> args, {
  bool withDi = false,
  bool runBuildRunnerAfter = true,
}) {
  ensurePubspec();

  if (args.isEmpty) {
    abort('Usage: clean-helper add-feature <feature_name> [--di]');
  }

  final featureName = args.first.toLowerCase();
  final basePath = 'lib/features/$featureName';

  final utils = resolveUtilsPackage();

  stdout.writeln('🚀 Generating feature: $featureName');
  createFeatureStructure(
    basePath,
    featureName,
    utils.import,
    resolveRouterPackage().import,
    withDi: withDi,
  );
  patchRouterModule(featureName);
  runDartFormat();
  if (runBuildRunnerAfter) runBuildRunner();

  stdout.writeln('✅ Feature "$featureName" generated successfully!');
}
