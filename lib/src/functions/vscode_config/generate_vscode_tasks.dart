import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/vscode_tasks_template.dart';

void generateVscodeTasks() {
  const path = '.vscode/tasks.json';
  writeFile(path, vscodeTasksTemplate());
  stdout.writeln('  📄 $path');
}
