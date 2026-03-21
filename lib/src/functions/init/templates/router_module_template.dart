String routerModuleTemplate(String pkg) => '''
import 'package:injectable/injectable.dart';

import '../../features/home/router/home_router.dart';
import 'app_go_router.dart';

@module
abstract class RouterModule {
  @lazySingleton
  AppGoRouter appGoRouter(HomeRouter homeRouter) => AppGoRouter(
    routers: [homeRouter]..sort((a, b) => a.priority.compareTo(b.priority)),
  );
}
''';
