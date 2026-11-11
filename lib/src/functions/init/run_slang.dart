import 'dart:io';

import '../shared/fvm_exec.dart';
import '../shared/run_command.dart';

void runSlang(String localizationPackageName, {String parentDir = 'packages'}) {
  stdout.writeln('🌐 Running slang in $localizationPackageName...');
  runCommand([
    ...fvmExec('dart'),
    'run',
    'slang',
  ], workingDirectory: '$parentDir/$localizationPackageName');
  stdout.writeln('🌐 Slang generation complete');
}
