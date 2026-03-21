import 'dart:io';

import '../shared/run_command.dart';

void runDartFormat() {
  stdout.writeln('🎨 Formatting code...');
  runCommand(['dart', 'format', '.']);
  stdout.writeln('🎨 Formatting complete');
}
