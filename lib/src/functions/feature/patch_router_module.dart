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
  final existingFeatures =
      importRegex.allMatches(content).map((m) => m.group(1)!).toList();

  existingFeatures.add(feature);

  file.writeAsStringSync(buildRouterModule(existingFeatures));
  stdout.writeln('🔗 ${pascalCase(feature)}Router registered in $path');
}

String buildRouterModule(List<String> features) {
  final imports =
      features
          .map((f) => "import '../../features/$f/router/${f}_router.dart';")
          .join('\n');

  final params = features
      .map((f) => '${pascalCase(f)}Router ${camelCase(f)}Router')
      .join(', ');

  final routerList = features.map((f) => '${camelCase(f)}Router').join(', ');

  return '''
// GENERATED CODE — DO NOT EDIT MANUALLY
// Managed by clean_helpers. Run `clean-helpers add_feature` to register new routers.

import 'package:injectable/injectable.dart';

$imports
import 'app_go_router.dart';

@module
abstract class RouterModule {
  @lazySingleton
  AppGoRouter appGoRouter($params) => AppGoRouter(
    routers: [$routerList]..sort((a, b) => a.priority.compareTo(b.priority)),
  );
}
''';
}
