import 'dart:io';

import '../shared/camel_case.dart';
import '../shared/pascal_case.dart';

void unpatchRouterModule(String feature) {
  const path = 'lib/app/router/router_module.dart';
  final file = File(path);

  if (!file.existsSync()) {
    stderr.writeln('⚠️  $path not found, skipping router deregistration');
    return;
  }

  var content = file.readAsStringSync();
  final pascal = pascalCase(feature);
  final camel = camelCase(feature);
  final importLine =
      "import '../../features/$feature/router/${feature}_router.dart';";

  if (!content.contains(importLine)) {
    stdout.writeln('  ⏭  Router for "$feature" not registered, skipping');
    return;
  }

  content = content.replaceFirst('$importLine\n', '');
  content = content.replaceFirst(', ${pascal}Router ${camel}Router', '');
  content = content.replaceFirst(', ${camel}Router', '');

  file.writeAsStringSync(content);
  stdout.writeln('🔗 ${pascal}Router removed from $path');
}
