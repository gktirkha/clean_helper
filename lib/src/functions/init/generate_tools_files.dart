import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/tools_bootstrap_template.dart';
import '../../templates/tools_build_config_template.dart';
import '../../templates/tools_build_template.dart';
import '../../templates/tools_clean_template.dart';
import '../../templates/tools_command_runner_template.dart';

void generateToolsFiles({bool overwrite = false}) {
  final write = overwrite ? overwriteFile : writeFile;
  write('tools/command_runner.dart', toolsCommandRunnerTemplate());
  write('tools/clean.dart', toolsCleanTemplate());
  write('tools/bootstrap.dart', toolsBootstrapTemplate());
  write('tools/build_android.dart', toolsBuildAndroidTemplate());
  write('tools/build_config.json', toolsBuildConfigTemplate());
  stdout.writeln('🔧 Tools generated');
  stdout.writeln();
}
