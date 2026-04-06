import 'dart:io';

import '../shared/write_file.dart';
import '../../templates/vscode_launch_template.dart';

void generateVscodeLaunch(String appName) {
  const path = '.vscode/launch.json';
  writeFile(path, vscodeLaunchTemplate(appName));
  stdout.writeln('  📄 $path');
}
