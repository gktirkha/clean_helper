import 'dart:io';

void runSlang(String localizationPackageName) {
  stdout.writeln('🌐 Running slang in $localizationPackageName...');
  final result = Process.runSync(
    'dart',
    ['run', 'slang'],
    runInShell: true,
    workingDirectory: 'packages/$localizationPackageName',
  );
  if (result.exitCode != 0) {
    stderr.writeln('⚠️  slang failed');
    stderr.writeln(result.stderr);
  }
  stdout.writeln('🌐 Slang generation complete');
}
