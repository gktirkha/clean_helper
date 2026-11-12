import '../functions/shared/pascal_case.dart';
import '../functions/shared/sort_imports.dart';

/// `lib/app/router/<app>_router.dart`: `<AppPascal>Router` wrapping go_router.
/// [routerPrefix] is the router package's class prefix (`<RouterPascal>`).
String appGoRouterTemplate(
  String appName,
  String routerImport,
  String routerPrefix,
) =>
    '''
import 'dart:async';

${sortImports(["import '$routerImport';", "import 'package:flutter/material.dart';", "import 'package:go_router/go_router.dart';"])}

import '../di/di_container.dart';
import '../../features/home/router/home_routes.dart';

part '${appName}_router_redirect.dart';

class ${pascalCase(appName)}Router {
  ${pascalCase(appName)}Router({required this.routers});

  final List<${routerPrefix}Base> routers;

  late final router = GoRouter(
    navigatorKey: diContainer<GlobalKey<NavigatorState>>(),
    debugLogDiagnostics: true,
    initialLocation: HomeRoutes.home,
    routes: [...routers.expand((r) => r.routes)],
    redirect: (context, state) => _handleRedirect(context, state, routers),
    refreshListenable: ${routerPrefix}Refresh(
      routers.expand((r) => r.refreshStreams).toList(),
    ),
  );
}
''';
