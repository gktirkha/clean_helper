/// [fvmUse] is false for a monorepo app, whose Flutter version is pinned at
/// the workspace root: the generated `fvmUse()` then does nothing.
String toolsCommandRunnerTemplate({bool fvmUse = true}) =>
    '''
import 'dart:io';

Future<void> commandRunner(String command, {String? workingDirectory}) async {
  final where = workingDirectory == null ? '' : ' (in \$workingDirectory)';
  stdout.write('\\n>>> \$command\$where\\n');

  final parts = command.split(' ');
  final executable = parts.first;
  final args = parts.skip(1).toList();

  final process = await Process.start(
    executable,
    args,
    workingDirectory: workingDirectory,
    runInShell: true,
    mode: .inheritStdio,
  );

  final exitCode = await process.exitCode;

  if (exitCode != 0) {
    stdout.write('\\n[ERROR] "\$command" exited with code \$exitCode');
    exit(exitCode);
  }
}

bool? _hasFvm;

Future<bool> _checkFvm() async {
  if (_hasFvm != null) return _hasFvm!;
  final result = await Process.run('fvm', ['--version'], runInShell: true);
  _hasFvm = result.exitCode == 0;
  return _hasFvm!;
}

Future<void> fvmRunner(String command, {String? workingDirectory}) async {
  final prefix = await _checkFvm() ? 'fvm ' : '';
  await commandRunner('\$prefix\$command', workingDirectory: workingDirectory);
}

${fvmUse ? '''Future<void> fvmUse() async {
  if (await _checkFvm()) await commandRunner('fvm use --skip-pub-get');
}''' : '''/// Monorepo app: the Flutter version is pinned at the workspace root.
Future<void> fvmUse() async {}'''}

void ensureProjectRoot() {
  if (!File('pubspec.yaml').existsSync()) {
    stderr.writeln('[ERROR] pubspec.yaml not found. Run this from the project root.');
    exit(1);
  }
}
''';
