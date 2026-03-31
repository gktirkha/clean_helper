import 'dart:io';

import '../shared/write_file.dart';

void addCleanRouterWorkspace() {
  final content = File('pubspec.yaml').readAsStringSync();

  if (content.contains('packages/clean_router')) {
    stdout.writeln('  ⏭  Skipped (exists): clean_router workspace entry');
    return;
  }

  // Insert workspace section before the dependencies: line
  final updated = content.replaceFirst(
    RegExp(r'^dependencies:', multiLine: true),
    'workspace:\n  - packages/clean_router\n\ndependencies:',
  );

  overwriteFile('pubspec.yaml', updated);
  stdout.writeln('📋 clean_router workspace added to pubspec.yaml');
}
