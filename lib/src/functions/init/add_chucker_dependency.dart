import 'dart:io';

import '../shared/run_command.dart';

void addChuckerDependency() {
  runCommand([
    'flutter',
    'pub',
    'add',
    'chucker_flutter',
    '--git-url=https://github.com/gktirkha/chucker-flutter.git',
  ]);
  stdout.writeln('🔍 Chucker dependency added');
}
