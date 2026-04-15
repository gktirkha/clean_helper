import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command_streamed.dart';

void runBuildRunnerBuild() {
  stdout.writeln('🔨 Running build_runner build...');
  runCommandStreamed([
    ...fvmExec('dart'),
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ]);
  stdout.writeln('🔨 Build complete');
}
