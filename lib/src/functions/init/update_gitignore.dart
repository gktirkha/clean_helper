import 'dart:io';

import '../../templates/gitignore_template.dart';

void updateGitignore() {
  final file = File('.gitignore');
  final block = gitignoreTemplate();

  if (file.existsSync()) {
    final content = file.readAsStringSync();
    if (content.contains(gitignoreMarker)) {
      stdout.writeln('  ⏭  Skipped (exists): Clean-Helper entries in .gitignore');
      return;
    }
    file.writeAsStringSync('${content.trimRight()}\n\n$block');
  } else {
    file.writeAsStringSync(block);
  }

  stdout.writeln('📋 .gitignore updated with Clean-Helper entries');
  stdout.writeln();
}
