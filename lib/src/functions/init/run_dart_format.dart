import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

void runDartFormat() {
  stdout.writeln('🎨 Formatting code...');
  runCommand([...fvmExec('dart'), 'format', '.']);
  stdout.writeln('🎨 Formatting complete');
}
