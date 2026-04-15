import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/tools_bootstrap_template.dart';
import '../../templates/tools_build_template.dart';
import '../../templates/tools_clean_template.dart';
import '../../templates/tools_command_runner_template.dart';

void generateToolsFiles() {
  writeFile('tools/command_runner.dart', toolsCommandRunnerTemplate());
  writeFile('tools/clean.dart', toolsCleanTemplate());
  writeFile('tools/bootstrap.dart', toolsBootstrapTemplate());
  writeFile('tools/build_android.dart', toolsBuildAndroidTemplate());
  stdout.writeln('🔧 Tools generated');
  stdout.writeln();
}
