import 'dart:io';

import 'run_command_streamed.dart';

void fvmUse() {
  final check = Process.runSync('fvm', ['--version'], runInShell: true);
  if (check.exitCode != 0) return;
  stdout.writeln('📱 Setting Flutter version via fvm...');
  runCommandStreamed(['fvm', 'use']);
  stdout.writeln();
}
