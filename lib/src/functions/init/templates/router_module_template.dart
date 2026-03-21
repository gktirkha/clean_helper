String routerModuleTemplate(String pkg) => '''
// GENERATED CODE — DO NOT EDIT MANUALLY
// Managed by clean_helpers. Run `clean-helpers add_feature` to register new routers.

import 'package:injectable/injectable.dart';

import '../../features/home/router/home_router.dart';
import 'app_go_router.dart';

@module
abstract class RouterModule {
  @lazySingleton
  AppGoRouter appGoRouter(HomeRouter homeRouter) => AppGoRouter(
    // TODO: set priority on each RouterBase subclass — lower number = added first to the list
    routers: [homeRouter]..sort((a, b) => a.priority.compareTo(b.priority)),
  );
}
''';
