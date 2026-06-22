import 'dart:io';

void runSlang(String localizationPackageName) {
  stdout.writeln('🌐 Activating slang globally...');
  Process.runSync('dart', [
    'pub',
    'global',
    'activate',
    'slang',
  ], runInShell: true);

  stdout.writeln('🌐 Running slang in $localizationPackageName...');
  final result = Process.runSync(
    'slang',
    [],
    runInShell: true,
    workingDirectory: 'packages/$localizationPackageName',
  );
  if (result.exitCode != 0) {
    stderr.writeln('⚠️  slang failed');
    stderr.writeln(result.stderr);
  }
  stdout.writeln('🌐 Slang generation complete');
}
