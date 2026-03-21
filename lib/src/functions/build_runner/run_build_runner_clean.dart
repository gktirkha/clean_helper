import 'dart:io';

import '../shared/run_command.dart';

void runBuildRunnerClean() {
  stdout.writeln('🧹 Cleaning build_runner cache...');
  runCommand(['dart', 'run', 'build_runner', 'clean']);
  stdout.writeln('🧹 Clean complete');
}
