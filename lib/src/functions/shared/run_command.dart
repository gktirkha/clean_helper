import 'dart:io';

void runCommand(List<String> cmd, {String? workingDirectory}) {
  final result = Process.runSync(
    cmd.first,
    cmd.sublist(1),
    runInShell: true,
    workingDirectory: workingDirectory,
  );
  if (result.exitCode != 0) {
    stderr.writeln('⚠️  Command failed: ${cmd.join(' ')}');
    stderr.writeln(result.stderr);
  }
}
