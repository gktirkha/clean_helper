import 'dart:io';

import '../shared/fvm_exec.dart';

void runBuildRunner({String? workingDirectory}) {
  final label = workingDirectory != null ? ' in $workingDirectory' : '';
  stdout.writeln('🔨 Running build_runner$label...');
  final cmd = [...fvmExec('dart'), 'run', 'build_runner', 'build'];
  final result = Process.runSync(
    cmd.first,
    cmd.sublist(1),
    runInShell: true,
    workingDirectory: workingDirectory,
  );
  if (result.exitCode != 0) {
    stderr.writeln('⚠️  build_runner failed$label');
    stderr.writeln(result.stderr);
  }
  stdout.writeln('🔨 Code generation complete$label');
}
