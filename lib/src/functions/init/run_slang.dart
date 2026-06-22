import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

void runSlang(String localizationPackageName) {
  stdout.writeln('🌐 Running slang in $localizationPackageName...');
  runCommand(
    [...fvmExec('dart'), 'run', 'slang'],
    workingDirectory: 'packages/$localizationPackageName',
  );
  stdout.writeln('🌐 Slang generation complete');
}
