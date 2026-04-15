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
}
''';
