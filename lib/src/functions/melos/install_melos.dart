import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

/// Adds `melos` to the dev dependencies of `./pubspec.yaml`, unless a
/// `melos` dependency is already declared.
void installMelos() {
  final content = File('pubspec.yaml').readAsStringSync();

  if (RegExp(r'^  melos:', multiLine: true).hasMatch(content)) {
    stdout.writeln('  ⏭  Skipped (exists): melos dev dependency');
    return;
  }

  runCommand([...fvmExec('flutter'), 'pub', 'add', '--dev', 'melos']);
  stdout.writeln('  📦 melos added to dev_dependencies');
}
