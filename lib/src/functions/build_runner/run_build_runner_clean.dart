import 'dart:io';

import '../shared/run_command_streamed.dart';

void runBuildRunnerClean() {
  stdout.writeln('🧹 Cleaning build_runner cache...');
  runCommandStreamed(['dart', 'run', 'build_runner', 'clean']);
  stdout.writeln('🧹 Clean complete');
}
