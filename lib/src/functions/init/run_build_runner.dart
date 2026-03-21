import 'dart:io';

import '../shared/run_command.dart';

void runBuildRunner() {
  stdout.writeln('🔨 Running build_runner...');
  runCommand([
    'dart',
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ]);
  stdout.writeln('🔨 Code generation complete');
}
