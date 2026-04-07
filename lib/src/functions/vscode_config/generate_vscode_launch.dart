import 'dart:io';

import '../../templates/vscode_launch_template.dart';
import '../shared/write_file.dart';

void generateVscodeLaunch(String appName) {
  const path = '.vscode/launch.json';
  writeFile(path, vscodeLaunchTemplate(appName));
  stdout.writeln('  ✏️  Written: $path');
}
