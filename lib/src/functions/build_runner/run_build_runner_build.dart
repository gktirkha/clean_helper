import 'dart:io';

import '../shared/run_command.dart';

void runBuildRunnerBuild() {
  stdout.writeln('🔨 Running build_runner build...');
  runCommand([
    'dart',
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ]);
  stdout.writeln('🔨 Build complete');
}
