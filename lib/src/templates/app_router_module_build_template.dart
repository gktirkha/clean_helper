import '../functions/shared/camel_case.dart';
import '../functions/shared/pascal_case.dart';

/// `lib/app/router/<app>_router_module.dart`: `<AppPascal>RouterModule`
/// providing `<AppPascal>Router` with every feature router, by priority.
String appRouterModuleBuildTemplate(String appName, List<String> features) {
  final appRouter = '${pascalCase(appName)}Router';
  final imports = features
      .map((f) => "import '../../features/$f/router/${f}_router.dart';")
      .join('\n');

  final params = features
      .map((f) => '${pascalCase(f)}Router ${camelCase(f)}Router')
      .join(', ');

  final routerList = features.map((f) => '${camelCase(f)}Router').join(', ');

  return '''
// GENERATED CODE — DO NOT EDIT MANUALLY
// Managed by clean_helper. Run `clean-helper add-feature` to register new routers.
// To resync with the features on disk, run `clean-helper regenerate-router`.

import 'package:injectable/injectable.dart';

$imports
import '${appName}_router.dart';

@module
abstract class ${appRouter}Module {
  @lazySingleton
  $appRouter ${camelCase(appName)}Router($params) => $appRouter(
    routers: [$routerList]..sort((a, b) => a.priority.compareTo(b.priority)),
  );
}
''';
}
