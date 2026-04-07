import 'dart:io';

import '../../templates/vscode_tasks_template.dart';
import '../shared/write_file.dart';

void generateVscodeTasks() {
  const path = '.vscode/tasks.json';
  writeFile(path, vscodeTasksTemplate());
  stdout.writeln('  ✏️  Written: $path');
}
