import '../functions/shared/camel_case.dart';
import '../functions/shared/pascal_case.dart';

String appRouterModuleBuildTemplate(List<String> features) {
  final imports = features
      .map((f) => "import '../../features/$f/router/${f}_router.dart';")
      .join('\n');

  final params = features
      .map((f) => '${pascalCase(f)}Router ${camelCase(f)}Router')
      .join(', ');

  final routerList = features.map((f) => '${camelCase(f)}Router').join(', ');

  return '''
// GENERATED CODE — DO NOT EDIT MANUALLY
// Managed by clean_helper. Run `clean-helper add_feature` to register new routers.
// To resync with the features on disk, run `clean-helper regenerate_router`.

import 'package:injectable/injectable.dart';

$imports
import 'app_go_router.dart';

@module
abstract class AppRouterModule {
  @lazySingleton
  AppGoRouter appGoRouter($params) => AppGoRouter(
    routers: [$routerList]..sort((a, b) => a.priority.compareTo(b.priority)),
  );
}
''';
}
