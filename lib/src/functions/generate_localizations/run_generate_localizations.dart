import 'dart:io';

import '../shared/run_command_streamed.dart';

void runGenerateLocalizations() {
  stdout.writeln('🌐 Running slang...');
  runCommandStreamed(['dart', 'run', 'slang']);
  stdout.writeln('✅ Locales generated');
}
