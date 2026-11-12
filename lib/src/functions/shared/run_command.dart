import 'dart:io';

import 'abort.dart';

/// Runs [cmd] and waits for it. On a non-zero exit, prints its output and
/// aborts: later steps depend on it, so continuing would only fail worse.
void runCommand(List<String> cmd, {String? workingDirectory}) {
  final result = Process.runSync(
    cmd.first,
    cmd.sublist(1),
    runInShell: true,
    workingDirectory: workingDirectory,
  );
  if (result.exitCode == 0) return;

  final output = '${result.stdout}\n${result.stderr}'.trim();
  if (output.isNotEmpty) stderr.writeln(output);
  final where = workingDirectory == null ? '' : ' (in $workingDirectory)';
  abort(
    'Command failed with exit code ${result.exitCode}: ${cmd.join(' ')}$where',
  );
}
