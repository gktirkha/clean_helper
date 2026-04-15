import 'dart:io';

bool? _hasFvm;

List<String> fvmExec(String exe) {
  _hasFvm ??=
      Process.runSync('fvm', ['--version'], runInShell: true).exitCode == 0;
  return _hasFvm! ? ['fvm', exe] : [exe];
}
