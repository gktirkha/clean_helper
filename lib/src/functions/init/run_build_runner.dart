import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

void runBuildRunner({String? workingDirectory}) {
  final label = workingDirectory != null ? ' in $workingDirectory' : '';
  stdout.writeln('🔨 Running build_runner$label...');
  runCommand([
    ...fvmExec('dart'),
    'run',
    'build_runner',
    'build',
  ], workingDirectory: workingDirectory);
  stdout.writeln('🔨 Code generation complete$label');
}
