import 'dart:io';

import 'tool_version.dart';

void checkVersionMismatch() {
  final lines = File('pubspec.yaml').readAsLinesSync();
  var inCleanHelper = false;
  String? projectVersion;

  for (final line in lines) {
    final isTopLevel =
        line.isNotEmpty && !line.startsWith(' ') && !line.startsWith('\t');

    if (isTopLevel) {
      if (line.trimRight() == 'clean-helper:') {
        inCleanHelper = true;
        continue;
      } else if (inCleanHelper) {
        break;
      }
    }

    if (inCleanHelper) {
      final trimmed = line.trim();
      if (trimmed.startsWith('version:')) {
        projectVersion = trimmed.substring('version:'.length).trim();
        break;
      }
    }
  }

  if (projectVersion == null || projectVersion == toolVersion) return;

  stderr.writeln(
    '⚠️  Version mismatch: this project was initialized with '
    'clean-helper v$projectVersion but you are running v$toolVersion.',
  );
  stderr.writeln('   Generated files may be out of date.');
  stderr.writeln(
    '   To suppress this warning, set '
    'clean-helper.version: $toolVersion in pubspec.yaml.',
  );
  stderr.writeln();
}
