import 'dart:io';

import '../feature/patch_router_module.dart' show buildRouterModule;
import '../shared/pascal_case.dart';
import '../shared/write_file.dart';

void unpatchRouterModule(String feature) {
  const path = 'lib/app/router/router_module.dart';
  final file = File(path);

  if (!file.existsSync()) {
    stderr.writeln('⚠️  $path not found, skipping router deregistration');
    return;
  }

  final content = file.readAsStringSync();
  final importLine =
      "import '../../features/$feature/router/${feature}_router.dart';";

  if (!content.contains(importLine)) {
    stdout.writeln('  ⏭  Router for "$feature" not registered, skipping');
    return;
  }

  // Parse existing feature routers and remove the target
  final importRegex = RegExp(
    r"import '\.\.\/\.\.\/features\/(\w+)\/router\/\w+_router\.dart';",
  );
  final remainingFeatures = importRegex
      .allMatches(content)
      .map((m) => m.group(1)!)
      .where((f) => f != feature)
      .toList();

  overwriteFile(path, buildRouterModule(remainingFeatures));
  stdout.writeln('🔗 ${pascalCase(feature)}Router removed from $path');
}
