import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

void runFlutterPubGet() {
  stdout.writeln('📦 Running flutter pub get...');
  runCommand([...fvmExec('flutter'), 'pub', 'get']);
  stdout.writeln('📦 Done');
}
