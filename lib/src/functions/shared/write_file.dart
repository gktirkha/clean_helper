import 'dart:io';

/// Writes [content] to [path] only if the file does not already exist.
void writeFile(String path, String content) {
  final file = File(path);
  if (file.existsSync()) {
    stdout.writeln('  ⏭  Skipped (exists): $path');
    return;
  }
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
}

/// Writes [content] to [path], overwriting any existing file.
void overwriteFile(String path, String content) {
  final file = File(path);
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(content);
  stdout.writeln('  ✏️  Written: $path');
}
