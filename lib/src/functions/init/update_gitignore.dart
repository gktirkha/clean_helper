import 'dart:io';

import '../../templates/gitignore_template.dart';
import '../shared/write_file.dart';

void updateGitignore() {
  final file = File('.gitignore');
  final block = gitignoreTemplate();

  if (file.existsSync()) {
    final content = file.readAsStringSync();
    if (content.contains(gitignoreMarker)) {
      stdout.writeln(
        '  ⏭  Skipped (exists): Clean-Helper entries in .gitignore',
      );
      return;
    }
    overwriteFile('.gitignore', '${content.trimRight()}\n\n$block');
  } else {
    overwriteFile('.gitignore', block);
  }

  stdout.writeln('📋 .gitignore updated with Clean-Helper entries');
  stdout.writeln();
}
