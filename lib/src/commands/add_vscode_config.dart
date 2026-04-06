import 'dart:io';

import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/read_package_name.dart';
import '../functions/vscode_config/generate_vscode_extensions.dart';
import '../functions/vscode_config/generate_vscode_launch.dart';
import '../functions/vscode_config/generate_vscode_tasks.dart';

void addVscodeConfig() {
  ensurePubspec();
  final appName = readPackageName();
  generateVscodeExtensions();
  generateVscodeLaunch(appName);
  generateVscodeTasks();
  stdout.writeln('✅ VSCode config generated.');
}
