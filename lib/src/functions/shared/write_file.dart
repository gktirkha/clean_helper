import 'dart:io';

import 'log.dart';

/// Writes [content] to [path] only if the file does not already exist.
void writeFile(String path, String content) {
  final file = File(path);
  if (file.existsSync()) {
    log('  ⏭  Skipped (exists): $path');
    return;
  }
  file.writeAsStringSync(content);
}

/// Writes [content] to [path], overwriting any existing file.
void overwriteFile(String path, String content) {
  File(path).writeAsStringSync(content);
  log('  ✏️  Written: $path');
}
