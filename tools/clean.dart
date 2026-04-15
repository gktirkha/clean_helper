import 'dart:io';

import 'command_runner.dart';

void main() async {
  await clean();
}

Future<void> clean() async {
  await commandRunner('fvm use --skip-pub-get');
  await commandRunner('fvm dart run build_runner clean');
  await commandRunner('fvm flutter clean');
  if (Directory('.git').existsSync()) {
    await commandRunner('git clean -fdX');
  }
}
