import 'dart:io';

import '../shared/pascal_case.dart';

void deleteFeatureFiles(String feature) {
  final pascal = pascalCase(feature);

  final dir = Directory('lib/features/$feature');
  if (dir.existsSync()) {
    dir.deleteSync(recursive: true);
    stdout.writeln('🗑️  Deleted lib/features/$feature/');
  } else {
    stderr.writeln('⚠️  lib/features/$feature/ not found');
  }

  final navImpl = File('lib/app/navigation/${feature}_navigation_impl.dart');
  if (navImpl.existsSync()) {
    navImpl.deleteSync();
    stdout.writeln('🗑️  Deleted ${feature}_navigation_impl.dart');
  }

  stdout.writeln('🗑️  $pascal feature files removed');
}
