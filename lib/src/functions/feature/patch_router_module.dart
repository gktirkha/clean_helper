import 'dart:io';

import '../shared/pascal_case.dart';
import '../shared/write_file.dart';
import 'build_router_module.dart';

void patchRouterModule(String feature) {
  const path = 'lib/app/router/router_module.dart';
  final file = File(path);

  if (!file.existsSync()) {
    stderr.writeln('⚠️  $path not found, skipping router registration');
    return;
  }

  final content = file.readAsStringSync();
  final importLine =
      "import '../../features/$feature/router/${feature}_router.dart';";

  if (content.contains(importLine)) {
    stdout.writeln('  ⏭  Router for "$feature" already registered');
    return;
  }

  // Parse existing feature routers from imports
  final importRegex = RegExp(
    r"import '\.\.\/\.\.\/features\/(\w+)\/router\/\w+_router\.dart';",
  );
  final existingFeatures = importRegex
      .allMatches(content)
      .map((m) => m.group(1)!)
      .toList();

  existingFeatures.add(feature);

  overwriteFile(path, buildRouterModule(existingFeatures));
  stdout.writeln('🔗 ${pascalCase(feature)}Router registered in $path');
}
