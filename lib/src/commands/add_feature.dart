import 'dart:io';

import '../functions/feature/create_feature_structure.dart';
import '../functions/feature/patch_router_module.dart';
import '../functions/feature/utils_has_context_utils.dart';
import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/package_configs.dart';
import '../functions/shared/read_package_name.dart';

void addFeature(
  List<String> args, {
  bool withDi = false,
  bool runBuildRunnerAfter = true,
}) {
  ensurePubspec();

  if (args.isEmpty) {
    stdout.writeln('❌ Please provide a feature name');
    stdout.writeln('Usage: clean-helper add_feature <feature_name>');
    return;
  }

  final featureName = args.first.toLowerCase();
  final basePath = 'lib/features/$featureName';

  final utilsPackageName =
      utilsPackageConfig?.name ?? '${readPackageName()}_utils';
  final utilsImport =
      utilsPackageConfig?.import ??
      'package:$utilsPackageName/$utilsPackageName.dart';

  stdout.writeln('🚀 Generating feature: $featureName');
  createFeatureStructure(
    basePath,
    featureName,
    utilsImport,
    withDi: withDi,
    contextUtils: utilsHasContextUtils(utilsPackageName),
  );
  patchRouterModule(featureName);
  runDartFormat();
  if (runBuildRunnerAfter) runBuildRunner();

  stdout.writeln('✅ Feature "$featureName" generated successfully!');
}
