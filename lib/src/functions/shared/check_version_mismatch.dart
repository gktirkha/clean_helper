import 'dart:io';

import 'read_clean_helper_fields.dart';
import 'tool_version.dart';

/// Warns when `clean-helper.version` in the current pubspec differs from the
/// running tool.
void checkVersionMismatch() {
  final projectVersion = readCleanHelperFields([])['version'];
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
