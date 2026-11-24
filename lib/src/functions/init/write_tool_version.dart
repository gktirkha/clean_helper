import 'dart:io';

import '../shared/tool_version.dart';
import '../shared/write_file.dart';

/// Stamps `clean-helper.version: [version]` in the current pubspec.
void writeToolVersion([String version = toolVersion]) {
  final file = File('pubspec.yaml');
  final lines = file.readAsStringSync().split('\n');

  var cleanHelperIndex = -1;
  var lastContentLine = -1;
  var versionIndex = -1;
  var inCleanHelper = false;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final isTopLevel =
        line.isNotEmpty && !line.startsWith(' ') && !line.startsWith('\t');

    if (isTopLevel) {
      if (line.trimRight() == 'clean-helper:') {
        cleanHelperIndex = i;
        inCleanHelper = true;
        continue;
      } else if (inCleanHelper) {
        break;
      }
    }

    if (inCleanHelper) {
      if (line.trim().startsWith('version:')) versionIndex = i;
      if (line.trim().isNotEmpty) lastContentLine = i;
    }
  }

  final updated = [...lines];

  if (cleanHelperIndex == -1) {
    updated.addAll(['clean-helper:', '  version: $version', '']);
  } else if (versionIndex == -1) {
    final insertAt = lastContentLine != -1
        ? lastContentLine + 1
        : cleanHelperIndex + 1;
    updated.insert(insertAt, '  version: $version');
  } else {
    updated[versionIndex] = '  version: $version';
  }

  overwriteFile('pubspec.yaml', updated.join('\n'));
}
