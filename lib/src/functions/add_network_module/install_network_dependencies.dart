import 'dart:io';

import '../shared/run_command.dart';

void installNetworkDependencies() {
  stdout.writeln('📦 Installing network dependencies...');

  final deps = ['dio', 'retrofit', 'json_annotation'];

  final devDeps = ['retrofit_generator', 'json_serializable'];

  runCommand(['dart', 'pub', 'add', ...deps]);
  runCommand(['dart', 'pub', 'add', '--dev', ...devDeps]);
  runCommand([
    'dart',
    'pub',
    'add',
    'pretty_dio_logger',
    '--git-url=https://github.com/gktirkha/pretty_dio_logger.git',
  ]);

  stdout.writeln('📦 Network dependencies installed');
}
