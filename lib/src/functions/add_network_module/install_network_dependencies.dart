import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

/// Adds what the app needs to use the network package: the package itself
/// (resolved from the workspace), Dio, Dio Lens and Retrofit, plus the
/// generators for REST datasources.
void installNetworkDependencies(String networkPackageName) {
  stdout.writeln('📦 Installing network dependencies...');

  runCommand([
    ...fvmExec('flutter'),
    'pub',
    'add',
    networkPackageName,
    'dio',
    'dio_lens',
    'retrofit',
    'json_annotation',
  ]);
  runCommand([
    ...fvmExec('flutter'),
    'pub',
    'add',
    '--dev',
    'retrofit_generator',
    'json_serializable',
  ]);

  stdout.writeln('📦 Network dependencies installed');
}
