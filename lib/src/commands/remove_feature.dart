import 'dart:io';

import '../functions/remove_feature/delete_feature_files.dart';
import '../functions/remove_feature/unpatch_router_module.dart';
import '../functions/shared/abort.dart';
import '../functions/shared/ensure_pubspec.dart';

void removeFeature(List<String> args) {
  ensurePubspec();

  if (args.isEmpty) {
    abort('Usage: clean-helper remove-feature <feature_name>');
  }

  final featureName = args.first.toLowerCase();

  stdout.writeln('🗑️  Removing feature: $featureName');
  unpatchRouterModule(featureName);
  deleteFeatureFiles(featureName);
  stdout.writeln('✅ Feature "$featureName" removed successfully!');
}
