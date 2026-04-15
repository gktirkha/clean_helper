import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command_streamed.dart';

void runBuildRunnerClean() {
  stdout.writeln('🧹 Cleaning build_runner cache...');
  runCommandStreamed([...fvmExec('dart'), 'run', 'build_runner', 'clean']);
  stdout.writeln('🧹 Clean complete');
}
