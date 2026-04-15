String toolsCleanTemplate() => '''
import 'dart:io';

import 'command_runner.dart';

void main() async {
  await clean();
}

Future<void> clean() async {
  final hasFvm = await fvmExists();
  final prefix = hasFvm ? 'fvm ' : '';
  if (hasFvm) await commandRunner('fvm use --skip-pub-get');
  await commandRunner('\${prefix}dart run build_runner clean');
  await commandRunner('\${prefix}flutter clean');
  if (Directory('.git').existsSync()) {
    await commandRunner('git clean -fdX');
  }
  _deleteEmptyFolders(Directory('.'));
}

void _deleteEmptyFolders(Directory dir) {
  if (!dir.existsSync()) return;

  for (final entity in dir.listSync()) {
    if (entity is Directory) {
      _deleteEmptyFolders(entity);
    }
  }

  final name = dir.path.split(Platform.pathSeparator).last;
  if (name.startsWith('.')) return;

  if (dir.listSync().isEmpty) {
    dir.deleteSync();
    stdout.writeln('🗑  Deleted empty folder: \${dir.path}');
  }
}
''';
