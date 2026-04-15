import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

void runBuildRunner() {
  stdout.writeln('🔨 Running build_runner...');
  runCommand([
    ...fvmExec('dart'),
    'run',
    'build_runner',
    'build',
    '--delete-conflicting-outputs',
  ]);
  stdout.writeln('🔨 Code generation complete');
}
