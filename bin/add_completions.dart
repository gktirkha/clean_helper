import 'dart:io';

const _repoUrl = 'https://github.com/my_org/clean_helpers';

void main(List<String> args) {
  final activate = Process.runSync(
    'dart',
    ['pub', 'global', 'activate', '--source', 'git', _repoUrl],
    runInShell: true,
  );

  if (activate.exitCode != 0) {
    stderr.writeln('❌ Failed to activate clean_helpers from git.');
    stderr.writeln(activate.stderr);
    exit(activate.exitCode);
  }

  stdout.writeln('✅ clean_helpers activated.');

  Process.run('clean_helpers', ['install-completion-files']);
}
