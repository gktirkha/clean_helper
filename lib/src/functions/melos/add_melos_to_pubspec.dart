import 'dart:io';

import '../../templates/melos_config_template.dart';
import '../shared/write_file.dart';

/// Appends the `melos:` block to `./pubspec.yaml`, unless a top-level
/// `melos:` key is already there.
void addMelosToPubspec() {
  final content = File('pubspec.yaml').readAsStringSync();

  if (RegExp(r'^melos:', multiLine: true).hasMatch(content)) {
    stdout.writeln('  ⏭  Skipped (exists): melos config in pubspec.yaml');
    return;
  }

  final separator = content.endsWith('\n') ? '\n' : '\n\n';
  overwriteFile('pubspec.yaml', '$content$separator${melosConfigTemplate()}');
  stdout.writeln('  📄 melos config added to pubspec.yaml');
}
