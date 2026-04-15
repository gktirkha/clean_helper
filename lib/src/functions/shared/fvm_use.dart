import 'dart:io';

Future<void> fvmUse() async {
  final check = Process.runSync('fvm', ['--version'], runInShell: true);
  if (check.exitCode != 0) return;

  stdout.writeln('📱 Setting Flutter version via fvm...');
  final process = await Process.start(
    'fvm',
    ['use'],
    runInShell: true,
    mode: .inheritStdio,
  );
  await process.exitCode;
  stdout.writeln();
}
