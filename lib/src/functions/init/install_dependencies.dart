import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

void installDependencies(
  String utilsPackageName,
  String localizationPackageName,
) {
  stdout.writeln('📦 Installing dependencies...');

  final deps = [
    'flutter_bloc',
    'go_router',
    'get_it',
    'injectable',
    'freezed_annotation',
    'fpdart',
    'package_info_plus',
    'flutter_svg',
    'json_annotation',
    'logger',
  ];

  final devDeps = [
    'build_runner',
    'injectable_generator',
    'freezed',
    'flutter_gen_runner',
    'json_serializable',
  ];

  runCommand([
    ...fvmExec('flutter'),
    'pub',
    'add',
    'flutter_localizations',
    '--sdk=flutter',
  ]);
  runCommand([...fvmExec('flutter'), 'pub', 'add', ...deps]);
  runCommand([...fvmExec('flutter'), 'pub', 'add', '--dev', ...devDeps]);
  // Workspace members resolve from the workspace, so no `--path` is needed.
  runCommand([
    ...fvmExec('flutter'),
    'pub',
    'add',
    'clean_router',
    localizationPackageName,
    utilsPackageName,
  ]);

  stdout.writeln('📦 Dependencies installed');
  stdout.writeln();
}
