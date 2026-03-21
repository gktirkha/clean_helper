import 'dart:io';

import '../shared/run_command.dart';

void runSlang() {
  stdout.writeln('🌐 Running slang...');
  runCommand(['dart', 'run', 'slang']);
  stdout.writeln('🌐 Slang generation complete');
}
