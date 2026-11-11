import 'dart:io';

import '../functions/shared/ensure_pubspec.dart';
import '../functions/shared/package_configs.dart';
import '../functions/shared/read_package_name.dart';
import '../functions/vscode_config/generate_vscode_extensions.dart';
import '../functions/vscode_config/generate_vscode_launch.dart';
import '../functions/vscode_config/generate_vscode_tasks.dart';

void addVscodeConfig() {
  ensurePubspec();

  stdout.writeln('🖥️  Generating VSCode config...');
  final appName = readPackageName();

  final config = vscodeConfig;
  if (config.extensions) generateVscodeExtensions();
  if (config.launch) generateVscodeLaunch(appName);
  if (config.tasks) generateVscodeTasks();
  for (final (file, on) in [
    ('extensions.json', config.extensions),
    ('launch.json', config.launch),
    ('tasks.json', config.tasks),
  ]) {
    if (!on) stdout.writeln('  ⏭  Skipped (vs_code_configs): .vscode/$file');
  }

  stdout.writeln('✅ VSCode config generated.');
  stdout.writeln();
}
