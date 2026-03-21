import 'dart:io';

import '../shared/run_command.dart';

void installDependencies() {
  stdout.writeln('📦 Installing dependencies...');

  final deps = [
    'flutter_bloc',
    'go_router',
    'get_it',
    'injectable',
    'freezed_annotation',
    'fpdart',
    'slang',
    'slang_flutter',
    'package_info_plus',
    'flutter_svg',
    'json_annotation',
  ];

  final devDeps = [
    'build_runner',
    'injectable_generator',
    'freezed',
    'flutter_gen_runner',
    'json_serializable',
  ];

  runCommand([
    'flutter',
    'pub',
    'add',
    'flutter_localizations',
    '--sdk=flutter',
  ]);
  runCommand(['dart', 'pub', 'add', ...deps]);
  runCommand(['dart', 'pub', 'add', '--dev', ...devDeps]);

  stdout.writeln('📦 Dependencies installed');
}
