import 'dart:io';

/// Writes [content] to [path] only if the file does not already exist.
void writeFile(String path, String content) {
  final file = File(path);
  if (file.existsSync()) {
    stdout.writeln('  ⏭  Skipped (exists): $path');
    return;
  }
  file.writeAsStringSync(content);
}

/// Writes [content] to [path], overwriting any existing file.
void overwriteFile(String path, String content) {
  File(path).writeAsStringSync(content);
  stdout.writeln('  ✏️  Written: $path');
}
