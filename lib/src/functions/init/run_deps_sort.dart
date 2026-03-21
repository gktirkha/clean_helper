import 'dart:io';

import '../shared/log.dart';
import '../shared/run_command.dart';

void runDepsSort() {
  runCommand(['dart', 'pub', 'global', 'activate', 'dart_dependency_checker_cli']);

  final check = Process.runSync('which', ['deps-sort'], runInShell: true);
  if (check.exitCode != 0) {
    log('⚠️  deps-sort not found on PATH, skipping sort');
    return;
  }

  log('🔃 Sorting dependencies...');
  runCommand(['deps-sort']);
  log('🔃 Dependencies sorted');
}
