import 'dart:io';

import '../shared/run_command_streamed.dart';

void runBuildRunnerBuild() {
  stdout.writeln('🔨 Running build_runner build...');
  runCommandStreamed([
    'dart',
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ]);
  stdout.writeln('🔨 Build complete');
}
