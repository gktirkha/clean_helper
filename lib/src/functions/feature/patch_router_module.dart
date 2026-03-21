import 'dart:io';

import '../shared/camel_case.dart';
import '../shared/pascal_case.dart';

void patchRouterModule(String feature) {
  const path = 'lib/app/router/router_module.dart';
  final file = File(path);

  if (!file.existsSync()) {
    stderr.writeln('⚠️  $path not found, skipping router registration');
    return;
  }

  var content = file.readAsStringSync();
  final pascal = pascalCase(feature);
  final camel = camelCase(feature);
  final importLine =
      "import '../../features/$feature/router/${feature}_router.dart';";

  if (content.contains(importLine)) {
    stdout.writeln('  ⏭  Router for "$feature" already registered');
    return;
  }

  // Add import before app_go_router.dart import
  content = content.replaceFirst(
    "import 'app_go_router.dart';",
    "$importLine\nimport 'app_go_router.dart';",
  );

  // Add router param before ) => AppGoRouter(
  content = content.replaceFirst(
    ') => AppGoRouter(',
    ', ${pascal}Router ${camel}Router) => AppGoRouter(',
  );

  // Add router to list before ]..sort
  content = content.replaceFirst(']..sort', ', ${camel}Router]..sort');

  file.writeAsStringSync(content);
  stdout.writeln('🔗 ${pascal}Router registered in $path');
}
