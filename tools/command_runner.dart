import 'dart:io';

Future<void> commandRunner(String command) async {
  stdout.write('\n>>> $command\n');

  final parts = command.split(' ');
  final executable = parts.first;
  final args = parts.skip(1).toList();

  final result = await Process.run(executable, args, runInShell: true);

  stdout.write(result.stdout);
  stderr.write(result.stderr);

  if (result.exitCode != 0) {
    stdout.write('\n[ERROR] "$command" exited with code ${result.exitCode}');
    exit(result.exitCode);
  }
}

Future<bool> fvmExists() async {
  final result = await Process.run('fvm', ['--version'], runInShell: true);
  return result.exitCode == 0;
}
