import 'dart:io';

import '../shared/tool_version.dart';
import '../shared/write_file.dart';

void writeToolVersion() {
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
    updated.addAll(['clean-helper:', '  version: $toolVersion', '']);
  } else if (versionIndex == -1) {
    final insertAt = lastContentLine != -1
        ? lastContentLine + 1
        : cleanHelperIndex + 1;
    updated.insert(insertAt, '  version: $toolVersion');
  } else {
    updated[versionIndex] = '  version: $toolVersion';
  }

  overwriteFile('pubspec.yaml', updated.join('\n'));
}
