import 'dart:io';

import '../shared/run_command.dart';

bool _isDepsSortAvailable() =>
    Process.runSync('which', ['deps-sort'], runInShell: true).exitCode == 0;

void runDepsSort() {
  if (!_isDepsSortAvailable()) {
    stdout.writeln('🔃 deps-sort not found, activating dart_dependency_checker_cli...');
    runCommand(['dart', 'pub', 'global', 'activate', 'dart_dependency_checker_cli']);
  }

  if (!_isDepsSortAvailable()) {
    stderr.writeln('⚠️  deps-sort still not available, skipping sort');
    return;
  }

  stdout.writeln('🔃 Sorting dependencies...');
  runCommand(['deps-sort']);
  stdout.writeln('🔃 Dependencies sorted');
}
