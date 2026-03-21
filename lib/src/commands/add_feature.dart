import 'dart:io';

import '../functions/feature/create_feature_structure.dart';
import '../functions/shared/ensure_pubspec.dart';

void addFeature(List<String> args) {
  ensurePubspec();

  if (args.isEmpty) {
    stdout.writeln('❌ Please provide a feature name');
    stdout.writeln(
      'Usage: dart run tools/generate_feature.dart <feature_name>',
    );
    return;
  }

  final featureName = args.first.toLowerCase();
  final basePath = 'lib/features/$featureName';

  stdout.writeln('🚀 Generating feature: $featureName');
  createFeatureStructure(basePath, featureName);
  stdout.writeln('✅ Feature "$featureName" generated successfully!');
}
