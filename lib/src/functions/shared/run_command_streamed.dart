import 'dart:io';

void runCommandStreamed(List<String> cmd) {
  final result = Process.runSync(cmd.first, cmd.sublist(1), runInShell: true);

  if (result.stdout case final String out when out.isNotEmpty) {
    stdout.write(out);
  }
  if (result.stderr case final String err when err.isNotEmpty) {
    stderr.write(err);
  }

  if (result.exitCode != 0) {
    stderr.writeln('⚠️  Command failed: ${cmd.join(' ')}');
  }
}
