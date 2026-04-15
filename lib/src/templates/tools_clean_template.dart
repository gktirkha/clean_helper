String toolsCleanTemplate() => '''
import 'dart:io';

import 'command_runner.dart';

const _defaultPreserveFiles = <String>[
  'tools/config/android_build_config.json',
];

void main() async {
  ensureProjectRoot();
  await clean();
}

Future<void> clean({List<String> preserveFiles = const []}) async {
  final allPreserve = {..._defaultPreserveFiles, ...preserveFiles}.toList();
  final backups = _backupFiles(allPreserve);

  await fvmUse();
  await fvmRunner('dart run build_runner clean');
  await fvmRunner('flutter clean');
  if (Directory('.git').existsSync()) {
    await commandRunner('git clean -fdX');
  }
  _deleteEmptyFolders(Directory('.'));

  _restoreFiles(backups);
}

Map<String, String> _backupFiles(List<String> paths) {
  final backups = <String, String>{};
  for (final path in paths) {
    final file = File(path);
    if (file.existsSync()) backups[path] = file.readAsStringSync();
  }
  return backups;
}

void _restoreFiles(Map<String, String> backups) {
  for (final entry in backups.entries) {
    final file = File(entry.key);
    file.parent.createSync(recursive: true);
    file.writeAsStringSync(entry.value);
    stdout.writeln('♻️  Restored \${entry.key}');
  }
}

void _deleteEmptyFolders(Directory dir) {
  if (!dir.existsSync()) return;

  final name = dir.path.split(Platform.pathSeparator).last;
  if (name.startsWith('.')) return;

  for (final entity in dir.listSync()) {
    if (entity is Directory) {
      _deleteEmptyFolders(entity);
    }
  }

  if (dir.listSync().isEmpty) {
    dir.deleteSync();
    stdout.writeln('🗑  Deleted empty folder: \${dir.path}');
  }
}
''';
