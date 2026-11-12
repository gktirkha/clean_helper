import 'dart:io';

import 'abort.dart';

/// Runs [cmd], printing its output as-is (for commands whose output is the
/// point, like `build-runner`). Aborts on a non-zero exit, like `runCommand`.
void runCommandStreamed(List<String> cmd) {
  final result = Process.runSync(cmd.first, cmd.sublist(1), runInShell: true);

  if (result.stdout case final String out when out.isNotEmpty) {
    stdout.write(out);
  }
  if (result.stderr case final String err when err.isNotEmpty) {
    stderr.write(err);
  }

  if (result.exitCode != 0) {
    abort('Command failed with exit code ${result.exitCode}: ${cmd.join(' ')}');
  }
}
