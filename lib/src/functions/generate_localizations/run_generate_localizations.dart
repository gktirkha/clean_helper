import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command_streamed.dart';

void runGenerateLocalizations() {
  stdout.writeln('🌐 Running slang...');
  runCommandStreamed([...fvmExec('dart'), 'run', 'slang']);
  stdout.writeln('✅ Locales generated');
}
