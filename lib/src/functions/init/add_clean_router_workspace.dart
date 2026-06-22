import 'dart:io';

import '../shared/write_file.dart';

void addCleanRouterWorkspace(
  String utilsPackageName,
  String localizationPackageName,
) {
  final content = File('pubspec.yaml').readAsStringSync();

  if (content.contains('packages/clean_router') &&
      content.contains('packages/$utilsPackageName') &&
      content.contains('packages/$localizationPackageName')) {
    stdout.writeln('  ⏭  Skipped (exists): workspace entries');
    return;
  }

  final workspaceEntry =
      'workspace:\n'
      '  - packages/clean_router\n'
      '  - packages/$localizationPackageName\n'
      '  - packages/$utilsPackageName\n';

  final updated = content.replaceFirst(
    RegExp(r'^dependencies:', multiLine: true),
    '$workspaceEntry\ndependencies:',
  );

  overwriteFile('pubspec.yaml', updated);
  stdout.writeln(
    '📋 Workspace entries added to pubspec.yaml'
    ' (clean_router, $utilsPackageName, $localizationPackageName)',
  );
}
