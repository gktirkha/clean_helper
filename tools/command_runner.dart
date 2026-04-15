import 'dart:io';

Future<void> commandRunner(String command) async {
  stdout.write('\n>>> $command\n');

  final parts = command.split(' ');
  final executable = parts.first;
  final args = parts.skip(1).toList();

  final process = await Process.start(
    executable,
    args,
    runInShell: true,
    mode: .inheritStdio,
  );

  final exitCode = await process.exitCode;

  if (exitCode != 0) {
    stdout.write('\n[ERROR] "$command" exited with code $exitCode');
    exit(exitCode);
  }
}

Future<bool> fvmExists() async {
  final result = await Process.run('fvm', ['--version'], runInShell: true);
  return result.exitCode == 0;
}
