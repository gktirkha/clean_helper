import 'dart:io';

import '../shared/run_command_streamed.dart';

void runBuildRunnerWatch() {
  stdout.writeln('👀 Starting build_runner watch...');
  runCommandStreamed([
    'dart',
    'run',
    'build_runner',
    'watch',
    '--delete-conflicting-outputs',
  ]);
}
