import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

/// [workspacePackages] are the router, localization and utils package names.
/// They're added without `--path`: pub resolves workspace members from the
/// workspace, whether `init` created them or they live elsewhere in it.
void installDependencies(List<String> workspacePackages) {
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
  runCommand([...fvmExec('flutter'), 'pub', 'add', ...workspacePackages]);

  stdout.writeln('📦 Dependencies installed');
  stdout.writeln();
}
