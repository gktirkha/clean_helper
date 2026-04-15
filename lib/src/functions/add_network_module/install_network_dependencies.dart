import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

void installNetworkDependencies() {
  stdout.writeln('📦 Installing network dependencies...');

  final deps = ['dio', 'retrofit', 'json_annotation'];

  final devDeps = ['retrofit_generator', 'json_serializable'];

  runCommand([...fvmExec('flutter'), 'pub', 'add', ...deps]);
  runCommand([...fvmExec('flutter'), 'pub', 'add', '--dev', ...devDeps]);
  runCommand([
    ...fvmExec('flutter'),
    'pub',
    'add',
    'pretty_dio_logger',
    '--git-url=https://github.com/gktirkha/pretty_dio_logger.git',
  ]);

  stdout.writeln('📦 Network dependencies installed');
}
