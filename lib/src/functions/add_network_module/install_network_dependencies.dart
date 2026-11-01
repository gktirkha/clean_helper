import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

void installNetworkDependencies() {
  stdout.writeln('📦 Installing network dependencies...');

  final deps = ['dio', 'dio_lens', 'retrofit', 'json_annotation'];

  final devDeps = ['retrofit_generator', 'json_serializable'];

  runCommand([...fvmExec('flutter'), 'pub', 'add', ...deps]);
  runCommand([...fvmExec('flutter'), 'pub', 'add', '--dev', ...devDeps]);

  stdout.writeln('📦 Network dependencies installed');
}
