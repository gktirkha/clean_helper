import 'dart:io';

import '../shared/log.dart';
import '../shared/run_command.dart';

bool _isDepsSortAvailable() =>
    Process.runSync('which', [
      'dart_dependency_checker',
    ], runInShell: true).exitCode ==
    0;

void runDepsSort() {
  if (!_isDepsSortAvailable()) {
    log('🔃 deps-sort not found, activating dart_dependency_checker_cli...');
    runCommand([
      'dart',
      'pub',
      'global',
      'activate',
      'dart_dependency_checker_cli',
    ]);
  }

  if (!_isDepsSortAvailable()) {
    log('⚠️  deps-sort still not available, skipping sort');
    return;
  }

  log('🔃 Sorting dependencies...');
  runCommand(['dart_dependency_checker', 'deps-sort']);
  log('🔃 Dependencies sorted');
}
