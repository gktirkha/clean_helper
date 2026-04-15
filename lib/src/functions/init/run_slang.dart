import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

void runSlang() {
  stdout.writeln('🌐 Running slang...');
  runCommand([...fvmExec('dart'), 'run', 'slang']);
  stdout.writeln('🌐 Slang generation complete');
}
