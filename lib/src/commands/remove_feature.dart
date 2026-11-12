import 'dart:io';

import '../functions/init/run_build_runner.dart';
import '../functions/init/run_dart_format.dart';
import '../functions/remove_feature/delete_feature_files.dart';
import '../functions/remove_feature/unpatch_router_module.dart';
import '../functions/shared/abort.dart';
import '../functions/shared/ensure_pubspec.dart';

/// Unregisters the feature's router, deletes its files, then formats and
/// reruns build_runner so the generated DI config drops its registrations.
void removeFeature(List<String> args, {bool runBuildRunnerAfter = true}) {
  ensurePubspec();

  if (args.isEmpty) {
    abort('Usage: clean-helper remove-feature <feature_name>');
  }

  final featureName = args.first.toLowerCase();

  stdout.writeln('🗑️  Removing feature: $featureName');
  unpatchRouterModule(featureName);
  deleteFeatureFiles(featureName);
  runDartFormat();
  if (runBuildRunnerAfter) runBuildRunner();
  stdout.writeln('✅ Feature "$featureName" removed successfully!');
}
