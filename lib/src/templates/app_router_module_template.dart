String appRouterModuleTemplate(String pkg) => '''
// GENERATED CODE — DO NOT EDIT MANUALLY
// Managed by clean_helper. Run `clean-helper add_feature` to register new routers.
// To resync with the features on disk, run `clean-helper regenerate_router`.

import 'package:injectable/injectable.dart';

import '../../features/home/router/home_router.dart';
import 'app_go_router.dart';

@module
abstract class AppRouterModule {
  @lazySingleton
  AppGoRouter appGoRouter(HomeRouter homeRouter) => AppGoRouter(
    routers: [homeRouter]..sort((a, b) => a.priority.compareTo(b.priority)),
  );
}
''';
