import 'dart:io';

import 'package_configs.dart';

/// Runs `fvm use` interactively when fvm is installed. Skipped in a monorepo
/// app ([monoRepoAppPath] set): the Flutter version is pinned at the
/// workspace root, not per app.
Future<void> fvmUse() async {
  if (monoRepoAppPath != null) {
    stdout.writeln('  ⏭  Monorepo app — skipping fvm use (pinned at the root)');
    return;
  }

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
