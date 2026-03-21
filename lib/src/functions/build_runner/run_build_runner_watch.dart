import 'dart:io';

import '../shared/run_command.dart';

void runBuildRunnerWatch() {
  stdout.writeln('👀 Starting build_runner watch...');
  runCommand([
    'dart',
    'run',
    'build_runner',
    'watch',
    '--delete-conflicting-outputs',
  ]);
}
